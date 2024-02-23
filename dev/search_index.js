var documenterSearchIndex = {"docs":
[{"location":"api/","page":"API","title":"API","text":"CurrentModule = GCIdentifier","category":"page"},{"location":"api/#Contents","page":"API","title":"Contents","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"Pages = [\"api.md\"]","category":"page"},{"location":"api/#Index","page":"API","title":"Index","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"Pages = [\"api.md\"]","category":"page"},{"location":"api/#types-and-methods","page":"API","title":"types and methods","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"GCIdentifier.GCPair\nGCIdentifier.get_groups_from_smiles\nGCIdentifier.get_groups_from_name\nGCIdentifier.find_missing_groups_from_smiles\nGCIdentifier.get_grouplist\nGCIdentifier.@gcstring_str\nGCIdentifier.group_replace","category":"page"},{"location":"api/#GCIdentifier.GCPair","page":"API","title":"GCIdentifier.GCPair","text":"GCPair\n\nStruct used to hold a description of a group. contains the SMARTS string necessary to match the group within a SMILES query, and the assigned name.\n\n\n\n\n\n","category":"type"},{"location":"api/#GCIdentifier.get_groups_from_smiles","page":"API","title":"GCIdentifier.get_groups_from_smiles","text":"get_groups_from_smiles(smiles::String,groups,lib = DEFAULTLIB;connectivity = false)\n\nGiven a SMILES string and a group list (groups::Vector{GCPair}), returns a list of groups and their corresponding amount.\n\nIf connectivity is true, then it will additionally return a vector containing the amount of bonds between each pair.\n\nlib allows the selection of a molecular library to perform the substructure matching. the two available options are:\n\nRDKitLib() : uses RDKit (via the RDKitMinimalLib.jl package) to perform the substructure matching. Default in Linux and Mac.\nMolecularGraphJL() : uses MolecularGraph.jlto perform the substructure matching. Default in Windows (due to a bug in RDKit in this particular Operating System).\n\nExamples\n\njulia> get_groups_from_smiles(\"CCO\",UNIFACGroups)\n(\"CCO\", [\"CH3\" => 1, \"CH2\" => 1, \"OH(P)\" => 1])\n\njulia> get_groups_from_smiles(\"CCO\",JobackGroups,connectivity = true)\n(\"CCO\", [\"-CH3\" => 1, \"-CH2-\" => 1, \"-OH (alcohol)\" => 1], [(\"-CH3\", \"-CH2-\") => 1, (\"-CH2-\", \"-OH (alcohol)\") => 1])\n\n\n\n\n\n","category":"function"},{"location":"api/#GCIdentifier.find_missing_groups_from_smiles","page":"API","title":"GCIdentifier.find_missing_groups_from_smiles","text":"find_missing_groups_from_smiles(smiles::String, groups, lib = DEFAULTLIB;max_group_size = nothing, environment=false, reduced=false)\n\nGiven a SMILES string and a group list (groups::Vector{GCPair}), returns a list of potential groups (new_groups::Vector{GCPair}) which could cover those atoms not covered within groups. If no groups vector is provided, it will simply generate all possible groups for the molecule.\n\nA set of heuristics are built into the code when it comes to combining heavy atoms into large groups:\n\nIf a carbon atom is bonded to another carbon atom, unless only one of the carbons is on a ring, they will not be combined into a group.\nAll other combinations of atoms are allowed.\n\nThe logic behind the first heuristic is due to the fact that neighbouring atoms with similar electronegativities won't have a great impact on each other's properties. As such, they are not combined into a group. In the future, this approach could be extended to use HNMR data to determine which atoms can be combined into the same group.\n\nOptional arguments:\n\nmax_group_size::Int: The maximum number of atoms within a group to be generated. If nothing, the maximum size is however many atoms a central atom is bonded to.\nenvironment::Bool: If true, the groups SMARTS will include information about the environment of the group is in. For example, in pentane, if environment is false, there will only be one CH2 group, whereas, if environment is true, there will be two CH2 groups, one bonded to CH3 and one bonded to another CH2.\nreduced::Bool: If true, the groups will be generated such that the minimum number of groups required to represent the molecule, based on max_group_size, will be generated. If false, all possible groups will be generated.\n\nExample\n\njulia> find_missing_groups_from_smiles(\"CC(=O)O\")\n7-element Vector{GCIdentifier.GCPair}:\n GCIdentifier.GCPair(\"[CX4;H3;!R]\", \"CH3\")\n GCIdentifier.GCPair(\"[CX3;H0;!R]\", \"C=\")\n GCIdentifier.GCPair(\"[OX1;H0;!R]\", \"O=\")\n GCIdentifier.GCPair(\"[OX2;H1;!R]\", \"OH\")\n GCIdentifier.GCPair(\"[CX3;H0;!R](=[OX1;H0;!R])\", \"C=O=\")\n GCIdentifier.GCPair(\"[CX3;H0;!R]([OX2;H1;!R])\", \"C=OH\")\n GCIdentifier.GCPair(\"[CX3;H0;!R](=[OX1;H0;!R])([OX2;H1;!R])\", \"C=O=OH\")\n\n\n\n\n\n","category":"function"},{"location":"api/#GCIdentifier.get_grouplist","page":"API","title":"GCIdentifier.get_grouplist","text":"get_grouplist(x)\n\nShould return a Vector{GCPair} containing the available groups for SMILES matching.\n\n\n\n\n\n","category":"function"},{"location":"api/#GCIdentifier.@gcstring_str","page":"API","title":"GCIdentifier.@gcstring_str","text":"@gcstring_str(str)\n\ngiven a string of the form \"Group1:n1;Group2:2\", returns [\"Group1\" => n1,\"Group2 => n2]\n\n\n\n\n\n","category":"macro"},{"location":"api/#GCIdentifier.group_replace","page":"API","title":"GCIdentifier.group_replace","text":"group_replace(grouplist,keys...)\n\ngiven a group list generated by get_groups_from_smiles, replaces certain groups in grouplist with the values specified in keys.\n\nExamples\n\ngroups1 = get_groups_from_smiles(\"CCO\", UNIFACGroups) #[\"CH3\" => 1, \"CH2\" => 1, \"OH(P)\" => 1]\n#we replace each \"OH(P)\" with 1 \"OH\" group\n#and each \"CH3\" group with 3 \"H\" group and 1 \"C\" group\ngroups2 = group_replace(groups1[2],\"OH(P)\" => (\"OH\" => 1), \"CH3\" => [(\"C\" => 1),(\"H\" => 3)])\n\n\n\n\n\n","category":"function"},{"location":"","page":"Home","title":"Home","text":"``@meta CurrentModule = GCIdentifier","category":"page"},{"location":"","page":"Home","title":"Home","text":"# GCIdentifier.jl\nAn extensible [Julia](http://julialang.org) package for the modelling of fluids using thermodynamic equations of state. These include the standard cubics (van der Waals, Redlich-Kwong, Peng-Robinson, _etc._), SAFT-type equations (PC-SAFT, SAFT-VR Mie, SAFT-$\\gamma$ Mie, _etc._), empirical equations (GERG2008, IAWPS95), Activity coefficient models (NRTL, UNIFAC, COSMO-SAC, _etc._) and many more.\n\nThe documentation is laid out as follows:\n\n- **Group Assignment**: Find out how to assign groups to a species within a group-contribution method.\n- **Finding Missing Groups**: Find out how to identify missing groups for a given species.\n- **Custom Groups**: Find out how to implement your own groups within GCIdentifier.\n- **API**: A list of all available methods.\n\n### Authors\n\n- [Pierre J. Walker](mailto:pjwalker@caltech.edu), California Institute of Technology\n- [Andrés Riedemann](mailto:andres.riedemann@gmail.com), University of Concepción\n\n### License\n\nGCIdentifier.jl is licensed under the [MIT license](https://github.com/ClapeyronThermo/GCIdentifier.jl/blob/master/LICENSE.md).\n\n### Installation\n\nGCIdentifier.jl is a registered package, it can be installed from the general registry by:\n","category":"page"},{"location":"","page":"Home","title":"Home","text":"pkg> add GCIdentifier ```","category":"page"}]
}
