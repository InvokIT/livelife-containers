#!/bin/bash
$AWS_METADATAURL="http://169.254.169.254/2014-11-05/meta-data"
$AWS_INSTANCEID=$(curl ${AWS_METADATAURL}/instance-id)
$AWS_AVZONE=$(curl ${AWS_METADATAURL}/placement/availability-zone)

exec /usr/local/bin/supervisord