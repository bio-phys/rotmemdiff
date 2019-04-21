mkdir results-rotation

for DIR in popc*-cnt1*; do 
	echo $DIR;
	NUM=0
	for FILE in $DIR/simulation/05_Prod_??.nc; do
		NUM=$(($NUM+1))
		NNN=$(printf "%02d" $NUM)
		python cnt_rotation.py -p $DIR/simulation/system.prmtop -t $FILE -o results-rotation/Rotation_CNT_$DIR-$NNN.xvg
	done
done
