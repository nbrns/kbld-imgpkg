#!/bin/bash

# cf. https://carvel.dev/imgpkg/docs/v0.24.0/basic-workflow/

mkdir -p pulled-bundle

# # kbld
# kbld -f ./src --imgpkg-lock-output ./bundle/.imgpkg/images.yml > bundle/manifests.yaml

# imgpkg
imgpkg pull -b localhost:5001/test/bundle:v1.0.0 -o pulled-bundle
kbld -f pulled-bundle > pulled-bundle/rendered-manifests.yaml