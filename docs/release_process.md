# Releasing Weave Assured Flux

This document describes the process of releasing a new version of the `weave-assured-flux` project.

## Patch Flux OSS

This project contains patches to the Flux OSS project. These patches are stored 
in directory `patches-flux-<version>`. The directory is a tree of subdirectories
that correspond to the flux OSS project:
- `flux2` contains patches to the `flux2` project
- `source-controller` contains patches to the `source-controller` project
- `kustomize-controller` contains patches to the `kustomize-controller` project
- `helm-controller` contains patches to the `helm-controller` project
- `notification-controller` contains patches to the `notification-controller` project
- `image-reflector-controller` contains patches to the `image-reflector-controller` project
- `image-automation-controller` contains patches to the `image-automation-controller` project
  
Each patch sub-directory contains patches that are applied to the flux OSS project
for a specific version of flux.

The patches are numbered in the order they should be applied. The patch files are
named `NNN-<description>.patch` where `NNN` is a number and `<description>` is a
short description of the patch. The patch files are applied in the order of their names.

During the release process, the patches are applied after cloning the Flux OSS projects
and before building the binaries. The final binaries is named `flux-<version>-wa.NNN`
where `NNN` is the number of the last patch applied and `<version>` is the version of
the flux OSS project being released.

## Release process

A different GitHub workflow is used for each release version. The workflow is
defined in file `.github/workflows/release_<version>.yaml`. The workflow is triggered
by a tag. GitHub Actions will run the right workflow based on the modified file.

Every time a new minor version of flux OSS is released, the following steps should be performed:
- Create a new directory `patches-flux-<version>` and copy the patches from the previous
  version that have not been solved upstream. 
- Include all new patches that have been created for the new version.
- Create a new GitHub workflow file `.github/workflows/release_<version>.yaml` based on the previous version
- Update the new workflow file to match the new version of flux OSS

The same workflow can be used for multiple patch versions of flux OSS. The workflow
will automatically detect the version of flux OSS and apply the right patches. The build
name will include the patch version.

## Example of build names

```
flux_v2.1.0 -> weave-assured-flux_v2.1.0-wa
flux_v2.1.0 -> weave-assured-flux_v2.1.0-wa.1
flux_v2.1.1 -> weave-assured-flux_v2.1.1-wa.2
flux_v2.1.1 -> weave-assured-flux_v2.1.1-wa.3
flux_v2.1.1 -> weave-assured-flux_v2.1.1-wa.4
flux_v2.2.0 -> weave-assured-flux_v2.2.0-wa
flux_v2.2.0 -> weave-assured-flux_v2.2.0-wa.1
``````

### Image tags

As part of the release process, the following images are built and pushed to Docker Hub:
- `weaveworks/weave-assured-flux-cli:<version>-wa.<patch>.<timestamp>-amd64`
- `weaveworks/weave-assured-flux-cli:<version>-wa.<patch>.<timestamp>-arm64`
- `weaveworks/weave-assured-flux-cli:<version>-wa.<patch>.<timestamp>-arm`
- `weaveworks/weave-assured-flux:source-controller-<version>-wa.<patch>.<timestamp>`
- `weaveworks/weave-assured-flux:kustomize-controller-<version>-wa.<patch>.<timestamp>`
- `weaveworks/weave-assured-flux:helm-controller-<version>-wa.<patch>.<timestamp>`
- `weaveworks/weave-assured-flux:notification-controller-<version>-wa.<patch>.<timestamp>`
- `weaveworks/weave-assured-flux:image-reflector-controller-<version>-wa.<patch>.<timestamp>`
- `weaveworks/weave-assured-flux:image-automation-controller-<version>-wa.<patch>.<timestamp>`
- `weaveworks/weave-assured-flux-manifests:<version>-wa.<patch>.<timestamp>`
- `weaveworks/weave-assured-flux-manifests:latest`

Each image is tagged with the version of flux OSS and the patch number. The timestamp
is the time when the image was built. Using the timestamp ensures that the image tag
changes every time the image is built. This is important to ensure we capture the
latest changes in the image when rebuilding a given release.

### Nightly builds

A nightly build is triggered by a cron job that runs Tuesday to Saturday at 1:00 AM UTC.
The nightly build is triggered by a tag named `<version>-wa.nightly.<timestamp>`
and is triggered by a different workflow than the release build.
The nightly build workflow is defined in file `.github/workflows/nightly_<version>.yaml`.
