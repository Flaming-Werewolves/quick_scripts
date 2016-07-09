
ACCOUNT=
USERNAME=
API_KEY=

$ curl  -s "https://monitoring.api.rackspacecloud.com/v1.0/accountnumber/entities/en5qAp6vtW" -H "X-auth-token: $TOKEN" | jq .
{
  "updated_at": 1448378597909,
  "created_at": 1448355775057,
  "scheduled_suppressions": [],
  "active_suppressions": [],
  "id": "en5qAp6vtW",
  "label": "WEBMANAGER-01",
  "ip_addresses": null,
  "metadata": null,
  "private_metadata": null,
  "managed": false,
  "uri": "https://lon.servers.api.rackspacecloud.com/accoutnumber/servers/server-uuid",
  "agent_id": "749eb245-b04e-4a9b-a785-380627dd9147”

}

