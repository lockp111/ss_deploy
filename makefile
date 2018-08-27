#配置文件路径：/etc/shadowsocks.json
#日志文件路径：/var/log/shadowsocksr.log
#代码安装目录：/usr/local/shadowsocks

MTPROXY_PATH = ./MTProxy
MTPROXY_BUILD = ./MTProxy-build
MTPROXY = $(MTPROXY_PATH)/mtproto-proxy

SS_PATH = ./SSR
SS_CONF = /etc/shadowsocks.json
SSR = python /usr/local/shadowsocks/server.py

s ?= mbs

dep:
	apt install -y git curl wget build-essential libssl-dev zlib1g-dev python3

clean:
	rm -rf $(MTPROXY_PATH) $(SS_PATH) $(MTPROXY_BUILD)

init:
	mkdir $(MTPROXY_PATH)
	mkdir $(SS_PATH)
	git clone https://github.com/TelegramMessenger/MTProxy $(MTPROXY_BUILD) && cd $(MTPROXY_BUILD) && make 
	cp $(MTPROXY_BUILD)/objs/bin/mtproto-proxy ./MTProxy/ && rm -rf $(MTPROXY_BUILD)
	cd $(MTPROXY_PATH) && curl -s https://core.telegram.org/getProxySecret -o proxy-secret && curl -s https://core.telegram.org/getProxyConfig -o proxy-multi.conf
	cd $(SS_PATH) && wget –no-check-certificate https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocksR.sh && chmod +x ./shadowsocksR.sh

mt-open:
	$(MTPROXY) -u nobody -p 8888 -H 443 -S $(s) --aes-pwd proxy-secret proxy-multi.conf -M 1

bbr-test:
	lsmod |grep 'tcp_bbr'

ssr-init:
	$(SS_PATH)/shadowsocksR.sh 2>&1 | tee $(SS_PATH)/shadowsocksR.log

bbr-init:
	wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh

ssr-open:
	$(SSR) -c $(SS_CONF)