#!/bin/bash

CUBE_DIR=$(dirname "$(readlink -f "${0}")")
/usr/bin/screen -s /bin/bash -dmS vahe ${CUBE_DIR}/bin_unix/linux_64_server -PfkbMAsRCDEPw -k2 -kA60 -y4 -McURD -Z7 -kb720 -LS5 -D2 -c4 -n'\f1|\f9VAH\f1| \f0- LSS' -x* -f28963
#${CUBE_DIR}/bin_unix/linux_64_server -PfkbMAsRCDEPw -k2 -y4 -McURD -Z7 -kb720 -LS5 -D1 -c4 -n'\f1|\f9VAH\f1| \f0- LSS' -x* -f28963
