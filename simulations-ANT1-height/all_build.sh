
for DIR in *-mult01-*height*; do
	cd $DIR	
	bash buildup.sh
	cd ..
done
