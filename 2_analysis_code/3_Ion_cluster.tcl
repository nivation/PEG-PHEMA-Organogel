file mkdir 5_cluster
cd 5_cluster
set cutoff 2.6
set totalframe [expr [molinfo top get numframes]-1]
set startframe [expr $totalframe -50]

proc search_li_cl {cl} {
	global li_search_list
	global cl_search_list
	global small_li_list
	global cutoff
	set cl_num [llength $cl]
	
	#puts $small_li_list
	#puts $li_search_list
	if {$cl_num > 0} {
		foreach cl_fragment_num $cl {
			if {[lsearch -exact $cl_search_list ${cl_fragment_num}] == -1} {
				lappend cl_search_list $cl_fragment_num
				set li_surround [atomselect top "name Li17 and within ${cutoff} of fragment $cl_fragment_num"]
				set li_num [llength [$li_surround list]]
				set flag 0
				if {$li_num > 0} {
					set li_fragment [$li_surround get fragment]
					$li_surround delete
					foreach li_fragment_num $li_fragment {
						if {[lsearch -exact $li_search_list ${li_fragment_num}] == -1} {
							# puts ""
							# puts "$li_fragment_num"
							# puts "$li_search_list"
							# puts ""
							lappend li_search_list $li_fragment_num
							lappend small_li_list $li_fragment_num
							set flag 1
						}
					}
					if {$flag == 1} {
						set cl_surround [atomselect top "name Cl11 and within ${cutoff} of fragment $li_fragment"]
						set cl_surround_list [$cl_surround get fragment]
						$cl_surround delete
						search_li_cl $cl_surround_list
					}
				}
			}
		}
	}
}

for {set i $startframe} {$i <= ${totalframe}} {incr i} {
	set outfile_final [open ./cluster/5_cluster_count_${i}.data w]
	puts $outfile_final "num_li num_cl num_PEG num_PHEMA"
	# set outfile [open 5_cluster_${i}.data w]
	# puts $outfile "Li_fragment Li_cluster"
	# set outfile_2 [open 5_cluster_cl_${i}.data w]
	# puts $outfile_2 "Li_fragment Cl_cluster"
	# set outfile_PEG [open 5_cluster_PEG_${i}.data w]
	# puts $outfile_2 "Li_fragment PEG_fragment"
	# set outfile_PHEMA [open 5_cluster_PHEMA_${i}.data w]
	# puts $outfile_2 "Li_fragment PHEMA_fragment"

	animate goto $i
	global li_search_list
	global cl_search_list
	set li_search_list {}
	set cl_search_list {}
	for {set j 324} {$j <= 713} {incr j} {
		global small_li_list
		set small_li_list {}
		if {[lsearch -exact $li_search_list ${j}] == -1} {
			lappend li_search_list $j
			lappend small_li_list $j
			set cl [atomselect top "name Cl11 and within ${cutoff} of fragment $j"]
			set cl_list [$cl get fragment]
			$cl delete
			search_li_cl $cl_list
			set cl_final [atomselect top "name Cl11 and within ${cutoff} of fragment $small_li_list"]
			set small_cl_list [$cl_final get fragment]
			$cl_final delete
			set PEG [atomselect top "name O3 O4 O5 and fragment 10 to 323 and within ${cutoff} of fragment $small_li_list"]
			set PHEMA [atomselect top "name O3 O4 O5 and fragment 0 to 9 and within ${cutoff} of fragment $small_li_list"]
			
			set PEG_fragment [lsort -unique [$PEG get fragment]]
			set PHEMA_fragment [lsort -unique [$PHEMA get fragment]]
			
			
			set num_li [llength $small_li_list]
			set num_cl [llength $small_cl_list]
			set num_PEG [llength $PEG_fragment]
			set num_PHEMA [llength $PHEMA_fragment]
			
			$PEG delete
			$PHEMA delete
			# puts $outfile "$j $small_li_list"
			# puts $outfile_2 "$j $small_cl_list"
			# puts $outfile_PEG "$j $PEG_fragment"
			# puts $outfile_PHEMA "$j $PHEMA_fragment"
			puts $outfile_final "$num_li $num_cl $num_PEG $num_PHEMA"
			
			
		}	
	}
	# close $outfile 
	# close $outfile_2 
	# close $outfile_PEG 
	# close $outfile_PHEMA 
	close $outfile_final
}
cd ../