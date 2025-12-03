FROM debian:bookworm

# 1) Herramientas básicas
RUN apt-get update \
 && apt-get install -y curl ca-certificates \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# 2) Directorios de Portainer
RUN mkdir -p /opt/portainer /data
WORKDIR /opt/portainer

# 3) Descargar y descomprimir Portainer CE
# OJO: tendrás que poner aquí una URL válida de una release de Portainer CE
# Esto es un ejemplo de estructura, no hace falta que uses exactamente esta versión:
RUN curl -L "https://github.com/portainer/portainer/releases/download/2.20.3/portainer-2.20.3-linux-amd64.tar.gz" -o portainer.tar.gz \
 && tar -xzf portainer.tar.gz --strip-components=1 \
 && rm portainer.tar.gz

# 4) Puerto HTTPS de Portainer
EXPOSE 9443

# 5) Ejecutar Portainer
CMD ["/opt/portainer/portainer", "--data", "/data"]

