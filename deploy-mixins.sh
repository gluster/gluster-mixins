#!/bin/sh

set -e
set -x
set -o pipefail

#git clone https://github.com/gluster/gluster-mixins.git
git clone -b kube-prometheus https://github.com/umangachapagain/gluster-mixins.git
cd gluster-mixins/extras
jb install
sh build.sh
kubectl apply -f manifests/
