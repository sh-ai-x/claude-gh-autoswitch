#!/bin/bash
# gh-autoswitch.sh <remote_url>
# Reads ~/.config/gh-autoswitch/accounts.conf and switches gh account if needed.

CONF="$HOME/.config/gh-autoswitch/accounts.conf"

if [ ! -f "$CONF" ]; then
  exit 0
fi

remote_url="${1:-}"
if [ -z "$remote_url" ]; then
  echo "[gh-autoswitch] No remote URL provided" >&2
  exit 0
fi

# Extract owner from URL
# https://github.com/owner/repo  or  git@github.com:owner/repo
owner=$(echo "$remote_url" | sed -E 's|.*github\.com[:/]([^/]+)/.*|\1|')

if [ -z "$owner" ] || [ "$owner" = "$remote_url" ]; then
  exit 0  # not a GitHub remote
fi

# Look up target account
target_account=""
while IFS='=' read -r key val; do
  [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
  key="${key// /}"
  val="${val// /}"
  if [ "$key" = "$owner" ]; then
    target_account="$val"
    break
  fi
done < "$CONF"

if [ -z "$target_account" ]; then
  exit 0  # no mapping for this owner
fi

# Check current active account
current_account=$(gh auth status 2>&1 | awk '/Active account: true/{found=1} found && /Logged in/{print $NF; exit}' | tr -d '()')
# Fallback parse
if [ -z "$current_account" ]; then
  current_account=$(gh auth status 2>&1 | grep -A2 "Active account: true" | grep "Logged in" | awk '{print $NF}')
fi

if [ "$current_account" = "$target_account" ]; then
  exit 0  # already on the right account
fi

echo "[gh-autoswitch] Switching gh account: $current_account → $target_account" >&2
gh auth switch --user "$target_account" >&2
