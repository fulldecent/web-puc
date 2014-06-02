#!/bin/bash

echo "Creating package files for bootstrap"

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASEDIR=$(dirname "$BASEDIR")
mkdir -p "$BASEDIR/packages/bootstrap"

# Clone or pull
[ ! -d "$BASEDIR/package-spiders/maxcdn-bootstrap/.git" ] &&
git clone https://github.com/MaxCDN/bootstrap-cdn.git "$BASEDIR/package-spiders/maxcdn-bootstrap" ||
cd "$BASEDIR/package-spiders/maxcdn-bootstrap/" && git pull

cd "$BASEDIR/package-spiders/maxcdn-bootstrap/public/twitter-bootstrap/"
for VER in $(ls); do
  [ -L $VER ] && continue
  FILE="$BASEDIR/packages/bootstrap/$VER"
  : > $FILE
  echo '{' >> $FILE
  echo '   "project":"bootstrap",' >> $FILE
  echo '   "projectHomepage":"http://getbootstrap.com/",' >> $FILE
  echo '   "version":"'$VER'",' >> $FILE
  echo -n '   "versionLatest":' >> $FILE
    diff -r latest "$VER" >> /dev/null && echo -n "true" >> $FILE || echo -n "false" >> $FILE
  echo ',' >> $FILE
  echo -n '   "versionSupported":' >> $FILE
    diff -r latest "$VER" >> /dev/null && echo -n "true" >> $FILE || echo -n "false" >> $FILE
  echo ',' >> $FILE
  echo '   "preferredCDN":"//netdna.bootstrapcdn.com/bootstrap/'$ver'/css/bootstrap.min.css",' >> $FILE
  echo '   "otherCDNs":' >> $FILE
  echo '   [' >> $FILE
  echo '      "//netdna.bootstrapcdn.com/bootstrap/'$ver'/css/bootstrap.css"' >> $FILE
  echo '   ],' >> $FILE
  echo '   "matchers":' >> $FILE
  echo '   [' >> $FILE
  echo '      {' >> $FILE
  echo '         "indication":"Bootstrap v'$ver' (http://getbootstrap.com)"' >> $FILE
  echo '      }' >> $FILE
  echo '   ]' >> $FILE
  echo '}' >> $FILE
done
