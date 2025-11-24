NAME        := inception
COMPOSE_FILE:= srcs/docker-compose.yml
ENV_FILE    := srcs/.env
COMPOSE     := docker compose -f $(COMPOSE_FILE) 

# Carpeta donde montas los volúmenes en el host (ajústala si usas otra)
VOLUME_DIR  := /home/shurtado/data
DATA_DIR    := $(VOLUME_DIR)
WP_DIR      := $(DATA_DIR)/wp
DB_DIR      := $(DATA_DIR)/db

all: up

up: dirs
	$(COMPOSE) up -d --build
dirs:
	@mkdir -p $(DATA_DIR) $(WP_DIR) $(DB_DIR)

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v

fclean: clean
	sudo rm -rf /home/shurtado/data
	mkdir /home/shurtado/data
re: fclean all

.PHONY: all up down clean fclean re

