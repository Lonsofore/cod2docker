#!/bin/bash

# ./doit.sh --cod2_patch=3 --speex=0 --mysql_variant=2

cc="g++"
options="-I. -m32 -fPIC -Wall"
# -g -ggdb -O0 // debug build without optimization
# -Wno-write-strings // not full warnings

# [Custom] Get parameters
debug="0"
while [ $# -gt 0 ]; do
    case "$1" in
        --cod2_patch=*)
        cod2_patch="${1#*=}"
        ;;
        --speex=*)
        speex="${1#*=}"
        ;;
        --mysql_variant=*)
        mysql_variant="${1#*=}"
        ;;
        --debug=*)
        debug="${1#*=}"
        ;;
        *)
        echo "Unknown argument: $1"
        exit 1
        ;;
    esac
    shift
done

for arg_name in "cod2_patch" "speex" "mysql_variant"; do
    arg_value=$(eval echo \$$arg_name)
    if [ -z "$arg_value" ]; then
        echo "Error: Missing argument --${arg_name}"
        exit 1
    fi
done
# End: [Custom] Get parameters


mysql_link=""
if [ "$mysql_variant" = '1' ]; then
    sed -i "/#define COMPILE_MYSQL_DEFAULT 0/c\#define COMPILE_MYSQL_DEFAULT 1" config.hpp
    if [ -d "./vendors/lib" ]; then
        mysql_link="-lmysqlclient -L./vendors/lib"
        export LD_LIBRARY_PATH_32="./vendors/lib"
    else
        mysql_link="-lmysqlclient -L/usr/lib/mysql"
    fi
elif [ "$mysql_variant" = '2' ]; then
    sed -i "/#define COMPILE_MYSQL_VORON 0/c\#define COMPILE_MYSQL_VORON 1" config.hpp
    if [ -d "./vendors/lib" ]; then
        mysql_link="-lmysqlclient -L./vendors/lib"
        export LD_LIBRARY_PATH_32="./vendors/lib"
    else
        mysql_link="-lmysqlclient -L/usr/lib/mysql"
    fi
fi


if [ "$speex" == "0" ]; then
    speex_link=""
    sed -i "/#define COMPILE_CUSTOM_VOICE 1/c\#define COMPILE_CUSTOM_VOICE 0" config.hpp
else
    speex_link="-lspeex"
fi

if [ "$debug" == "1" ]; then
    debug="-g -ggdb -O0"
else
    debug=""
fi
set -- "cod2_1_${cod2_patch}"
constants="-D COD_VERSION=COD2_1_${cod2_patch}"

if [ -f extra/functions.hpp ]; then
	constants+=" -D EXTRA_FUNCTIONS_INC"
fi

if [ -f extra/config.hpp ]; then
	constants+=" -D EXTRA_CONFIG_INC"
fi

if [ -f extra/includes.hpp ]; then
	constants+=" -D EXTRA_INCLUDES_INC"
fi

if [ -f extra/methods.hpp ]; then
	constants+=" -D EXTRA_METHODS_INC"
fi

mkdir -p bin
mkdir -p objects_$1

echo "##### COMPILE $1 CRACKING.CPP #####"
$cc $debug $options $constants -c cracking.cpp -o objects_$1/cracking.opp

echo "##### COMPILE $1 GSC.CPP #####"
$cc $debug $options $constants -c gsc.cpp -o objects_$1/gsc.opp

if  grep -q "COMPILE_BOTS 1" config.hpp; then
	echo "##### COMPILE $1 GSC_BOTS.CPP #####"
	$cc $debug $options $constants -c gsc_bots.cpp -o objects_$1/gsc_bots.opp
fi

if  grep -q "COMPILE_ENTITY 1" config.hpp; then
	echo "##### COMPILE $1 GSC_ENTITY.CPP #####"
	$cc $debug $options $constants -c gsc_entity.cpp -o objects_$1/gsc_entity.opp
fi

if grep -q "COMPILE_EXEC 1" config.hpp; then
	echo "##### COMPILE $1 GSC_EXEC.CPP #####"
	$cc $debug $options $constants -c gsc_exec.cpp -o objects_$1/gsc_exec.opp
fi

if grep -q "COMPILE_LEVEL 1" config.hpp; then
	echo "##### COMPILE $1 GSC_LEVEL.CPP #####"
	$cc $debug $options $constants -c gsc_level.cpp -o objects_$1/gsc_level.opp
fi

if grep -q "COMPILE_MEMORY 1" config.hpp; then
	echo "##### COMPILE $1 GSC_MEMORY.CPP #####"
	$cc $debug $options $constants -c gsc_memory.cpp -o objects_$1/gsc_memory.opp
fi

if [ $mysql_variant == 1 ]; then
	echo "##### COMPILE $1 GSC_MYSQL.CPP #####"
	$cc $debug $options $constants -c gsc_mysql.cpp -o objects_$1/gsc_mysql.opp
fi

if [ $mysql_variant == 2 ]; then
	echo "##### COMPILE $1 GSC_MYSQL_VORON.CPP #####"
	$cc $debug $options $constants -c gsc_mysql_voron.cpp -o objects_$1/gsc_mysql_voron.opp
fi

if grep -q "COMPILE_PLAYER 1" config.hpp; then
	echo "##### COMPILE $1 GSC_PLAYER.CPP #####"
	$cc $debug $options $constants -c gsc_player.cpp -o objects_$1/gsc_player.opp
fi

if grep -q "COMPILE_UTILS 1" config.hpp; then
	echo "##### COMPILE $1 GSC_UTILS.CPP #####"
	$cc $debug $options $constants -c gsc_utils.cpp -o objects_$1/gsc_utils.opp
fi

if grep -q "COMPILE_WEAPONS 1" config.hpp; then
	echo "##### COMPILE $1 GSC_WEAPONS.CPP #####"
	$cc $debug $options $constants -c gsc_weapons.cpp -o objects_$1/gsc_weapons.opp
fi

if [ "$(< config.hpp grep '#define COMPILE_BSP' | grep -o '[0-9]')" == "1" ]; then
	echo "##### COMPILE $1 BSP.CPP #####"
	$cc $debug $options $constants -c bsp.cpp -o objects_"$1"/bsp.opp
fi

if [ "$(< config.hpp grep '#define COMPILE_JUMP' | grep -o '[0-9]')" == "1" ]; then
	echo "##### COMPILE $1 JUMP.CPP #####"
	$cc $debug $options $constants -c jump.cpp -o objects_"$1"/jump.opp
fi

echo "##### COMPILE $1 LIBCOD.CPP #####"
$cc $debug $options $constants -c libcod.cpp -o objects_$1/libcod.opp

echo "##### COMPILE $1 QVSNPRINTF.C #####"
$cc $debug $options $constants -c lib/qvsnprintf.c -o objects_"$1"/qvsnprintf.opp

if [ -d extra ]; then
	echo "##### COMPILE $1 EXTRAS #####"
	cd extra
	for F in *.cpp;
	do
		echo "###### COMPILE $1 EXTRA: $F #####"
		$cc $debug $options $constants -c $F -o ../objects_$1/${F%.cpp}.opp;
	done
	cd ..
fi

echo "##### LINKING lib$1.so #####"
objects="$(ls objects_$1/*.opp)"
$cc -m32 -shared -L/lib32 -o bin/lib$1.so -ldl $objects -lpthread $mysql_link $speex_link
rm objects_$1 -r

if [ mysql_variant > 0 ]; then
	sed -i "/#define COMPILE_MYSQL_DEFAULT 1/c\#define COMPILE_MYSQL_DEFAULT 0" config.hpp
	sed -i "/#define COMPILE_MYSQL_VORON 1/c\#define COMPILE_MYSQL_VORON 0" config.hpp
fi

# Read leftover
rm 0