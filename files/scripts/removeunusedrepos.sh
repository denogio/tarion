#!/usr/bin/env bash

set -oue pipefail

# Negativo17 repositories removed - using RPM Fusion instead
# rm -f /etc/yum.repos.d/negativo17-fedora-nvidia.repo
# rm -f /etc/yum.repos.d/negativo17-fedora-multimedia.repo
# rm -f /etc/yum.repos.d/fedora-negativo17.repo
rm -f /etc/yum.repos.d/eyecantcu-supergfxctl.repo
rm -f /etc/yum.repos.d/_copr_ublue-os-akmods.repo
rm -f /etc/yum.repos.d/rpmfusion-nonfree-nvidia-driver.repo
rm -f /etc/yum.repos.d/rpmfusion-nonfree-nvidia-driver.repo.rpmsave
rm -f /etc/yum.repos.d/nvidia-container-toolkit.repo
rm -f /etc/yum.repos.d/fedora-cisco-openh264.repo
