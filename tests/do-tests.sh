#!/bin/bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for TEST in $(ls $BASEDIR/test*)
do
    echo RUNNING TEST: $TEST
    . $TEST
    echo
done
