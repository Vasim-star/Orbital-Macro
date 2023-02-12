README.TXT for sgp4mat.zip

This zip file contains a matlab version of the SGP4 propagator for generating satellite ephemerides.  The code is a line-by-line translation of Vallado's C++ version of 28 Jun 05.

Contents:

  drivers
    sgp4test.m - driver script for testing and example usage
    twoline2rv.m - TLE conversion routine

  core routines
    sgp4.m
    sgp4init.m
    initl.m
    dsinit.m
    dspace.m
    dpper.m
    dscom.m

  test files
    sgp4-all.tle - TLE file for testing
    tmatver.af80 - verification test output when AF80 inclination check is used in dpper (as delivered)
    tmatver.gsfc - verification test output when AF80 inclination check is commented out

  debug routines
    debug1.m
    debug2.m
    debug3.m
    debug4.m
    debug5.m
    debug6.m
    debug7.m

To verify your installation, execute the sgp4test script in matlab.  At the input type prompt, enter "v". At the input elset prompt, enter "sgp4-all.tle".  The elset numbers will scroll down the screen and some error messages will appear.  When execution is complete, do a file comparison of your output file "tmatver.out" with "tmatver.af80" (or "tmatver.gsfc" if you elected to comment out the AF80 inclination selection in dpper).

To generate debug output, execute the following lines in matlab before executing sgp4test:

    global idebug
    idebug = 1;

If you have any corrections, comments, or suggestions, please feel free to contact me at beckja@alumni.lehigh.edu.  Also, if you develop any supplemental routines (e.g. a GUI driver or an orbit display) and would like to share them, I'll be happy to include them with future versions.

Jeff Beck
beckja@alumni.lehigh.edu
19 Oct 2005