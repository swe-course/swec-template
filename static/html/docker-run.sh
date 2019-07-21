#!/bin/bash -e
if [ -f ".env" ]; then export $(envsubst < ".env" | grep -v ^# | xargs); fi
docker run -d --rm \
  -p ${COMPONENT_PARAM_PORT}:80 \
  -p ${COMPONENT_PARAM_PORTS}:443 \
  --name ${COMPONENT_ID} ${COMPONENT_ID}:${COMPONENT_VERSION}