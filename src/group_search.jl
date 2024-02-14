
"""
    GCPair

Struct used to hold a description of a group. contains the SMARTS string necessary to match the group within a SMILES query, and the assigned name.

"""
struct GCPair
    smarts::String
    name::String
end

smarts(x::GCPair) = x.smarts
name(x::GCPair) = x.name

#sorting comparison between 2 smatches
function _isless_smatch(smatch1,smatch2)
    #fallback, if one is not matched, throw to the end
    len_smatch1 = length(smatch1)
    len_smatch2 = length(smatch1)
    if len_smatch1 == 0 || len_smatch2 == 0
        return len_smatch1 < len_smatch2
    end

    #first criteria: bigger groups go first,
    #the group with the bigger group
    atom_size1 = length(smatch1[1]["atoms"])
    atom_size2 = length(smatch2[1]["atoms"])
    if atom_size1 != atom_size2
        return atom_size1 < atom_size2
    end

    #second criteria
    #if the size of the match is the same,
    #return the one with the least amount of matches first
    if len_smatch1 != len_smatch2
        len_smatch1 > len_smatch2
    end

    #third criteria
    #return the match with more bonds
    bond_count1 = length(smatch1[1]["bonds"])
    bond_count2 = length(smatch2[1]["bonds"])
    if bond_count1 != bond_count2
        return bond_count1 < bond_count2
    end

    #no more comparizons?
    return false
end

function unique_groups!(groups)
    n = length(groups)
    counts = zeros(Int,n)
    to_delete = fill(false,n)
    #step 1: find uniques and group those
    for i in 1:(n-1)
        str,val =groups[i]
        counts[i] = val
        for j in (i+1):n
            str2,vals2 = groups[j]
            if str2 == str && !to_delete[j]
                to_delete[j] = true
                counts[i] += vals2
                counts[j] = 0
            end
        end
    end
    #step 2: set new values
    for i in 1:n
        str,val =groups[i]
        groups[i] = str => counts[i]
    end
    #step 3: delete groups with zero values
    return deleteat!(groups,to_delete)
end

"""
    get_grouplist(x)

Should return a `Vector{GCPair}` containing the available groups for SMILES matching.

"""
function get_grouplist end
get_grouplist(x::Vector{GCPair}) = x

"""
    get_groups_from_smiles(smiles::String,groups,lib = DEFAULTLIB;connectivity = false)

Given a SMILES string and a group list (`groups::Vector{GCPair}`), returns a list of groups and their corresponding amount.

If `connectivity` is true, then it will additionally return a vector containing the amount of bonds between each pair.

`lib` allows the selection of a molecular library to perform the substructure matching. the two available options are:
- `RDKitLib()` : uses `RDKit` (via the `RDKitMinimalLib.jl` package) to perform the substructure matching. Default in Linux and Mac.
- `MolecularGraphJL()` : uses `MolecularGraph.jl`to perform the substructure matching. Default in Windows (due to a bug in RDKit in this particular Operating System).

## Examples

```julia
julia> get_groups_from_smiles("CCO",UNIFACGroups)
("CCO", ["CH3" => 1, "CH2" => 1, "OH(P)" => 1])

julia> get_groups_from_smiles("CCO",JobackGroups,connectivity = true)
("CCO", ["-CH3" => 1, "-CH2-" => 1, "-OH (alcohol)" => 1], [("-CH3", "-CH2-") => 1, ("-CH2-", "-OH (alcohol)") => 1])
```
"""
function get_groups_from_smiles(smiles::String,groups;connectivity = false)
    groups = get_grouplist(groups)
    return get_groups_from_smiles(smiles,groups;connectivity = connectivity)
end

function get_groups_from_smiles(smiles::String,groups::Vector{GCPair},lib =DEFAULTLIB;connectivity=false,check = true)
    mol = get_mol(lib,smiles)
    atoms = get_atoms(lib,mol)
    __bonds = __getbondlist(lib,mol)

    smatches = []
    smatches_idx = Int[]

    #step 0.a, find all groups that could get a match
    for i in 1:length(groups)
        query_i = get_qmol(lib,smarts(groups[i]))
        if has_substruct_match(lib,mol,query_i)
            push!(smatches,get_substruct_matches(lib,mol,query_i,__bonds))
            push!(smatches_idx,i)
        end
    end

    #step 0.b, sort the matches by the amount of matched atoms. biggest groups come first.
    perm = sortperm(smatches,lt = _isless_smatch,rev = true)
    smatches = smatches[perm]
    smatches_idx = smatches_idx[perm]

    # Expand smatches so that groups are listed
    smatches_expanded = [smatches[i][j] for i in 1:length(smatches) for j in 1:length(smatches[i])]
    smatches_idx_expanded = [smatches_idx[i] for i in 1:length(smatches) for j in 1:length(smatches[i])]

    ngroups = length(smatches_expanded)
    natoms = length(atoms)

    # Create a matrix with the atoms that are in each group
    bond_mat = zeros(Int64, ngroups, natoms)
    for i in 1:ngroups
        for j in 1:length(smatches_expanded[i]["atoms"])
            bond_mat[i, smatches_expanded[i]["atoms"][j]+1] = 1
        end
    end

    # Find all atoms that are in more than one group
    overlap = findall(sum(bond_mat, dims=1)[:] .> 1)

    # Split the groups in two sets: those that overlap and those that don't
    overlap_groups = findall(sum(bond_mat[:, overlap], dims=2)[:] .> 0)
    non_overlap_groups = findall(sum(bond_mat[:, overlap], dims=2)[:] .== 0)

    if !isempty(overlap)
        # Reduce the bond_mat to only the overlapping atoms
        bond_mat_overlap = bond_mat[overlap_groups, overlap]

        # Generate all possible combinations of groups which cover all atoms
        candidate = []
        for i in 1:size(bond_mat_overlap, 1)
            combs = combinations(1:size(bond_mat_overlap, 1), i)
            for comb in combs
                # Test if the combination of groups covers all atoms
                if sum(bond_mat_overlap[comb, :], dims=1) == ones(Int64, 1, size(bond_mat_overlap, 2))
                    push!(candidate, comb)
                end
            end
            # For the first combination that covers all atoms, stop (since it will use the fewest groups)
            if length(candidate) > 0
                break
            end
        end

        # Select the groups that cover the most atoms
        best_comb = overlap_groups[candidate[1]]
        push!(non_overlap_groups, best_comb...)
    end

    bond_mat_minimum = bond_mat[non_overlap_groups, :]
    group_id_expanded = smatches_idx_expanded[non_overlap_groups]

    group_id = unique(group_id_expanded)
    group_occ_list = [sum(group_id_expanded .== i) for i in group_id]

    gcpairs = [name(groups[group_id[i]]) => group_occ_list[i] for i in 1:length(group_id)]

    if check
        if sum(bond_mat_minimum) != natoms
            error("Could not find all groups for "*smiles)
        end
    end

    if connectivity
        return (smiles,gcpairs,get_connectivity(mol,group_id,groups,lib))
    else
        return (smiles,gcpairs)
    end
end

function get_connectivity(mol,group_id,groups,lib = DEFAULTLIB)

    ngroups = length(group_id)
    A = zeros(ngroups,ngroups)
    connectivity = Pair{NTuple{2,String},Int}[]
    for i in 1:ngroups
        gci = groups[group_id[i]]
        smart1 = smarts(gci)
        smart2 = smarts(gci)
        querie = get_qmol(lib,smart1*smart2)
        smatch = get_substruct_matches(lib,mol,querie)
        name_i = name(gci)
        A[i,i] = length(smatch)
        if A[i,i]!=0
            append!(connectivity,[(name_i,name_i)=>Int(A[i,i])])
        end

        for j in i+1:ngroups
            gcj = groups[group_id[j]]
            smart2 = smarts(gcj)
            querie = get_qmol(lib,smart1*smart2)
            smatch = get_substruct_matches(lib,mol,querie)
            A[i,j] = length(smatch)
            name_j = name(gcj)
            if A[i,j]!=0
                append!(connectivity,[(name_i,name_j)=>Int(A[i,j])])
            end
        end
    end
    return [pairs[i]=>nbonds[i] for i in 1:length(nbonds)]
end



#TODO: move this to Clapeyron?
"""
    @gcstring_str(str)

    given a string of the form "Group1:n1;Group2:2", returns ["Group1" => n1,"Group2 => n2]

"""
macro gcstring_str(str)
    gcpairs = split(str,';')
    res = Pair{String,Int}[]
    for gci in gcpairs
        gc,_ni = split_2(gci,':')
        ni = parse(Int,_ni)
        push!(res,gc => ni)
    end
    res
end

"""
    group_replace(grouplist,keys...)

given a group list generated by `get_groups_from_smiles`, replaces certain groups in grouplist with the values specified in `keys`.

## Examples

```
groups1 = get_groups_from_smiles("CCO", UNIFACGroups) #["CH3" => 1, "CH2" => 1, "OH(P)" => 1]
#we replace each "OH(P)" with 1 "OH" group
#and each "CH3" group with 3 "H" group and 1 "C" group
groups2 = group_replace(groups1[2],"OH(P)" => ("OH" => 1), "CH3" => [("C" => 1),("H" => 3)])
```

"""
function group_replace(grouplist,group_keys...)
    res = Dict{String,Int}(grouplist)

    for (k,v) in group_keys
        if haskey(res,k)
            multiplier = res[k]
            res[k] = 0
            if v isa Pair
                v = (v,)
            end
            for vals in v
                knew = first(vals)
                vnew = last(vals)
                if haskey(res,knew)
                    val_old = res[knew]
                    res[knew] = val_old + vnew*multiplier
                else
                    res[knew] = vnew*multiplier
                end
            end
        end
    end

    for kk in keys(res)
        if res[kk] == 0
            delete!(res,kk)
        end
    end
    return [k => v for (k,v) in pairs(res)]

end
export get_groups_from_name, get_groups_from_smiles, group_replace