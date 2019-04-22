# rotmemdiff
Study on finite-size effects on rotational diffusion in membranes: parameters, analysis scripts, and results.

This repository contains:
- **simulation folders** (simulations-\*) with start coordinates, simulation parameters, and analysis scripts. The scripts called protein_rotation.py calculate the rotation between two frames using RMSD fits.
- **analysis notebooks** (\*.ipynb) to calculate rotational diffusion coefficients. These scripts recreate plots in the paper. Note that for ANT1 simulations, variables with "old" refer to data from previous simulations (constant-density study) and variables with "new" to simulations that were performed for the rotational diffusion paper (dilute-limit study).
- **data files** of diffusion coefficients (\*.dat) and the corresponding box sizes.
- the python library diffusion.py with functions to calculate diffusion.
