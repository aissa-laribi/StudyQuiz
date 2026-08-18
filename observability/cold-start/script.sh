#!/bin/bash

DAY=$(date +%w)
MONTH=$(date +%m)

RESULT=$(curl -s -o /dev/null \
  -w "%{time_connect} %{time_starttransfer}" \
  'https://studyquiz.fastapicloud.dev/')

TIME_CONNECT=$(echo "$RESULT" | cut -d' ' -f1)
TIME_STARTTRANSFER=$(echo "$RESULT" | cut -d' ' -f2)

echo "$DAY,$MONTH,$TIME_CONNECT,$TIME_STARTTRANSFER" \
  >> observability/cold-start/fastapi-coldstart.csv