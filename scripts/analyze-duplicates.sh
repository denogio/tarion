#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Analyzing duplicate Hyprland bindings..."
echo "============================================"
echo ""

# List of duplicates from previous analysis
declare -A DUPLICATES=(
    ["SUPER, T"]="bindings.conf (Top/btop) vs tiling-v2.conf (toggle floating)"
    ["SUPER, O"]="bindings.conf (Obsidian) vs tiling-v2.conf (window pop)"
    ["SUPER, G"]="bindings.conf (Messenger) vs tiling-v2.conf (toggle grouping)"
    ["ALT, TAB"]="tiling-v2.conf (cyclenext) vs tiling-v2.conf (bringactivetotop)"
    ["ALT SHIFT, TAB"]="tiling-v2.conf (cyclenext prev) vs tiling-v2.conf (bringactivetotop)"
    ["SUPER SHIFT, LEFT"]="tiling-v2.conf (swapwindow l) vs scrolling.conf (movewindow l)"
    ["SUPER SHIFT, RIGHT"]="tiling-v2.conf (swapwindow r) vs scrolling.conf (movewindow r)"
    ["SUPER SHIFT, UP"]="tiling-v2.conf (swapwindow u) vs scrolling.conf (movewindow u)"
    ["SUPER SHIFT, DOWN"]="tiling-v2.conf (swapwindow d) vs scrolling.conf (movewindow d)"
    ["SUPER ALT, F"]="tiling-v2.conf (fullscreen 1) vs defaults.conf (File manager)"
    ["CTRL ALT, SPACE"]="utilities.conf (Vicinae WM) vs hyprland.conf (vicinae windows)"
)

echo "Found ${#DUPLICATES[@]} duplicate bindings:"
echo ""

for binding in "${!DUPLICATES[@]}"; do
    echo "❌ ${binding}: ${DUPLICATES[$binding]}"
done

echo ""
echo "📋 Recommended actions:"
echo "======================"
echo ""
echo "1. bindings.conf is marked as DEPRECATED - consider removing it entirely"
echo "2. ALT/TAB duplicates in tiling-v2.conf - need to choose one function"
echo "3. SUPER SHIFT + arrow conflicts - scrolling.conf vs tiling-v2.conf"
echo "4. SUPER ALT, F conflict - file manager vs full width"
echo "5. CTRL ALT, SPACE - default hyprland.conf may not be used"
echo ""
echo "Let's examine each conflict in detail..."