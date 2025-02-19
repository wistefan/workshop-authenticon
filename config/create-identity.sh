#!/bin/bash

mkdir output

echo "COUNTRY=\"BE\"
LOCALITY=\"Brussels\"
STATE=\"BRUSSELS\"
# the organisation identifier needs to match the identifier of your did:elsi
ORGANISATION_IDENTIFIER=\"$1\"
ORGANISATION=\"Fancy Marketplace Co.\"
COMMON_NAME=\"www.fancy-marketplace.biz\"
EMAIL=\"contact@fancy-marketplace.biz\"
# needs to be an actual available crl. localhost:3000 is valid for the local test env
CRL_URI=http://localhost:3000/crl.pem" > output/config

docker run -v $(pwd)/output:/out -v $(pwd)/output/config:/config/config quay.io/fiware/eidas:1.3.2

sudo chmod a+rw output/keystore.p12

# provider: configuration of the digital-signature-service
yq -i ".dss.crl.secret.\"crl.pem\" = \"$(kubectl create secret generic t --dry-run=client -o json --from-file output/crl.pem | jq -r .data.\"crl.pem\")\"" provider-elsi.yaml 
yq -i ".dss.keystores.\"store.jks\" = \"$(kubectl create secret generic t --dry-run=client -o json --from-file output/ca-store.jks | jq -r .data.\"ca-store.jks\")\"" provider-elsi.yaml 

# consumer: configure keycloak
yq -i ".elsi.keystore.\"keystore.p12\" = \"$(kubectl create secret generic t --dry-run=client -o json --from-file output/keystore.p12 | jq -r .data.\"keystore.p12\")\"" consumer-elsi.yaml 
yq -i ".elsi.did = \"did:elsi:$1\"" consumer-elsi.yaml 
yq -i "(.keycloak.initContainers[] | select(has(\"env\")) | .env[] | select(has(\"value\"))).value = \"did:elsi:$1\"" consumer-elsi.yaml

