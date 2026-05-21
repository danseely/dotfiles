# Dotfiles alignment — working ledger

> Temporary file. Tracks the cleanup/alignment of this repo across two Macs.
> **Delete before the project is considered done.** This is not part of the dotfiles.

## Goal / end-state (CONFIRM)

Working assumption (Dan to confirm): **#1 — identical configs on both Macs**
is the goal. Maximize what is shared and byte-identical. Use the
**per-host `*.local` override mechanism (#2)** ONLY for irreducible
differences that genuinely cannot be unified (e.g. Intel vs Apple-Silicon
paths, work-only tools). Do NOT create `.local` files speculatively.

## Decisions log

| # | Decision | Value |
|---|----------|-------|
| End state | identical (#1), `*.local` fallback only where forced | assumed, confirm |
| Cross-machine compare | Run Claude on BOTH Macs, coordinate via git | set |
| Progress tracking | this `NOTES.md` (in repo) + Claude memory | set |
| Canonical Mac | none global — decide source-of-truth per file from diffs | set |
| Keep `.bash_profile` | yes | set |
| Keep `.zshrc-backup-24-jan-2022` | yes | set |
| iTerm plist handling | Curated export only (Pass 0 design below) | set |

## Hosts

### MacBook-Air (this Mac)
- macOS 26.4.1, Apple Silicon, zsh, iTerm2 3.6.10
- Uncommitted at project start: M .gitconfig .iterm/...plist README.md
  karabiner/karabiner.json zsh/.zprofile zsh/.zshrc ; untracked .oh-my-zsh/
  .fzf.zsh karabiner/automatic_backups/2023..2025*
- iTerm: `~/.iterm` is a SYMLINK -> this repo's `.iterm/`, and iTerm has
  `LoadPrefsFromCustomFolder=1`, so iTerm reads/writes its real prefs into
  the repo. Plain gitignore is not viable.

### <other Mac> (fill in from its Claude session)
- (the other Mac's Claude session appends its facts here — own this section)

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

- End-state #1 vs #2 — confirm interpretation above.
- iTerm plist (Pass 0) — which handling option.
- Which Mac is the "other" Mac; its hostname + state.
