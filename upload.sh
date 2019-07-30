#!/bin/bash

GROUP_ID=io.swec.services
ARTIFACT_ID=api
BUNDLE_VERSION=19.8.0-SNAPSHOT
BUNDLE_PACKAGING="jar"
ARTIFACT="${GROUP_ID}.${ARTIFACT_ID}-${BUNDLE_VERSION}.${BUNDLE_PACKAGING}"
PATH_TO=./services/api/target

echo "Upload artifact ${ARTIFACT} into Nexus snapshot repository"
printenv

mvn --settings ./settings.xml deploy:deploy-file \
  -DrepositoryId=${NEXUS_REPO} \
  -Durl="${NEXUS_HOST}/repository/${NEXUS_REPO}" \
  -Dfile="${PATH_TO}/${ARTIFACT}" \
  -DgroupId="${GROUP_ID}" \
  -DartifactId="${ARTIFACT_ID}" \
  -Dversion="${BUNDLE_VERSION}" \
  -Dpackaging="${BUNDLE_PACKAGING}" \
  -DgeneratePom=true \
  -DuniqueVersion=false
