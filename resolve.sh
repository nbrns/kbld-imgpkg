#!/bin/bash

# cf. https://carvel.dev/imgpkg/docs/v0.24.0/basic-workflow/
BUNDLE_DIR=out
rm -r $BUNDLE_DIR
mkdir -p $BUNDLE_DIR


resolve_bundle () {
    REGISTRY=$1
    BUNDLE=$2
    BUNDLE_VERSION=$3
    imgpkg pull -b $REGISTRY/$BUNDLE:$BUNDLE_VERSION -o $BUNDLE_DIR/$BUNDLE --registry-insecure
    kbld -f $BUNDLE_DIR/$BUNDLE > $BUNDLE_DIR/$BUNDLE/resolved-manifests.yaml
}

resolve_bundle host.minikube.internal:5001 test/apps v1.0.0
resolve_bundle host.minikube.internal:5001 test/operators v1.0.0
