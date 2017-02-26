FROM java:8-jre-alpine

RUN apk add --no-cache git unzip wget curl bash ttf-dejavu coreutils

ENV FITNESSE_HOME=/var/fitnesse_home

ARG user=fitnesse
ARG group=fitnesse
ARG uid=1000
ARG gid=1000

# Fitnesse is run with user `fitnesse`, uid = 1000
# If you bind mount a volume from the host or a data container, 
# ensure you use the same uid
RUN addgroup -g ${gid} ${group} \
    && adduser -h "$FITNESSE_HOME" -u ${uid} -G ${group} -s /bin/bash -D ${user}

VOLUME /var/fitnesse_home

ENV TINI_VERSION 0.13.2
ENV TINI_SHA afbf8de8a63ce8e4f18cb3f34dfdbbd354af68a1

# Use tini as subreaper in Docker container to adopt zombie processes
RUN curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 -o /bin/tini && chmod +x /bin/tini \
  && echo "$TINI_SHA  /bin/tini" | sha1sum -c -

# Install everything in a temporary reference directory first.
# Everything will be copied over to FITNESSE_HOME on container startup to avoid mounting issues
# We need to mount the whole installation content of FITNESSE_HOME to local directory for user convenience
WORKDIR /usr/share/fitnesse/ref

# Install Fitnesse HSAC Plugin
RUN wget "https://github.com/fhoeben/hsac-fitnesse-fixtures/releases/download/2.11.0/hsac-fitnesse-fixtures-2.11.0-standalone.zip" && \
    unzip hsac-fitnesse-fixtures-2.11.0-standalone.zip && \
    rm -fr hsac-fitnesse-fixtures-2.11.0-standalone.zip

# Install JDBC SLIM plugin
RUN mkdir -p plugins/jdbcslim && \
    wget "https://github.com/six42/jdbcslim/releases/download/v1.0.1/jdbcslim.jar" -O "plugins/jdbcslim/jdbcslim.jar"

# Install JDBC driver for csv database
RUN wget "https://sourceforge.net/projects/csvjdbc/files/CsvJdbc/1.0-18/csvjdbc-1.0-18.jar" \
      -O plugins/jdbcslim/csvjdbc-1.0-18.jar

# Install DBfit dependencies for encryption
RUN wget "https://github.com/dbfit/dbfit/releases/download/v3.2.0/dbfit-complete-3.2.0.zip" && \
    unzip -j dbfit-complete-3.2.0.zip "lib/dbfit-core-3.2.0.jar" -d plugins/jdbcslim/ && \
    unzip -j dbfit-complete-3.2.0.zip "lib/commons-codec-1.10.jar" -d plugins/jdbcslim/ && \
    rm -fr dbfit-complete-3.2.0.zip

# Install JDBC driver for MysQL
RUN wget "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.40.zip" && \
    unzip -j mysql-connector-java-5.1.40.zip "mysql-connector-java-5.1.40/mysql-connector-java-5.1.40-bin.jar" -d plugins/jdbcslim/ && \
    rm -fr mysql-connector-java-5.1.40.zip

# Install JDBC Plugin Documentation
RUN wget "https://github.com/six42/jdbcslim/archive/v1.0.1.zip" && \
    unzip v1.0.1.zip && \
    mv jdbcslim-1.0.1/FitNesseRoot/PlugIns FitNesseRoot/ && \
    rm -fr v1.0.1.zip jdbcslim-1.0.1

# Fix JDBC Documentation Installation wiki windows path by overwriting with the correct contents
COPY resources/Jdbc_installation_doc_content.txt FitNesseRoot/PlugIns/JdbcSlim/Installation/content.txt

# Copy custom Front Page contents
COPY resources/Frontpage_content.txt FitNesseRoot/FrontPage/content.txt

# Deploy Petclinic sample tests
RUN cd /tmp && git clone https://github.com/bzon/PetClinicFitnesseSamples.git && \
    mkdir -p REF_CONFIG_DIR/FitNesseRoot/PetClinicFitnesseSamples && \
    mv /tmp/PetClinicFitnesseSamples /usr/share/fitnesse/ref/FitNesseRoot/PetClinicFitnesseSamples/ 

RUN chown -R ${user} "$FITNESSE_HOME" "/usr/share/fitnesse/ref"

# Clean up
RUN rm -fr /tmp/**

# Web interface
EXPOSE 8080

USER ${user}

COPY resources/fitnesse.sh /usr/local/bin/fitnesse.sh

ENTRYPOINT ["/bin/tini","--","/usr/local/bin/fitnesse.sh"]
