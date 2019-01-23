#!/bin/sh

runDocker (){
    if [ ! -n "$1" ]; then
        echo "Usage: $0 <mt secret> <pwd>" && \
        exit
    fi

    if [ ! -n "$2" ]; then
        echo "Usage: $0 <mt secret> <pwd>" && \
        exit
    fi

    docker run -d -p443:443 --name=mtproto-proxy \
        --restart=always \
        -v proxy-config:/data \
        -e SECRET=$1 \
        --name mtproto \
        --network host \
        telegrammessenger/proxy:latest

    docker run --privileged -d \
        -p 989:989/tcp \
        -p 989:989/udp \
        --name ss2 \
        -e PASSWORD=$2 \
        -e PROTO=AES_256_GCM \
        -e PORT=989 \
        lockp111/ss2:latest
}

if hash docker 2>/dev/null; then 
  runDocker $1 $2
else 
  git clone https://github.com/lockp111/docker-install.git && sh ./docker-install/install.sh
fi