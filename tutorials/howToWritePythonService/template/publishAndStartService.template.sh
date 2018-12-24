#!/bin/sh

if [ -z "$1" ]
  then
    echo "Invalid PAYMENT_ADDRESS: ./publishAndStartService.sh PAYMENT_ADDRESS"
    exit 1
fi

echo "Publishing your service. Please wait..."

TMP_FILE=/tmp/__SNET_SERVICE_PUBLISH_LOG.txt
rm -f $TMP_FILE
snet service metadata-init __PROTO_DIR__ __SERVICE_NAME__ $1
snet service metadata-set-fixed-price 0.00000001
snet service metadata-add-endpoints http://localhost:7000
snet service publish __ORGANIZATION_NAME__ __SERVICE_NAME__ -y 2>&1 | tee $TMP_FILE
python3 server.py &
snetd --config __DAEMON_CONFIG_FILE__ &
sleep 3
