#!/bin/bash

# --- setup

# cleanup
rm -r build

# build folder (temporary)
mkdir -p build/operators/.imgpkg
mkdir -p build/apps/.imgpkg
cp -r src/* build

# --- package

function package_bundle() {
    SOURCE_REGISTRY=$1
    TARGET_REGISTRY=$2
    BUNDLE_REPOSITORY=$3
    BUNDLE_NAME=$4
    BUNDLE_VERSION=$5

    imgpkg push -b $SOURCE_REGISTRY/$BUNDLE_REPOSITORY/$BUNDLE_NAME:$BUNDLE_VERSION -f ./build/$BUNDLE_NAME --file-exclusion .imgpkgignore --file-exclusion helm
    imgpkg copy -b $SOURCE_REGISTRY/$BUNDLE_REPOSITORY/$BUNDLE_NAME:$BUNDLE_VERSION --to-repo $TARGET_REGISTRY/$BUNDLE_REPOSITORY/$BUNDLE_NAME --registry-insecure
}

# ------ Step 1: Templating / Render Helm Charts

# template helm releases
# TODO: This could be outsourced and automated instead of scripted here
helm template --include-crds strimzi-operator strimzi-kafka-operator --repo https://strimzi.io/charts/ --values build/operators/helm/strimzi-values.yaml > build/operators/helm-strimzi.yaml

# ------ Step 2: Build & Bundle
# carvel workflow
# cf. https://carvel.dev/imgpkg/docs/v0.24.0/basic-workflow/

# ---------- Step 2.1: Build Operators / CRDs
# 
# Operators and CRDs need to be installed before the actual applications
# to express this dependency across image 

kbld -f ./build/operators --imgpkg-lock-output ./build/operators/.imgpkg/images.yml

# ---------- Step 2.2: Build Apps
#
# Package and install applications

kbld -f ./build/apps --imgpkg-lock-output ./build/apps/.imgpkg/images.yml

# ------ Step 3: Bundle
package_bundle localhost:5000 host.minikube.internal:5001 test operators v1.0.0
package_bundle localhost:5000 host.minikube.internal:5001 test apps v1.0.0