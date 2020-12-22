#!/bin/bash -ex

# prefix to parse cvars from envs
prefix=COD2_
cmds=(set seta sets)

# show envs | search for prefix | delete prefix name | replace = to space | format to set cvar output | join lines
COMMANDS=""
for cmd in ${cmds[@]}; do
    fullprefix="${prefix}${cmd^^}_"
    parsed=$(env | grep $fullprefix | sed "s/$fullprefix//g" | sed 's/=/ /g' | awk -v cmd=$cmd '{print "+" cmd " " $1 " " $2}' | paste -sd " " -)
    COMMANDS="$COMMANDS $parsed" 
done

# preload libcon and unload it in future
echo "/cod2/libcod.so" > /etc/ld.so.preload;
(sleep 15; echo "" > /etc/ld.so.preload) &

/cod2/cod2_lnxded "$PARAMS_BEFORE $COMMANDS $PARAMS $PARAMS_AFTER"
