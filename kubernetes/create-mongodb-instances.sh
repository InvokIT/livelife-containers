#!/bin/sh

sed s/{{INSTANCE}}/1/ mongodb-rc-template.yaml | kubectl create -f -
sed s/{{INSTANCE}}/2/ mongodb-rc-template.yaml | kubectl create -f -
sed s/{{INSTANCE}}/3/ mongodb-rc-template.yaml | kubectl create -f -
