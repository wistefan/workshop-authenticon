#!/bin/bash

curl -s -X 'POST' 'http://til.127.0.0.1.nip.io:8080/issuer' -H 'Content-Type: application/json' -d "{\"did\": \"$1\", \"credentials\": []}"

curl -s -X GET http://tir.127.0.0.1.nip.io:8080/v4/issuers | jq .