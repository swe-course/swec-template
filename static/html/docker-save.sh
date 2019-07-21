#!/bin/bash -e
if [ -f ".env" ]; then export $(envsubst < ".env" | grep -v ^# | xargs); fi
docker save -o ${COMPONENT_ID}-${COMPONENT_VERSION}.tar ${COMPONENT_ID}:${COMPONENT_VERSION}