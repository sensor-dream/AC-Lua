#!/bin/bash

CUBE_DIR=$(dirname "$(readlink -f "${0}")")
/usr/bin/screen -s /bin/bash -dmS vahe ${CUBE_DIR}/bin_unix/native_server -PfkbMAsRCDEPw -k2 -y4 -McURD -Z7 -kb720 -LS5 -D2 -c12 -n'\f1|\f9VAH\f1| \f3- CTF' -x* -f28763
#${CUBE_DIR}/bin_unix/native_server -PfkbMAsRCDEPw -k2 -y4 -McURD -Z7 -kb720 -LS5 -D2 -c12 -n'\f1|\f9VAH\f1| \f3- CTF' -x* -f28763
