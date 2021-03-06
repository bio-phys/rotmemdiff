import numpy as np
import MDAnalysis as mda
from MDAnalysis.analysis import align
from MDAnalysis.analysis.rms import rmsd

# initialize the system
u = mda.Universe('analysis/mdstart_Membrane.gro','analysis/nojump_Membrane.xtc')
bb = u.select_atoms('name B*')
num_proteins = len(bb)/292

outfile = open('analysis/Rotation_Protein.xvg','w')

# Write header and legend
outfile.write("# This file was generated by protein_rotation.py\n")
outfile.write( "# Martin Voegele, MPI of Biophysics\n")
outfile.write( "# Version 2018-09-17\n")

outfile.write( "@    title \"Rotation\"\n" )
outfile.write( "@    xaxis  label \"Time (ps)\"\n")
outfile.write( "@    yaxis  label \"Rot. Angle (rad)\"\n")
outfile.write( "@TYPE xy\n" )

outfile.write( "@ view 0.15, 0.15, 0.75, 0.85\n" )
outfile.write( "@ legend on\n" )
outfile.write( "@ legend box on\n" )
outfile.write( "@ legend loctype view\n" )
outfile.write( "@ legend 0.78, 0.8\n" )
outfile.write( "@ legend length 2\n" )

for proti in xrange(num_proteins):
    outfile.write( "@ s"+str(proti)+" legend \"Protein "+str(proti)+" delta_theta\"\n" )

# initial reference structure
ref = []
for i in xrange(num_proteins):
    prot = bb[i*292:(i+1)*292]
    ref.append(prot.positions - prot.center_of_mass())


# START LOOP HERE
for ts in u.trajectory:
    
    # Initialize the print string with the current simulation time
    format_string = '%4.4e ' % ts.time

    # go through all proteins
    for i in xrange(num_proteins):
        # select the protein
        prot = bb[i*292:(i+1)*292]
        # remove center of mass
        mobile = prot.positions - prot.center_of_mass() 
        # project to xy plane by setting z coord. to zero
        mobile[:,2] = 0
        ref[i][:,2] = 0
	# RMSD fit to the respective reference
        R, rmsd = align.rotation_matrix( mobile, ref[i] )
        # Calculate the angle wrt the last structure (increment of theta) from the rotation matrix
        delta_theta = np.arcsin(R[1,0])
        # add the increment of theta to the print string
        format_string = format_string+'%4.8f ' % delta_theta
        # calculate new reference structures
        ref[i] = np.copy( prot.positions - prot.center_of_mass() )

    # write results of this time step to the file
    outfile.write( format_string+'\n' )

outfile.close()

