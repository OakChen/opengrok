# A Docker container for OpenGrok

This docker is based on official OpenGrok docker(opengrok/docker), but replace the default fonts and disable history.

## Download from Docker Hub

    docker pull oakchen/opengrok

## Usage

    docker run -d --restart=always -p 8090:8080 -v /path/to/source_root:/opengrok/src -e NOMIRROR=1 oakchen/opengrok

Also, you can specify a directory to store index data, if you don't do this, /opengrok/data inside container will be used.

    docker run -d --restart=always -p 8090:8080 -v /path/to/source_root:/opengrok/src -v /path/to/index_root:/opengrok/data -e NOMIRROR=1 oakchen/opengrok

The container has OpenGrok as default web app installed (accessible directly from /). With the above container setup, you can find it running on

http://dockerhost:8090/

Please note: on first startup, the web interface will display empty content until the indexing has been completed. Give it some time (depending on the amount of data indexed - might take many hours for large code bases !) and reload.

The subsequent reindex will be incremental so will take signigicantly less time.

## Configurable parameters by environment variables

    INDEXER_OPT ""		# Specify index options, such as ignore files: "-i *.dat -i d:out"
    SYNC_PERIOD_MINUTES     10	# The index will be rebuild every ten minutes

## Others

There is a wrapped shell script to run this docker: https://github.com/OakChen/opengrok/raw/master/run.sh.

