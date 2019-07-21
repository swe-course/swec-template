#!/bin/bash -e
if [ -f ".env" ]; then export $(envsubst < ".env" | grep -v ^# | xargs); fi
docker stop ${COMPONENT_ID}
docker rmi ${COMPONENT_ID}:${COMPONENT_VERSION}