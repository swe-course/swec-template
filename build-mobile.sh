#!/bin/bash -e
if [ -f ".env" ]; then export $(envsubst < ".env" | grep -v ^# | xargs); fi
ng build --prod --configuration=production --base-href . --output-path mobile/