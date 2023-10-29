#!/bin/bash
now=$(date "+%Y%m%d-%H%M")
# Create new cert in LBR
/home/ubuntu/bin/oci lb certificate create \
--certificate-name MydomainCom-$now \
--ca-certificate-file /etc/letsencrypt/live/www.mydomain.com/chain.pem \
--private-key-file /etc/letsencrypt/live/www.mydomain.com/privkey.pem \
--public-certificate-file /etc/letsencrypt/live/www.mydomain.com/cert.pem \
--max-wait-seconds 150 \
--wait-for-state SUCCEEDED \
--load-balancer-id <<ocid-of-lbr>>
# Update LBR Listener to use the cert
/home/ubuntu/bin/oci lb listener update \
--listener-name MydomainCom \
--ssl-certificate-name MydomainCom-$now \
--rule-set-names "['MydomainComIndexing']" \
--hostname-names "['MydomainCom','WwwMydomainCom']" \
--routing-policy-name MydomainComCertbot \
--connection-configuration-idle-timeout 290 \
--default-backend-set-name <<name-of-bes>> \
--port 443 \
--protocol HTTP \
--max-wait-seconds 150 \
--wait-for-state SUCCEEDED \
--force \
--load-balancer-id <<ocid-of-lbr>>
