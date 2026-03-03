#!/bin/bash
terraform apply \
  -var="domain_name=mohamed-uptime.com" \
  -var="subdomain=umami" \
  -var="route53_zone_id=Z04320312JZF7DHJUYXSA" \
  -var="db_password=password123!" \
  -parallelism=1 \
  -auto-approve
