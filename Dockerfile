FROM opengrok/docker
MAINTAINER Oak Chen <oak@sfysoft.com>

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends cron procps vim locales apt-utils && \
    sed -i "s/^# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen && \
    locale-gen && update-locale LANG=en_US.UTF-8 LANGUAGE="en_US:en" && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

RUN curl http://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo && chmod +x /usr/local/bin/repo

COPY reindex.sh /scripts/
COPY reindex.cron /etc/
COPY embed-font.* /tmp/

RUN cat /tmp/embed-font.sh >> /scripts/index.sh && \
    rm /tmp/embed-font.sh

RUN crontab /etc/reindex.cron && \
    mkdir -p /var/log/reindex && \
    sed -i "s/^\(indexer \&\)$/service cron start\n\1/" /scripts/start.sh && \
    sed -i "s/-H -P -S -G/-P/" /scripts/index.sh

ENV _JAVA_OPTIONS="-Xmx1G"
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
