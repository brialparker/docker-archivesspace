#!/bin/bash

# pull the latest images
echo "Pulling MySQL image"
docker pull mysql

echo "Pulling latest ArchivesSpace build image"
docker pull brialparker/archivesspace

echo "Starting MySQL instance in background"
docker run -d \
  -p 3306:3306 \
  --name mysql \
  -e MYSQL_ROOT_PASSWORD=123456 \
  -e MYSQL_DATABASE=archivesspace \
  -e MYSQL_USER=archivesspace \
  -e MYSQL_PASSWORD=archivesspace \
  mysql

# give mysql time to start
echo "Waiting for MySQL to initialize"
sleep 30

echo "Starting ArchivesSpace instance in background"
docker run --name archivesspace -d \
  -p 8080:8080 \
  -p 8081:8081 \
  -p 8089:8089 \
  -p 8090:8090 \
  -e ARCHIVESSPACE_DB_TYPE=mysql \
  --link mysql:db \
  brialparker/archivesspace
