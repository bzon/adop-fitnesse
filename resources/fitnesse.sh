#!/bin/bash -e

if [ ! -d $FITNESSE_HOME/FitNesseRoot ]; then
    cp -rp /usr/share/fitnesse/ref/** $FITNESSE_HOME
fi

cd $FITNESSE_HOME

java -jar fitnesse-standalone.jar -p 8080 -v -o
