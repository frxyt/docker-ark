# Copyright (c) 2021 FEROX YT EIRL, www.ferox.yt <devops@ferox.yt>
# Copyright (c) 2021 Jérémy WALTHER <jeremy.walther@golflima.net>
# See <https://github.com/frxyt/docker-ark> for details.

FROM debian:buster-slim
LABEL maintainer="Jérémy WALTHER <jeremy@ferox.yt>"

ARG ARK_SERVER_TOOLS_VERSION=v1.6.60b
ENV ARK_SERVER_TOOLS_VERSION=${ARK_SERVER_TOOLS_VERSION} \
    DEBIAN_FRONTEND=noninteractive

RUN set -ex; \
    dpkg --add-architecture i386; \
    apt-get update -y; \
    apt-get install -y --fix-missing --no-install-recommends \
        bash \
        bzip2 \
        ca-certificates \
        coreutils \
        curl \
        findutils \
        git \
        lib32gcc1 \
        libc6-i386 \
        lsof \
        perl \
        perl-modules \
        rsync \
        sed \
        tar; \
    useradd -ms /bin/bash steam; \
    passwd -du steam; \
    mkdir -p /home/steam/steamcmd; \
    cd /home/steam/steamcmd; \
    curl -sSL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" -o steamcmd_linux.tar.gz; \
    tar -xvzf steamcmd_linux.tar.gz; \
    rm steamcmd_linux.tar.gz; \
    chown steam:steam -R /home/steam/steamcmd; \
    cd /home/steam; \
    su -c '~/steamcmd/steamcmd.sh +quit' steam; \
    git clone -b ${ARK_SERVER_TOOLS_VERSION} https://github.com/arkmanager/ark-server-tools.git; \
    cd /home/steam/ark-server-tools/tools; \
    ./install.sh steam; \
    rm -rf ark-server-tools; \
    apt-get purge -y git; \
    apt-get clean -y && apt-get clean -y && apt-get autoclean -y && rm -r /var/lib/apt/lists/*;
    
USER steam
WORKDIR /home/steam