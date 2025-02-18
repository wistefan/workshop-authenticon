#!/bin/bash

# create data
curl -s -X POST http://scorpio-provider.127.0.0.1.nip.io:8080/ngsi-ld/v1/entities \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
      "id": "urn:ngsi-ld:EnergyReport:fms-1",
      "type": "EnergyReport",
      "name": {
        "type": "Property",
        "value": "Standard Server"
      },
      "consumption": {
        "type": "Property",
        "value": "94"
      }
    }'

# create policy

curl -s -X 'POST' http://pap-provider.127.0.0.1.nip.io:8080/policy \
    -H 'Content-Type: application/json' \
    -d  '{ 
            "@context": {
              "dc": "http://purl.org/dc/elements/1.1/",
              "dct": "http://purl.org/dc/terms/",
              "owl": "http://www.w3.org/2002/07/owl#",
              "odrl": "http://www.w3.org/ns/odrl/2/",
              "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
              "skos": "http://www.w3.org/2004/02/skos/core#"
            },
            "@id": "https://mp-operation.org/policy/common/type",
            "@type": "odrl:Policy",
            "odrl:permission": {
              "odrl:assigner": {
                "@id": "https://www.mp-operation.org/"
              },
              "odrl:target": {
                "@type": "odrl:AssetCollection",
                "odrl:source": "urn:asset",
                "odrl:refinement": [
                  {
                    "@type": "odrl:Constraint",
                    "odrl:leftOperand": "ngsi-ld:entityType",
                    "odrl:operator": {
                      "@id": "odrl:eq"
                    },
                    "odrl:rightOperand": "EnergyReport"
                  }
                ]
              },
              "odrl:assignee": {
                "@id": "vc:any"
              },
              "odrl:action": {
                "@id": "odrl:read"
              }
            }
          }'