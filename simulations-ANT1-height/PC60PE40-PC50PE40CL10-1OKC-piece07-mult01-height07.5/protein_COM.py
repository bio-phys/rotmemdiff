import numpy as np
import MDAnalysis as mda

# initialize the system
u = mda.Universe('analysis/mdstart_Membrane.gro','analysis/nojump_Membrane.xtc')
bb = u.select_atoms('name B*')
num_proteins = len(bb)/292

outfile = open('analysis/COM_Protein.xvg','w')

# Write header and legend
outfile.write("# This file was generated by protein_COM.p\n")
outfile.write( "# Martin Voegele, MPI of Biophysics\n")
outfile.write( "# Version 2017-04-15\n")

outfile.write( "@    title \"Center of mass\"\n" )
outfile.write( "@    xaxis  label \"Time (ps)\"\n")
outfile.write( "@    yaxis  label \"Coordinate (nm)\"\n")
outfile.write( "@TYPE xy\n" )

outfile.write( "@ view 0.15, 0.15, 0.75, 0.85\n" )
outfile.write( "@ legend on\n" )
outfile.write( "@ legend box on\n" )
outfile.write( "@ legend loctype view\n" )
outfile.write( "@ legend 0.78, 0.8\n" )
outfile.write( "@ legend length 2\n" )

for proti in xrange(num_proteins):
    outfile.write( "@ s"+str(proti*3+0)+" legend \"Protein "+str(proti)+" X\"\n" )
    outfile.write( "@ s"+str(proti*3+1)+" legend \"Protein "+str(proti)+" Y\"\n" )
    outfile.write( "@ s"+str(proti*3+2)+" legend \"Protein "+str(proti)+" Z\"\n" )

# START LOOP HERE
for ts in u.trajectory:
    
    # Calculate all centers of mass
    com = []
    for i in xrange(num_proteins):
        prot = bb[i*292:(i+1)*292]
        comi = prot.center_of_mass()
        com.append(comi)
    com = np.array(com)*0.1 # Conversion from A to nm

    # Print all centers of mass
    format_string = '%4.4e ' % ts.time
    for i in xrange(num_proteins):
        format_string = format_string+'%4.4f %4.4f %4.4f ' % (com[i,0],com[i,1],com[i,2])
    outfile.write( format_string+'\n' )

outfile.close()
