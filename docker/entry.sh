#!/usr/bin/env bash

sa_dir=/var/run/secrets/kubernetes.io/serviceaccount

kc_args="--server=https://kubernetes.default.svc.cluster.local --token=$(cat $sa_dir/token) --certificate-authority=$sa_dir/ca.crt"

kubectl $kc_args apply -f manifests/

if [ $? -ne 0 ]; then
    echo "Failed to apply manifests/ folder"
fi
