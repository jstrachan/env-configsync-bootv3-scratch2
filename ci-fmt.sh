#!/bin/sh

echo "formatting the kubernetes resources ready to create a Pull Request..."

rm -rf src
mkdir -p src/base
jx-gitops kpt recreate --ignore-errors --dir config-root --out-dir src/base
jx-gitops namespace --dir-mode --dir src/base/namespaces
jx-gitops label --dir src/base gitops.jenkins-x.io/pipeline=environment
jx-gitops annotate --dir src/base --kind Deployment wave.pusher.com/update-on-config-change=true
jx-gitops kustomize --source src/base --target config-root --output src/overlays/default