#!/bin/bash
set -e

echo "=== Setup SSH key ==="

# SSH key aus ENV schreiben
mkdir -p /root/.ssh
chmod 700 /root/.ssh

printf '%s\n' "$SSH_PRIVATE_KEY" > /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa

# GitHub Host Key hinzufügen (um Confirm-Prompt zu vermeiden)
ssh-keyscan github.com >> /root/.ssh/known_hosts

echo "=== Clone or pull Repo B ==="
REPO_SSH="git@github.com:YourUser/YourJavaProjectRepo.git"
REPO_DIR="/opt/tonieverwaltung/project"

if [ ! -d "$REPO_DIR" ]; then
  git clone "$REPO_SSH" "$REPO_DIR"
else
  cd "$REPO_DIR"
  git pull
fi

echo "=== Build with Maven ==="
cd "$REPO_DIR"
mvn -B -DskipTests clean package

JAR=$(ls target/*.jar | head -n1)
if [ -z "$JAR" ]; then
  echo "ERROR: No jar found after build" >&2
  exit 1
fi

echo "=== Run application ==="
exec java -jar "$JAR"
