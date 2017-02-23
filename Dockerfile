FROM java:8-jre-alpine

ENV FITNESSE_HOME=/opt/fitnesse

WORKDIR $FITNESSE_HOME

RUN apk add --no-cache wget unzip git rsync

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
    mkdir -p FITNESSE_HOME/FitNesseRoot/PetClinicFitnesseSamples && \
    mv /tmp/petclinic-fitnesse-test/ $FITNESSE_HOME/FitNesseRoot/PetClinicFitnesseSamples/ 

# Clean up
RUN rm -fr /tmp/**

# Start Fitnesse
CMD java -jar fitnesse-standalone.jar -p 80 -v
