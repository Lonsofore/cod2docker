docker build \
--build-arg cod2_version="1_0" \
--build-arg libcod_mysql=1 \
--build-arg libcod_sqlite=1 \
-t cod2:1.0 \
.