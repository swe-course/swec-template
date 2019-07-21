#!/bin/bash -e
if [ -f ".env" ]; then export $(envsubst < ".env" | grep -v ^# | xargs); fi
echo Hi, home: ${COMPONENT_HOME}
~/projects/sonar-scanner-3.3.0.1492/bin/sonar-scanner -X