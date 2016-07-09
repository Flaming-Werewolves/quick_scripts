
ACCOUNT=
USERNAME=
API_KEY=
API_ENDPOINT=https://storage101.lon3.clouddrive.com/v1/MossoCloudFS_
CDN_ENDPOINT=https://cdn3.clouddrive.com/v1/MossoCloudFS_
AUTH_TOKEN=$(curl -s -XPOST https://identity.api.rackspacecloud.com/v2.0/tokens -d'{"auth":{"RAX-KSKEY:apiKeyCredentials":{"username":"'$USERNAME'","apiKey":"'$API_KEY'"}}}' -H "Content-type:application/json" | python -c 'import sys,json;data=json.loads(sys.stdin.read());print data["access"]["token"]["id"]')

# Create Container
curl -i -X PUT -H "X-Auth-Token: $AUTH_TOKEN" $API_ENDPOINT/ACLContainer

# Set ACL Header
curl -i -X PUT -H "X-Auth-Token: $AUTH_TOKEN" $API_ENDPOINT/ACLContainer -H 'X-Container-Read: aaronhughes' -H 'X-Container-Write: aaronhughes'

# Check if worked
curl -si -X HEAD -H "X-Auth-Token: $AUTH_TOKEN" $API_ENDPOINT/ACLContainer | grep -E 'X-Container-Write|X-Container-Read'

# Upload a txt file
curl -i -X PUT $API_ENDPOINT/ACLContainer/rsaa.sh -H "X-Auth-Token: $AUTH_TOKEN" -H "Content-Type: text/plain" -H "Content-Length: 0"

# Enable CDN (Admin Access Required)
curl -i -X PUT -H "X-Auth-Token: $AUTH_TOKEN" $CDN_ENDPOINT/ACLContainer -H "X-CDN-Enabled: True" -H "X-TTL: 604800"

# Get CDN URLs
curl -i -X HEAD -H "X-Auth-Token: $AUTH_TOKEN" $CDN_ENDPOINT/ACLContainer 

