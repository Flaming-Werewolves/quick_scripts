#!/bin/sh

ACCOUNT=
USERNAME=
API_KEY=
EXPORT_REGION=lon
IMPORT_REGION=lon
EXPORT_SERVER_ENDPOINT=https://$EXPORT_REGION.servers.api.rackspacecloud.com/v2/$ACCOUNT
IMPORT_SERVER_ENDPOINT=https://$IMPORT_REGION.servers.api.rackspacecloud.com/v2/$ACCOUNT
EXPORT_IMAGE_ENDPOINT=https://$EXPORT_REGION.images.api.rackspacecloud.com/v2/$ACCOUNT
IMPORT_IMAGE_ENDPOINT=https://$IMPORT_REGION.images.api.rackspacecloud.com/v2/$ACCOUNT
EXPORT_CF_ENDPOINT=https://storage101.lon3.clouddrive.com/v1/MossoCloudFS_
IMPORT_CF_ENDPOINT=https://storage101.lon3.clouddrive.com/v1/MossoCloudFS_
EXPORT_CONTAINER="Longshot"
IMPORT_CONTAINER="Longshot"
BASE_IMAGE_ID=5bcad79f-b64b-4a7f-854c-3b013af58bfa
# Centos 6.5 stock image
FLAVOR_ID="performance1-1"
TOKEN=$(curl -s -XPOST https://identity.api.rackspacecloud.com/v2.0/tokens -d'{"auth":{"RAX-KSKEY:apiKeyCredentials":{"username":"'$USERNAME'","apiKey":"'$API_KEY'"}}}' -H"Content-type:application/json" | python -c 'import sys,json;data=json.loads(sys.stdin.read());print data["access"]["token"]["id"]')
echo $TOKEN
ZIP_FILENAME=AUC_Elastix1_Longshot.zip
VHD_FILENAME=TorExit
curl -X PUT -T /tmp/$VHD_FILENAME \
      -H "X-Auth-Token: $TOKEN" \
      "$IMPORT_CF_ENDPOINT/$IMPORT_CONTAINER/$VHD_FILENAME"

