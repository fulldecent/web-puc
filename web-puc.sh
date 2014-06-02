#!/bin/bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
usage() { echo "Usage: $0 [-e GLOB] [-s] [-c] [-u] FILES ..." 1>&2; exit 1; }

EXCLUDE=()
ALLOW_SUPPORTED=0
UPDATE=0
RETVAL=0

while getopts ":e:iscou" o; do
    case "${o}" in
        e)
            EXCLUDE+=("${OPTARG}")
            ;;
        s)
            ALLOW_SUPPORTED=1
            ;;
        u)
            UPDATE=1
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ $UPDATE == 1 ]
then
    rm packages/*
    for SCRIPT in $(ls $BASEDIR/package-spiders/*.sh)
    do
        echo -e " \033[1;33m\033[40m  UPDATING $SCRIPT \033[0m"
        . "$SCRIPT"
    done
    exit 0
elif [ "$#" -eq 0 ]
then
    usage
fi

EXCLUDEOPTS=()
for i in "${EXCLUDE[@]}"
do
    EXCLUDEOPTS+=("-path")
    EXCLUDEOPTS+=("$i")
    EXCLUDEOPTS+=("-or")
done

IFS=$'\n'
FILES=$(find "$@" -type f -and \! \( "${EXCLUDEOPTS[@]}" -false \))

for FILE in $FILES
do
    #echo Checking file: $FILE
    for GOODFILE in $(ls $BASEDIR/packages/*.good)
    do
        BADFILE="$BASEDIR/packages/"$(basename $GOODFILE .good)".bad"
        BADMATCH=$(grep -nh -F -f $BADFILE $FILE | cut -d ':' -f 1)
        RETVAL=2
        if [ "$BADMATCH" != "" ]
        then
            echo ERROR
            echo ------------------------------------------
            echo "FILE: $FILE"
            echo RECOMMENDATION: $(cat $GOODFILE)
            echo "INDICATION(S) BY LINE:"
            grep -o -nh -F -f $BADFILE $FILE 
            echo
          fi
  done
done

exit $RETVAL
