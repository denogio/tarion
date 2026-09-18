#!/usr/bin/env bash

set -euo pipefail

# NetBird's %post scriptlet runs `netbird service install` and
# `netbird service start`. Neither works during a container build (no running
# systemd), the scriptlet exits non-zero and takes the whole rpm transaction
# with it. Install with scriptlets disabled instead; the unit it would have
# generated is shipped at
# files/system/usr/lib/systemd/system/netbird.service and enabled in
# 06-services.yml. netbird-ui's only scriptlet restarts an already-running UI
# process, so skipping it is harmless at build time.

cat > /etc/yum.repos.d/netbird.repo <<'REPO'
[netbird]
name=NetBird
baseurl=https://pkgs.netbird.io/yum/
enabled=1
gpgcheck=0
gpgkey=https://pkgs.netbird.io/yum/repodata/repomd.xml.key
repo_gpgcheck=1
REPO

dnf install -y \
    --setopt=install_weak_deps=False \
    --setopt=tsflags=noscripts \
    netbird \
    netbird-ui

rm -f /etc/yum.repos.d/netbird.repo
