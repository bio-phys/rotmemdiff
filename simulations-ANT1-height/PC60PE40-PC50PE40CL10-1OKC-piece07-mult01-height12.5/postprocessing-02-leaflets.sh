# -------------------------------------------------------------------
# Split COM coordinates for leaflets
# Only applicable to lipid species that are present in both leaflets
# (will otherwise draw the leaflet boundary within one leaflet)
# -------------------------------------------------------------------

set -ex

DIRECTORY=$( pwd )

cp ../leaflets.py .

for COMP in 'POPC' 'POPE' ; do 

	python leaflets.py $COMP

done

cd ..
