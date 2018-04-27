#!/bin/bash 

set -e

PRODUCT_NETWORK_CONFIG=$(
  echo "{}" |
  jq -n \
    --arg singleton_jobs_az "$SINGLETON_JOBS_AZ" \
    --arg other_azs "$OTHER_AZS" \
    --arg network_name "$NETWORK_NAME" \
    --arg services_network_name "$SERVICES_NETWORK_NAME" \
    '. +
    {
      "singleton_availability_zone": {
        "name": $singleton_jobs_az
      },
      "other_availability_zones": ($other_azs | split(",") | map({name: .})),
      "network": {
        "name": $network_name
      },
      "service_network": {
        "name": $services_network_name
      }
    }
    '
)

om-linux \
  --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USERNAME}" \
  --password "${OPSMAN_PASSWORD}" \
  configure-product \
  -n "${PRODUCT_IDENTIFIER}" \
  -pn "${PRODUCT_NETWORK_CONFIG}"
