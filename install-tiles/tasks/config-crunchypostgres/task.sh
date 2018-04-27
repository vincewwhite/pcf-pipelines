#!/bin/bash

properties_config=$(jq -n \
  --arg properties_az_multi_select "$PROPERTIES_AZ_MULTI_SELECT" \
  --arg properties_consul_server_disk_type "$PROPERTIES_CONSUL_SERVER_DISK_TYPE" \
  --arg properties_consul_server_vm_type "$PROPERTIES_CONSUL_SERVER_VM_TYPE" \
  --arg properties_extra_large_disk_type "$PROPERTIES_EXTRA_LARGE_DISK_TYPE" \
  --arg properties_extra_large_postgresql_instance_count "$PROPERTIES_EXTRA_LARGE_POSTGRESQL_INSTANCE_COUNT" \
  --arg properties_extra_large_postgresql_service_quota "$PROPERTIES_EXTRA_LARGE_POSTGRESQL_SERVICE_QUOTA" \
  --arg properties_extra_large_vm_type "$PROPERTIES_EXTRA_LARGE_VM_TYPE" \
  --arg properties_large_disk_type "$PROPERTIES_LARGE_DISK_TYPE" \
  --arg properties_large_postgresql_instance_count "$PROPERTIES_LARGE_POSTGRESQL_INSTANCE_COUNT" \
  --arg properties_large_postgresql_service_quota "$PROPERTIES_LARGE_POSTGRESQL_SERVICE_QUOTA" \
  --arg properties_large_vm_type "$PROPERTIES_LARGE_VM_TYPE" \
  --arg properties_medium_disk_type "$PROPERTIES_MEDIUM_DISK_TYPE" \
  --arg properties_medium_postgresql_instance_count "$PROPERTIES_MEDIUM_POSTGRESQL_INSTANCE_COUNT" \
  --arg properties_medium_postgresql_service_quota "$PROPERTIES_MEDIUM_POSTGRESQL_SERVICE_QUOTA" \
  --arg properties_medium_vm_type "$PROPERTIES_MEDIUM_VM_TYPE" \
  --arg properties_postgresql_haproxy_disk_type "$PROPERTIES_POSTGRESQL_HAPROXY_DISK_TYPE" \
  --arg properties_postgresql_haproxy_vm_type "$PROPERTIES_POSTGRESQL_HAPROXY_VM_TYPE" \
  --arg properties_small_disk_type "$PROPERTIES_SMALL_DISK_TYPE" \
  --arg properties_small_postgresql_instance_count "$PROPERTIES_SMALL_POSTGRESQL_INSTANCE_COUNT" \
  --arg properties_small_postgresql_service_quota "$PROPERTIES_SMALL_POSTGRESQL_SERVICE_QUOTA" \
  --arg properties_small_vm_type "$PROPERTIES_SMALL_VM_TYPE" \
  --arg properties_smoke_tests_disk_type "$PROPERTIES_SMOKE_TESTS_DISK_TYPE" \
  --arg properties_smoke_tests_vm_type "$PROPERTIES_SMOKE_TESTS_VM_TYPE" \
'{
  ".properties.az_multi_select": {
    "value": ($properties_az_multi_select | split(",") | map(.))
  },
  ".properties.consul_server_vm_type": {
    "value": $properties_consul_server_vm_type
  },
  ".properties.consul_server_disk_type": {
    "value": $properties_consul_server_disk_type
  },
  ".properties.postgresql_haproxy_vm_type": {
    "value": $properties_postgresql_haproxy_vm_type
  },
  ".properties.postgresql_haproxy_disk_type": {
    "value": $properties_postgresql_haproxy_disk_type
  },
  ".properties.smoke_tests_vm_type": {
    "value": $properties_smoke_tests_vm_type
  },
  ".properties.smoke_tests_disk_type": {
    "value": $properties_smoke_tests_disk_type
  },
  ".properties.small_vm_type": {
    "value": $properties_small_vm_type
  },
  ".properties.small_disk_type": {
    "value": $properties_small_disk_type
  },
  ".properties.small_postgresql_instance_count": {
    "value": $properties_small_postgresql_instance_count
  },
  ".properties.small_postgresql_service_quota": {
    "value": $properties_small_postgresql_service_quota
  },
  ".properties.medium_vm_type": {
    "value": $properties_medium_vm_type
  },
  ".properties.medium_disk_type": {
    "value": $properties_medium_disk_type
  },
  ".properties.medium_postgresql_instance_count": {
    "value": $properties_medium_postgresql_instance_count
  },
  ".properties.medium_postgresql_service_quota": {
    "value": $properties_medium_postgresql_service_quota
  },
  ".properties.large_vm_type": {
    "value": $properties_large_vm_type
  },
  ".properties.large_disk_type": {
    "value": $properties_large_disk_type
  },
  ".properties.large_postgresql_instance_count": {
    "value": $properties_large_postgresql_instance_count
  },
  ".properties.large_postgresql_service_quota": {
    "value": $properties_large_postgresql_service_quota
  },
  ".properties.extra-large_vm_type": {
    "value": $properties_extra_large_vm_type
  },
  ".properties.extra-large_disk_type": {
    "value": $properties_extra_large_disk_type
  },
  ".properties.extra-large_postgresql_instance_count": {
    "value": $properties_extra_large_postgresql_instance_count
  },
  ".properties.extra-large_postgresql_service_quota": {
    "value": $properties_extra_large_postgresql_service_quota
  }
}'
)

resources_config="{
  \"broker\": {\"instances\": $BROKER_INSTANCES},
  \"register_on_demand_service_broker\": {\"instances\": \"$REGISTER_ON_DEMAND_SERVICE_BROKER_INSTANCES\"},
  \"delete-all-service-instances-and-deregister-broker\": {\"instances\": \"$DELETE_ALL_SERVICE_INSTANCES_AND_DEREGISTER_BROKER_INSTANCES\"},
  \"acceptance_tests\": {\"instances\": \"$ACCEPTANCE_TESTS_INSTANCES\"},
  \"upgrade_all_service_instances\": {\"instances\": \"$UPGRADE_ALL_SERVICE_INSTANCES_INSTANCES\"}
}"

network_config=$(jq -n \
  --arg network_name "$NETWORK_NAME" \
  --arg other_azs "$OTHER_AZS" \
  --arg singleton_az "$SINGLETON_JOBS_AZ" \
  --arg services_network_name "$SERVICES_NETWORK_NAME" \
'
  {
    "network": {
      "name": $network_name
    },
    "other_availability_zones": ($other_azs | split(",") | map({name: .})),
    "singleton_availability_zone": {
      "name": $singleton_az
    },
    "service_network": {
      "name": $services_network_name
    }
  }
'
)

om-linux \
  --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
  --username "${OPSMAN_USERNAME}" \
  --password "${OPSMAN_PASSWORD}" \
  --skip-ssl-validation \
  configure-product \
  --product-name crunchy-postgresql \
  --product-properties "${properties_config}" \
  --product-network "${network_config}" \
  --product-resources "${resources_config}"
