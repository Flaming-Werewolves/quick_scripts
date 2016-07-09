#!/bin/sh

ACCOUNT=
USERNAME=
API_KEY=
IMPORT_REGION=lon
IMPORT_SERVER_ENDPOINT=https://$IMPORT_REGION.servers.api.rackspacecloud.com/v2/$ACCOUNT
IMPORT_IMAGE_ENDPOINT=https://$IMPORT_REGION.images.api.rackspacecloud.com/v2/$ACCOUNT
IMPORT_CF_ENDPOINT=https://storage101.lon3.clouddrive.com/v1/MossoCloudFS_00000_xxxxx
IMPORT_CONTAINER="Longshot"
TOKEN=$(curl -s -XPOST https://identity.api.rackspacecloud.com/v2.0/tokens -d'{"auth":{"RAX-KSKEY:apiKeyCredentials":{"username":"'$USERNAME'","apiKey":"'$API_KEY'"}}}' -H "Content-type:application/json" | python -c 'import sys,json;data=json.loads(sys.stdin.read());print data["access"]["token"]["id"]')
echo $TOKEN
VHD_FILENAME=$1
curl -X PUT -T $VHD_FILENAME -H "X-Auth-Token: $TOKEN" "$IMPORT_CF_ENDPOINT/$IMPORT_CONTAINER/$VHD_FILENAME"

curl -X POST "$IMPORT_CF_ENDPOINT/tasks" -H "X-Auth-Token: $TOKEN" -H "Content-Type: application/json" -d "{\"type\":\"import\",\"input\":{\"image_properties\":{\"name\":\"$VHD_FILENAME\"},\"import_from\":\"$IMPORT_CONTAINER/$VHD_FILENAME\"}}" | python -mjson.tool
