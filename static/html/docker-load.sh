#!/bin/bash -e
if [ -f ".env" ]; then export $(envsubst < ".env" | grep -v ^# | xargs); fi
docker load -i ${COMPONENT_ID}-${COMPONENT_VERSION}.tar