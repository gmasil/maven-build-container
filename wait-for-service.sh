#! /bin/bash

set -eu

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

: "${ENDPOINT:=}"
: "${TIMEOUT:=5}"
: "${RETRIES:=20}"
: "${INTERVAL:=5}"
: "${VERBOSE:=false}"

if [ "${VERBOSE}" == "true" ] || [ -z "${ENDPOINT}" ]; then
  echo "ENDPOINT = ${ENDPOINT}"
  echo "TIMEOUT  = ${TIMEOUT}s"
  echo "RETRIES  = ${RETRIES}"
  echo "INTERVAL = ${INTERVAL}s"
  echo "VERBOSE  = ${VERBOSE}"
fi

if [ -z "${ENDPOINT}" ]; then
  echo "No endpoint specified!"
  exit 15
fi

STATUS="NOK"
for (( i=1; i <= ${RETRIES}; i++ )); do
  if [ "${VERBOSE}" == "true" ]; then
    echo "Checking... $i"
  fi
  if [ "$(curl -s --max-time ${TIMEOUT} ${ENDPOINT} | jq -r '.status')" == "UP" ]; then
    STATUS="OK"
    break
  fi
  sleep ${INTERVAL}
done

if [ "${STATUS}" == "OK" ]; then
  if [ "${VERBOSE}" == "true" ]; then
    echo "service is running"
  fi
  exit 0
else
  if [ "${VERBOSE}" == "true" ]; then
    echo "service is not running"
  fi
  exit 1
fi
