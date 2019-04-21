#!/bin/bash

doanalysis () {
	local SPECIES=$1
	local PIECE='07'
        local HEIGHT=$2
	local STDDIR=$3
	local TRJDIR=$4
	local RESDIR=$5    
	local MULT='01'
	local LETTER=$6

	cd $TRJDIR/PC60PE40-PC50PE40CL10-1OKC-piece$PIECE-mult$MULT-height$HEIGHT-$LETTER/analysis
	
	echo $(pwd)


	# Get the box dimensions

	BOXX_LINE=$( printf "Box-X\n\n" | g_energy -f ../simulation/martini_md.edr -o box_x.xvg | grep 'Box-X' )
	read -a BOXX_ARRAY <<< $BOXX_LINE
	BOXX="${BOXX_ARRAY[1]}"

	BOXZ_LINE=$( printf "Box-Z\n\n" | g_energy -f ../simulation/martini_md.edr -o box_z.xvg | grep 'Box-Z' )
	read -a BOXZ_ARRAY <<< $BOXZ_LINE
	BOXZ="${BOXZ_ARRAY[1]}"
	

	# Go back and perform analysis

	cd $STDDIR
	
	TRJFILE=PC60PE40-PC50PE40CL10-1OKC-piece$PIECE-mult$MULT-height$HEIGHT-$LETTER/analysis/COM_$SPECIES.xvg
	REFFILE=PC60PE40-PC50PE40CL10-1OKC-piece$PIECE-mult$MULT-height$HEIGHT-$LETTER/analysis/COM_Membrane.xvg
	OUTFILE=$RESDIR/msd-$SPECIES-piece$PIECE-mult$MULT-height$HEIGHT-$LETTER.dat

	DC_ALL=$( python ../scripts/membrane_diffusion/memdiff.py -trj $TRJFILE -ref $REFFILE -out $OUTFILE -nbl 020 -sb 400 -se 100 )

	echo "$BOXX $BOXZ $DC_ALL" >> $RESDIR/dc_$SPECIES.dat

	cd $STDDIR
	
}


#######################################################
#  MAIN  -  MAIN  -  MAIN  -  MAIN  -  MAIN  -  MAIN  #
#######################################################


TRJDIR=$( pwd )
STDDIR=$( pwd )

RESDIR="results-translation"
mkdir $RESDIR

cd $STDDIR 

HEIGHTS="07.5 10.0 12.5 15.0 17.5 20.0"
LETTERS="A B C D E F"

for SPECIES in 'Protein' 'CDL2' 'POPC' 'POPE' 'POPC_lower' 'POPC_upper' 'POPE_lower' 'POPE_upper'; do
	echo "# Box-X Box-Z D Err " > $RESDIR/dc_$SPECIES.dat
	for HEIGHT in $HEIGHTS ; do
		for LETTER in $LETTERS; do
			echo "PC60PE40-PC50PE40CL10-1OKC-piece$PIECE-mult$MULT-$LETTER" 
			doanalysis $SPECIES $HEIGHT $STDDIR $TRJDIR $RESDIR $LETTER
		done
	done
done


wait


unset doanalysis


exit
