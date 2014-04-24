#!/bin/bash

for SCRIPT in $(ls package-spiders/*.sh)
do
  echo -e " \033[1;33m\033[40m  UPDATING $SCRIPT \033[0m"
  . "$SCRIPT"
done
