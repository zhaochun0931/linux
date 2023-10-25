docker run --rm --name openldap \
  --network rabbitmq_vnet \
  --env LDAP_ADMIN_USERNAME=admin \
  --env LDAP_ADMIN_PASSWORD=adminpassword \
  --env LDAP_USERS=user \
  --env LDAP_PASSWORDS=password \
  --env LDAP_ROOT=dc=example,dc=org \
  --env LDAP_ADMIN_DN=cn=admin,dc=example,dc=org \
  bitnami/openldap:latest







docker run --rm -d -it --name rabbitmq1 \
  --network rabbitmq_vnet \
  -p 5672:5672 -p 15672:15672 \
  --mount type=bind,source="$(pwd)"/advanced.config,target=/etc/rabbitmq/advanced.config,readonly \
  rabbitmq:3.11-management




rabbitmq-plugins enable rabbitmq_auth_backend_ldap


login the localhost:15672 with user/password


