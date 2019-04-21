set -ex

PIECE=7
MULT=1
EDGE=$(($MULT*$PIECE))
HEIGHT=15


mkdir buildup
cd buildup


cp ../resources/protein.pdb .
cp ../resources/protein.itp .


../resources/insane-modx.py -l POPC:35 -l POPX:15 -l POPE:30 -l POPY:10 -l CDL2:10 -u POPC:45 -u POPX:15 -u POPE:30 -u POPY:10 -salt 0.15 -x $PIECE -y $PIECE -z $HEIGHT -center -pbc cubic -sol W:9 -sol WF:1 -f protein.pdb -p piece.top -o piece.gro

gmx genconf -nbox $MULT $MULT 1 -f piece.gro -o system.gro


cp piece.top system.top

for i in $( seq $(($MULT*$MULT-1)) ); do
	echo $i
	tail -n 14 piece.top >> system.top
done


printf '1|13|14|15|16|17|23|24|25|26|27 \n 18|19|20|21|28|29|30|31 \n name 32 Membrane \n name 33 Water \n q \n' | gmx make_ndx -f system.gro -o index.ndx


cd ..

