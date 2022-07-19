set startframe 149
set totalframe 149
set dis_cutoff 3.5
set ang_cutoff 150
set count 0
for {set i $startframe} {$i <= ${totalframe}} {incr i} {
	animate goto $i
	# accepter
	set PEG_O [atomselect top "fragment 10 to 323 and name O3 O5"]
	set PEG_O_list [$PEG_O list]
	foreach O_index $PEG_O_list {
		set O_surround [atomselect top "fragment 10 to 323 and not index $O_index and name O4 and within $dis_cutoff of index $O_index"]
		set O_surround_list [$O_surround list]
		foreach O_surround_index $O_surround_list {
			set O_surround_atom [atomselect top "index $O_surround_index"]
			set O_surround_list_bond [$O_surround_atom getbonds]
			foreach O_surround_list_bond_index [lindex $O_surround_list_bond 0] {
				set temp_atom [atomselect top "index $O_surround_list_bond_index"]
				#puts "$O_surround_list_bond_index [$temp_atom get name]"
				if {[$temp_atom get name] == "H8"} {
					set temp_list "$O_index $O_surround_list_bond_index $O_surround_index"
					set angle [measure angle $temp_list]
					#puts "$O_index $O_surround_list_bond_index $O_surround_index $angle"
					if {$angle >= $ang_cutoff} {
						set count [expr $count +1]
						set temp [atomselect top "index $O_index"]
						puts "$O_index [$temp get fragment] $O_surround_list_bond_index $O_surround_index [$O_surround_atom get fragment] $angle"
						$temp delete
					}	
					break
				}
			}
			$temp_atom delete
			$O_surround_atom delete
		}
		$O_surround delete
	}
	$PEG_O delete
	puts $count
	# donor
	set PEG_O [atomselect top "fragment 10 to 323 and name O4"]
	foreach PEG_O_index [$PEG_O list] {
		set O [atomselect top "index $PEG_O_index"]
		set O_bond [$O getbonds]
		foreach O_bond_index [lindex $O_bond 0] {
			set temp_atom [atomselect top "index $O_bond_index"]
			# puts "$O_bond_index [$temp_atom get name]"
			if {[$temp_atom get name] == "H8"} {
				set h_index $O_bond_index
				set h_atom [atomselect top "index $O_bond_index"]
				break
			}
		}
		set O_surround [atomselect top "fragment 10 to 323 and not index $PEG_O_index and name O3 O4 O5 and within $dis_cutoff of index $PEG_O_index"]
		foreach O_surround_index [$O_surround list] {
			set temp_list "$PEG_O_index $h_index $O_surround_index"
			set angle [measure angle $temp_list]
			if {$angle >= $ang_cutoff} {
				set count [expr $count +1]
				set temp [atomselect top "index $O_surround_index"]
				puts "$PEG_O_index [$O get fragment] $h_index $O_surround_index [$temp get fragment] $angle"
				$temp delete
			}	
		}
		$O_surround delete
		$temp_atom delete
		$O delete
		$h_atom delete
	}
	$PEG_O delete
	puts $count
}