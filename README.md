# kbld-imgpkg

Just messing around with kbld and imgpkg to generate immutable and transferable k8s manifests/bundles.

## Prerequisites

Spin up the two registries (local and simulated "remote")

```bash
docker-compose up -d
```

## Usage

Create imgpkg bundle, push to "local" registry and ship to "remote" registry

```bash
./package.sh
```

Resolve imgpkg bundle at "remote" registry

```bash
./resolve.sh
```

Output: A fully rendered k8s manifest with images retagged to the local registry.
