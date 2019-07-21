#!/bin/bash -e
if [ -f ".env" ]; then export $(envsubst < ".env" | grep -v ^# | xargs); fi
ng serve --host=${COMPONENT_PARAM_LSTN} --port=${COMPONENT_PARAM_PORT}