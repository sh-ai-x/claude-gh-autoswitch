# claude-gh-autoswitch

Automatically switches the active `gh` CLI account before `git push` based on the remote URL owner. No manual `gh auth switch` needed — just push.

## How it works

1. A global git `pre-push` hook fires on every `git push`
2. It extracts the owner from the remote URL (e.g. `sh-ai-x` from `github.com/sh-ai-x/repo`)
3. Looks up the owner in `~/.config/gh-autoswitch/accounts.conf`
4. If the current `gh` account differs from the target, runs `gh auth switch --user <account>`

## Install

```bash
git clone https://github.com/sh-ai-x/claude-gh-autoswitch
cd claude-gh-autoswitch
bash scripts/install.sh
```

Then edit `~/.config/gh-autoswitch/accounts.conf` to match your setup.

## Config

`~/.config/gh-autoswitch/accounts.conf`:

```
# github_owner=gh_cli_account
sh-ai-x=sh-ai-x
mybotagent=mybotagent
lshtrade=lshtrade
```

- `github_owner` — org or username in the GitHub remote URL
- `gh_cli_account` — account name registered via `gh auth login`

## Claude Code skill

Install the companion skill to manage mappings from inside Claude Code:

```bash
mkdir -p ~/.claude/skills/gh-switch
cp skill/SKILL.md ~/.claude/skills/gh-switch/SKILL.md
```

Then use `/gh-switch`, `/gh-switch add <owner> <account>`, `/gh-switch remove <owner>`.

## Uninstall

```bash
git config --global --unset core.hooksPath
rm -rf ~/.config/gh-autoswitch
rm ~/.config/git/hooks/pre-push
```
