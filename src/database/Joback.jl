JobackGroups = [raw"[CX4H3]" "-CH3";
raw"[!R;CX4H2]" "-CH2-";
raw"[!R;CX4H]" ">CH-";
raw"[!R;CX4H0]" ">C<";
raw"[CX3H2][CX3H1]" "CH2=CH-";
raw"[CX3H1][CX3H1]" "-CH=CH-";
raw"[$([!R;#6X3H0]);!$([!R;#6X3H0]=[#8])]" "=C<";
raw"[$([CX2H0](=*)=*)]" "=C=";
raw"[$([CX2H1]#[!#7])]" "CH";
raw"[$([CX2H0]#[!#7])]" "C";
raw"[R;CX4H2]" "ring-CH2-";
raw"[R;CX4H]" "ring>CH-";
raw"[R;CX4H0]" "ring>C<";
raw"[R;CX3H1,cX3H1]" "ring=CH-";
raw"[$([R;#6X3H0]);!$([R;#6X3H0]=[#8])]" "ring=C<";
raw"[F]" "-F";
raw"[Cl]" "-Cl";
raw"[Br]" "-Br";
raw"[I]" "-I";
raw"[OX2H;!$([OX2H]-[#6]=[O]);!$([OX2H]-a)]" "-OH (alcohol)";
raw"[O;H1;$(O-!@c)]" "-OH (phenol)";
raw"[OX2H0;!R;!$([OX2H0]-[#6]=[#8])]" "-O- (non-ring)";
raw"[#8X2H0;R;!$([#8X2H0]~[#6]=[#8])]" "-O- (ring)";
raw"[$([CX3H0](=[OX1]));!$([CX3](=[OX1])-[OX2]);!R]=O" ">C=O (non-ring)";
raw"[$([#6X3H0](=[OX1]));!$([#6X3](=[#8X1])~[#8X2]);R]=O" ">C=O (ring)";
raw"[CH;D2](=O)" "O=CH- (aldehyde)";
raw"[OX2H]-[C]=O" "-COOH (acid)";
raw"[#6X3H0;!$([#6X3H0](~O)(~O)(~O))](=[#8X1])[#8X2H0]" "-COO- (ester)";
raw"[OX1H0;!$([OX1H0]~[#6X3]);!$([OX1H0]~[#7X3]~[#8])]" "=O (other than above)";
raw"[NX3H2]" "-NH2";
raw"[NX3H1;!R]" ">NH (non-ring)";
raw"[#7X3H1;R]" ">NH (ring)";
raw"[#7X3H0;!$([#7](~O)~O)]" ">N- (non-ring)";
raw"[#7X2H0;!R]" "-N= (non-ring)";
raw"[#7X2H0;R]" "-N= (ring)";
raw"[#7X2H1]" "=NH";
raw"[#6X2]#[#7X1H0]" "-CN";
raw"[$([#7X3,#7X3+][!#8])](=[O])~[O-]" "-NO2";
raw"[SX2H]" "-SH";
raw"[#16X2H0;!R]" "-S- (non-ring)";
raw"[#16X2H0;R]" "-S- (ring)"]

export JobackGroups