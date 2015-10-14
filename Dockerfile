FROM ubuntu:trusty
MAINTAINER Mark Cooper <mark.c.cooper@outlook.com>

ENV ARCHIVESSPACE_VERSION 1.4.1
ENV ARCHIVESSPACE_URL https://github.com/archivesspace/archivesspace/releases/download/v$ARCHIVESSPACE_VERSION/archivesspace-v$ARCHIVESSPACE_VERSION.zip
ENV ARCHIVESSPACE_DB_TYPE demo
ENV ARCHIVESSPACE_DB_NAME archivesspace
ENV ARCHIVESSPACE_DB_USER archivesspace
ENV ARCHIVESSPACE_DB_PASS archivesspace


RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
  mysql-client \
  openjdk-7-jre-headless \
  wget \
  unzip

RUN wget $ARCHIVESSPACE_URL
RUN unzip archivesspace-v$ARCHIVESSPACE_VERSION.zip
RUN wget http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.34/mysql-connector-java-5.1.34.jar 


# FINALIZE SETUP
RUN rm -rf /archivesspace/plugins/*
RUN cp /mysql-connector-java-5.1.34.jar /archivesspace/lib/
ADD plugins/ /archivesspace/plugins
ADD setup.sh /setup.sh
RUN chmod u+x /*.sh

EXPOSE 8080 8081 8089 8090

CMD ["/setup.sh"]
