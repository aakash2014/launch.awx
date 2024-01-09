#!/bin/bash
path=`pwd`
mkdir awx
cd awx
tar -xvzf ../awx_packaged.tar.gz

printf "***********************************************************************\nLoading All images\n***********************************************************************"
docker load --input temp_image.tar
docker load --input awx_awx1.tar
docker load --input redis_awx.tar
docker load --input postgres_awx1.tar
docker network create awxnetwork
mountpath=$path"/awx/mount"

printf "***********************************************************************\nCreating postgres image\n***********************************************************************"
docker container create --net awxnetwork --network-alias=postgres  --name tools_postgres_1 postgres_awx:v1

printf "***********************************************************************\nLoading postgres volume\n***********************************************************************"

./docker-volume.sh tools_postgres_1 load tools_postgres_1-volumes.tar

printf "***********************************************************************\nCreating redis image\n***********************************************************************"

docker container create --net awxnetwork --network-alias=redis_1 --name=tools_redis_1 -v $mountpath/redis.conf:/usr/local/etc/redis/redis.conf redis_awx:v1

printf "***********************************************************************\nLoading redis volume\n***********************************************************************"

./docker-volume.sh tools_redis_1 load tools_redis_1-volumes.tar

printf "***********************************************************************\nCreating AWX image\n***********************************************************************"
