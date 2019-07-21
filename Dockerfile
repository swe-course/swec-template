FROM openjdk:11.0.3

# Create app directory
WORKDIR /usr/src/app

# Copy sources
COPY ./target/*jar-with* ./

#RUN apk --update --no-cache add curl

#COPY ./target/${SERVICES_GJ_ARTIFACT} /
#HEALTHCHECK --interval=5s --timeout=3s CMD curl --fail http://localhost:${SERVICES_GJ_PORT}/healthcheck || exit 1

CMD exec java -jar $(ls *.jar)
