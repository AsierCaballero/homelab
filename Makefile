include .env
export $(shell sed 's/=.*//' .env 2>/dev/null)

.PHONY: setup deploy stop restart logs health backup restore lint clean logging-logs

setup:
	cp -n .env.example .env 2>/dev/null || true
	mkdir -p data/portainer data/grafana data/prometheus data/loki
	chmod 600 .env

deploy:
	docker compose up -d
	docker compose -f docker-compose.monitoring.yml up -d
	docker compose -f docker-compose.logging.yml up -d

stop:
	docker compose down
	docker compose -f docker-compose.monitoring.yml down
	docker compose -f docker-compose.logging.yml down

restart: stop deploy

logs:
	docker compose logs -f

logging-logs:
	docker compose -f docker-compose.logging.yml logs -f

health:
	@./scripts/health-check.sh

backup:
	@./scripts/backup.sh

restore:
	@./scripts/restore.sh

lint:
	@docker compose config
	@docker compose -f docker-compose.monitoring.yml config
	@docker compose -f docker-compose.logging.yml config

clean:
	docker compose down -v
	docker compose -f docker-compose.monitoring.yml down -v
	docker compose -f docker-compose.logging.yml down -v
	rm -rf data/
