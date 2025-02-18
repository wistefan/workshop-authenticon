export ACCESS_TOKEN=$(./scripts/get_access_token_oid4vp.sh http://mp-data-service.127.0.0.1.nip.io:8080 $1 $2)

curl -s -X POST http://mp-data-service.127.0.0.1.nip.io:8080/ngsi-ld/v1/entities \
-H 'Accept: */*' \
-H 'Content-Type: application/json' \
-H "Authorization: Bearer ${ACCESS_TOKEN}" \
-d '{
    "id": "urn:ngsi-ld:K8SCluster:fancy-marketplace",
    "type": "K8SCluster",
    "name": {
    "type": "Property",
    "value": "Fancy Marketplace Cluster"
    },
    "numNodes": {
    "type": "Property",
    "value": "3"
    },
    "k8sVersion": {
    "type": "Property",
    "value": "1.26.0"        
    }
}'

curl -s -X GET http://mp-data-service.127.0.0.1.nip.io:8080/ngsi-ld/v1/entities/urn:ngsi-ld:K8SCluster:fancy-marketplace \
-H 'Accept: */*' \
-H 'Content-Type: application/json' \
-H "Authorization: Bearer ${ACCESS_TOKEN}"