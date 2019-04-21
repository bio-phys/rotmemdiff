set -ex

for DIR in PC*-mult01-*; do 
	cp postprocessing-0*.sh $DIR
	cd $DIR
	./postprocessing-00-trajectories.sh 
	./postprocessing-01-com.sh
        cd ..
done

