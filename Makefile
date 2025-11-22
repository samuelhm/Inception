NAME        := inception
COMPOSE_FILE:= srcs/docker-compose.yml
ENV_FILE    := srcs/.env
COMPOSE     := docker compose -f $(COMPOSE_FILE) 

# Carpeta donde montas los volúmenes en el host (ajústala si usas otra)
VOLUME_DIR  := /home/shurtado/data

all: up

up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v

fclean: clean
	sudo rm -rf /home/shurtado/data
	mkdir /home/shurtado/data
re: fclean all

.PHONY: all up down clean fclean re

