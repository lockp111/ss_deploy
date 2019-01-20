#!/bin/sh

runDocker (){
    if [ ! -n "$1" ]; then
        echo "Usage: $0 <pwd> <mt secret>" && \
        exit
    fi

    if [ ! -n "$2" ]; then
        echo "Usage: $0 <pwd> <mt secret>" && \
        exit
    fi

    docker run -d -p443:443 --name=mtproto-proxy \
        --restart=always \
        -v proxy-config:/data \
        -e SECRET=$2 \
        --name mtproto \
        --network host \
        telegrammessenger/proxy:latest

    docker run --privileged -d \
        -p 465:465/tcp \
        -p 465:465/udp \
        -p 993:993/tcp \
        -p 993:993/udp \
        --name ssr \
        --network host \
        lockp111/ssr:latest

    docker exec -it ssr python mujson_mgr.py -a -u friend -p 993 -k $1 -G overwall -g 993
}

if hash docker 2>/dev/null; then 
  runDocker
else 
  git clone https://github.com/lockp111/docker-install.git && sh ./docker-install/install.sh
fi