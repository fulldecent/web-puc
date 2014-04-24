echo "Creating package files for bootstrap"

BASEDIR=$(pwd)
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
  echo '   "version":"'$VER'",' >> $FILE
  echo -n '   "versionSupported":' >> $FILE
    diff -r latest "$VER" >> /dev/null && echo -n "true" >> $FILE || echo -n "false" >> $FILE
  echo ',' >> $FILE
  echo -n '   "versionLatest":' >> $FILE
    diff -r latest "$VER" >> /dev/null && echo -n "true" >> $FILE || echo -n "false" >> $FILE
  echo ',' >> $FILE
  echo '   "homepage":"http://getbootstrap.com/",' >> $FILE
  echo '   "cdns":' >> $FILE
  echo '   [' >> $FILE
  echo '      {' >> $FILE
  echo '         "name":"Bootstrap DNA",' >> $FILE
  echo '         "preferred":true,' >> $FILE
  echo '         "homepage":"http://www.bootstrapcdn.com/",' >> $FILE
  echo '         "canonicalURL":"//netdna.bootstrapcdn.com/bootstrap/'$ver'/css/bootstrap.min.css",' >> $FILE
  echo '         "otherURLs":[]' >> $FILE
  echo '      }' >> $FILE
  echo '   ],' >> $FILE
  echo '   "identifiers":' >> $FILE
  echo '   [' >> $FILE
  echo '      "Bootstrap v'$ver' (http://getbootstrap.com)"' >> $FILE
  echo '   ],' >> $FILE
  echo '   "contentMatchers":' >> $FILE
  echo '   []' >> $FILE
  echo '}' >> $FILE
done
