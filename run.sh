#! /bin/sh

# OpenGrok docker运行脚本
# Copyright (C) 2019-2019 Oak Chen <oak@sfysoft.com>

port=8090
until [ $# -eq 0 ]
do
	case $1 in
	-h | --help)
		echo "Usage:"
		echo "-h, --help        Display this information"
		echo "-s, --source      Source directory"
		echo "-d, --data        Opengrok data directory, if not specified, inside the docker"
		echo "-n, --no-home     Don't map $HOME directory"
		echo "-p, --port        Listen port, default 8090"
		echo "-i, --ignore      Ignore files, support * and more than once, such as '*'.dat, avoid extending by Shell"
		echo "-I, --ignore-dir  Ignore directory"
		echo "-H, --history     Enable history"
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
	-n | --no-home)
		nohome=true
		;;
	-p | --port)
		port=$2
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
		index_opts="$index_opts -H -S"
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

if [ -z "$nohome" ]; then
	options="$options -v $HOME:$HOME"
fi

if [ "$port" != "" ]; then
	options="$options -p $port:8080"
fi

if [ "$index_opts" != "" ]; then
	options="$options -e INDEXER_OPT=\"$index_opts\""
fi

options="$options $others"
# 无需自动索引，在容器内由cron每天自动运行一次索引
options="$options -e REINDEX=0"

commandline="docker run -d --restart=always $options oakchen/opengrok"

echo $commandline
eval $commandline
