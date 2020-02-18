#!/usr/bin/env bash
which jq >/dev/null 2>&1
if [ $? != 0 ]
then
    echo "jq/curl missing. Please install jq and curl"
    exit 2
fi

if [ $# -eq 0 ]
  then
    curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document
else
    curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | jq ".. | .$1? // empty"
fi