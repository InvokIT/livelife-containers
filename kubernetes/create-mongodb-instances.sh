#!/bin/sh

sed s/{{INSTANCE}}/1/ mongodb-controller-template.yaml | kubectl create -f -
sed s/{{INSTANCE}}/2/ mongodb-controller-template.yaml | kubectl create -f -
sed s/{{INSTANCE}}/3/ mongodb-controller-template.yaml | kubectl create -f -
