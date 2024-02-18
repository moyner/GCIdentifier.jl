var documenterSearchIndex = {"docs":
[{"location":"api/","page":"API","title":"API","text":"CurrentModule = GCIdentifier","category":"page"},{"location":"api/#Contents","page":"API","title":"Contents","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"Pages = [\"api.md\"]","category":"page"},{"location":"api/#Index","page":"API","title":"Index","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"Pages = [\"api.md\"]","category":"page"},{"location":"api/#types-and-methods","page":"API","title":"types and methods","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"GCIdentifier.GCPair\nGCIdentifier.RDKitLib\nGCIdentifier.MolecularGraphJL\nGCIdentifier.get_grouplist\nGCIdentifier.get_groups_from_smiles\nGCIdentifier.@gcstring_str\nGCIdentifier.group_replace","category":"page"},{"location":"api/#GCIdentifier.GCPair","page":"API","title":"GCIdentifier.GCPair","text":"GCPair\n\nStruct used to hold a description of a group. contains the SMARTS string necessary to match the group within a SMILES query, and the assigned name.\n\n\n\n\n\n","category":"type"},{"location":"api/#GCIdentifier.RDKitLib","page":"API","title":"GCIdentifier.RDKitLib","text":"RDKitLib\n\nStruct used to select the RDKit library (via RDKitMinimalLib.jl package) to perform the group search. Default in Linux and Mac.\n\n\n\n\n\n","category":"type"},{"location":"api/#GCIdentifier.MolecularGraphJL","page":"API","title":"GCIdentifier.MolecularGraphJL","text":"MolecularGraphJL\n\nStruct used to select the MolecularGraph.jl library to perform the group search. Default in Windows.\n\n\n\n\n\n","category":"type"},{"location":"api/#GCIdentifier.get_grouplist","page":"API","title":"GCIdentifier.get_grouplist","text":"get_grouplist(x)\n\nShould return a Vector{GCPair} containing the available groups for SMILES matching.\n\n\n\n\n\n","category":"function"},{"location":"api/#GCIdentifier.get_groups_from_smiles","page":"API","title":"GCIdentifier.get_groups_from_smiles","text":"get_groups_from_smiles(smiles::String,groups,lib = DEFAULTLIB;connectivity = false)\n\nGiven a SMILES string and a group list (groups::Vector{GCPair}), returns a list of groups and their corresponding amount.\n\nIf connectivity is true, then it will additionally return a vector containing the amount of bonds between each pair.\n\nlib allows the selection of a molecular library to perform the substructure matching. the two available options are:\n\nRDKitLib() : uses RDKit (via the RDKitMinimalLib.jl package) to perform the substructure matching. Default in Linux and Mac.\nMolecularGraphJL() : uses MolecularGraph.jlto perform the substructure matching. Default in Windows (due to a bug in RDKit in this particular Operating System).\n\nExamples\n\njulia> get_groups_from_smiles(\"CCO\",UNIFACGroups)\n(\"CCO\", [\"CH3\" => 1, \"CH2\" => 1, \"OH(P)\" => 1])\n\njulia> get_groups_from_smiles(\"CCO\",JobackGroups,connectivity = true)\n(\"CCO\", [\"-CH3\" => 1, \"-CH2-\" => 1, \"-OH (alcohol)\" => 1], [(\"-CH3\", \"-CH2-\") => 1, (\"-CH2-\", \"-OH (alcohol)\") => 1])\n\n\n\n\n\n","category":"function"},{"location":"api/#GCIdentifier.@gcstring_str","page":"API","title":"GCIdentifier.@gcstring_str","text":"@gcstring_str(str)\n\ngiven a string of the form \"Group1:n1;Group2:2\", returns [\"Group1\" => n1,\"Group2 => n2]\n\n\n\n\n\n","category":"macro"},{"location":"api/#GCIdentifier.group_replace","page":"API","title":"GCIdentifier.group_replace","text":"group_replace(grouplist,keys...)\n\ngiven a group list generated by get_groups_from_smiles, replaces certain groups in grouplist with the values specified in keys.\n\nExamples\n\ngroups1 = get_groups_from_smiles(\"CCO\", UNIFACGroups) #[\"CH3\" => 1, \"CH2\" => 1, \"OH(P)\" => 1]\n#we replace each \"OH(P)\" with 1 \"OH\" group\n#and each \"CH3\" group with 3 \"H\" group and 1 \"C\" group\ngroups2 = group_replace(groups1[2],\"OH(P)\" => (\"OH\" => 1), \"CH3\" => [(\"C\" => 1),(\"H\" => 3)])\n\n\n\n\n\n","category":"function"}]
}
