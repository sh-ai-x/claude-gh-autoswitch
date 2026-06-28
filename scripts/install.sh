#!/bin/bash
# install.sh — sets up gh-autoswitch globally

set -e

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONF_DIR="$HOME/.config/gh-autoswitch"
HOOKS_DIR="$HOME/.config/git/hooks"

echo "Installing gh-autoswitch..."

# 1. Config
mkdir -p "$CONF_DIR"
if [ ! -f "$CONF_DIR/accounts.conf" ]; then
  cp "$REPO_DIR/config/accounts.conf" "$CONF_DIR/accounts.conf"
  echo "  ✓ accounts.conf → $CONF_DIR/"
else
  echo "  ~ accounts.conf already exists, skipping (edit manually to update)"
fi

# 2. Core script
cp "$REPO_DIR/scripts/gh-autoswitch.sh" "$CONF_DIR/gh-autoswitch.sh"
chmod +x "$CONF_DIR/gh-autoswitch.sh"
echo "  ✓ gh-autoswitch.sh → $CONF_DIR/"

# 3. Global pre-push hook
mkdir -p "$HOOKS_DIR"
cp "$REPO_DIR/scripts/pre-push" "$HOOKS_DIR/pre-push"
chmod +x "$HOOKS_DIR/pre-push"
echo "  ✓ pre-push hook → $HOOKS_DIR/"

# 4. Register global hooks path
git config --global core.hooksPath "$HOOKS_DIR"
echo "  ✓ git config --global core.hooksPath $HOOKS_DIR"

echo ""
echo "Done. git push will now auto-switch gh accounts based on $CONF_DIR/accounts.conf"
