FROM opengrok/docker
MAINTAINER Oak Chen <oak@sfysoft.com>

RUN apt-get update -y && apt-get install -y --no-install-recommends cron procps vim && rm -rf /var/lib/apt/lists/* && apt-get clean

RUN curl http://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo && chmod +x /usr/local/bin/repo
RUN mkdir -p /var/log/reindex

COPY reindex.sh /scripts/
COPY reindex.cron /etc/

RUN crontab /etc/reindex.cron
RUN sed -i "s/^\(indexer \&\)$/service cron start\n\1/" /scripts/start.sh
RUN sed -i "s/-G //" /scripts/index.sh

ENV _JAVA_OPTIONS="-Xmx2G"
