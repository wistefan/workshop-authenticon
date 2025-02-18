#!/bin/bash

export ACCESS_TOKEN=$(./scripts/get_access_token_oid4vp.sh http://mp-data-service.127.0.0.1.nip.io:8080 $USER_CREDENTIAL default);

export CONSUMER_DID=$(yq ".elsi.did" config/consumer-elsi.yaml) 

# register the consumer as a customer
export FANCY_MARKETPLACE_ID=$(curl -s -X POST http://mp-tmf-api.127.0.0.1.nip.io:8080/tmf-api/party/v4/organization \
    -H 'Accept: */*' \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    -d "{
        \"name\": \"Fancy Marketplace Inc.\",
        \"partyCharacteristic\": [
        {
            \"name\": \"did\",
            \"value\": \"${CONSUMER_DID}\" 
        }
        ]
    }" | jq '.id' -r); echo ${FANCY_MARKETPLACE_ID}