#!/bin/bash

export PRODUCT_SPEC_ID=$(curl -s -X 'POST' http://tm-forum-api.127.0.0.1.nip.io:8080/tmf-api/productCatalogManagement/v4/productSpecification \
     -H 'Content-Type: application/json;charset=utf-8' \
     -d '{
        "brand": "M&P Operations",
        "version": "1.0.0",
        "lifecycleStatus": "ACTIVE",
        "name": "M&P K8S"
     }' | jq '.id' -r ); echo ${PRODUCT_SPEC_ID}

export PRODUCT_OFFERING_ID=$(curl -s -X 'POST' http://tm-forum-api.127.0.0.1.nip.io:8080/tmf-api/productCatalogManagement/v4/productOffering \
     -H 'Content-Type: application/json;charset=utf-8' \
     -d "{
        \"version\": \"1.0.0\",
        \"lifecycleStatus\": \"ACTIVE\",
        \"name\": \"M&P K8S Offering\",
        \"productSpecification\": {
          \"id\": \"${PRODUCT_SPEC_ID}\"
        }
     }"| jq '.id' -r ); echo ${PRODUCT_OFFERING_ID}

curl -s -X GET http://tm-forum-api.127.0.0.1.nip.io:8080/tmf-api/productCatalogManagement/v4/productOffering/${PRODUCT_OFFERING_ID} | jq .