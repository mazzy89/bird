FROM ghcr.io/linuxserver/baseimage-ubuntu:bionic

ARG BIRD_RELEASE
LABEL maintainer="mazzy89"

ENV DEBIAN_FRONTEND="noninteractive"

RUN \
  echo "**** install build dependencies ****" && \
  apt-get update && \
  apt-get install -y \
    build-essential \
    flex \
    bison \
    autoconf \
    ncurses-dev \
    libreadline-dev \
    libssh-gcrypt-dev \
    linuxdoc-tools-latex \
    texlive-latex-extra \
    opensp \
    docbook-xsl \
    xsltproc && \
  echo "**** install runtime dependencies ****" && \
  apt-get install -y \
    git \
    dpkg-dev \
    debhelper \
    apt-utils \
    quilt \
    python3 \
    python3-pip \
    python3-setuptools && \
    echo "**** install bird ****" && \
    git clone https://gitlab.nic.cz/labs/bird.git && \
    cd bird && \
    git checkout "${BIRD_RELEASE}" && \
    autoreconf && \
    ./configure --sysconfdir=/etc/bird --runstatedir=/run/bird && \
    make && \
    make install && \
  echo "**** clean up ****" && \
  apt-get purge --auto-remove -y \
    build-essential \
    flex \
    bison \
    autoconf \
    ncurses-dev \
    libreadline-dev \
    linuxdoc-tools-latex \
    texlive-latex-extra \
    opensp \
    docbook-xsl \
    xsltproc && \
  apt-get clean && \
  rm -rf \
    /config/* \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# add local files
COPY /root /

EXPOSE 179

VOLUME /config
