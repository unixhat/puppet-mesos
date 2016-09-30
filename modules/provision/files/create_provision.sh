#!/bin/bash
MARATHON=http://localhost:8080

for file in /etc/scaling/*
do
  echo "Deploying $file..."
  curl -X PUT "$MARATHON/v2/apps/`/bin/basename $file`?force=true" -d @"$file" -H "Content-type: application/json"
  echo ""
done

