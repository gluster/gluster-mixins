#!/bin/sh

set -e
set -x
set -o pipefail

git clone https://github.com/gluster/gluster-mixins.git
cd gluster-mixins/extras
jb install
sh build.sh

kubectl apply -f manifests/
