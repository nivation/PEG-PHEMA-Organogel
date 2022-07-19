file mkdir 3_coordinate
cd 3_coordinate

set cutoff 2.6
set totalframe [expr [molinfo top get numframes]-1]
set startframe [expr $totalframe -50]
set outfile [open 3_Li_type.data w]
set outfile_2 [open 3_coordinate.data w]
set outfile_3 [open 3_coordinate_number.data w]
puts $outfile "Li_PEG Li_PHEMA Li_Cl Li_PEG_Cl Li_PHEMA_Cl Li_PEG_PHEMA Li_All Li_Iso"
puts $outfile_2 "Frame Li_PEG_O Li_PHEMA_O"
puts $outfile_3 "Frame Li_PEG_cn Li_PHEMA_cn Li_PEG_Cl_cn Li_PEG_Cl_Cl Li_PHEMA_Cl_cn Li_PHEMA_Cl_Cl Li_PEG_PHEMA_cn Li_All_cn Li_All_cn_Cl"

proc average {list} {
    expr {[tcl::mathop::+ {*}$list 0.0] / max(1, [llength $list])}
}

for {set i $startframe} {$i <= ${totalframe}} {incr i} {
	animate goto $i
	set Li_PEG	     0
	set Li_PHEMA     0
	set Li_Cl        0
	set Li_PEG_PHEMA 0
	set Li_PHEMA_Cl  0
	set Li_PEG_Cl    0
	set Li_All       0
	set Li_Iso       0
	set total_Li_PEG_O   0
	set total_Li_PHEMA_O 0
	
	set Li_PEG_list	      {}
	set Li_PHEMA_list     {}
	set Li_PEG_PHEMA_list {}
	set Li_PHEMA_Cl_list  {}
	set Li_PEG_Cl_list    {}
	set Li_All_list       {}
	set Li_PHEMA_Cl_list_Cl  {}
	set Li_PEG_Cl_list_Cl    {}
	set Li_All_list_Cl       {}

    for {set j 324} {$j <= 713} {incr j} {	
		set PHEMA [atomselect top "fragment 0 to 9 and name O3 O4 O5 and within $cutoff of fragment $j"]
		set PEG   [atomselect top "fragment 10 to 324 and name O3 O4 O5 and within $cutoff of fragment $j"]
		set Cl    [atomselect top "name Cl11 and within $cutoff of fragment $j"]
		
		set PHEMA_num [llength [$PHEMA list]] 
		set PEG_num   [llength [$PEG   list]]  
		set Cl_num    [llength [$Cl    list]] 
		set cn 		[expr $PHEMA_num + $PEG_num]
		
		set total_Li_PEG_O 		[expr $total_Li_PEG_O + $PEG_num]
		set total_Li_PHEMA_O 	[expr $total_Li_PHEMA_O + $PHEMA_num]
		
		if { ($PHEMA_num>0) && ($PEG_num>0) && ($Cl_num >0)} {
			set Li_All [expr $Li_All +1]
			lappend Li_All_list $cn
			lappend Li_All_list_Cl $Cl_num
		} elseif {($PHEMA_num>0)  && ($PEG_num>0)  && ($Cl_num ==0)} {
			set Li_PEG_PHEMA [expr $Li_PEG_PHEMA +1]
			lappend Li_PEG_PHEMA_list $cn
		} elseif {($PHEMA_num>0)  && ($PEG_num==0) && ($Cl_num >0) } {
			set Li_PHEMA_Cl [expr $Li_PHEMA_Cl +1]
			lappend Li_PHEMA_Cl_list $cn
			lappend Li_PHEMA_Cl_list_Cl $Cl_num
		} elseif {($PHEMA_num==0) && ($PEG_num>0)  && ($Cl_num >0) } {
			set Li_PEG_Cl [expr $Li_PEG_Cl +1]
			lappend Li_PEG_Cl_list $cn
			lappend Li_PEG_Cl_list_Cl $Cl_num
		} elseif {($PHEMA_num>0)  && ($PEG_num==0) && ($Cl_num ==0)} {
			set Li_PHEMA [expr $Li_PHEMA +1]
			lappend Li_PHEMA_list $cn
		} elseif {($PHEMA_num==0) && ($PEG_num>0)  && ($Cl_num ==0)} {
			set Li_PEG [expr $Li_PEG +1]
			lappend Li_PEG_list $cn
		} elseif {($PHEMA_num==0) && ($PEG_num==0) && ($Cl_num >0) } {
			set Li_Cl [expr $Li_Cl +1]
		} elseif {($PHEMA_num==0) && ($PEG_num==0) && ($Cl_num ==0)} {
			set Li_Iso [expr $Li_Iso +1]
		}
		$PHEMA delete
		$PEG   delete
		$Cl    delete
	}
	
	set Li_PEG_cn [average $Li_PEG_list]
	set Li_PHEMA_cn [average $Li_PHEMA_list]
	set Li_PEG_Cl_cn [average $Li_PEG_Cl_list]
	set Li_PEG_Cl_Cl [average $Li_PEG_Cl_list_Cl]
	set Li_PHEMA_Cl_cn [average $Li_PHEMA_Cl_list]
	set Li_PHEMA_Cl_Cl [average $Li_PHEMA_Cl_list_Cl]
	set Li_PEG_PHEMA_cn [average $Li_PEG_PHEMA_list]
	set Li_All_cn [average $Li_All_list]
	set Li_All_Cl [average $Li_All_list_Cl]
	
	puts $outfile "$Li_PEG $Li_PHEMA $Li_Cl $Li_PEG_Cl $Li_PHEMA_Cl $Li_PEG_PHEMA $Li_All $Li_Iso"
	puts $outfile_2 "$i $total_Li_PEG_O $total_Li_PHEMA_O"
	puts $outfile_3 "$i $Li_PEG_cn $Li_PHEMA_cn $Li_PEG_Cl_cn $Li_PEG_Cl_Cl $Li_PHEMA_Cl_cn $Li_PHEMA_Cl_Cl $Li_PEG_PHEMA_cn $Li_All_cn $Li_All_Cl"
}

close $outfile 
close $outfile_2
close $outfile_3
cd ../