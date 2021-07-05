#! /bin/sh

# OpenGrok docker运行脚本
# Copyright (C) 2019-2021 Oak Chen <oak@sfysoft.com>

port=8090
rest=5000
until [ $# -eq 0 ]
do
	case $1 in
	-h | --help)
		echo "Usage:"
		echo "-h, --help        Display this information"
		echo "-s, --source      Source directory"
		echo "-d, --data        Opengrok data directory, if not specified, inside the docker"
		echo "-e, --etc         Opengrok configuration directory for both web app and indexer, if not specified, inside the docker"
		echo "-t, --period      Period of automatic synchronization by minute"
		echo "-n, --no-home     Don't map $HOME directory"
		echo "-p, --port        Listen port, default 8090"
		echo "-r, --rest        Rest API port, default 5000"
		echo "-i, --ignore      Ignore files, support * and more than once, such as '*'.dat, avoid extending by Shell"
		echo "-I, --ignore-dir  Ignore directory"
		echo "-H, --history     Enable history"
		echo "-m, --mirror      Enable opengrok-mirror(https://github.com/oracle/opengrok/wiki/Repository-synchronization)"
		exit
		;;
	-s | --source)
		src=$2
		shift
		;;
	-d | --data)
		data=$2
		shift
		;;
	-e | --etc)
		etc=$2
		shift
		;;
	-t | --period)
		period=$2
		shift
		;;
	-n | --no-home)
		nohome=true
		;;
	-p | --port)
		port=$2
		shift
		;;
	-r | --rest)
		rest=$2
		shift
		;;
	-i | --ignore)
		index_opts="$index_opts -i $2"
		shift
		;;
	-I | --ignore-dir)
		index_opts="$index_opts -i d:$2"
		shift
		;;
	-H | --history)
		index_opts="$index_opts -H"
		;;
	-m | --mirror)
		mirror=true
		;;
	*)
		others="$*"
		break
		;;
	esac
	shift
done


if [ "$src" != "" ]; then
	options="$options -v $src:/opengrok/src"
else
	echo "Source directory missed, use $0 -h for help"
	exit
fi

if [ "$data" != "" ]; then
	options="$options -v $data:/opengrok/data"
fi

if [ "$etc" != "" ]; then
	options="$options -v $etc:/opengrok/etc"
fi

if [ "$period" != "" ]; then
	options="$options -e SYNC_PERIOD_MINUTES=$period"
fi

if [ -z "$nohome" ]; then
	options="$options -v $HOME:$HOME"
fi

if [ "$port" != "" ]; then
	options="$options -p $port:8080"
fi

if [ "$rest" != "" ]; then
	options="$options -p $rest:5000"
fi

if [ "$mirror" != "true" ]; then
	options="$options -e NOMIRROR=1"
fi

if [ "$index_opts" != "" ]; then
	# shellcheck disable=SC2089
	options="$options -e INDEXER_OPT=\"$index_opts\""
fi

options="$options $others"
commandline="docker run -d --restart=always $options oakchen/opengrok"

echo "$commandline"
# shellcheck disable=SC2090
$commandline
