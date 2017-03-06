#!/bin/bash

echo "Creating package files for bootstrap"

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASEDIR="$(dirname "$BASEDIR")"
GOODFILE=$BASEDIR/packages/bootstrap.good
BADFILE=$BASEDIR/packages/bootstrap.bad

# Clone or pull
[ ! -d "$BASEDIR/package-spiders/maxcdn-bootstrap/.git" ] &&
  git clone https://github.com/MaxCDN/bootstrap-cdn.git "$BASEDIR/package-spiders/maxcdn-bootstrap" ||
  cd "$BASEDIR/package-spiders/maxcdn-bootstrap/" && git pull

cd "$BASEDIR/package-spiders/maxcdn-bootstrap/public/twitter-bootstrap/"
for VER in $(ls); do
  [ -L $VER ] && continue
  [ -f $VER ] && continue
  if [ "$(readlink latest)" = "$VER/" ]
  then
    echo '//netdna.bootstrapcdn.com/bootstrap/'$VER'/css/bootstrap.min.css' > $GOODFILE
  else
    echo '//netdna.bootstrapcdn.com/bootstrap/'$VER'/css/bootstrap.min.css' >> $BADFILE
    echo "Bootstrap v$VER (http://getbootstrap.com)" >> $BADFILE
  fi
  echo '//netdna.bootstrapcdn.com/bootstrap/'$VER'/css/bootstrap.css' >> $BADFILE
done

sort -u -o $BADFILE $BADFILE
