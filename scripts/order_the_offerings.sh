#!/bin/bash
export ACCESS_TOKEN=$(./scripts/get_access_token_oid4vp.sh http://mp-data-service.127.0.0.1.nip.io:8080 $USER_CREDENTIAL default);

# show the offerings
curl -s -X GET http://mp-tmf-api.127.0.0.1.nip.io:8080/tmf-api/productCatalogManagement/v4/productOffering -H "Authorization: Bearer ${ACCESS_TOKEN}" | jq .

# get the ID of the offering to be ordered
export OFFER_ID=$(curl -s -X GET http://mp-tmf-api.127.0.0.1.nip.io:8080/tmf-api/productCatalogManagement/v4/productOffering -H "Authorization: Bearer ${ACCESS_TOKEN}" | jq '.[0].id' -r)

# create the product order
export ORDER_ID=$(curl -s -X POST http://mp-tmf-api.127.0.0.1.nip.io:8080/tmf-api/productOrderingManagement/v4/productOrder \
      -H 'Accept: */*' \
      -H 'Content-Type: application/json' \
      -H "Authorization: Bearer ${ACCESS_TOKEN}" \
      -d "{
          \"productOrderItem\": [
            {
              \"id\": \"random-order-id\",
              \"action\": \"add\",
              \"productOffering\": {
                \"id\" :  \"${OFFER_ID}\"
              }
            }  
          ],
          \"relatedParty\": [
            {
              \"id\": \"$1\"
            }
          ]}" | jq -r '.id'); echo Order ID: $ORDER_ID

# order needs to be processed by the provider and set to "completed"
curl -s -X 'PATCH' http://tm-forum-api.127.0.0.1.nip.io:8080/tmf-api/productOrderingManagement/v4/productOrder/${ORDER_ID} \
      -H 'Accept: */*' \
      -H 'Content-Type: application/json' \
      -H "Authorization: Bearer ${ACCESS_TOKEN}" \
      -d "{ 
            \"state\": \"completed\"
          }" | jq .