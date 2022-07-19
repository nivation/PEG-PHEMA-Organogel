pbc wrap -all
file mkdir 1_hydrogen
cd 1_hydrogen

file mkdir PHEMA
file mkdir PEG
file mkdir PEG_inter

set A [atomselect top "all"]
hbonds -sel1 $A -dist 3.5 -ang 30 -plot no -writefile yes -upsel no -outfile "all.data" -polar yes

set A [atomselect top "fragment 0 to 9"]
hbonds -sel1 $A -dist 3.5 -ang 30 -plot no -writefile yes -upsel no -outfile "0_9.data" -polar yes

set B [atomselect top "fragment 10 to 324"]
hbonds -sel1 $B -dist 3.5 -ang 30 -plot no -writefile yes -upsel no -outfile "10_324.data" -polar yes

set A [atomselect top "fragment 0 to 9"]
set B [atomselect top "fragment 10 to 324"]
hbonds -sel1 $A -sel2 $B -dist 3.5 -ang 30 -plot no -writefile yes -upsel no -outfile "0_9_10_324.data" -polar yes
$A delete
$B delete


file mkdir PHEMA
for {set j 0} {$j <= 9} {incr j} {
	set A [atomselect top "fragment $j"]
	hbonds -sel1 $A -dist 3.5 -ang 30 -plot no -writefile yes -upsel no -outfile "PHEMA/${j}.data" -polar yes
	$A delete
}

file mkdir PEG
for {set j 10} {$j <= 324} {incr j} {
	set A [atomselect top "fragment $j"]
	hbonds -sel1 $A -dist 3.5 -ang 30 -plot no -writefile yes -upsel no -outfile "PEG/${j}.data" -polar yes
	$A delete
}

file mkdir PEG_inter
for {set j 10} {$j <= 323} {incr j} {
	set A [atomselect top "fragment $j"]
	set B [atomselect top "fragment 10 to 323 and not fragment $j"]
	hbonds -sel1 $A -sel2 $B -dist 3.5 -ang 30 -plot no -writefile yes -upsel no -outfile "PEG_inter/${j}.data" -polar yes
	$A delete
	$B delete
}