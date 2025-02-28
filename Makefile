SS_VERSION := 1.1.0

build: down
	docker buildx build --platform linux/amd64 -t lockp111/ssserver-rust:${SS_VERSION} --target ssserver .
	docker buildx build --platform linux/amd64 -t lockp111/sslocal-rust:${SS_VERSION} --target sslocal .
	docker image prune -f

push:
	docker push lockp111/ssserver-rust:${SS_VERSION}
	docker push lockp111/sslocal-rust:${SS_VERSION}

up:
	docker compose up -d
	docker logs -f ss-rust

down:
	docker compose down
