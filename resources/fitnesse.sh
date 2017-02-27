#!/bin/bash -e

if [ ! -d $FITNESSE_HOME/FitNesseRoot ]; then
  cp -rp /usr/share/fitnesse/ref/** $FITNESSE_HOME
fi

if [[ ${#@} -lt 1 ]]; then
  exec java -jar fitnesse-standalone.jar -p 8080 $FITNESSE_OPTS
fi

# As argument is not fitnesse, assume user want to run his own process, for example a `bash` shell to explore this image
exec "$@"

