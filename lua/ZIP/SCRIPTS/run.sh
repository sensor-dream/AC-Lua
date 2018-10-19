#!/bin/bash

cd CTF
#./ctf_server.sh & > /dev/null
./lua_ctf_server.sh & > /dev/null
cd ../GEMA
#./gema_server.sh & > /dev/null
./lua_gema_server.sh & > /dev/null
cd ../LSS
#./lss_server.sh & > /dev/null
./lua_lss_server.sh & > /dev/null
cd ../VS
#./vs_server.sh & > /dev/null
./lua_vs_server.sh & > /dev/null
#cd ../TEMPLE
#./temle_server.sh & > /dev/null
#./lua_temle_server.sh & > /dev/null
