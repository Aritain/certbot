#!/bin/sh

set -e

DOMAIN=$DOMAIN_SUFFIX

if [ -z "$DOMAIN" ]; then
	echo "Missing domain, please pass it via env"
	exit 1
fi

LOG_RESULT=$(cat /var/log/letsencrypt/letsencrypt.log | grep -ci "Nginx reload failed") || [ $? -eq 1 ]

if [ $LOG_RESULT != 0 ]; then
    echo "Nginx reload failed"
    exit 1
else
    echo "No Nginx errors recently"
fi

echo "Done"