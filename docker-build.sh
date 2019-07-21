#!/bin/bash -e
if [ -f ".env" ]; then export $(envsubst < ".env" | grep -v ^# | xargs); fi
rm -rf ./target || true
mkdir target
mkdir target/conf.d
if [ -d ./ssl ]
then
  envsubst "\${COMPONENT_ID} \${COMPONENT_PARAM_HOST}" > ./target/conf.d/default.conf < ./default.conf.https.template
  cp -r ./ssl ./target/
else
  envsubst "\${COMPONENT_PARAM_HOST}" > ./target/conf.d/default.conf < ./default.conf.template
fi
docker build \
  -t ${COMPONENT_ID}:${COMPONENT_VERSION} .