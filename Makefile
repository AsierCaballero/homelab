include .env
export $(shell sed 's/=.*//' .env 2>/dev/null)

.PHONY: setup deploy stop restart logs health backup restore lint clean

setup:
	cp -n .env.example .env 2>/dev/null || true
	mkdir -p data/portainer data/grafana data/prometheus
	chmod 600 .env

deploy:
	docker compose up -d

stop:
	docker compose down

restart: stop deploy

logs:
	docker compose logs -f

health:
	@./scripts/health-check.sh

backup:
	@./scripts/backup.sh

restore:
	@./scripts/restore.sh

lint:
	@docker compose config

clean:
	docker compose down -v
	rm -rf data/
