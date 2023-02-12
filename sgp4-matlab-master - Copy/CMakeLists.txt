# $Id$
#
# 

project(matsgp4)

set (MATLAB_INSTALL_DIR "${MATLAB_INSTALL_DIR}/SGP4")

set (MFILES
#    Contents.m
    debug1.m
    debug2.m
    debug3.m
    debug4.m
    debug5.m
    debug6.m
    debug7.m
    dpper.m
    dscom.m
    dsinit.m
    dspace.m
    getgravc.m
    initl.m
    sgp4.m
    sgp4init.m
#    sgp4-ver.tle
#    testmat.m
#    tmatver.dav
#    tmatver.out
    twoline2rv.m
)

# install copy of matlab files in build directory for testing
foreach (MFILE ${MFILES})
	configure_file (${MFILE} ${MFILE} COPYONLY)
endforeach (MFILE ${MFILES})

install (PROGRAMS ${MFILES} DESTINATION ${MATLAB_INSTALL_DIR}/)

# HISTORY
#  $Log:  $
#
