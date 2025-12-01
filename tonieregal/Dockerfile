# syntax=docker/dockerfile:1

FROM maven:3.9-eclipse-temurin-21-jammy

# Installiere git + ssh-client
RUN apt-get update \
    && apt-get install -y --no-install-recommends git openssh-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/tonieverwaltung

# Kopiere start-Script
COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
