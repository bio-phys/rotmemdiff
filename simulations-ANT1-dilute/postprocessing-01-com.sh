# --------------------------------------
# Write out different COM coordinates
# --------------------------------------

set -ex

DIRECTORY=$( pwd )
cd analysis

# COM of the components 
# TO DO:
# - Special treatment for proteins (use MDAnalysis)
# - Separate analysis for leaflets (use MDAnalysis)
for COMP in 'CDL2' 'POPC' 'POPE' ; do 

	# Count the molecules of the selected species
	NUMCOMP=$( python -c "import MDAnalysis as mda; u = mda.Universe('mdstart_$COMP.gro'); print len(u.residues)"  )
	
	# If there are more than 10,000 molecules, choose 10,000 randomly.
	LIMIT=10000
	LIMCOMP=$( python -c "print min([$NUMCOMP,$LIMIT])")
	INDICES=$( python -c "import random; a = random.sample(range(1, $NUMCOMP+1), $LIMCOMP); print a" | sed s/,//g | sed 's/\]//' | sed 's/\[//' )

	# Make the index file
	NDXINPUT=""
	for resnum in $INDICES; do
		NDXINPUT="$NDXINPUT ri $resnum \n"
	done
	printf "$NDXINPUT \n q \n" | make_ndx -f mdstart_$COMP.gro -o index_$COMP.ndx

	#  0 System
	#  1 Other
	#  2 POPC
	#  3 r_1
	#  4 r_2
	#  5 r_3
	#   ...

	# COM of single molecules
	nums=""
	for resnum in `seq 1 $LIMCOMP`; do
        	nums="$nums $(( $resnum+2 ))"
	done
	printf "$nums" | g_traj -ng $LIMCOMP -com -n index_$COMP.ndx -ox COM_$COMP.xvg -f nojump_$COMP.xtc -s mdstart_$COMP.gro 

done

# COM of the whole membrane
printf "Membrane\n" | g_traj -com -n ../simulation/index.ndx -ox COM_Membrane.xvg -f nojump_Membrane.xtc -s mdstart_Membrane.gro

cd ..
