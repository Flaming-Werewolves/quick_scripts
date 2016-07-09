#!/bin/bash

ACCOUNT=
USERNAME=
API_KEY=
EXPORT_REGION=LON

EXPORT_IMAGE_ENDPOINT=https://$EXPORT_REGION.images.api.rackspacecloud.com/v2/$ACCOUNT
EXPORT_CONTAINER_ENDPOINT=https://storage101.lon3.clouddrive.com/v1/MossoCloudFS_000xxxx000_0000

EXPORT_IMAGE_ID=28b73a5e-e845-4d5c-8188-a8026bec85ad
EXPORT_CONTAINER="Longshot"

TOKEN=$(curl -s -XPOST https://identity.api.rackspacecloud.com/v2.0/tokens -d'{"auth":{"RAX-KSKEY:apiKeyCredentials":{"username":"'$USERNAME'","apiKey":"'$API_KEY'"}}}' -H"Content-type:application/json" | python -c 'import sys,json;data=json.loads(sys.stdin.read());print data["access"]["token"]["id"]')

echo "Making the Call to export"
curl -s -X POST $EXPORT_IMAGE_ENDPOINT/tasks -H "X-Auth-Token: $TOKEN" -H "Content-Type: application/json" -d "{\"type\": \"export\", \"input\": {\"receiving_swift_container\": \"$EXPORT_CONTAINER\", \"image_uuid\": \"$EXPORT_IMAGE_ID\"} }" | python -mjson.tool

echo "How are we doing?"
curl -s -X GET -H "X-Auth-Token: $TOKEN" $EXPORT_IMAGE_ENDPOINT/tasks | python -m json.tool
