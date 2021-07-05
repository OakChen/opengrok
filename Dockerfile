FROM opengrok/docker:1.7.13
MAINTAINER Oak Chen <oak@sfysoft.com>

# 避免Ubuntu 18.04+构建时提示debconf错误
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends procps vim locales apt-utils && \
    sed -i "s/^# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen && \
    locale-gen && update-locale LANG=en_US.UTF-8 LANGUAGE="en_US:en" && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

COPY embed-font.* /scripts/
# 替代默认字体
RUN sed -i "s#\(tomcat_popen.wait\)#os.system('/scripts/embed-font.sh')\n    \1#" /scripts/start.py
# 默认不允许历史记录
RUN sed -i "/'-H'/d" /scripts/start.py

ENV _JAVA_OPTIONS="-Xmx1G"
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
