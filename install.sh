#!/bin/sh

runDocker() {
  docker compose up -d
}

if hash docker 2>/dev/null; then
  runDocker
else
  apt install -y debian-keyring debian-archive-keyring apt-transport-https
  git clone https://github.com/lockp111/docker-install.git && sh ./docker-install/install.sh && runDocker
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
  apt update -y
  apt install -y caddy
fi
