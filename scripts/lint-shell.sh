#!/usr/bin/env bash
# ShellCheck wrapper for Tairon project
set -euo pipefail

echo "🔍 Running ShellCheck on Tairon scripts..."
echo "=========================================="

# Find all shell scripts (exclude git, node_modules, scripts, and inspiration directories)
SCRIPTS=$(find . -name "*.sh" -not -path "./.git/*" -not -path "./node_modules/*" -not -path "./scripts/*" -not -path "./.inspiration/*")

# Run shellcheck on each script
ISSUES_FOUND=0
for script in $SCRIPTS; do
    echo "Checking: $script"
    if distrobox enter shellcheck-dev -- shellcheck "$script" >/dev/null 2>&1; then
        echo "✅ $script - PASSED"
    else
        echo "❌ $script - ISSUES FOUND"
        distrobox enter shellcheck-dev -- shellcheck "$script"
        echo ""
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    fi
done

echo ""
echo "=========================================="
if [ $ISSUES_FOUND -eq 0 ]; then
    echo "🎉 All scripts passed ShellCheck!"
else
    echo "⚠️  Found issues in $ISSUES_FOUND scripts"
fi
echo "ShellCheck complete!"

echo "ShellCheck complete!"