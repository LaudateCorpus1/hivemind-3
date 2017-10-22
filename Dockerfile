FROM phusion/baseimage:0.9.19


ENV ENVIRONMENT DEV
ENV LOG_LEVEL INFO
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV PIPENV_VENV_IN_PROJECT 1
ENV APP_ROOT /app
ENV WSGI_APP ${APP_ROOT}/hive/server/serve.py
ENV HTTP_SERVER_PORT 9000

RUN \
    apt-get update && \
    apt-get install -y \
        build-essential \
        daemontools \
        libffi-dev \
        libmysqlclient-dev \
        libssl-dev \
        make \
        python3 \
        python3-dev \
        python3-pip \
        python3-setuptools \
        libxml2-dev \
        libxslt-dev \
        runit \
        libpcre3 \
        libpcre3-dev

RUN \
    pip3 install --upgrade pip setuptools

ADD . /app

RUN \
    mv /app/service/* /etc/service && \
    chmod +x /etc/service/*/run

WORKDIR /app

RUN \
    pip3 install . && \
    apt-get remove -y \
        build-essential \
        libffi-dev \
        libssl-dev && \
    apt-get autoremove -y && \
    rm -rf \
        /root/.cache \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /var/cache/* \
        /usr/include \
        /usr/local/include

EXPOSE ${HTTP_SERVER_PORT}
