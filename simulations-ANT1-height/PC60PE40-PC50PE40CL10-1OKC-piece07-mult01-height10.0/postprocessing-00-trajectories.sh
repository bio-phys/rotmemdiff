# --------------------------------------
# Write out different COM coordinates
# --------------------------------------

mkdir analysis

set -ex

cd simulation

# Create new topology and index files to be used for anlysis of trajectories without water

printf "Membrane\n" | trjconv -f system.gro -o mem.gro -b 0 -e 0 -s martini_md.tpr -pbc whole -n index.ndx
printf "0\nname 16 Membrane\nq\n" | make_ndx -f mem.gro -o mem.ndx
sed '/^W/ d' ../simulation/system.top | sed '/^NA/ d' | sed '/^CL/ d' > mem.top 
sed 's/Water//g' martini_md.mdp | sed 's/1.0    1.0/1.0/g' | sed 's/310    310/310/g' > mem.mdp
grompp -c mem.gro -f mem.mdp -p mem.top -o mem.tpr -n mem.ndx
mv mem.* ../analysis

cd ../analysis


# Now postprocess the trajectories

for COMP in 'Membrane' 'Protein' 'CDL2' 'POPC' 'POPE'; do 

	printf "$COMP\n" | trjconv -f ../simulation/martini_md.xtc -o mdstart_$COMP.gro -b 0 -e 0 -s mem.tpr -pbc whole -n mem.ndx 
	printf "$COMP\n" | trjconv -f ../simulation/martini_md.xtc -s mem.tpr -n mem.ndx -o whole_$COMP.xtc -pbc whole 
	printf "0 \n" | trjconv -f whole_$COMP.xtc -o nojump_$COMP.xtc -pbc nojump 

done

cd ..
