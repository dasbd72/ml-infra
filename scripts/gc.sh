#!/bin/sh
set -e

if [ -z "$POSTGRES_USER" ] || [ -z "$POSTGRES_PASSWORD" ] || [ -z "$POSTGRES_DB" ]; then
  echo "POSTGRES_USER, POSTGRES_PASSWORD, and POSTGRES_DB must be set"
  exit 1
fi

container_id=$(docker compose ps -q mlflow)
if [ -z "$container_id" ]; then
  echo "No container found"
  exit 1
fi

docker exec -it $container_id mlflow gc \
    --backend-store-uri postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@db:5432/${POSTGRES_DB}
if [ $? -eq 0 ]; then
  echo "Garbage collection completed"
else
  echo "Garbage collection failed"
fi
