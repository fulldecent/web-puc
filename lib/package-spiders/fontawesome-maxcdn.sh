#!/bin/bash

echo "Creating package files for font-awesome"

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASEDIR="$(dirname "$BASEDIR")"
GOODFILE=$BASEDIR/packages/font-awesome.good
BADFILE=$BASEDIR/packages/font-awesome.bad

# Clone or pull
[ ! -d "$BASEDIR/package-spiders/maxcdn-bootstrap/.git" ] &&
  git clone https://github.com/MaxCDN/bootstrap-cdn.git "$BASEDIR/package-spiders/maxcdn-bootstrap" ||
  cd "$BASEDIR/package-spiders/maxcdn-bootstrap/" && git pull

cd "$BASEDIR/package-spiders/maxcdn-bootstrap/public/font-awesome/"
for VER in $(ls); do
  [ -L $VER ] && continue
  [ -f $VER ] && continue
  if [ "$(readlink latest)" = "$VER/" ]
  then
    echo '//netdna.bootstrapcdn.com/font-awesome/'$VER'/css/font-awesome.min.css' > $GOODFILE
  else
    echo '//netdna.bootstrapcdn.com/font-awesome/'$VER'/css/font-awesome.min.css' >> $BADFILE
    echo "Font Awesome $VER by @davegandy" >> $BADFILE
  fi
  echo '//netdna.bootstrapcdn.com/font-awesome/'$VER'/css/font-awesome.css' >> $BADFILE
done

sort -u -o $BADFILE $BADFILE
