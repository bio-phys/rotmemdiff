
for DIR in PC60PE40*; do

	cp -r $DIR ${DIR}-A
	cp -r $DIR ${DIR}-B
	cp -r $DIR ${DIR}-C
	cp -r $DIR ${DIR}-D
	cp -r $DIR ${DIR}-E
	cp -r $DIR ${DIR}-F

done


COUNTER='0'

for DIR in *-mult01-*; do
	
	COUNTER=$(($COUNTER+1))
	sed -i "s/gen_seed                 = /gen_seed                 = $COUNTER/g" $DIR/resources/martini_eq.mdp
	sed -i "s/gen_seed                 = /gen_seed                 = $COUNTER/g" $DIR/resources/martini_md.mdp

done
