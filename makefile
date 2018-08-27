#配置文件路径：/etc/shadowsocks.json
#日志文件路径：/var/log/shadowsocksr.log
#代码安装目录：/usr/local/shadowsocks

s ?= mbs

init:
	apt install -y git curl build-essential libssl-dev zlib1g-dev
	mkdir ./MTProxy
	git clone https://github.com/TelegramMessenger/MTProxy ./MTProxy-build
	cd ./MTProxy-build && make
	cp ./MTProxy-build/objs/bin/mtproto-proxy /MTProxy/
    rm -rf /MTProxy-build
	cd ./MTProxy && curl -s https://core.telegram.org/getProxySecret -o proxy-secret && curl -s https://core.telegram.org/getProxyConfig -o proxy-multi.conf
	mkdir ./BBR
	cd ./BBR && wget --no-check-certificate -qO 'BBR.sh' 'https://moeclub.org/attachment/LinuxShell/BBR.sh' && chmod a+x BBR.sh && bash BBR.sh -f
	cd ./BBR && wget --no-check-certificate -qO 'BBR_POWERED.sh' 'https://moeclub.org/attachment/LinuxShell/BBR_POWERED.sh' && chmod a+x BBR_POWERED.sh && bash BBR_POWERED.sh
	mkdir ./SSR
	cd ./SSR && wget –no-check-certificate https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocksR.sh && chmod +x shadowsocksR.sh

mt-open:
	./mtproto-proxy -u nobody -p 8888 -H 443 -S $(s) --aes-pwd proxy-secret proxy-multi.conf -M 1

bbr-test:
	lsmod |grep 'bbr_powered'

ssr-init:
	./shadowsocksR.sh 2>&1 | tee shadowsocksR.log

bbr-open:
	./BBR/BBR_POWERED.sh