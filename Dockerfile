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
ARG cod2_patch="0"
COPY ./cod2_lnxded/1_${cod2_patch} /cod2/cod2_lnxded

# compile libcod
ARG libcod_url="https://github.com/ibuddieat/zk_libcod"
ARG libcod_commit="54c4a8463b165bf22a85dece01e89fcf92315aa4"
ARG mysql_variant="1"
ARG sqlite_enabled="1"
RUN if [ "$mysql_variant" != "0" ] || [ "$sqlite_enabled" != "0" ]; then apt-get update; fi \
    && if [ "$mysql_variant" != "0" ]; then apt-get install -y libmysqlclient-dev:i386; fi \
    && if [ "$sqlite_enabled" != "0" ]; then apt-get install -y libsqlite3-dev:i386; fi \
    && if [ "$mysql_variant" != "0" ] || [ "$sqlite_enabled" != "0" ]; then apt-get clean; fi  \
    && cd /cod2 \
    && git clone ${libcod_url} \
    && cd zk_libcod \
    && if [ -z "$libcod_commit" ]; then git checkout ${libcod_commit}; fi

WORKDIR /cod2/zk_libcod/code
COPY ./doit.sh doit.sh
RUN yes ${mysql_variant} | ./doit.sh --cod2_patch=${cod2_patch} --speex=0 --mysql_variant=${mysql_variant} \
    && cp ./bin/libcod2_1_${cod2_patch}.so /cod2/libcod.so \
    && rm -rf /cod2/libcod

# base dir
WORKDIR /cod2

COPY healthcheck.sh entrypoint.sh /cod2/

# check server info every 5 seconds 7 times (check, if your server can change a map without restarting container)
HEALTHCHECK --interval=5s --timeout=3s --retries=7 CMD /cod2/healthcheck.sh

# start script
ENTRYPOINT /cod2/entrypoint.sh
