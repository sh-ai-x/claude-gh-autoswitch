# claude-gh-autoswitch

Automatically switches the active `gh` CLI account before `git push`, and optionally when a Claude Code session starts, based on the remote URL owner. No manual `gh auth switch` needed.

Also sets `git commit` author to the currently active `gh` account via a global pre-commit hook, so commit attribution matches the GitHub account that owns the target repo.

## How it works

### On `git push`

1. A global git `pre-push` hook fires on every `git push`
2. It extracts the owner from the remote URL (e.g. `sh-ai-x` from `github.com/sh-ai-x/repo`)
3. Looks up the owner in `~/.config/gh-autoswitch/accounts.conf`
4. If the current `gh` account differs from the target, runs `gh auth switch --user <account>`

A global `pre-commit` hook additionally:

1. Reads the active gh account via `gh auth status`
2. Resolves an email (tries `gh api user` first, then falls back to `<login>@users.noreply.github.com`)
3. Applies `git config --local user.name` / `user.email` so the commit is attributed to the right account

### On Claude Code session start (optional)

`scripts/gh-autoswitch-on-start.sh` does the same lookup against the **current directory's** git remote, so the right account is already active before you run anything (e.g. `/plugin marketplace add <owner>/<repo>`, which needs the correct account to clone private repos).

Wire it up by adding this to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.config/gh-autoswitch/gh-autoswitch-on-start.sh"
          }
        ]
      }
    ]
  }
}
```

`install.sh` copies the script into place but does not edit your Claude settings for you — add the snippet above manually.

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
rm ~/.config/git/hooks/pre-commit
```
