# Dotfiles alignment — working ledger

> Temporary file. Tracks the cleanup/alignment of this repo across two Macs.
> **Delete before the project is considered done.** This is not part of the dotfiles.

> **Fresh-session quickstart.** If you're a Claude session picking this up
> cold:
> 1. `cd <repo>; git fetch; git worktree list` — confirm where you are and
>    whether the other Mac's worktree exists. If editing `align/cleanup`,
>    use a worktree (e.g. `~/dev/dotfiles-align`) so live symlinked config
>    in the main checkout isn't clobbered.
> 2. Identify this host (`scutil --get LocalHostName`) and find its
>    §Hosts entry below. ⚠️ markers there name current blockers.
> 3. Check the `BATON:` line under §Cross-machine protocol — only edit
>    `align/cleanup` if it says `idle`. Take BATON in the same commit that
>    does the work, release back to `idle` at the end.
> 4. §Decisions log = settled (don't relitigate). §Pass plan & status =
>    the work queue. §Open questions = what's actively unresolved.
> 5. Primary guardrail: **LOSE NO DATA**. Preserve everything; throw away
>    only after both Macs have verified.

## Goal / end-state

**#1 — identical configs on both Macs.** Maximize what is shared and
byte-identical. Use the **per-host `*.local` override mechanism (#2)** ONLY
for irreducible differences that genuinely cannot be unified (e.g. Intel vs
Apple-Silicon paths, work-only tools). Do NOT create `.local` files
speculatively. Confirmed by Dan, 2026-05-21.

## Decisions log

| # | Decision | Value |
|---|----------|-------|
| End state | identical (#1), `*.local` fallback only where forced | **confirmed 2026-05-21** |
| Primary guardrail | **LOSE NO DATA** — preserve everything; throw away only after both Macs verified | **confirmed 2026-05-21** |
| Snapshot branch labels | `macbook-pro` (Dan-Seely D6RX99KXNMAA), `macbook-air` | confirmed 2026-05-21 |
| Cross-machine compare | Run Claude on BOTH Macs, coordinate via git | set |
| Progress tracking | this `NOTES.md` (in repo) + Claude memory | set |
| Canonical Mac | none global — decide source-of-truth per file from diffs | set |
| Keep `.bash_profile` | yes | set |
| Keep `.zshrc-backup-24-jan-2022` | yes | set |
| iTerm plist handling | Curated export only (Pass 0 design below) | set |

## Hosts

> Note: section headings no longer say "this Mac" — this NOTES.md is edited
> from either Mac via worktree; "this Mac" is ambiguous in the file itself.

### MacBook-Air
- macOS 26.4.1, Apple Silicon, zsh, iTerm2 3.6.10
- Uncommitted at project start: M .gitconfig .iterm/...plist README.md
  karabiner/karabiner.json zsh/.zprofile zsh/.zshrc ; untracked .oh-my-zsh/
  .fzf.zsh karabiner/automatic_backups/2023..2025*
- iTerm: `~/.iterm` is a SYMLINK -> this repo's `.iterm/`, and iTerm has
  `LoadPrefsFromCustomFolder=1`, so iTerm reads/writes its real prefs into
  the repo. Plain gitignore is not viable.
- ⚠️ **`snapshot/macbook-air` not yet pushed.** Pre-cleanup uncommitted
  edits to `.gitconfig`, `karabiner/karabiner.json`, `zsh/.zprofile`,
  `zsh/.zshrc` are still local-only on macbook-air as of 2026-05-21.
  Pass 2+ on align/cleanup should not proceed until those are pushed
  (either as a `snapshot/macbook-air` branch or as commits to
  `align/cleanup` on Pass 2's first work).

### MacBook-Pro (joined 2026-05-21)
- Hostname: `D6RX99KXNMAA` (Dan-Seely). Apple Silicon. zsh.
- Checkout location: `~/dev/dotfiles` (worktree `~/dev/dotfiles-align`
  added 2026-05-21 for align/cleanup work that won't clobber live config).
- Uncommitted at project start: M .gitconfig Brewfile
  karabiner/karabiner.json zsh/.zprofile zsh/.zshrc ; untracked .oh-my-zsh/
  fzf/ zed/ zsh/.zshenv karabiner/automatic_backups/karabiner_2024..2025*
  ; stash@{0} = pre-@adadapted era (different email + 1Password SSH signing
  setup); .DS_Store junk.
- iTerm: **no decouple needed here.** `~/.iterm` does NOT exist on this
  Mac. `LoadPrefsFromCustomFolder` is unset (default 0). iTerm reads its
  real plist from `~/Library/Preferences/com.googlecode.iterm2.plist`.
- `~/.fzf.zsh`: does NOT exist on this Mac. Repo's `fzf/.fzf.zsh` is
  dormant; safe to ignore.
- `~/.oh-my-zsh` → repo's `.oh-my-zsh/` (same pattern as macbook-air). 35M,
  upstream-tracking, nothing personal under `custom/`. Restorable via
  upstream installer; long-term plan = un-symlink and install standardly.
- iTerm Dynamic Profiles **DO** matter here: `zsh/.zshrc` defines a
  `theme()` function that emits `OSC 1337 SetProfile=theme-{lavender,sage,
  slate,amber,crimson}`. These dynamic profiles need to be exported to
  `iterm/DynamicProfiles/dan.json` as part of Pass 0's "Other Mac" step.
  Profile content lives at `~/Library/Application Support/iTerm2/
  DynamicProfiles/theme-profiles.json` per the inline `.zshrc` comment.
- `snapshot/macbook-pro` pushed at `9ac1d68` (2026-05-21). Includes
  `snapshot/stash@0.patch` so the pre-@adadapted stash data travels even
  if macbook-pro's local clone is destroyed. The stash entry is also
  left intact in the local stash list (belt + suspenders). Commit is
  unsigned — `op-ssh-sign` invocation didn't fire in the agent shell
  context; throwaway branch so not addressed.
- Skipped from snapshot: `.oh-my-zsh/`, `.DS_Store`, `fzf/.DS_Store`,
  `zed/embeddings/` (SQLite cache). All deliberate, documented in the
  snapshot's commit message.

## Session handoff (this Mac, for Pass 1)

Pass 1 needs iTerm fully quit. Plan: quit iTerm, then RESUME this same
session from Terminal.app (cleaner than cold-start — full context):
`claude --resume 6f8d330c-7a40-4828-8dc7-4c64276ea022` (or `--continue`).
If that resume ever fails, cold-start works too: a fresh `claude` in the
repo reads this NOTES.md + project memory and continues from here.

## Resuming on the OTHER Mac (next session, 2026-05-20+)

`align/cleanup` has been pushed to origin (commit `7f1d979`). On the
other Mac:

1. `cd` into the dotfiles repo on that Mac (wherever it lives).
2. `git fetch origin` ; review with `git log origin/align/cleanup -1`.
   Do NOT check out yet — the other Mac has its own uncommitted local
   state that must be captured first.
3. Start `claude` in the repo dir; tell it:
   *"Continue the dotfiles alignment project — this is the OTHER Mac
   (not MacBook-Air). Read NOTES.md."*
4. That Claude session's first task: capture `snapshot/<hostname>` of
   THIS Mac's current state verbatim (commit all uncommitted edits +
   untracked files of interest, push to origin). Take BATON in NOTES.md.
5. Then mirror Pass 1 here, with the critical ORDERING from Pass 0:
   **export the handful of important iTerm profiles to
   `iterm/DynamicProfiles/dan.json` BEFORE un-tracking `.iterm` /
   removing any `~/.iterm` symlink.** `snapshot/<hostname>` also
   preserves the raw plist as backup.
6. After per-file canonical decisions on Pass 2-4 diffs, push, release
   BATON, hand back to MacBook-Air for review.

If `~/.iterm` is also a symlink into the repo on the other Mac (likely),
the iTerm decouple steps from Pass 1 apply there too — but only AFTER
the curated profile export.

## Cross-machine protocol (Claude on both Macs)

Branches:
- `master` — untouched / known-good fallback until a pass is verified on BOTH Macs.
- `align/cleanup` — shared working branch. All cleanup commits go here.
- `snapshot/<hostname>` — each Mac commits its *current local state verbatim*
  (incl. uncommitted edits) here so the other Mac can diff whole files. Throwaway.

Baton rule (avoid clobbering): the line below names who may edit
`align/cleanup` right now. Take it, push, set back to `idle` when done.

    BATON: idle

### BATON history

- 2026-05-21 — macbook-pro briefly took BATON to register this Mac's
  arrival (host facts in §Hosts, snapshot capture record, iTerm
  Dynamic Profiles work item, decisions log updates). No file content
  reconciliation done; Pass 2+ deferred pending `snapshot/macbook-air`.
  Released BATON → idle in same commit.

Flow:
1. MacBook-Air creates `align/cleanup` off `master`, adds this NOTES.md.
2. Each Mac pushes `snapshot/<hostname>` of its current state.
3. Per file in scope: `git diff snapshot/A..snapshot/B -- <file>` →
   decide canonical → apply onto `align/cleanup` → record decision here.
4. Pass-by-pass. Merge `align/cleanup` → `master` only when a pass is
   verified on both Macs. Delete snapshot branches at the end.

## Pass plan & status

- [ ] **Pass 0 — iTerm plist → curated export**. Design (REFINED):
      Curation scope = **profiles ONLY**. Verified on MacBook-Air
      (2026-05-19): zero deliberate global customization — GlobalKeyMap
      is iTerm's stock nav set, no active hotkey window, all notable
      toggles at/near default. `iterm-defaults.sh` DROPPED entirely.
      Only curated artifact = Dynamic Profiles JSON, authored on the
      OTHER Mac where the important profiles live (`Nutshell *` on this
      Mac are stale work, not carried).
      - **This Mac (MacBook-Air):** nothing to curate. Pass 0 here =
        just the un-track step, folded into Pass 1:
        back up live plist outside repo → disable iTerm
        `LoadPrefsFromCustomFolder` (via `defaults write`, iTerm quit)
        → remove `~/.iterm` symlink → `git rm -r --cached .iterm` →
        gitignore `.iterm/`.
      - **Other Mac:** its Claude session exports the handful of
        important profiles to `iterm/DynamicProfiles/dan.json`
        (tracked, identical across Macs; symlinked into
        `~/Library/Application Support/iTerm2/DynamicProfiles/`),
        THEN does its own un-track step.
        - DONE on macbook-pro 2026-05-21: exported the 5 `theme-*`
          profiles (lavender/sage/slate/amber/crimson) verbatim from
          live `~/Library/Application Support/iTerm2/DynamicProfiles/
          theme-profiles.json` (98 lines, 3.2K, all Dynamic-Profile-
          Parent-Name=Default with only background-color overrides).
          File added at `iterm/DynamicProfiles/dan.json`.
        - DEFERRED (Phase 2): replacing the live
          `~/Library/Application Support/iTerm2/DynamicProfiles/
          theme-profiles.json` with a symlink to the repo. Reason:
          macbook-pro's main checkout is currently on
          `snapshot/macbook-pro` (worktree on `align/cleanup`).
          Symlinking now would have to target the worktree, which
          gets removed at project end. Do this when main checkout
          lands on `master` post-merge.
      - ⚠️ ORDERING HAZARD: do NOT un-track/de-symlink `.iterm` on the
        OTHER Mac until its important profiles are exported to the repo
        first. `snapshot/<otherhost>` also preserves its raw plist.
      - Do iTerm prefs surgery with **iTerm fully quit**, driven from
        Terminal.app/Warp via `defaults write` (no GUI, no race).
- [x] **Pass 1 — Hygiene** — DONE on branch `align/cleanup`,
      commit `7f1d979` (not pushed, master untouched).
      - iTerm decoupled from repo: backup at
        `~/iterm-prefs-backup-20260519.plist`; rich 8-profile config
        imported to iTerm standard domain; `LoadPrefsFromCustomFolder=0`;
        `~/.iterm` symlink removed.
      - `.gitignore` added: `.oh-my-zsh/`, `.fzf.zsh`, `.iterm/`,
        `karabiner/automatic_backups/`, `.claude/*.local.json`.
      - Untracked (files kept on disk): `.iterm/com.googlecode.iterm2.plist`
        + 9 tracked `karabiner/automatic_backups/karabiner_20{20,21}*.json`.
      - Orphan `.iterm/` dir still on disk; physically deletable once
        Dan confirms iTerm behaves correctly across a few launches.
      - VERIFIED: iTerm launched cleanly post-decouple on MacBook-Air
        (Dan, 2026-05-20).
- [ ] **Pass 2 — Easy real changes**: `.gitconfig` (email + gh helper),
      `.zprofile` (brew shellenv). Revert/commit README whitespace.
- [ ] **Pass 3 — `.zshrc` review**: pyenv init flag change, new plugin,
      `codex-inline` alias — confirm on both Macs before committing.
- [ ] **Pass 4 — Karabiner**: review the −500-line diff section by
      section; confirm intentional vs silently dropped.
- [ ] **Pass 5 — Reconcile other Mac**: per-file canonical decisions,
      introduce `*.local` only where forced.

## Resolved side-issues (do not re-investigate)

- **CC scrollback "broke out of nowhere" (2026-05-19):** NOT the dotfiles.
  Claude Code 2.1.138's fullscreen/alt-screen renderer regression, GitHub
  issue #58364 (open as of 2026-05-19, no merged fix yet). Fix/workaround:
  `/tui default` (persists to `~/.claude/settings.json` `"tui"` key).
  Revert later with `/tui fullscreen` once a CC patch >2.1.139 ships.
  If the other Mac's Claude session hits dead trackpad scroll in iTerm,
  this is the cause — don't re-debug.

## Open questions

- ~~End-state #1 vs #2~~ — confirmed #1 (Dan, 2026-05-21).
- ~~iTerm plist (Pass 0) — which handling option~~ — settled (Pass 0
  design above is final). On macbook-pro side, the only remaining iTerm
  work is exporting the 5 `theme-*` dynamic profiles for the `theme()`
  shell function — folded into Pass 0's "Other Mac" step.
- ~~Which Mac is the "other" Mac~~ — macbook-pro (D6RX99KXNMAA).
- **`snapshot/macbook-air` doesn't exist on origin yet.** Macbook-air's
  pre-cleanup uncommitted edits to `.gitconfig`, `karabiner.json`,
  `zsh/.zprofile`, `zsh/.zshrc` are not on the server. Either push a
  verbatim snapshot or fold them into Pass 2/3/4 commits on
  `align/cleanup`. Until then, macbook-pro cannot diff against
  macbook-air's actual file content.
- Should the Claude Code config (`~/.claude/CLAUDE.md`, `settings.json`,
  `keybindings.json`, `statusline-command.sh`, `skills/`) be folded into
  this repo as a new pass? `.gitignore` already contains
  `.claude/*.local.json` which suggests yes. Dan proposed this — decide
  whether to do it as Pass 6 or defer to a follow-on project.
