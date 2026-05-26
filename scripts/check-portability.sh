#!/usr/bin/env bash
# check-portability.sh — flag hardcoded user-home paths in tracked config.
#
# Enforces the username-portability decision (NOTES.md §Decisions log):
# no hardcoded `/Users/<name>/` references in any tracked active config.
# Use `$HOME` or `~` (where shell-glob-safe) instead.
#
# Cross-Mac context: this repo ships on two Macs with different usernames
# (`dan` on personal air, `dseely` on work pro). Hardcoded paths under
# either user's home directory silently break on the other Mac. The
# decision is to eliminate the surface area in dotfiles rather than carry
# per-Mac `*.local` overrides for it.
#
# Exit codes:
#   0  clean — no hits in tracked files (after exceptions)
#   1  hits  — print offending file:line lines, fix-or-exempt guidance
#   2  usage / environment error
#
# Run manually before committing canonical-touching work, or wire up as a
# pre-commit hook (`.git/hooks/pre-commit` or `core.hooksPath`).

set -euo pipefail

# Find repo root (works from any subdir or as a pre-commit hook).
if ! repo_root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
  echo "error: not inside a git repo" >&2
  exit 2
fi
cd "$repo_root"

# Pattern: hardcoded user-home paths for either Mac's account.
pattern='/Users/(dan|dseely)/'

# Exclusions (git pathspec `:!` form). Documented in NOTES §Decisions log:
#   manifests/                 — per-Mac symlink inventories, by design
#   archived/                  — graveyard, frozen content
#   snapshot/macbook-*         — verbatim snapshot branch artifacts
#   .zshrc-backup-24-jan-2022  — frozen historical zshrc backup
#   NOTES.md, README.md        — docs may carry example paths; soft-exempt
#                                (new content should still prefer $HOME/~)
exclude=(
  ':!manifests/'
  ':!archived/'
  ':!snapshot/'
  ':!.zshrc-backup-24-jan-2022'
  ':!NOTES.md'
  ':!README.md'
  ":!$(basename "$0")"
  ":!scripts/$(basename "$0")"
)

# `git grep` over tracked files only (untracked / gitignored is out of scope).
# `|| true` so set -e doesn't trip on grep's "no matches → exit 1".
hits=$(git grep -nE "$pattern" -- "${exclude[@]}" 2>/dev/null || true)

if [[ -n "$hits" ]]; then
  echo "✗ Portability lint failed — hardcoded user paths found in tracked files:"
  echo
  echo "$hits"
  echo
  echo "Replace with \$HOME or ~ (where shell-glob-safe)."
  echo "See NOTES.md §Decisions log → \"Username portability\"."
  echo
  echo "If a hit is legitimate (e.g., a frozen historical artifact),"
  echo "add it to the exclude list at the top of this script and"
  echo "document the carve-out in NOTES.md."
  exit 1
fi

echo "✓ Portability lint passed — 0 hits in tracked active config."
