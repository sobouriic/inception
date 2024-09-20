WP_DATA = /home/data/wordpress/*
DB_DATA = /home/data/mariadb/*
COMPOSE = ./srcs/docker-compose.yml 
all: up
up: build
	docker compose -f $(COMPOSE) up --build
down:
	docker compose -f $(COMPOSE) down
stop:
	docker compose -f $(COMPOSE) stop
start:
	docker compose -f $(COMPOSE) start
build:
	docker compose -f $(COMPOSE) build
logs:
	docker compose -f $(COMPOSE) logs
clean:
	@docker stop $$(docker ps -qa) || true
	@docker system prune -a -f || true
	@docker volume rm $$(docker volume ls -q) || true
	@sudo rm -rf $(WP_DATA) || true
	@sudo rm -rf $(DB_DATA) || true

re: clean up	
