#!/usr/bin/env bash
# Validate the niri configuration shipped in the skeleton.
# Mirrors tarion-sync: the skel config.kdl includes
# ~/.local/share/tarion/niri/{bindings,autostart}.kdl and the DMS-managed
# configs by absolute path under ~/.config/niri/dms/ (seeded on first run),
# so we assemble a temporary HOME with both locations and validate the full
# include chain.
# Requires: niri

set -euo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)
SKEL_NIRI="${REPO_ROOT}/files/system/usr/share/tarion/skel/niri"

echo "🔍 Validating niri configuration..."

if ! command -v niri &>/dev/null; then
    echo "⚠️  niri not found on PATH; skipping niri validation (CI build will catch errors)."
    exit 0
fi

if [ ! -d "${SKEL_NIRI}" ]; then
    echo "❌ skel niri directory not found: ${SKEL_NIRI}"
    exit 1
fi

tmp_home=$(mktemp -d)
trap 'rm -rf "${tmp_home}"' EXIT

mkdir -p "${tmp_home}/.local/share/tarion"
cp -r "${SKEL_NIRI}" "${tmp_home}/.local/share/tarion/niri"

# DMS-managed configs are included by absolute path (~/.config/niri/dms/);
# seed them there as tarion-sync would on first run.
if [ -d "${SKEL_NIRI}/dms" ]; then
    mkdir -p "${tmp_home}/.config/niri"
    cp -r "${SKEL_NIRI}/dms" "${tmp_home}/.config/niri/dms"
fi

config="${tmp_home}/.local/share/tarion/niri/config.kdl"

echo -n "  Checking skel/niri/config.kdl... "
if output=$(HOME="${tmp_home}" niri validate -c "${config}" 2>&1); then
    echo "✅ PASSED"
else
    echo "❌ FAILED"
    echo "${output}"
    exit 1
fi

echo ""
echo "Summary: niri configuration is valid"
