mkdir results-rotation

for DIR in PC60PE40-PC50PE40CL10-1OKC-piece*-mult01-*; do 

	echo $DIR

	cd $DIR

	mkdir analysis

	cp ../protein_rotation.py .
	python protein_rotation.py
	 
	cp analysis/Rotation_Protein.xvg ../results-rotation/Rotation_Protein_$DIR.xvg

	cd ..

done
