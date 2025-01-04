build: down
	docker buildx build --platform linux/amd64 -t lockp111/ssserver-rust:1.0.0 --target ssserver .
	docker buildx build --platform linux/amd64 -t lockp111/sslocal-rust:1.0.0 --target sslocal .
	docker image prune -f

push:
	docker push lockp111/ssserver-rust:1.0.0
	docker push lockp111/sslocal-rust:1.0.0

up:
	docker compose up -d
	docker logs -f ss-rust

down:
	docker compose down
