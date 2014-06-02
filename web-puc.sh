#!/bin/bash

usage() { echo "Usage: $0 [-e GLOB] [-s] [-c] [-u] FILES ..." 1>&2; exit 1; }

EXCLUDE=()
ALLOW_SUPPORTED=0
ALLOW_CDNS=0
UPDATE=0

while getopts ":e:iscou" o; do
    case "${o}" in
        e)
            EXCLUDE+=("${OPTARG}")
            ;;
        s)
            ALLOW_SUPPORTED=1
            ;;
        c)
            ALLOW_CDNS=1
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
    for SCRIPT in $(ls package-spiders/*.sh)
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

echo THE FILES WE WANT TO PROCESS ARE:
IFS=$'\n'
FILES=$(find "$@" \! \( "${EXCLUDEOPTS[@]}" -false \))

for file in $FILES
do
  echo $file
  for package in ./packages/*/*
  do
    echo $package
  done
done



