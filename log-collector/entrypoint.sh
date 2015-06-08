#!/bin/bash
$AWS_METADATAURL="http://169.254.169.254/2015-01-05/meta-data"
$AWS_INSTANCEID=$(curl ${AWS_METADATAURL}/instance-id)
$AWS_DOMAIN=$(curl ${AWS_METADATAURL}/services/domain)
$AWS_AVZONE=$(curl ${AWS_METADATAURL}/placement/availability-zone)

exec /usr/local/bin/supervisord