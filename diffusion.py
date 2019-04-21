import numpy as np


def compute_correlation_via_fft(x, y=None):
    """
    Correlation of two arrays calculated via FFT
    """
    x   = np.array(x)
    l   = len(x)
    xft = np.fft.fft(x, 2*l)
    if y is None:
        yft = xft
    else:
        y   = np.array(y)
        yft = np.fft.fft(y, 2*l)
    corr    = np.real(np.fft.ifft(np.conjugate(xft)*yft))
    norm    = l - np.arange(l)
    corr    = corr[:l]/norm
    return corr


def compute_MSD_3D_via_correlation(x,y,z):
    """
    Three-dimensional MSD calculated via FFT-based auto-correlation
    """
    corrx  = compute_correlation_via_fft(x) 
    corry  = compute_correlation_via_fft(y)
    corrz  = compute_correlation_via_fft(z)
    nt     = len(x)
    dsq    = x**2+y**2+z**2
    sumsq  = 2*np.sum(dsq)
    msd    = np.empty(nt)
    msd[0] = 0
    for m in range(1,nt):
        sumsq  = sumsq - dsq[m-1]-dsq[nt-m]
        msd[m] = sumsq/(nt-m) - 2*corrx[m] - 2*corry[m] - 2*corrz[m]        
    return msd    


def compute_MSD_1D_via_correlation(x):
    """
    One-dimensional MSD calculated via FFT-based auto-correlation
    """
    corrx  = compute_correlation_via_fft(x) 
    nt     = len(x)
    dsq    = x**2
    sumsq  = 2*np.sum(dsq)
    msd    = np.empty(nt)
    msd[0] = 0
    for m in range(1,nt):
        sumsq  = sumsq - dsq[m-1]-dsq[nt-m]
        msd[m] = sumsq/(nt-m) - 2*corrx[m]
    return msd    


# Function for the mean squared displacement averaged over an array of trajectories
def average_MSD(xarr,frames_per_block,first,last):
    msd = np.zeros(frames_per_block)
    arrshape = np.shape(xarr)
    for i in np.arange(0,arrshape[0]):
        x = xarr[i]
        newmsd = compute_MSD_1D_via_correlation(x[first:last])
        msd += newmsd
    msd /= arrshape[0]
    return msd
    
    
#** Calculate the diffusion coefficient from MSD functions **#
def compute_dc(t,x,numblocks,fitstart,fitend):
    
    frames_per_block = int(len(t)/numblocks)

    dc  = np.zeros(numblocks)

    for i in range(0, numblocks):
        
        first  = i*frames_per_block
        last   = (i+1)*frames_per_block
        
        newmsd = average_MSD(x,frames_per_block,first,last)
        
        # Regression on a single mean squared displacement
        regr   = np.polyfit(t[fitstart:fitend], newmsd[fitstart:fitend], 1)
        dc[i]  = regr[0]/2

    # Total MSD
    msd = average_MSD(x,len(t),0,len(t)) 
    
    # Regression on the total MSD
    totregr = np.polyfit(t[fitstart:fitend], msd[fitstart:fitend], 1)
    
    # Write values to the arrays
    totdc     = totregr[0]/2
    diffcoeff = np.nanmean(dc)
    err_diffc = np.nanstd(dc)/np.sqrt(len(dc))        
    
    return totdc, diffcoeff, err_diffc, t, msd