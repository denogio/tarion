#!/usr/bin/env bash
set -euo pipefail

# Script to check for duplicate Hyprland keybindings

CONFIG_DIR="files/system/usr/share/tarion/defaults/hypr"
BINDINGS_FILES=(
    "${CONFIG_DIR}/bindings.conf"
    "${CONFIG_DIR}/bindings/media.conf"
    "${CONFIG_DIR}/bindings/tiling-v2.conf"
    "${CONFIG_DIR}/bindings/scrolling.conf"
    "${CONFIG_DIR}/bindings/utilities.conf"
    "${CONFIG_DIR}/bindings/clipboard.conf"
    "${CONFIG_DIR}/apps/defaults.conf"
    "files/system/hyprland/usr/share/hyprland/hyprland.conf"
)

# Extract all bindings with their source file
declare -A BINDINGS_MAP
declare -a DUPLICATES=()

echo "🔍 Checking Hyprland keybindings for duplicates..."
echo "=================================================="

for file in "${BINDINGS_FILES[@]}"; do
    if [[ ! -f "${file}" ]]; then
        echo "⚠️  File not found: ${file}"
        continue
    fi
    
    echo "📄 Analyzing: ${file}"
    
    # Extract bind and bindd lines (excluding comments)
    while IFS= read -r line; do
        # Skip comments and empty lines
        [[ "${line}" =~ ^[[:space:]]*# ]] && continue
        [[ -z "${line//[[:space:]]/}" ]] && continue
        
        # Check if line contains bind or bindd
        if [[ "${line}" =~ ^[[:space:]]*(bind|bindd)[[:space:]]+ ]]; then
            # Extract the key combination (modifier + key)
            # Pattern: bind(d) = MOD, KEY, ...
            if [[ "${line}" =~ (bind|bindd)[[:space:]]*=[[:space:]]*([^,]+),[[:space:]]*([^,]+) ]]; then
                modifier="${BASH_REMATCH[2]}"
                key="${BASH_REMATCH[3]}"
                binding="${modifier}, ${key}"
                
                # Clean up modifier/key (remove quotes, trim)
                modifier=$(echo "${modifier}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/^"//' -e 's/"$//')
                key=$(echo "${key}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/^"//' -e 's/"$//')
                binding="${modifier}, ${key}"
                
                # Extract description if present (third comma-separated value)
                if [[ "${line}" =~ (bind|bindd)[[:space:]]*=[[:space:]]*([^,]+),[[:space:]]*([^,]+),[[:space:]]*([^,]+) ]]; then
                    description="${BASH_REMATCH[4]}"
                    description=$(echo "${description}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/^"//' -e 's/"$//')
                else
                    description="(no description)"
                fi
                
                # Extract full command
                if [[ "${line}" =~ (bind|bindd)[[:space:]]*=[[:space:]]*([^,]+),[[:space:]]*([^,]+),[^,]*,[[:space:]]*(.+) ]]; then
                    command="${BASH_REMATCH[4]}"
                    command=$(echo "${command}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
                else
                    command="(unknown command)"
                fi
                
                # Check if this binding already exists
                if [[ -n "${BINDINGS_MAP[${binding}]+x}" ]]; then
                    DUPLICATES+=("DUPLICATE: ${binding}")
                    DUPLICATES+=("  File 1: ${BINDINGS_MAP[${binding}]}")
                    DUPLICATES+=("  File 2: ${file}: ${description} -> ${command}")
                    DUPLICATES+=("")
                else
                    BINDINGS_MAP["${binding}"]="${file}: ${description} -> ${command}"
                fi
            fi
        fi
    done < "${file}"
done

echo ""
echo "📊 Summary:"
echo "==========="
echo "Total unique bindings found: ${#BINDINGS_MAP[@]}"

if [[ ${#DUPLICATES[@]} -gt 0 ]]; then
    echo ""
    echo "❌ DUPLICATE BINDINGS FOUND:"
    echo "============================"
    for duplicate in "${DUPLICATES[@]}"; do
        echo "${duplicate}"
    done
    echo ""
    echo "⚠️  Action required: Resolve these duplicate bindings"
else
    echo ""
    echo "✅ No duplicate bindings found!"
fi

# Also check for potential conflicts with similar keys
echo ""
echo "🔍 Checking for potential key conflicts..."
echo "=========================================="

declare -a POTENTIAL_CONFLICTS=()

# Get all bindings and sort them
for binding in "${!BINDINGS_MAP[@]}"; do
    echo "${binding}" >> /tmp/bindings_list.txt
done

sort /tmp/bindings_list.txt | while read -r binding1; do
    while read -r binding2; do
        # Skip same binding
        [[ "${binding1}" == "${binding2}" ]] && continue
        
        # Check if bindings share same key with different modifiers
        key1=$(echo "${binding1}" | awk -F ', ' '{print $2}')
        key2=$(echo "${binding2}" | awk -F ', ' '{print $2}')
        
        if [[ "${key1}" == "${key2}" ]]; then
            mod1=$(echo "${binding1}" | awk -F ', ' '{print $1}')
            mod2=$(echo "${binding2}" | awk -F ', ' '{print $1}')
            
            # Check if modifiers are subsets (e.g., SUPER vs SUPER_SHIFT)
            if [[ "${mod1}" == *"${mod2}"* ]] || [[ "${mod2}" == *"${mod1}"* ]]; then
                POTENTIAL_CONFLICTS+=("POTENTIAL CONFLICT: Same key '${key1}' with modifiers '${mod1}' and '${mod2}'")
                POTENTIAL_CONFLICTS+=("  Binding 1: ${BINDINGS_MAP[${binding1}]}")
                POTENTIAL_CONFLICTS+=("  Binding 2: ${BINDINGS_MAP[${binding2}]}")
                POTENTIAL_CONFLICTS+=("")
            fi
        fi
    done < <(sort /tmp/bindings_list.txt)
done

rm -f /tmp/bindings_list.txt

if [[ ${#POTENTIAL_CONFLICTS[@]} -gt 0 ]]; then
    echo "⚠️  POTENTIAL CONFLICTS FOUND:"
    echo "=============================="
    for conflict in "${POTENTIAL_CONFLICTS[@]}"; do
        echo "${conflict}"
    done
else
    echo "✅ No potential conflicts found!"
fi

echo ""
echo "📋 All unique bindings:"
echo "======================="
for binding in "${!BINDINGS_MAP[@]}"; do
    echo "${binding}: ${BINDINGS_MAP[${binding}]}"
done | sort