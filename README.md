# SS Deploy

This shell only support ubuntu/debian

## Install
```bash
$ sh install.sh
```
### Run
```bash
$ sh install.sh <ss pwd>
```
### Open BBR
```bash
$ echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
$ echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
$ sysctl -p
$ lsmod | grep bbr
```
### Nginx conf
```bash
location / {
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    if ($http_upgrade = "websocket") {
            proxy_pass http://127.0.0.1:3000;
    }
}
```
