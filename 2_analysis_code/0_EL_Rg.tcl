set startframe 0
set totalframe [expr [molinfo top get numframes]-1]
file mkdir 0_length
set PEG_Rg    [open 0_length/PEG_Rg.data w]
set PHEMA_Rg  [open 0_length/PHEMA_Rg.data w]
set PEG_E2E   [open 0_length/PEG_E2E.data w]
set PHEMA_E2E [open 0_length/PHEMA_E2E.data w]

for {set i $startframe} {$i <= ${totalframe}} {incr i} {
	animate goto $i
	set phema_rg  {}
	set phema_e2e {}
	set peg_e2e   {}
	set peg_rg    {}
	# HEMA 
	for {set j 0} {$j <= 9} {incr j} {
		# Rg
		set temp [atomselect top "fragment $j"]
		set rg [measure rgyr $temp]
		lappend phema_rg [measure rgyr $temp]
		$temp delete
		
		
		# E2E
		set start [expr 1+$j*1902]
		set end   [expr 1883+$j*1902]
		set head  [atomselect top "serial $start"]
		set tail  [atomselect top "serial $end"]
		set A_vector [lindex [$head get {x y z}] 0]
		set B_vector [lindex [$tail get {x y z}] 0]
		lappend phema_e2e [veclength [vecsub	$A_vector	$B_vector]]
		$head delete
		$tail delete
	}
	# PEG 
	for {set j 10} {$j <= 323} {incr j} {
		# Rg
		set temp [atomselect top "fragment $j"]
		set rg [measure rgyr $temp]
		lappend peg_rg [measure rgyr $temp]
		$temp delete
		
		# E2E
		set k [expr ${j}-10]
		set start [expr 19023+$k*66]
		set end   [expr 19082+$k*66]
		set head  [atomselect top "serial $start"]
		set tail  [atomselect top "serial $end"]
		set A_vector [lindex [$head get {x y z}] 0]
		set B_vector [lindex [$tail get {x y z}] 0]
		lappend peg_e2e [veclength [vecsub	$A_vector	$B_vector]]
		$head delete
		$tail delete
	}
	puts $PHEMA_Rg  "$i $phema_rg"
	puts $PEG_Rg    "$i $peg_rg"
	puts $PHEMA_E2E "$i $phema_e2e"
	puts $PEG_E2E   "$i $peg_e2e"
	
}
close $PHEMA_Rg
close $PEG_Rg
close $PHEMA_E2E
close $PEG_E2E