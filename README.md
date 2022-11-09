# kbld-imgpkg

Just messing around with kbld and imgpkg to generate immutable and transferable k8s manifests/bundles, aiming for a deployment via [FluxCD](https://fluxcd.io/).

## Prerequisites

> **NOTE**: I deploy to a local minikube cluster, thus the target registry is referenced via _host.minikube.internal_.
> This DNS entry references the host from inside the minikube cluster and it also ensures, that _host.minikube.internal_ is the target registry. Make sure that your local DNS knows that _host.minikube.internal_ resolves to localhost when packaging.

Spin up the two registries (local and simulated "remote")

```bash
docker-compose up -d
```

Spin up a minikube

```bash
minikube start
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

> **NOTE**: There are two bundles due to dependencies between the operator bundle and the apps bundle. We need to install the CRDs first before installing Kafka via the operator/CRD.

Deploy with kubectl

```bash
kubectl apply -f .\out\test\operators\resolved-manifests.yaml
kubectl apply -f .\out\test\apps\resolved-manifests.yaml
```

## Drawbacks

### Helm

- Use of Helm functionality is limited to templating (no deployment capabilities) as `kbld` only looks for `image: some-image` keys, it does not recognize specific image values in Helm (unless they are exactly `image: someimage`)
- Note: therefore also the use of [FluxCD Helm Releases](https://fluxcd.io/flux/components/helm/) cannot be guaranteed / is risky

## Cleanup

```bash
docker-compose stop
minikube delete
```