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
