#!/bin/bash

# try to find healthcheck port
[ -z "$CHECK_PORT" ] && CHECK_PORT="$CVAR_net_port"
[ -z "$CHECK_PORT" ] && CHECK_PORT=$(echo "$PARAMS" | tr "+" "\n" | grep net_port | awk '{print $3}')
[ -z "$CHECK_PORT" ] && CHECK_PORT=28960

# check
if [ -z "$(echo -e '\xff\xff\xff\xffgetinfo' | nc -w 1 -u 127.0.0.1 ${CHECK_PORT})" ] 
then 
  exit 1; 
else 
  exit 0; 
fi

