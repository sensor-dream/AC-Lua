#!/bin/bash

CUBE_DIR=$(dirname "$(readlink -f "${0}")")
#/usr/bin/screen -s /bin/bash -dmS vahe ${CUBE_DIR}/bin_unix/linux_64_server -PfkbMAsRCDEPw -k2 -y4 -McURD -Z7 -kb720 -LS5 -D2 -c8 -n'\f1|\f2VAH\f1| \fX- \f9G\f2e\f1m\f0A' -x* -f28863

/usr/bin/screen -s /bin/bash -dmS vahe ${CUBE_DIR}/bin_unix/linux_64_server -PfkbMAsRCDEPw  -McURD -Z7 -kb720 -kA25 -LS5 -D1 -c8 -n'\f1|\f2VAH\f1| \fX- \f9G\f2e\f1m\f0A' -p'gemavah' -x* -f28863
#${CUBE_DIR}/bin_unix/linux_64_server -PfkbMAsRCDEPw -k2 -y4 -McURD -Z7 -kb720 -LS5 -D2 -c8 -n'\f1|\f2VAH\f1| \fX- \f9G\f2e\f1m\f0A' -p'gemavah' -x* -f28863
