SS_VERSION := 1.1.0

build: down
	docker buildx build --platform linux/amd64 -t lockp111/ssserver-rust:${SS_VERSION} --target ssserver .
	docker buildx build --platform linux/amd64 -t lockp111/sslocal-rust:${SS_VERSION} --target sslocal .
	docker image prune -f

push:
	docker push lockp111/ssserver-rust:${SS_VERSION}
	docker push lockp111/sslocal-rust:${SS_VERSION}

genpwd:
	openssl rand -base64 32

up:
	docker compose up -d
	docker logs -f ss-rust

down:
	docker compose down

optimization:
	mkdir -p ./etc/security
	echo "# for server running in root:" > ./etc/security/limits.conf
	echo "root soft nofile 51200" >> ./etc/security/limits.conf
	echo "root hard nofile 51200" >> ./etc/security/limits.conf
	ulimit -n 51200

	echo "# network optimization:" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_ecn = 1" >> /etc/sysctl.conf
	echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
	echo "fs.file-max = 51200" >> /etc/sysctl.conf
	echo "net.core.rmem_max = 67108864" >> /etc/sysctl.conf
	echo "net.core.wmem_max = 67108864" >> /etc/sysctl.conf
	echo "net.core.netdev_max_backlog = 250000" >> /etc/sysctl.conf
	echo "net.core.somaxconn = 4096" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_tw_reuse = 1" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_tw_recycle = 0" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_fin_timeout = 30" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_keepalive_time = 1200" >> /etc/sysctl.conf
	echo "net.ipv4.ip_local_port_range = 10000 65000" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_max_syn_backlog = 8192" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_max_tw_buckets = 5000" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_fastopen = 3" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_mem = 25600 51200 102400" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_rmem = 4096 87380 67108864" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_wmem = 4096 65536 67108864" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_mtu_probing = 1" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_congestion_control = cubic" >> /etc/sysctl.conf
	sysctl -p