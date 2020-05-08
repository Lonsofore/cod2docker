FROM ubuntu:18.04

# cod2 requirements 
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y \
        g++-multilib \
        libstdc++5:i386 \
        netcat \
        git \
    && apt-get clean

# copy cod2 server file
ARG cod2_version="1_0"
COPY ./cod2_lnxded/${cod2_version} /cod2/cod2_lnxded

# compile libcod
ARG libcod_url="https://github.com/voron00/libcod"
ARG libcod_commit
ARG libcod_mysql="1"
ARG libcod_sqlite="1"
RUN if [ "$libcod_mysql" != "0" ] || [ "$libcod_sqlite" != "0" ]; then apt-get update; fi \
    && if [ "$libcod_mysql" != "0" ]; then apt-get install -y libmysqlclient-dev:i386; fi \
    && if [ "$libcod_sqlite" != "0" ]; then apt-get install -y libsqlite3-dev:i386; fi \
    && if [ "$libcod_mysql" != "0" ] || [ "$libcod_sqlite" != "0" ]; then apt-get clean; fi  \
    && cd /cod2 \
    && git clone ${libcod_url} \
    && cd libcod \
    && if [ -z "$libcod_commit" ]; then git checkout ${libcod_commit}; fi \
    && yes ${libcod_mysql} | ./doit.sh cod2_${cod2_version} \
    && cp /cod2/libcod/bin/libcod2_${cod2_version}.so /cod2/libcod.so \
    && rm -rf /cod2/libcod

# base dir
WORKDIR /cod2

# check server info every 5 seconds 7 times (check, if your server can change a map without restarting container)
HEALTHCHECK --interval=5s --timeout=3s --retries=7 CMD if [ -z "$(echo -e '\xff\xff\xff\xffgetinfo' | nc -w 1 -u 127.0.0.1 ${CHECK_PORT})" ]; then exit 1; else exit 0; fi

# preload libcod
# plan to unload it
# start the server
ENTRYPOINT echo "/cod2/libcod.so" > /etc/ld.so.preload; \
    (sleep 15; echo "" > /etc/ld.so.preload) & \
    /cod2/cod2_lnxded "$PARAMS"
