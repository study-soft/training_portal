FROM openjdk:8-jre-alpine

# Add a tportal user to run our application so that it doesn't need to run as root
RUN adduser -D -s /bin/sh tportal
WORKDIR /home/tportal

USER tportal

COPY target/*.war app.war

CMD java -jar app.war
