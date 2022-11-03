#!/bin/bash

# cf. https://carvel.dev/imgpkg/docs/v0.24.0/basic-workflow/

mkdir -p bundle/.imgpkg

# kbld
kbld -f ./src --imgpkg-lock-output ./bundle/.imgpkg/images.yml
cp -r src/* bundle

# imgpkg
imgpkg push -b localhost:5000/test/bundle:v1.0.0 -f ./bundle
imgpkg copy -b localhost:5000/test/bundle:v1.0.0 --to-repo localhost:5001/test/bundle