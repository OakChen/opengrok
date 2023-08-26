FROM opengrok/docker:1.12
MAINTAINER Oak Chen <oak@sfysoft.com>

# 避免Ubuntu 18.04+构建时提示debconf错误
ENV DEBIAN_FRONTEND noninteractive

COPY replace-font /sbin/
RUN apt update -y && \
    apt upgrade -y && \
    apt install -y procps vim locales apt-utils csstidy && \
    sed -i "s/^# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen && \
    locale-gen && update-locale LANG=en_US.UTF-8 LANGUAGE="en_US:en" && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean && \
    pushd $(mktemp -d) && \
    jar xf /opengrok/lib/source.war && \
    /sbin/replace-font && \
    jar -m META-INF/MANIFEST.MF --create -f /opengrok/lib/source.war * && \
    popd && \
    rm -rf /tmp/*

# 默认不允许历史记录
RUN sed -i '/"-H"/d' /scripts/start.py

ENV _JAVA_OPTIONS="-Xmx4G"
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
