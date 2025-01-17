module GCIdentifier
using Combinatorics

@static if !isdefined(Base,:eachsplit)
    eachsplit(str::AbstractString, dlm; limit::Integer=0, keepempty::Bool=true) = split(str,dlm;limit,keepempty)
    eachsplit(str::AbstractString; limit::Integer=0, keepempty::Bool=false)  = split(str;limit,keepempty)
end

split_2(str) = NTuple{2}(eachsplit(str, limit=2))
split_2(str,dlm) = NTuple{2}(eachsplit(str,dlm, limit=2))

#TODO: windows support with MolecularGraph
import MolecularGraph

include("prelude.jl")
include("group_search.jl")
include("missing_groups.jl")
include("database/database.jl")

"""
    get_groups_from_name(name::String,groups;connectivity = false)

Given a molecule name and a group list (`groups::Vector{GCPair}`), returns a list of groups and their corresponding amount.

If `connectivity` is true, then it will additionally return a vector containing the amount of bonds between each pair.

Note: Can only be used if ChemicalIdentifiers is also called.

## Examples

```julia
julia> get_groups_from_name("ethanol",UNIFACGroups)
("ethanol", ["CH3" => 1, "CH2" => 1, "OH(P)" => 1])

julia> get_groups_from_name("ethanol",JobackGroups,connectivity = true)
("ethanol", ["-CH3" => 1, "-CH2-" => 1, "-OH (alcohol)" => 1], [("-CH3", "-CH2-") => 1, ("-CH2-", "-OH (alcohol)") => 1])
```
"""
function get_groups_from_name end #overload this if ChemicalIdentifiers is loaded.

if !isdefined(Base,:get_extension)
    using Clapeyron,ChemicalIdentifiers
    include("../ext/GCIdentifierClapeyronExt.jl")
    include("../ext/GCIdentifierChemicalIdentifiersExt.jl")
end

end # module
