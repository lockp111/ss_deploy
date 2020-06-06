#!/bin/sh

runDocker (){
    if [ ! -n "$1" ]; then
        echo "Usage: $0 <pwd>" && \
        exit
    fi

    PASSWORD=$1 docker-compose up -d
}

if hash docker 2>/dev/null; then 
  runDocker $1
else
  git clone https://github.com/lockp111/docker-install.git && sh ./docker-install/install.sh && runDocker $1
fi
