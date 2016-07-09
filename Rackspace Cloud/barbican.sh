#!/bin/sh

ACCOUNT=
USERNAME=
API_KEY=
API_ENDPOINT=https://iad.keep.api.rackspacecloud.com

AUTH_TOKEN=$(curl -s -XPOST https://identity.api.rackspacecloud.com/v2.0/tokens -d'{"auth":{"RAX-KSKEY:apiKeyCredentials":{"username":"'$USERNAME'","apiKey":"'$API_KEY'"}}}' -H"Content-type:application/json" | python -c 'import sys,json;data=json.loads(sys.stdin.read());print data["access"]["token"]["id"]')

curl -X POST -H 'Content-Type: application/json' -H 'Accept: application/json'\
-H 'X-Auth-Token: '$AUTH_TOKEN -d '{ "name": "AES key","expiration": "2020-02-28T19:14:44.180394","algorithm": "aes","bit_length": 256,"mode": "cbc","payload": "HERE GOES BASE64 TEXT","payload_content_type": "application/octet-stream","payload_content_encoding": "base64"}' $API_ENDPOINT/v1/secrets


