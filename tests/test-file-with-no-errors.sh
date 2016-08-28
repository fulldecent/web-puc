#!/bin/bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WEBPUC=$BASEDIR/../web-puc

echo Creating temp file
tempfoo=`basename $0`
TMPFILE=`mktemp -q /tmp/${tempfoo}.XXXXXX`
if [ $? -ne 0 ]; then
    echo "$0: Can't create temp file, exiting..."
    exit 1
fi
echo "Boring file" > $TMPFILE

echo Running web-puc
$WEBPUC $TMPFILE > /dev/null 2> /dev/null
RESULT=$?
rm $TMPFILE
if [ $RESULT -eq "0" ]; then
    echo Test passed
else
    echo Test failed: error found in innocuous file
    echo $RESULT
    exit 1
fi

