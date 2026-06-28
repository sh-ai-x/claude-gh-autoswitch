---
name: gh-switch
description: Manage gh-autoswitch account mappings. Shows current config, adds or removes owner→account mappings, and checks which account would activate for a given GitHub URL. Use when the user types /gh-switch, asks to add a GitHub account mapping, or wants to check auto-switch status.
---

# gh-switch Skill

Manages `~/.config/gh-autoswitch/accounts.conf` — the mapping that auto-switches gh CLI accounts on `git push`.

## Trigger phrases
- `/gh-switch` — show current mappings and active account
- `/gh-switch add <owner> <account>` — add or update a mapping
- `/gh-switch remove <owner>` — remove a mapping
- `/gh-switch check <url>` — show which account would activate for a GitHub URL

## Config file

`~/.config/gh-autoswitch/accounts.conf`:
```
# github_owner=gh_cli_account
sh-ai-x=sh-ai-x
mybotagent=mybotagent
```

## Workflow

### Show status
```bash
echo "=== Active account ==="
gh auth status 2>&1 | grep -E "Logged in|Active account"
echo ""
echo "=== Account map ==="
cat ~/.config/gh-autoswitch/accounts.conf
```

### Add mapping
Append `<owner>=<account>` to the conf file (skip if already present).

### Remove mapping
Delete the line matching `<owner>=` from the conf file.

### Check URL
Extract the owner from the URL, look it up in the conf, and report which account would be used.

## Response format
One short summary line per action. No extra explanation.
