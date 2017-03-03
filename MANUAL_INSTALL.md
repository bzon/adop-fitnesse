# Sypnosis

Since not all users may be able to run docker on their machine. This manual is for guiding users the step by step instructions of installing FitNesse.

# Windows User

## Requirements

**Git Bash**, I recommend users to download and install Git Bash by following this [guide](https://openhatch.org/missions/windows-setup/install-git-bash).


**Babun**, Heavy unix shell users will love to install (babun)[http://babun.github.io/].


**Java 7** or higher. Either JRE or JDK is fine.

## Install FitNesse

Open Git Bash or Babun.

Create your preferred installation directory. Example: /c/FitNesse
```bash
mkdir /c/FitNesse
```

Install [HSAC with FitNesse standalone bundle](https://github.com/fhoeben/hsac-fitnesse-fixtures). 
You can download the latest release [here](https://github.com/fhoeben/hsac-fitnesse-fixtures/releases).  
Unzip the downloaded zip file in your installation directory `/c/FitNesse`.  Remove the zip file after installation.  
```bash
wget "https://github.com/fhoeben/hsac-fitnesse-fixtures/releases/download/2.11.0/hsac-fitnesse-fixtures-2.11.0-standalone.zip"
unzip hsac-fitnesse-fixtures-2.11.0-standalone.zip
rm -fr hsac-fitnesse-fixtures-2.11.0-standalone.zip
```

Create the plugins directory. 
```bash
mkdir -p plugins/jdbcslim
```

Download and install the jdbc slim plugins.
```bash
wget "https://github.com/six42/jdbcslim/releases/download/v1.0.1/jdbcslim.jar" -O "plugins/jdbcslim/jdbcslim.jar"
```  

Install the JDBC Slim plugin documentations.  
```bash
wget "https://github.com/six42/jdbcslim/archive/v1.0.1.zip"
unzip v1.0.1.zip
mv jdbcslim-1.0.1/FitNesseRoot/PlugIns FitNesseRoot/ 
rm -fr v1.0.1.zip jdbcslim-1.0.1
```

Download CSV Jdbc driver. A driver that will be used by FitNesse to connect to CSV databases.  
```bash
wget "https://sourceforge.net/projects/csvjdbc/files/CsvJdbc/1.0-18/csvjdbc-1.0-18.jar" -O plugins/jdbcslim/csvjdbc-1.0-18.jar
```

Download MySQL Jdbc driver. A driver that will be used by FitNesse to connect to MySQL databases.  
```bash
wget "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.40.zip"
unzip -j mysql-connector-java-5.1.40.zip "mysql-connector-java-5.1.40/mysql-connector-java-5.1.40-bin.jar" -d plugins/jdbcslim/
rm -fr mysql-connector-java-5.1.40.zip
```

**NOTE:** For Oracle, Postgres or other SQL drivers just put their connector binaries in `plugins/jdbcslim` folder.  

Install DBFit binaries for Database encryption.
```bash
wget "https://github.com/dbfit/dbfit/releases/download/v3.2.0/dbfit-complete-3.2.0.zip"
unzip -j dbfit-complete-3.2.0.zip "lib/dbfit-core-3.2.0.jar" -d plugins/jdbcslim/
unzip -j dbfit-complete-3.2.0.zip "lib/commons-codec-1.10.jar" -d plugins/jdbcslim/
rm -fr dbfit-complete-3.2.0.zip
```

**Finishing touches**  

Download this repo and copy some wiki files to `FitNesseRoot`.  
```bash
git clone https://github.com/bzon/adop-fitnesse.git
cp resources/Jdbc_installation_doc_content.txt FitNesseRoot/PlugIns/JdbcSlim/Installation/content.txt
cp resources/Frontpage_content.txt FitNesseRoot/FrontPage/content.txt
```

Install the Sample quickstart project.  
```bash
cd FitNesseRoot
git clone https://github.com/bzon/PetClinicFitnesseSamples.git
```

Start FitNesse!  
```bash
java -jar fitnesse-standalone.jar -p 8081
```

You should be able to access FitNesse at http://localhost:8081.  

# Mac OS User

Just follow the [Dockerfile](https://github.com/bzon/adop-fitnesse/blob/master/Dockerfile) steps for now..
