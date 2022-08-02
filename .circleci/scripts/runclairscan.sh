#! /usr/bin/env bash

 

#This script starts up clair scanning service via docker-compose that includes a clair server container
#and a clair postgres db container.
if [ "$#" != 3 ]
then
 echo "Usage Error: $0 <docker_compose_file> <image_to_scan> <scan_report_name>"
 exit 1
fi

DOCKER_COMPOSE_FILE=$1

IMAGE_TO_SCAN=$2

SCAN_REPORT_NAME=$3

echo ‘Running clair scanner server and clair database...'

if ! [ -x "$(command -v docker-compose)" ]; then
    echo "docker-compose is not available in executable path."
    exit 1

fi

echo ‘Start clair service...'

docker-compose -f $DOCKER_COMPOSE_FILE up -d 

if ! [ -x "$(command -v clair-scanner)" ]; then
    echo "clair-scanner is not available in executable path"

    exit 1
fi


echo 'Scanning...'
clair-scanner —-report $SCAN_REPORT_NAME. json --ip $(hostname -i | cut -d' ' -f1) $IMAGE_TO_SCAN

echo 'Stop clair service...'
docker-compose -f $DOCKER_COMPOSE_FILE down --rmi local --volumes --remove-orphans