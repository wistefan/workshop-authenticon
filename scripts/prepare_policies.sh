#!/bin/bash

# allow every participant to read offerings
curl -s -X 'POST' http://pap-provider.127.0.0.1.nip.io:8080/policy \
    -H 'Content-Type: application/json' \
    -d  "$(cat ./policies/read_offerings.json)"

# allow every participant to register as customer
curl -s -X 'POST' http://pap-provider.127.0.0.1.nip.io:8080/policy \
    -H 'Content-Type: application/json' \
    -d  "$(cat ./policies/registration_as_customer.json)"

# allow  participants to create product orders
curl -s -X 'POST' http://pap-provider.127.0.0.1.nip.io:8080/policy \
    -H 'Content-Type: application/json' \
    -d  "$(cat ./policies/create_product_order.json)"

# allow cluster creation for participants in role "OPERATOR"
curl -s -X 'POST' http://pap-provider.127.0.0.1.nip.io:8080/policy \
    -H 'Content-Type: application/json' \
    -d  "$(cat ./policies/operator_cluster_creation.json)"