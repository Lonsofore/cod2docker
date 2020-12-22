#!/bin/bash -ex

# prefix to parse cvars from envs
prefix=CVAR_

# show envs | search for prefix | delete prefix name | replace = to space | format to set cvar output | join lines
CVARS=$(env | grep $prefix | sed 's/CVAR_//g' | sed 's/=/ /g' | awk '{print "+set " $1 " " $2}' | paste -sd " " -)

# preload libcon and unload it in future
echo "/cod2/libcod.so" > /etc/ld.so.preload;
(sleep 15; echo "" > /etc/ld.so.preload) &

/cod2/cod2_lnxded "$PARAMS" "$CVARS"
