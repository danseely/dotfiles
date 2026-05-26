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
> 5. Primary guardrails: **LOSE NO DATA** (preserve everything; throw
>    away only after both Macs have verified) AND **LIVE-BREAKAGE
>    PROHIBITED** (both Macs are in-use, work-reliant; no change may
>    land on a live `~/dev/dotfiles` checkout until verified safe in
>    a worktree, including temporary degradation). See §Decisions log
>    for full text + §Pass plan per-pass risk table.

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
| Primary guardrail 2 | **LIVE-BREAKAGE PROHIBITED** — both Macs are in-use, work-reliant machines. Changes that could break or degrade live state (interactive shell startup, oh-my-zsh/p10k load, keyboard remapping, iTerm launch, git operations, editor launch) MUST NOT land on a live `~/dev/dotfiles` checkout until verified safe in isolation (worktree). Temporary degradation counts as breakage. If a change is unavoidable but live-affecting, it must be staged: (a) authored in a worktree, (b) smoke-tested via selective live test, (c) only then promoted to main. The deletions-only danger check is **necessary but not sufficient** — it doesn't catch content modifications to files reached through symlinks. Always pair it with a worktree smoke test for any pass that touches: `.zshrc`, `.zshenv`, `.zprofile`, `.p10k.zsh`, `.gitconfig`, `karabiner.json`, Zed config, iTerm plist. | **confirmed 2026-05-26** |
| Snapshot branch labels | `macbook-pro` (Dan-Seely D6RX99KXNMAA), `macbook-air` | confirmed 2026-05-21 |
| Cross-machine compare | Run Claude on BOTH Macs, coordinate via git | set |
| Progress tracking | this `NOTES.md` (in repo) + Claude memory | set |
| Canonical Mac | none global — decide source-of-truth per file from diffs | set |
| Keep `.bash_profile` | yes | set |
| Keep `.zshrc-backup-24-jan-2022` | yes | set |
| iTerm plist handling | Curated export only (Pass 0 design below) | set |
| Merge cadence | one merge `align/cleanup` → `master` at project end (master = clean rollback target throughout) | **confirmed 2026-05-22** |
| `.gitconfig` identity | global `dan@danseely.net`; `includeIf "gitdir:~/dev/adadapted/"` overrides to `dseely@adadapted.com` via repo-internal `gitconfig/adadapted` (referenced as `path = ~/dev/dotfiles/gitconfig/adadapted`). Byte-identical `.gitconfig` ships on both Macs; inert on machines without `~/dev/adadapted/`. | **confirmed 2026-05-22** |
| Verification protocol | receiving Mac pulls into worktree first, runs danger check (deleted-files × symlink manifest), optionally tests selective symlinks, only then advances main checkout | **confirmed 2026-05-22** |
| Symlink manifest | per-Mac `manifests/symlinks-<host>.txt` committed to repo as LOSE-NO-DATA pre-flight inventory of symlinks-into-repo | **confirmed 2026-05-22** |
| `.bash_profile`, `.zshrc-backup-24-jan-2022` | keep as-is, no content review | confirmed 2026-05-22 |
| `~/.claude/` config in repo | yes — Pass 6 (deferred to end), selective symlinks pattern | confirmed 2026-05-22 |
| Graveyard pattern (`archived/`) | for files queued for deletion but not yet yanked (honors LOSE-NO-DATA). Move to `archived/<filename>`; deletion happens as a separate operation later. Empty for now. | **confirmed 2026-05-22** |
| Username portability | **No hardcoded `/Users/<name>/` in any tracked active config.** Use `$HOME` (or `~` where shell-glob-safe). Cross-Mac username drift (`dan` on air, `dseely` on pro) is an irreducible OS-level difference; we eliminate its surface area in dotfiles rather than carry a per-Mac `*.local` for it. **Exceptions**: `manifests/symlinks-<host>.txt` (per-Mac inventories by design); `.zshrc-backup-24-jan-2022` (frozen historical artifact, per existing decision). NOTES.md and README.md may reference example paths but should prefer `$HOME`/`~` in new content. Enforcement: Pass 7 ships `scripts/check-portability.sh` (greps the repo, exits non-zero on hits, optional pre-commit hook). | **confirmed 2026-05-26** |

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
  the repo. Plain gitignore is not viable. (Resolved in Pass 1.)
- `snapshot/macbook-air` pushed at `da6d5bc` (2026-05-22), branched off
  `master` (e5385e2). Captures the 5 tracked-file working-tree mods
  verbatim: `.gitconfig`, `README.md`, `karabiner/karabiner.json`,
  `zsh/.zprofile`, `zsh/.zshrc`. Untracked files on disk (`.oh-my-zsh/`,
  `.fzf.zsh`, `.claude/`, karabiner auto-backups) deliberately skipped
  — tool-managed / now-gitignored, not config to align.

### MacBook-Pro (joined 2026-05-21)
- Hostname: `D6RX99KXNMAA` (Dan-Seely). Apple Silicon. zsh.
- Checkout location: `~/dev/dotfiles` (main, on `snapshot/macbook-pro`
  through Pass 2; advances to `align/cleanup` after Pass 3 lands the
  cross-Mac username portability fixes). Worktree `~/dev/dotfiles-align`
  on `align/cleanup` is pro's authoring location for Pass 2 onward.
  A 2026-05-26 attempt to advance main to `align/cleanup` was rolled
  back same session — see §Macbook-pro Pass 1 verification —
  DONE BUT ADVANCE DEFERRED.
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

## Session handoff (HISTORICAL — Pass 1, done 2026-05-20)

> Superseded. Pass 1 is complete and verified on macbook-air. Kept
> for the record. Fresh sessions: use the §Fresh-session quickstart
> at the top, not this section.

Pass 1 needed iTerm fully quit. The session was resumed from
Terminal.app via `claude --resume 6f8d330c-...`. Cold-start also works:
a fresh `claude` in the repo reads this NOTES.md + project memory.

## Resuming on the OTHER Mac (HISTORICAL — pro arrived 2026-05-21)

> Superseded. macbook-pro joined on 2026-05-21, pushed its snapshot,
> and did Pass 0 dynamic-profile export. The onboarding steps below
> are done. The pro-side work that REMAINS (Pass 1.5 manifest + Pass 1
> verification) is tracked in §Pass plan and §Pass 1.5 analysis →
> "Macbook-pro Pass 1 verification — STILL PENDING". Commit hash
> below (`7f1d979`) is stale (amended to `d9da728`).

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

- 2026-05-26 — macbook-pro took BATON for **Pass 2 authoring**
  (content commits, all 5 originally-scoped files + the 3
  username-portability files). Authored in pro worktree
  `~/dev/dotfiles-align`; pro main untouched (stays on
  `snapshot/macbook-pro` per the deferred-advance gate; Pass 3 is
  the unblock). Functional regression pre-flight in worktree using
  `GIT_CONFIG_GLOBAL` + ad-hoc git repos exercised `.gitconfig`
  includeIf in both directions (personal email outside
  `~/dev/adadapted/`, work email inside) ✅; `.zprofile` brew
  shellenv populates PATH ✅; `.zshenv` `[ -f ]` guard correctly
  no-ops when `~/.cargo/env` absent ✅; portability lint pre-check
  (`grep /Users/dan|/Users/dseely`) on the 7 authored files
  returns zero hits ✅. See §Pass 2 authored — DONE for the full
  file-by-file table + caveats (includeIf testing required a
  temporary `~/dev/dotfiles/gitconfig` symlink workaround). Air-side
  verification + main-advance left for air's next session. Released
  BATON → idle in same commit.
- 2026-05-26 — macbook-pro took BATON for **LIVE-BREAKAGE PROHIBITED
  guardrail capture** (follow-on to the Pass 1 advance rollback
  earlier same day). Today's session — advance main → break pro's
  oh-my-zsh load → roll back — exposed a missing top-level principle:
  no explicit prohibition on landing changes that could break or
  degrade live state on these in-use, work-reliant Macs. Process
  saved us via smoke test + rollback, but the rule wasn't named.
  Landed three additions to NOTES: (1) §Decisions log entry
  "Primary guardrail 2: LIVE-BREAKAGE PROHIBITED" with the explicit
  scope list (`.zshrc`/`.zshenv`/`.zprofile`/`.p10k.zsh`/`.gitconfig`/
  `karabiner.json`/Zed/iTerm), (2) new §Hardened verification
  protocol step 3 "Functional regression pre-flight" — the
  deletions-only danger check is now formally documented as
  necessary-but-not-sufficient and must be paired with a worktree
  smoke test for any pass touching the scoped files; original
  step 3 (selective live test) renumbered to 4, etc., (3) new
  §Per-pass live-breakage risk table at the top of §Pass plan
  & status with explicit None/Low/Medium/High tags + rationale
  per pass. Also updated §Fresh-session quickstart to mention the
  new guardrail alongside LOSE-NO-DATA so cold-start sessions
  pick it up. NOTES.md only; no config content. Released BATON →
  idle in same commit.
- 2026-05-26 — macbook-pro took BATON for **Pass 1 verification + pro
  symlink manifest + cross-Mac username portability reframe**
  (Pass 1.5 pro-side closing). Generated
  `manifests/symlinks-D6RX99KXNMAADan-Seely.txt` (6 entries:
  karabiner dir, gitconfig, oh-my-zsh, p10k, zprofile, zshrc; no
  `.fzf.zsh` symlink, no Zed symlinks yet). Ran danger check on main
  (`snapshot/macbook-pro` → `origin/align/cleanup`): 21 working-tree
  deletions, all benign — `fzf/.fzf.{bash,zsh}` (no live symlink),
  16 `karabiner/automatic_backups/*.json` (historical auto-backups
  under symlinked dir; preserved in snapshot branch),
  `snapshot/{README.md,stash@0.patch}` (preserved in snapshot branch
  + local `stash@{0}`), `zsh/.zshenv` (no `~/.zshenv` on pro).
  **Attempted main-checkout advance to `align/cleanup` (`47683ca`);
  rolled back same session.** The post-advance smoke test surfaced
  that `zsh/.zshrc:12` hardcodes `export ZSH="/Users/dan/.oh-my-zsh"`
  (master/align-cleanup version); pro's home is `/Users/dseely/`, so
  oh-my-zsh failed to source on `align/cleanup`. Pro's snapshot
  already carried the `$HOME/.oh-my-zsh` portability fix as a
  working-tree mod; Pass 3's canonical also lands it. With Dan,
  reframed this as a recurring class of bug ("cross-Mac username
  drift") and added the **username-portability decision** (see
  §Decisions log: no hardcoded `/Users/<name>/` in tracked active
  config). Pass 2 scope expanded to cover `.bash_profile` +
  `osx.sh` + `.gitconfig commit.template`. Pass 7 gains a portability
  lint. Main checkout reverted to `snapshot/macbook-pro` (`9ac1d68`);
  the `~/dev/dotfiles-align` worktree was recreated for continued
  align/cleanup authoring. Pro main-checkout advance is **deferred
  until Pass 3 lands the `$HOME/.oh-my-zsh` + gcloud-path fixes**;
  the danger-check + manifest portion of Pass 1 verification is ✅.
  Released BATON → idle in same commit.
- 2026-05-25 — macbook-air took BATON for **Pass 5 air-side fold-in**
  (later same day as the Pass 7 entry below). Landed `zed/` config in
  repo (new VS-Code-aligned canonical that supersedes the original
  minimal Pass 5 plan), moved pre-overhaul originals to
  `archived/zed-macbook-air-prepass/`, swapped live
  `~/.config/zed/{settings,keymap}.json` to symlinks into the repo,
  updated air's symlink manifest, expanded NOTES Pass 5 plan + added
  §Pass 5 air-side completion section with pro-side adoption steps and
  a Brewfile note. Verified pro had pushed nothing new (origin in sync
  at `25284a1`, `snapshot/macbook-pro` unchanged at `9ac1d68`). Released
  BATON → idle in same commit.
- 2026-05-25 — macbook-air took BATON to add **Pass 7 (README
  modernization & upkeep)** to the §Pass plan — a small ledger addition
  slipped into the existing planning thread. Verified pro had pushed
  nothing new (`origin/align/cleanup` in sync at `f6e5f49`,
  `snapshot/macbook-pro` unchanged at `9ac1d68`). NOTES.md only — no
  config content; new follow-on commit (not an amend, since `f6e5f49`
  was already on origin). Released BATON → idle in same commit.
- 2026-05-22 → 2026-05-23 — macbook-air took BATON for **Pass 1.5
  diff dive** (multi-commit work over two days). Completed: symlink
  manifest generated + committed; Pass 2/3/4/5 file diff analyses
  written with proposed canonicals; Pass 2 + Pass 3 decisions
  approved by Dan; secrets scans clean across all Pass 2-5 files;
  legacy WIP assessment resolved (the 5 air working-tree mods ARE
  air's snapshot content, no separate analysis needed). Pass 1.5
  pro-side work (its manifest + Pass 1 verification) still
  pending — pro will take BATON when ready. Released BATON → idle.
- 2026-05-22 — macbook-air took BATON for **plan revision**: expanded
  pass scope (Brewfile, Zed config, `.zshenv`, fzf subdir added);
  added Pass 1.5 (reality check, diff dive, secrets scan, symlink
  manifest); added Pass 6 (Claude config, deferred); hardened
  verification with worktree-first receiving-Mac protocol + symlink
  manifest danger check; locked in `includeIf gitdir:` mechanism for
  `.gitconfig` work-vs-personal email; single-merge-at-end cadence.
  NOTES.md only — no `align/cleanup` content commits. Released
  BATON → idle in same commit.
- 2026-05-22 — macbook-air took BATON to push `snapshot/macbook-air`
  (`da6d5bc` off master), unblocking Pass 2+. Updated §Hosts entry,
  resolved the snapshot-gap §Open question. No file content
  reconciliation done. Released BATON → idle in same commit.
- 2026-05-21 — macbook-pro briefly took BATON to register this Mac's
  arrival (host facts in §Hosts, snapshot capture record, iTerm
  Dynamic Profiles work item, decisions log updates). No file content
  reconciliation done; Pass 2+ deferred pending `snapshot/macbook-air`.
  Released BATON → idle in same commit.

Flow:
1. MacBook-Air creates `align/cleanup` off `master`, adds this NOTES.md.
2. Each Mac pushes `snapshot/<hostname>` of its current state.
3. Each Mac commits its `manifests/symlinks-<host>.txt` (Pass 1.5).
4. Per file in scope: `git diff snapshot/A..snapshot/B -- <file>` →
   decide canonical → apply onto `align/cleanup` → record decision here.
5. Pass-by-pass with verification gate between (see protocol below).
6. **Single merge** `align/cleanup` → `master` at project end (one
   commit, after every pass green on both Macs). Delete snapshot
   branches. master is rollback target throughout.

### Hardened verification protocol (2026-05-22)

**Receiving-Mac protocol** (any Mac that did NOT author the pass being
verified). Apply for every pass that touches tracked file content:

1. **Pull into worktree only**, never directly into main checkout. If a
   worktree doesn't exist, create one: `git worktree add ~/dev/dotfiles-align align/cleanup`.
2. **Danger check** — list files this pull would remove from working tree:
   ```
   git diff --name-only --diff-filter=D HEAD..origin/align/cleanup
   ```
   Cross-reference against `manifests/symlinks-<host>.txt`. If any
   deletion is a live symlink target, do NOT advance main yet. Resolve
   first: re-point symlink, replace with file, or accept and clean up
   the symlink post-pull. Document the resolution in NOTES.
3. **Functional regression pre-flight** (per Primary guardrail 2:
   LIVE-BREAKAGE PROHIBITED). Before advancing main, run the pass's
   functional smoke test against the worktree as a stand-in for live
   state. The deletions-only danger check (step 2) does NOT catch
   content modifications to files reached through symlinks — but
   those modifications can still break live config. Examples:
   - Shell-affecting passes: source the worktree `.zshrc` in a
     subshell — `ZDOTDIR=~/dev/dotfiles-align/zsh zsh -l -i -c
     'echo OK; type omz; type git'` — to test the worktree's
     `.zshrc` without symlinking it live. Watch for any
     `no such file` / `command not found` / hardcoded-path errors.
   - Pass 2 portability: confirm `git -C ~/dev/adadapted config
     user.email` resolves correctly against the worktree's
     `.gitconfig` via `GIT_CONFIG_GLOBAL=~/dev/dotfiles-align/.gitconfig`.
   - Pass 0 / iTerm: launch iTerm WITHOUT the symlinked profile and
     confirm core behavior; only then symlink the curated profile in.

   If the pre-flight surfaces a regression — even a degradation,
   not just a hard break — the advance is **BLOCKED** until the
   regression is fixed in `align/cleanup`. Document the block in
   NOTES (which pass, which file, which line, the resolution plan).
   Today's deferred main-advance on macbook-pro (Pass 1 verification)
   is the worked example.
4. **Selective live test** (higher-risk passes only — Karabiner, .zshrc).
   Temporarily `ln -sf <worktree-path> <live-path>` for the affected
   file, exercise behavior, revert symlink if broken. Examples:
   - `.zshrc`: `ln -sf ~/dev/dotfiles-align/zsh/.zshrc ~/.zshrc; zsh -l -i -c true; <revert if errors>`
   - `karabiner.json`: `ln -sf ~/dev/dotfiles-align/karabiner/karabiner.json ~/.config/karabiner/karabiner.json` (karabiner auto-reloads); revert if remap behavior broken.
5. **Advance main checkout**: in main, `git pull --ff-only origin align/cleanup`.
6. **Smoke test** the pass-specific behavior in main; mark verified in NOTES.
7. **Rollback if needed**: `git checkout snapshot/<host>` restores all
   repo content to pre-cleanup state. Symlinks in `~` are untouched
   throughout — only the *content at their targets* changes, which
   reverts with the checkout.

**Authoring-Mac protocol**: author's choice on main-checkout vs worktree.
Main-checkout authoring means continuous self-test (live config reflects
every commit) which has been working for macbook-air. Worktree authoring
is also fine and matches macbook-pro's pattern.

## Pass plan & status

### Per-pass live-breakage risk (per Primary guardrail 2)

Every pass is tagged with its risk of breaking or degrading live
state. Higher-risk passes require the §Hardened verification
protocol step 3 (functional regression pre-flight) AND step 4
(selective live test) before any main-checkout advance.

| Pass | Live-breakage risk | Why |
|---|---|---|
| Pass 0 (iTerm decouple + curated export) | **High** | iTerm prefs surgery requires iTerm fully quit; mistakes brick the prefs domain |
| Pass 1 (gitignore + hygiene) | **None** | Additive only (gitignore + un-track); no content changes to symlink-reached files |
| Pass 1.5 (manifests + analysis) | **None** | NOTES + manifest files only |
| Pass 2 (env + identity) | **Low** | `.gitconfig`, `.zprofile`, `.zshenv`, `.bash_profile`, `osx.sh`, `Brewfile`. Includes the username-portability fixes that UNBLOCK pro for Pass 3; but the interactive-shell breakage itself lives in Pass 3 |
| Pass 3 (`.zshrc` + `.p10k.zsh`) | **Medium-High** | Shell startup. Cross-Mac username drift surfaced here (line 12). All new shells inherit any breakage immediately |
| Pass 4 (Karabiner) | **High** | Keyboard remapping. A broken karabiner.json can leave Dan unable to type. Selective live test is mandatory |
| Pass 5 (Zed) | **Low-Medium** | Editor only; no shell impact. Bad config means Zed launches degraded, not unusable |
| Pass 6 (Claude Code config) | **Low** | Claude sessions separable from shell; bad config means a Claude session degrades, not the OS |
| Pass 7 (README + portability lint) | **None** | Docs + a non-blocking script |

**Pro's main-checkout advance is gated on Pass 3** — until the
`$HOME/.oh-my-zsh` + gcloud-path fixes land, advancing main from
`snapshot/macbook-pro` to `align/cleanup` breaks pro's interactive
shell (worked example: 2026-05-26 attempt + rollback).

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
      commit `d9da728` (pushed, master untouched).
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
      - VERIFIED on macbook-air: iTerm launched cleanly post-decouple
        (Dan, 2026-05-20).
      - PARTIAL on macbook-pro 2026-05-26: danger check clean (see
        §Macbook-pro Pass 1 verification — DONE BUT ADVANCE DEFERRED),
        but **main-checkout advance is deferred** until Pass 3 lands
        the `$HOME/.oh-my-zsh` + gcloud-path fixes (cross-Mac username
        drift; see §Decisions log username-portability entry). Main
        stays on `snapshot/macbook-pro` for now; pro authors future
        passes from the `~/dev/dotfiles-align` worktree.
- [~] **Pass 1.5 — Reality check, scope freeze, pre-flight inventory**
      (manifests + analyses DONE both sides 2026-05-26; pro main-
      checkout advance deferred to Pass 3 per username-portability)
      - ✅ macbook-air: manifest committed, full diff dive analysis
        for Pass 2-5 in NOTES, secrets scans clean, ALL Dan decisions
        in (Pass 2, Pass 3, Pass 4 rule [1] = disabled, Pass 5 Zed
        dock = right), WIP assessment resolved. Air side fully done.
      - ✅ macbook-pro 2026-05-26: manifest committed
        (`symlinks-D6RX99KXNMAADan-Seely.txt`, 6 entries), Pass 1
        danger check run + green. Pass 0 / Pass 1 gitignore /
        Pass 1.5 analyses all coherent on pro. **Gate cleared —
        Pass 2 content commits may begin.** Main-checkout advance
        on pro is deferred to Pass 3 (cross-Mac username drift; see
        §Decisions log + §Macbook-pro Pass 1 verification — DONE
        BUT ADVANCE DEFERRED); doesn't block Pass 2 authoring,
        which proceeds in pro's worktree.
      - **Per-Mac symlink manifest** (LOSE-NO-DATA pre-flight inventory).
        On each Mac:
        ```
        mkdir -p manifests
        find "$HOME" -type l 2>/dev/null -exec sh -c '
          for f; do
            t=$(readlink "$f")
            case "$t" in
              *dotfiles*) printf "%s -> %s\n" "$f" "$t" ;;
            esac
          done
        ' _ {} + | sort > "manifests/symlinks-$(scutil --get LocalHostName).txt"
        ```
        Commit each Mac's file. These are the danger-check reference
        for every subsequent pull into main.
        Note: do NOT use `find -lname "*/dev/dotfiles/*"` — BSD find's
        `-lname` glob does not traverse `/`, so the pattern returns
        zero matches even when symlinks exist. The shell-loop form
        above is robust.
      - **Diff dive** on both snapshots vs master: `.gitconfig`,
        `.zprofile`, `.zshenv`, `Brewfile`, `.zshrc`, `karabiner.json`,
        Zed config, fzf subdir. Output: per-file analysis notes in
        NOTES (proposed canonical + rationale).
      - **Macbook-air's 5 legacy WIP mods**: assess each as "intended
        canonical / partial WIP to amend / discard." They're inputs
        to the canonical decision, NOT commit-as-Pass-2-input.
      - **Secrets scan**: `.gitconfig` signingkey/credential tokens,
        `.zshrc` inline credentials, any other suspicious content.
      - **Macbook-pro Pass 1 verification**: with pro's manifest in
        hand, pull Pass 1 (and Pass 0 dynamic profile file) into pro's
        worktree, run danger check, advance main checkout once green.
        Closes the Pass 1 verification gap.
      - **Output**: revised per-file scope captured in NOTES, manifests
        committed, pro on Pass 1 in main checkout, all open analytical
        questions resolved before any Pass 2+ content commits.
- [~] **Pass 2 — Env & identity** (authored 2026-05-26 in pro worktree;
      air-side verification + pro main-advance still pending — see
      §Pass 2 completion below; LIVE: only authored files reside on
      `align/cleanup`, pro/air main checkouts untouched)
      - `.gitconfig`: main file at repo root + `gitconfig/adadapted`
        (3 lines, work-email override), referenced via
        `[includeIf "gitdir:~/dev/adadapted/"] path = ~/dev/dotfiles/gitconfig/adadapted`.
        Byte-identical `.gitconfig` on both Macs; inert on machines
        without `~/dev/adadapted/`.
      - `.gitconfig` portability (per username-portability decision):
        `[core] excludesfile = /Users/dan/.gitignore_global` →
        `~/.gitignore_global`; `[commit] template = /Users/dan/.stCommitMsg`
        → `~/.stCommitMsg`. Both silently no-op on pro today; the fixed
        form is portable across both Macs even when the referenced files
        don't exist (git tolerates missing referenced paths).
      - `.zprofile`: brew shellenv. Apple-Silicon `/opt/homebrew` path
        same on both Macs (both are Apple-Silicon per Hosts entries).
      - `.zshenv`: decide adopt (pro's content) / omit / merge.
      - `.bash_profile` portability (per username-portability decision):
        gcloud `source` lines hardcode `/Users/dan/dev/google-cloud-sdk/`
        → `$HOME/dev/google-cloud-sdk/`. Pro uses zsh at runtime so
        this is dead code on pro today, but kept portable per the
        principle.
      - `osx.sh` portability (per username-portability decision):
        `echo '... brew shellenv' >> /Users/dan/.zprofile` →
        `>> "$HOME/.zprofile"`. Setup-time script only; still gets
        the fix.
      - `Brewfile`: reconcile pro's 3-line diff. Plus the Pass 5
        addendum: add `cask "zed"` so both Macs converge on
        cask-managed Zed (see §Pass 5 air-side completion → Brewfile
        note).
      - `README.md` whitespace.
      - VERIFICATION GATE: receiving Mac → worktree pull → danger
        check → main pull → both Macs confirm `git -C ~/dev/adadapted
        config user.email` returns work email, `git -C ~/anywhere-else
        config user.email` returns personal email, shells open clean,
        `brew bundle check` passes. **Pro's main-checkout advance still
        deferred until Pass 3** — Pass 2 verification on pro happens
        in the worktree; main stays on `snapshot/macbook-pro`.
- [ ] **Pass 3 — `.zshrc` + `.p10k.zsh`** (medium-risk: shell startup)
      - 107-line `.zshrc` divergence per Mac vs master. Per-block
        canonical decisions: pyenv init flag, plugin list,
        `codex-inline` alias, `theme()` function (depends on Pass 0's
        dynamic profiles), fzf init, anything else surfacing in
        Pass 1.5's diff dive.
      - `.p10k.zsh` (Powerlevel10k prompt config, tracked + live-
        symlinked on air): per-Mac diff + canonical decision. Tightly
        coupled to `.zshrc` so grouped here.
      - VERIFICATION GATE: receiving Mac protocol + open fresh shell
        on each Mac, confirm no startup errors, prompt renders
        correctly (p10k), `theme()` swaps profiles on pro.
- [ ] **Pass 4 — Karabiner** (highest-risk: keyboard remapping)
      - **Investigation first** (in Pass 1.5 or as Pass 4's opening
        step): macbook-air's −500-line cut vs master is asymmetric
        with macbook-pro's 36-line diff. Determine whether air's cut
        was intentional pruning or a corruption/sync artifact, before
        any canonical decision.
      - **Section-by-section review** with Dan on what to keep —
        karabiner.json has discrete `complex_modifications` blocks
        that can be assessed individually.
      - VERIFICATION GATE: receiving Mac runs selective live test in
        worktree FIRST (`ln -sf <worktree>/karabiner/karabiner.json
        ~/.config/karabiner/karabiner.json`, karabiner reloads
        automatically on file change, test key remap behavior, revert
        symlink if broken). Only then advance main. Karabiner's
        `automatic_backups/` is an additional fallback alongside
        `snapshot/<host>`.
- [~] **Pass 5 — Editor & tool config** (air-side DONE 2026-05-25;
      pro-side adoption pending; fzf still TBD)
      - `zed/keymap.json`, `zed/settings.json`: ✅ **air-side landed as
        `zed/` in repo + symlinks.** Canonical was OVERHAULED from the
        original "adopt pro's tiny version" plan to mirror Dan's VS Code
        setup (theme **One Dark**, JetBrains Mono 15, Ruff+pyright for
        Python, per-language `format_on_save`, terminal dock right,
        `opt`→`alt` keymap fix, `cmd-t`→file_finder in Workspace context
        for Zed 1.3's default swap). See §Pass 5 air-side completion
        below for details + pro-side adoption steps.
      - `fzf/` subdir vs root `.fzf.zsh` (already gitignored at root):
        canonical location for fzf init shell loader. **Still pending.**
      - Anything else surfaced in Pass 1.5.
      - VERIFICATION GATE: receiving Mac protocol per file.
- [ ] **Pass 6 — Claude Code config in repo** (deferred to end)
      - Bring `~/.claude/CLAUDE.md`, `settings.json`, `keybindings.json`,
        `statusline-command.sh`, `skills/` into repo at `claude/`
        via **selective symlinks** from `~/.claude/<thing>` →
        `~/dev/dotfiles/claude/<thing>`. Care: `~/.claude/` already
        contains per-machine state (projects/, todos/, shell-snapshots/)
        that must NOT be symlinked — only the config files Dan curates.
      - Decide what's shared (e.g., `CLAUDE.md`, `settings.json`,
        `skills/`) vs per-host (`*.local.json` already gitignored).
      - VERIFICATION GATE: receiving Mac protocol + confirm Claude
        sessions start cleanly with new symlinks in place.
- [ ] **Pass 7 — README modernization & upkeep** (the "separate later
      cleanup pass" deferred from Pass 2 — see §Pass 2 `README.md` analysis)
      - `README.md` is stale WIP: wrong clone path (`~/.dotfiles` vs the
        real `~/dev/dotfiles`), outdated symlink list, and "High-level
        todos" this project has already resolved (oh-my-zsh / fzf / iterm
        portability).
      - Rewrite to document the aligned end-state: correct setup steps, the
        actual symlink set (from `manifests/symlinks-<host>.txt`), the
        per-host `*.local` override mechanism (#2), and editor config (Zed
        is now Homebrew-managed; Pass 5 `zed/` config — see Claude memory
        [[pass5-zed-vscode-align]]).
      - Treat README as a LIVING doc: refresh it as each pass lands so it
        never drifts again; do a final accuracy pass at merge time.
      - **Portability lint** (per username-portability decision):
        ship `scripts/check-portability.sh` that greps the repo for
        `/Users/dan/` and `/Users/dseely/`, skipping the documented
        exceptions (`manifests/`, `.zshrc-backup-24-jan-2022`,
        `archived/`, `snapshot/`, plus NOTES/README which may carry
        example paths). Exits non-zero on hits. Optionally wired as
        a pre-commit hook via `.git/hooks/pre-commit` or
        `core.hooksPath`. Run it as a project-end gate before the
        single merge to master.
      - VERIFICATION GATE: README's documented symlinks/steps match reality
        on BOTH Macs; portability lint exits 0 on both Macs.
- [ ] **Final — Merge `align/cleanup` → `master`** in one commit,
      after all passes verified green on both Macs.
      - Delete `snapshot/macbook-air`, `snapshot/macbook-pro`.
      - Delete `NOTES.md`.
      - `manifests/`: decide at merge time — keep as setup reference
        or delete with NOTES.
      - Tag known-good state (e.g., `aligned-2026-05`).

## Pass 1.5 analysis (air-side DONE 2026-05-23; pro-side DONE 2026-05-26 with main-advance deferred to Pass 3)

### Symlink manifest — macbook-air (7 entries)

Generated `manifests/symlinks-MacBook-Air.txt`. Live symlinks from
home into the repo:

```
~/.config/karabiner -> ~/dev/dotfiles/karabiner        (DIRECTORY symlink)
~/.fzf.zsh          -> ~/dev/dotfiles/.fzf.zsh         (file; repo file is gitignored)
~/.gitconfig        -> ~/dev/dotfiles/.gitconfig
~/.oh-my-zsh        -> ~/dev/dotfiles/.oh-my-zsh       (gitignored long-term)
~/.p10k.zsh         -> ~/dev/dotfiles/.p10k.zsh
~/.zprofile         -> ~/dev/dotfiles/zsh/.zprofile
~/.zshrc            -> ~/dev/dotfiles/zsh/.zshrc
```

**Scope-affecting findings**:

1. **`.p10k.zsh` is in scope but was missing from the pass plan.**
   Tracked in repo (9875 bytes, Aug 2023), live-symlinked. Powerlevel10k
   theme config. Needs cross-Mac canonical decision. **Add to Pass 3
   (.zshrc-adjacent) or its own bullet under Pass 2.**

2. **`~/.config/karabiner` is a DIRECTORY-level symlink**, not a file
   symlink for karabiner.json specifically. Implication: karabiner.app
   writes its `automatic_backups/` directly into the repo dir (already
   handled by Pass 1's gitignore). Also: changes to repo's
   `karabiner/karabiner.json` propagate to karabiner.app instantly via
   the dir symlink. This makes Pass 4's "selective live test"
   trickier — the standard `ln -sf <worktree>/...` trick at the
   karabiner.json level won't work because the parent dir is already
   a symlink. Test instead by temporarily re-pointing the WHOLE
   directory symlink: `ln -sfn ~/dev/dotfiles-align/karabiner ~/.config/karabiner`,
   karabiner reloads, revert if broken. Update Pass 4 verification
   notes to reflect.

3. **`.bash_profile` is tracked (4428 bytes) but NO `~/.bash_profile`
   symlink exists** — it's an orphan in the repo. Decisions log says
   "keep" but that decision predated this discovery. **DECISION:
   hold pending macbook-pro's manifest.** If pro also has no live
   symlink, candidate for `archived/.bash_profile` (graveyard pattern,
   see Decisions log) rather than active deletion. If pro DOES have
   a live symlink, restore it on air.

4. **`~/.bashrc` is a regular file on this Mac**, not from repo:
   contains `[ -f ~/.fzf.bash ] && source ~/.fzf.bash`. fzf-installed.
   Out of repo scope, but worth noting macbook-pro might have a
   different bashrc state.

5. **`~/.zshenv` is a regular file** on macbook-air (not symlink, not
   from repo). Macbook-pro had `zsh/.zshenv` in its snapshot as a
   *repo-tracked* addition. Pass 2 needs to decide whether air adopts
   pro's `.zshenv` (and creates the symlink) or pro's is dropped.

6. **`.fzf.zsh` inconsistency confirmed**: macbook-air has live
   symlink `~/.fzf.zsh → ~/dev/dotfiles/.fzf.zsh`, but the file at
   that path is **gitignored** as of Pass 1. So the symlink target
   exists on this Mac's disk only as long as no one removes the
   gitignored file. Macbook-pro has `fzf/.fzf.zsh` in a subdir
   (tracked). **Pass 5's fzf canonical decision must pick:** revive
   tracking at root, move to `fzf/` subdir (pro's pattern), or
   un-track entirely and let fzf installer manage it.

### Diff dive — Pass 2 scope (2026-05-22)

#### `.gitconfig`

**Master state** (relevant fields):
- `[user] email = dseely@adadapted.com` (work)
- `signingkey = ssh-ed25519 AAAAC3...` (public half of SSH signing key — not a secret)
- `[gpg] format = ssh`, `[gpg "ssh"] program = /Applications/1Password.app/.../op-ssh-sign`
- `[commit] gpgsign = true`
- `[includeIf "gitdir:~/dev/adadapted/"] path = ~/dev/adadapted/.gitconfig`
  (external file, NOT in repo — currently INERT on macbook-air:
  `~/dev/adadapted/` dir exists but no `.gitconfig` inside)
- `[core] excludesfile = /Users/dan/.gitignore_global` (dangling: file
  does NOT exist on macbook-air; git silently no-ops the missing path)

**macbook-air diff**:
- Email: `dseely@adadapted.com` → `dan@danseely.net` ✓ matches the
  end-state we want.
- Adds `[credential "https://github.com"]` and `[credential "https://gist.github.com"]`
  blocks with `gh auth git-credential` helper — standard output of
  `gh auth setup-git`.

**macbook-pro diff**:
- Email: unchanged (still `dseely@adadapted.com` — work-only Mac so
  no urgency to flip historically, but Pass 2 will flip it).
- Same gh credential helper blocks (identical to air).
- Cosmetic noise: `{$HOME}` brace syntax replacing absolute paths in
  `excludesfile` and `[commit] template`. **`{$HOME}` is NOT valid
  git config syntax** — git supports `~/` and absolute paths only,
  not brace expansion. These edits silently break those config keys
  on pro (excludesfile and stCommitMsg refs become literal `{$HOME}/...`
  paths that don't resolve). Looks like editor auto-touch (JetBrains
  template-style?). **Drop these changes.**
- Cosmetic noise: trailing whitespace stripped on `path = ` line; tab
  → 4-space indent on one `[gpg] format = ssh` line. Drop these too.

**Secrets scan**: signingkey is the **public** half (`ssh-ed25519 AAAAC3...`
prefix is the public-key format). 1Password's `op-ssh-sign` holds
the private key. Safe to commit. No tokens or passwords in any
diff. ✓ clean.

**Proposed canonical** (Pass 2 work):
```
[user]
    name = Dan Seely
    email = dan@danseely.net
    signingkey = ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqOHWqaDcvrbxJZBsMlHl+pZq+u9SD+HvqCQGJW3s7Y

[core]
    editor = vim
    excludesfile = ~/.gitignore_global   # use ~ not absolute — portable + host-agnostic

[includeIf "gitdir:~/dev/adadapted/"]
    path = ~/dev/dotfiles/gitconfig/adadapted   # repo-internal, replaces old external ref

[credential "https://github.com"]
    helper =
    helper = !/opt/homebrew/bin/gh auth git-credential

[credential "https://gist.github.com"]
    helper =
    helper = !/opt/homebrew/bin/gh auth git-credential
```
…plus all other existing master sections (`[filter "lfs"]`, `[pull]`,
sourcetree, `[commit]`, `[init]`, `[gpg]`, etc.) unchanged.

New file `gitconfig/adadapted` (3 lines, repo-tracked):
```
[user]
    email = dseely@adadapted.com
```

**Open follow-ups for Pass 2**:
- The old external `~/dev/adadapted/.gitconfig` file (referenced by
  master) doesn't exist on air; if it exists on pro it can be
  deleted post-Pass-2 (inert once we re-point includeIf into repo).
- `~/.gitignore_global` is referenced but missing on air. Either
  create the file with sensible content (.DS_Store, etc.) — could
  be Pass 5 — or remove the reference. **Defer to Pass 5.**

#### `zsh/.zprofile`

**Master**: 11 lines, Poetry/Pyenv/GPG env exports. No Homebrew.

**Both Macs**: append the same `eval "$(/opt/homebrew/bin/brew shellenv)"`.
Functionally identical; cosmetic comment-case difference (`# Homebrew`
vs `# homebrew`).

**Proposed canonical**:
```
# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
```
Pick capitalized comment.

#### `zsh/.zshenv`

**Master**: file does not exist.
**macbook-air**: not present (regular file at `~/.zshenv` per Pass 1.5
manifest probe — but `zsh/.zshenv` in repo doesn't exist on air either).
**macbook-pro**: adds new file at `zsh/.zshenv`:
```
. "$HOME/.cargo/env"
```

**macbook-air cargo check**: Rust IS installed (`~/.cargo/env` exists,
`cargo` and `rustc` resolve in PATH). Adoption is safe.

**Proposed canonical**: adopt pro's, with `[ -f ]` guard for safety
(file might not exist on a fresh clone before rustup runs):
```
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
```
Pass 2 work also includes setting up the `~/.zshenv → zsh/.zshenv`
symlink on macbook-air (currently a regular non-repo file at `~/.zshenv`
— investigate its content before clobbering, in case there's anything
worth preserving in `archived/`).

#### `Brewfile`

**Master**: 67-line Brewfile with taps/brews/casks/mas.
**macbook-air**: no diff (file not touched).
**macbook-pro** diff:
- `+cask 'keyboard-cleaner'` (lockscreen tool for keyboard wipe-down)
- `mas 'XCode', id: 497799835` → commented out (XCode via mas-cli is
  flaky; common workaround is to install manually)

**Proposed canonical**: adopt pro's changes verbatim. Both are
harmless on air (keyboard-cleaner gets installed; XCode line stays
commented). Identical-on-both-Macs achieved.

#### `README.md`

**macbook-air**: adds two trailing spaces to one line — noise from
editor/linter. Discard.

**macbook-pro**: substantive reorganization of "High-level todos"
section, adds "Automate installs" and "Changes" sections. Actual
content change.

**Proposed canonical**: adopt pro's diff. Discard air's whitespace.
Optional: also update the README's symlink list with the current
manifest contents (since `.iterm` is gone, `.zprofile`, `.config/karabiner`,
`.oh-my-zsh`, `.p10k.zsh`, `.fzf.zsh` should be there). **Defer
README content modernization to a separate later cleanup pass — not
in Pass 2 scope.**

### Secrets scan — done for Pass 2 files (2026-05-22)

No secrets in scope. `.gitconfig` signingkey is the public half of an
ed25519 SSH key (private half lives in 1Password). No tokens, no
inline passwords, no `.netrc`-style URLs with auth. Pass 3+ files
(`.zshrc`, `.p10k.zsh`, etc.) still to scan.

### Pass 2 canonical — APPROVED (Dan, 2026-05-22)

All five files' canonical proposals approved:
- `.gitconfig`: air's diff wins; pro's `{$HOME}` brace edits + cosmetic
  noise dropped.
- `zsh/.zprofile`: capitalized `# Homebrew` comment.
- `zsh/.zshenv`: pro's content with `[ -f ]` guard.
- `Brewfile`: pro's two changes verbatim.
- `README.md`: pro's todos reorg; air's whitespace discarded.
- `~/.gitignore_global` dangling ref → Pass 5 (create file with
  sensible content like `.DS_Store`).
- Old external `~/dev/adadapted/.gitconfig`: delete post-Pass-2 on pro,
  **conditional on first verifying its content has nothing else worth
  preserving** (likely just `email = dseely@adadapted.com` which is
  now covered by the new repo override). Pro to confirm-and-delete
  as part of Pass 2 verification.

### `~/.zshenv` content investigation — RESOLVED (2026-05-22)

`~/.zshenv` on macbook-air = regular file, 21 bytes, dated Jun 29 2023.
Content: `. "$HOME/.cargo/env"` (single line, no newline at end).

Same content as pro's tracked `zsh/.zshenv`. Auto-created by rustup
installer on both Macs at install time. Replacing air's regular file
with `~/.zshenv → ~/dev/dotfiles/zsh/.zshenv` symlink is **content-
preserving** — nothing to archive.

Pass 2 work plan for `.zshenv` on air: `rm ~/.zshenv && ln -s
~/dev/dotfiles/zsh/.zshenv ~/.zshenv`. (After the repo file is
committed with the `[ -f ]` guard.)

### Pass 2 authored — DONE 2026-05-26 (in pro worktree)

All five originally-scoped files + the three username-portability
files landed on `align/cleanup`. Authored from pro's worktree
(`~/dev/dotfiles-align`); pro main + air main NOT advanced — air
verifies in its own session and decides when to flip its main.

**Files landed:**

| File | Change |
|---|---|
| `.gitconfig` | email → `dan@danseely.net`; `excludesfile` → `~/.gitignore_global`; `commit.template` → `~/.stCommitMsg`; includeIf path → `~/dev/dotfiles/gitconfig/adadapted`; gh credential helper blocks for github.com + gist.github.com; comments updated for repo-internal include |
| `gitconfig/adadapted` (NEW) | 3-line work-email override: `[user] email = dseely@adadapted.com` |
| `zsh/.zprofile` | append `# Homebrew\neval "$(/opt/homebrew/bin/brew shellenv)"` |
| `zsh/.zshenv` (NEW) | `[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"` (guard for fresh-clone safety) |
| `.bash_profile` | gcloud `source` lines: `/Users/dan/dev/google-cloud-sdk/...` → `"$HOME/dev/google-cloud-sdk/..."` (per username-portability) |
| `osx.sh` | brew shellenv `>>` target: `/Users/dan/.zprofile` → `"$HOME/.zprofile"` (per username-portability) |
| `Brewfile` | `+cask 'keyboard-cleaner'`, `+cask 'zed'` (Pass 5 addendum), comment out `mas 'XCode'` |

**Functional regression pre-flight** (per §Hardened verification
protocol step 3 — using `GIT_CONFIG_GLOBAL` + ad-hoc git repos to
exercise `.gitconfig` and `ZDOTDIR`/direct-source to exercise
`.zprofile`/`.zshenv` against the worktree, NOT live):

- **`.gitconfig` outside `~/dev/adadapted/`**: `user.email`
  resolves to `dan@danseely.net` ✅
- **`.gitconfig` inside `~/dev/adadapted/`**: `user.email`
  resolves to `dseely@adadapted.com` via the includeIf →
  `gitconfig/adadapted` chain ✅
- Other config keys resolve to portable paths:
  `commit.template = ~/.stCommitMsg`,
  `core.excludesfile = ~/.gitignore_global`,
  `user.signingkey` = ed25519 public key (unchanged).
- **`.zprofile`**: sourcing the worktree file populates PATH with
  `/opt/homebrew/bin` + `/opt/homebrew/sbin` and `PYENV_ROOT` ✅
- **`.zshenv`**: `[ -f ]` guard correctly skips when `~/.cargo/env`
  is absent (pro's case — exit=1 from the test) ✅
- Audit: `grep -nH "/Users/dan\|/Users/dseely"` on the 7 authored
  files returns ZERO hits ✅

**Pre-flight caveat noted**: testing `.gitconfig`'s includeIf
requires the path `~/dev/dotfiles/gitconfig/adadapted` to be
reachable. With pro's main still on `snapshot/macbook-pro` (which
doesn't have the `gitconfig/` subdir), the file isn't yet at the
expected live location. The pre-flight worked around this by
temporarily symlinking `~/dev/dotfiles/gitconfig` →
`~/dev/dotfiles-align/gitconfig` during the test. Once pro's main
advances to `align/cleanup` (post-Pass-3), the symlink is no longer
needed and the real path resolves natively.

**Air verification — pending air session.** Air's main IS on
`master` (or wherever air put it post-Pass-1 verification). Air
needs to: (a) pull `align/cleanup` into its worktree, (b) danger
check, (c) functional pre-flight on `.gitconfig` includeIf using
air's worktree path (`GIT_CONFIG_GLOBAL=~/dev/dotfiles-align/.gitconfig`
inside `~/dev/adadapted/<test-repo>` — assuming air has a
`~/dev/adadapted/` dir; if not, the test exercise can skip), (d)
advance main, (e) confirm `git config user.email` returns the right
value inside vs outside `~/dev/adadapted/`. README.md whitespace from
air's pre-Pass-1 working tree is irrelevant to canonical — Pass 7
will modernize the file.

**Pro main-advance still deferred** to Pass 3 (interactive-shell
breakage in `zsh/.zshrc:12` until Pass 3 lands `$HOME/.oh-my-zsh`).
Pass 2 doesn't unblock pro; that's Pass 3's job.

**Old external `~/dev/adadapted/.gitconfig`**: Pass 2's canonical
includeIf no longer references it (now points at
`~/dev/dotfiles/gitconfig/adadapted` in-repo). If the old file
exists anywhere, it's inert. Pro doesn't have `~/dev/adadapted/`
populated; air to verify and (if file exists) `cat` it for any
content beyond `email = dseely@adadapted.com` then archive or delete.

### Diff dive — Pass 3 scope (2026-05-22)

#### `.p10k.zsh`

Both Macs' snapshots have **zero diff** vs master — file is byte-
identical everywhere. Live-symlinked on air per Pass 1.5 manifest.
**No canonical decision needed.** Pass 3 work: confirm pro also has
`~/.p10k.zsh` symlinked (or set up the symlink there if not), then
ship as-is.

#### `zsh/.zshrc` — analysis

**Master**: 172 lines. Stock p10k+oh-my-zsh, pyenv, poetry, lots of
2023-era stale stuff (PHP 7.4, vagrant alias, hardcoded
`/Users/dan/google-cloud-sdk/`).

**macbook-air diff** (12 lines, small):
1. **pyenv PATH**: adds `$PYENV_ROOT` to the PATH alongside
   `$PYENV_ROOT/bin`. Old line commented out.
2. **plugins**: adds `history-substring-search` to oh-my-zsh plugins.
3. **codex-inline alias**: `alias codex-inline='command codex --no-alt-screen'`
   — Codex CLI defaults to alt-screen mode which clears visible history
   in iTerm2; this alias runs it in inline mode.
4. **pyenv init**: switches `eval "$(pyenv init --path)"` to
   `eval "$(pyenv init -)"` (older `--path` line commented out).

**macbook-pro diff** (107 lines, dense):
1. **VS Code / Cursor agent guard** at file top (~12 lines): early
   `return` if `$PAGER` looks like a Cursor agent's PAGER. References
   Cursor forum post. Prevents agent terminal hangs.
2. **`export ZSH="/Users/dan/.oh-my-zsh"` → `"$HOME/.oh-my-zsh"`**: portability fix.
3. **pyenv**: replaces master's PATH line with `[[ -d $PYENV_ROOT/bin ]]
   && export PATH=...`, adds BOTH `eval "$(pyenv init --path)"` AND
   `eval "$(pyenv init -)"` at top. Removes the old eval at file
   bottom. **Matches pyenv docs' current recommendation** (both inits).
4. **poetry**: adds a `# or this?` commented alternative (noise; drop).
5. **plugins**: drops `zsh-nvm` (replaced with manual NVM lazy-load).
   Does NOT add `history-substring-search` (air's addition).
6. **Moves Google Cloud SDK source lines** from before pyenv init
   to after LDFLAGS. Hardcoded path is `/Users/dseely/google-cloud-sdk/`
   — work username, **NOT portable to air**.
7. **rbenv** commented-out line `# eval "$(rbenv init - zsh)"` —
   inactive; drop.
8. **iTerm2 shell integration**:
   `test -e "${HOME}/.iterm2_shell_integration.zsh" && source ...`
   — guarded source; safe on either Mac (no-op if file missing).
9. **Antigravity PATH**: `export PATH="/Users/dseely/.antigravity/antigravity/bin:$PATH"`
   — hardcoded work username, no guard. **Drop in canonical** (tool
   installer can re-add per Mac if Dan ever installs Antigravity on
   air; not dotfiles' job).
10. **NVM manual lazy-load**:
    ```
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    ```
    Replaces zsh-nvm plugin. **Adopt — both file-guarded, NVM is
    installed on air (`~/.nvm/` confirmed).**
11. **`theme()` function** (~60 lines): OSC 1337 SetProfile + iTerm2
    Python API hybrid. Depends on `iterm/DynamicProfiles/dan.json`
    (already in repo from Pass 0 pro work). **Adopt verbatim.** Works
    on air once the dynamic profile file gets symlinked into
    `~/Library/Application Support/iTerm2/DynamicProfiles/` (separate
    Pass 0 air-side step or post-merge cleanup).

**Air-side install state** (relevant to canonical decisions):
- `~/google-cloud-sdk` MISSING → gcloud lines harmlessly no-op via
  `[ -f ... ]` guards already in source.
- `~/.nvm` EXISTS → manual NVM lazy-load works on air.
- `~/.iterm2_shell_integration.zsh` MISSING → guarded source no-ops
  cleanly until installed.
- `~/.antigravity` MISSING → drop Antigravity PATH (don't ship dead refs).
- VS Code installed; Cursor not. The agent-guard preamble is harmless
  either way.

**Proposed canonical `.zshrc` structure** (high level — full file
written in Pass 3 itself):

1. **Top**: pro's Cursor/VS Code agent guard verbatim.
2. **p10k instant prompt** block: unchanged from master.
3. **PATH exports**: unchanged from master.
4. **`export ZSH="$HOME/.oh-my-zsh"`** (pro's portability fix).
5. **pyenv block**: pro's version — conditional PATH, both eval lines
   at top.
6. **poetry, theme, etc.**: master shape, no `# or this?` noise.
7. **plugins**: `(git docker docker-compose z history-substring-search)`
   — pro's drop of zsh-nvm + air's add of history-substring-search.
8. **oh-my-zsh source**: unchanged.
9. **aliases**: master + air's `codex-inline` alias.
10. **Google Cloud SDK source**: use `$HOME/google-cloud-sdk/...`
    (universal path), keep `[ -f ... ]` guards. Pro's "moved to after
    LDFLAGS" placement is fine; could leave at master's location too.
    **Defer placement to Dan's preference.**
11. **LDFLAGS / CPPFLAGS / PHP 7.4 PATH lines**: flag as stale
    2023-era cruft. **Candidate for removal or `archived/`. Defer
    Dan decision.**
12. **iTerm2 shell integration source**: pro's guarded line, adopt.
13. **NVM lazy-load**: pro's three lines, adopt.
14. **`theme()` function**: pro's full implementation, adopt verbatim.
15. **Antigravity PATH**: dropped.
16. **rbenv commented line**: dropped.
17. **gcloud paths**: `$HOME/` not `/Users/dan/` or `/Users/dseely/`.

**Pass 3 decisions — APPROVED (Dan, 2026-05-22)**:
- a) **Keep all 2023-era stale lines as-is** in canonical `.zshrc`.
  Deal with archive/remove later (separate cleanup pass after merge).
- b) **gcloud source placement: pro's** (after LDFLAGS/CPPFLAGS).
- c) **Install dynamic profiles on air in Pass 3.** `theme()` works
  on both Macs after Pass 3 lands. Implementation: symlink
  `~/Library/Application Support/iTerm2/DynamicProfiles/dan.json`
  → `~/dev/dotfiles/iterm/DynamicProfiles/dan.json` on air. Same
  pattern pro will follow post-merge (its DEFERRED Phase 2 step
  in Pass 0).

**Secrets scan — `.zshrc`**: no tokens, no inline passwords, no
auth URLs. Comment references to `aws-auth.sh` are an external script
that handles MFA — script isn't in repo. ✓ clean.

### Diff dive — Pass 4 scope: `karabiner/karabiner.json` (2026-05-22)

**The "−500-line cut" mystery resolved.** Master is 1225 lines /
50KB; both Macs are ~830 lines / ~37KB. **The bulk of the drop is
Karabiner's serializer omitting default-valued fields** when it
re-writes the file (it strips `is_pointing_device: false`,
`ignore: false`, and other default-equal fields that don't need
explicit storage). Not a content cut.

Structural check across all three refs:
- All three have 1 profile (`Default`), selected, with **19 complex
  modification rules — identical names**.
- 18 of 19 rule bodies are byte-identical across master/air/pro.
  Only **rule [1]** differs (see below).
- `fn_function_keys`: 12 entries, byte-identical across all three.

**What actually changed (semantic-level):**

1. **`global` key removed on both Macs** (master had
   `check_for_updates_on_startup`, `show_in_menu_bar`,
   `show_profile_name_in_menu_bar`). UI prefs — harmless, defaults
   apply when missing.
2. **`profile.parameters` removed on both Macs** (master had
   `delay_milliseconds_before_open_device: 1000`). Reverts to
   Karabiner default.
3. **`complex_modifications.parameters` removed on both Macs**
   (master had 5 timing params: simultaneous_threshold, to_delayed_
   action_delay, to_if_alone_timeout, to_if_held_down_threshold,
   mouse_motion_to_scroll.speed). Reverts to defaults.
4. **`devices`** — per-machine hardware list. Master had 15 devices;
   air has 20 (5 more — devices added over time as new keyboards/mice
   plugged in), pro has 18 (3 more than master, 2 fewer than air).
   **Karabiner auto-populates `devices` at runtime** as it
   encounters new hardware. **Treat as ignored-for-canonical** — both
   Macs will re-append their own hardware. No `*.local` mechanism
   needed; Karabiner handles divergence itself.
5. **`virtual_hid_keyboard`** — schema migrated. Master has
   `country_code`, `indicate_sticky_modifier_keys_state`,
   `mouse_key_xy_scale`; both Macs added `keyboard_type_v2: ansi`
   (Karabiner's newer schema). Pro's is the most-compact (just
   `caps_lock_delay_milliseconds`, `keyboard_type`, `keyboard_type_v2`).
   **Adopt pro's compact form** — it matches Karabiner's current
   default-omission style.
6. **`simple_modifications`** — all three share `caps_lock →
   right_control`. **Air alone adds**:
   ```
   f5 → apple_vendor_top_case_key_code: illumination_down
   f6 → apple_vendor_top_case_key_code: illumination_up
   ```
   Backlight key remaps that make sense on Air's built-in keyboard.
   On pro's keyboard (probably external) the source `f5`/`f6` keys
   don't conflict with illumination handling, so these remaps would
   be **inert no-ops on pro**. **Safe to canonicalize on both Macs.**
7. **Rule [1] divergence** (only rule that differs across the three):
   - Rule description: "Change right option to Hyper (i.e.,
     command+control+option+shift)"
   - **master + air**: rule is **enabled** (no `enabled` key —
     defaults to true).
   - **pro**: rule has `"enabled": false`.
   - One-line diff: pro adds `"enabled": false`. **Decision needed.**

**Asymmetry investigation conclusion**: NOT a corruption or sync
artifact. The cut is mostly Karabiner's serializer normalizing
default values out. The two genuine cross-Mac decisions are tiny:
rule [1] enabled-or-not, and adopt-pro's compact `virtual_hid_keyboard`.

**Proposed canonical** (Pass 4 work):
- Adopt the compact pro-style file as a base (drop default-equal
  fields the way Karabiner does).
- 19 complex modification rules: keep all 19, bodies as-is.
- **Rule [1] (right_option → Hyper)**: decision pending — Dan needs
  to confirm enabled or disabled.
- `simple_modifications`: caps_lock + f5/f6 (air's superset). Inert
  on pro's keyboard, useful on air's.
- `virtual_hid_keyboard`: pro's compact form
  (`caps_lock_delay_milliseconds: 0`, `keyboard_type: ansi`,
  `keyboard_type_v2: ansi`).
- `devices`: leave whatever's in the repo; Karabiner will auto-append
  each Mac's hardware at runtime. **No reconciliation needed.**
- `global`, `profile.parameters`, `complex_modifications.parameters`:
  omit (defaults apply).

**Verification gate (Pass 4)** updated based on Pass 1.5 manifest
finding: `~/.config/karabiner` is a directory-level symlink, so
selective-live-test cannot just re-point `karabiner.json`. Re-point
the whole dir:
```
ln -sfn ~/dev/dotfiles-align/karabiner ~/.config/karabiner
```
Karabiner reloads automatically on file change. Revert with same
command back to main checkout if remap behavior breaks.

**Rule [1] decision — APPROVED (Dan, 2026-05-23)**: **disabled.**
Canonical karabiner.json carries rule [1] "right_option → Hyper"
with `"enabled": false` (pro's state).

**Secrets scan — karabiner.json**: pure config, no secrets. ✓ clean.

### Diff dive — Pass 5 scope (2026-05-23)

#### `zed/keymap.json`, `zed/settings.json`

**Tracked in repo (pro-only addition)**: pro committed both files at
`zed/keymap.json` and `zed/settings.json` in its snapshot. Air had no
tracked Zed config.

**Live state on air**:
- Zed IS installed (`/Applications/Zed.app`, `~/.config/zed/`).
- Air has its OWN `~/.config/zed/keymap.json` (381 bytes) and
  `~/.config/zed/settings.json` (528 bytes) — regular files, not from
  repo.

**Diff: air's local vs pro's tracked**:
- `keymap.json`: **byte-identical**. Both Macs converged on the same
  keybindings independently.
- `settings.json`: **1 line differs** —
  ```
  air:  // "dock": "right",    (commented out — terminal floats)
  pro:     "dock": "right",    (active — terminal docked to right)
  ```
  Otherwise identical (font size 15, autosave 1s, JetBrains Mono,
  terminal blinking off).

**Proposed canonical**:
- Adopt pro's tracked versions in repo at `zed/keymap.json` and
  `zed/settings.json`.
- For `settings.json`'s terminal dock: **decision needed** —
  active "dock: right" (pro's) or commented out / floating (air's)?
- Air-side Pass 5 work:
  1. Move air's existing `~/.config/zed/{keymap,settings}.json` to
     `archived/zed-macbook-air-prepass/` (honor LOSE-NO-DATA — they
     match the repo versions ± the one dock line anyway, so they
     might just be deleted, but archive first per the graveyard
     pattern).
  2. `ln -s ~/dev/dotfiles/zed/keymap.json ~/.config/zed/keymap.json`
  3. `ln -s ~/dev/dotfiles/zed/settings.json ~/.config/zed/settings.json`

**Side observation** (not Pass 5 scope, just noted): air's
`~/.config/zed/` also has `.tmp0gtP7h` (5KB), `.tmpMKF2gP` (122KB),
`conversations/`, `embeddings/` — Zed's runtime state, not config.
Leave alone.

#### `fzf/.fzf.bash`, `fzf/.fzf.zsh`

**Tracked in repo (pro-only addition)**: pro added at `fzf/.fzf.bash`
and `fzf/.fzf.zsh`. Air has nothing tracked in `fzf/`; air has a
**gitignored** `.fzf.zsh` at repo root with old-style content.

**Content comparison**:
- **Pro's `fzf/.fzf.zsh`** (modern, 6 lines):
  ```
  if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
    PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
  fi
  source <(fzf --zsh)
  ```
  Uses `fzf --zsh` (fzf v0.48+ command) — single-source-of-truth from
  fzf itself, auto-includes completion + key-bindings.
- **Air's gitignored root `.fzf.zsh`** (old style, ~11 lines): manually
  sources `/opt/homebrew/opt/fzf/shell/completion.zsh` and
  `key-bindings.zsh`. Pre-`fzf --zsh` approach. Functionally
  equivalent but more boilerplate.
- **Pro's `fzf/.fzf.bash`**: same modern pattern with `fzf --bash`.

**Loading mechanism**: all three `.zshrc` versions have
`[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh` (master line 150, air line
154, pro line 171). So the symlink target at `~/.fzf.zsh` is what
loads. No `.zshrc` changes needed in Pass 5 for fzf.

**Proposed canonical**:
- Adopt pro's modern `fzf/.fzf.{bash,zsh}` in repo (tracked).
- Air-side Pass 5 work:
  1. Move repo root `.fzf.zsh` (old-style, gitignored, ~341 bytes,
     dated Aug 2023) to `archived/.fzf.zsh` per graveyard pattern.
  2. Update `~/.fzf.zsh` symlink: previously
     `~/.fzf.zsh → ~/dev/dotfiles/.fzf.zsh` (the old file we just
     archived); change to `~/.fzf.zsh → ~/dev/dotfiles/fzf/.fzf.zsh`.
  3. Update `.gitignore`: remove the `.fzf.zsh` line at root (file
     no longer present there).
- Pro-side Pass 5 work: confirm pro's `~/.fzf.zsh` symlink points at
  the in-repo `fzf/.fzf.zsh` (likely already does per pro's manifest,
  TBD).

**Zed dock decision — APPROVED (Dan, 2026-05-23)**: **pro's setting**
— `"dock": "right"` active (terminal docked right). Canonical
`zed/settings.json` = pro's tracked version verbatim.

**Secrets scan — Pass 5 files**: pure config; no secrets. ✓ clean.

### Pass 5 air-side completion — DONE 2026-05-25

The original Pass 5 plan (adopt pro's minimal tracked config; archive
air's existing files; symlink) was **superseded** in-session. Live air
`~/.config/zed/{settings,keymap}.json` was overhauled to mirror Dan's
VS Code setup; that overhauled config is now the Pass 5 canonical.

**What landed (this commit):**
- `zed/settings.json`, `zed/keymap.json` — verbatim copies of the
  overhauled live air files.
- `archived/zed-macbook-air-prepass/{settings,keymap}.json` — air's
  pre-overhaul originals (LOSE-NO-DATA graveyard).
- Air's `~/.config/zed/{settings,keymap}.json` now SYMLINK into
  `zed/`; air's symlink manifest updated.

**Decisions baked into the canonical (confirmed by Dan):**
- Theme: **One Dark** — Zed's built-in default dark theme (bundled,
  no extension). Briefly tried the Alabaster Dark extension (near-
  exact hex match to VS Code's Alabaster Dark); reverted.
- Font: **JetBrains Mono 15** (only font from VS Code's editor.fontFamily
  fallback chain actually installed on the Macs).
- Python: **Ruff** (format + lint + import-sort) + **pyright** (types);
  `preferred_line_length: 99`; `code_actions_on_save` runs
  `source.organizeImports.ruff` + `source.fixAll.ruff`.
- **No in-editor AI** (Copilot / Gemini / Tabnine not ported — Claude
  Code remains separate).
- `git.inline_blame` on (stands in for GitLens current-line blame).
- Per-language `format_on_save` only where VS Code had it (Python, PHP,
  HTML, GraphQL, Go); global stays off (matches VS Code).
- Terminal `dock: right` (the already-approved Pass 5 dock value).
- Auto-installed Zed extensions: `php`, `graphql`, `dockerfile`, `toml`.
- Keymap: `opt-*` → `alt-*` (Zed's modifier name; the old `opt-*` was
  invalid and spammed the log on launch). `cmd-t` → `file_finder::Toggle`
  MUST live in **Workspace** context, not Editor — Zed 1.3 swapped the
  defaults (`cmd-p` = file finder, `cmd-t` = project_symbols), so an
  Editor-only override leaks to the symbol finder whenever focus isn't
  in an editor.

**Runtime behavior to know about:**
- On first launch, Zed wrote panel-dock keys (`project_panel`,
  `outline_panel`, `collaboration_panel`, `agent`, `git_panel`) into
  `settings.json`. They're committed verbatim at the top of
  `zed/settings.json` — they reflect Dan's UI layout and should be fine
  on pro. If pro prefers a different layout it can override locally,
  but note: Zed re-writes `settings.json` when panel docks change, and
  since the live file is a symlink into the repo, those writes will
  produce a dirty working tree.

**Pro-side adoption (when pro takes its next baton turn):**
1. Quit Zed on pro.
2. Verify pro's Zed is current (≥ 1.3.x). If still on a standalone
   `< 1.3` app, install via `brew install --cask zed` (see Brewfile
   note below).
3. Move pro's current `~/.config/zed/{settings,keymap}.json` (its
   pre-air-canonical files) to `archived/zed-macbook-pro-prepass/`
   per the graveyard pattern.
4. Symlink into the repo:
   - `ln -s ~/dev/dotfiles/zed/settings.json ~/.config/zed/settings.json`
   - `ln -s ~/dev/dotfiles/zed/keymap.json   ~/.config/zed/keymap.json`
5. Update `manifests/symlinks-macbook-pro.txt` with the two new entries
   (sorted alphabetically by left-hand path).
6. Launch Zed on pro and verify (a) the 4 extensions auto-install,
   (b) theme "One Dark" loads (it's bundled, should be instant),
   (c) keymap loads with no `Invalid keystroke` errors in
   `~/Library/Logs/Zed/Zed.log`, (d) `cmd-t` opens the file finder.

**Brewfile note (for Pass 2 — Brewfile):** Zed on air is now installed
via Homebrew cask (replaced a broken 0.123.6 standalone with cask zed
1.3.6 on 2026-05-24). Pass 2's Brewfile reconciliation should add
`cask "zed"` so both Macs converge on cask-managed Zed.

**Cross-ref:** Claude memory [[pass5-zed-vscode-align]] captured the
in-flight state before this fold-in landed; kept as historical context.

### Legacy WIP assessment — RESOLVED (2026-05-23)

The 5 working-tree mods on macbook-air (`.gitconfig`, `README.md`,
`karabiner.json`, `.zprofile`, `.zshrc`) ARE the input to
`snapshot/macbook-air`'s commit. The diff dive above analyzed each
file's air-snapshot content against master and pro's snapshot,
producing per-file canonical proposals. **No separate "WIP
assessment" needed — the analysis IS the assessment.**

Pass 2 onwards will commit the **proposed canonical** (synthesized
from both Macs' analyses) onto `align/cleanup`, not commit air's
WIP mods as-is.

### Macbook-pro Pass 1 verification — DONE BUT ADVANCE DEFERRED 2026-05-26

**Manifest generated** at `manifests/symlinks-D6RX99KXNMAADan-Seely.txt`
(6 entries — produced by the documented `find` + `sort` heredoc with
`scutil --get LocalHostName` as the suffix). Filename is uglier than
air's `symlinks-MacBook-Air.txt` because pro's LocalHostName is
`D6RX99KXNMAADan-Seely`; cross-references to "macbook-pro" elsewhere
in NOTES point at the same file.

Pro's 6 in-repo symlinks (no Zed entries yet — that's pro's Pass 5
adoption work; no `.fzf.zsh` symlink — pro never had one, per §Hosts):

```
~/.config/karabiner -> ~/dev/dotfiles/karabiner     (DIRECTORY symlink)
~/.gitconfig        -> ~/dev/dotfiles/.gitconfig
~/.oh-my-zsh        -> ~/dev/dotfiles/.oh-my-zsh
~/.p10k.zsh         -> ~/dev/dotfiles/.p10k.zsh
~/.zprofile         -> ~/dev/dotfiles/zsh/.zprofile
~/.zshrc            -> ~/dev/dotfiles/zsh/.zshrc
```

**Danger check** (`git diff --name-only --diff-filter=D
HEAD..origin/align/cleanup`, where HEAD was `snapshot/macbook-pro`
at `9ac1d68`): 21 deletions, all benign after manifest cross-ref:

- `fzf/.fzf.bash`, `fzf/.fzf.zsh` — no `~/.fzf.zsh` symlink on pro
  (confirmed in manifest); deleting the in-repo files affects nothing
  live. Pass 5's fzf canonical decision will reintroduce them.
- `karabiner/automatic_backups/karabiner_2020*.json` (9 files) +
  `karabiner/automatic_backups/karabiner_202{4,5}*.json` (7 files) —
  historical Karabiner auto-backups. Live at
  `~/.config/karabiner/automatic_backups/` via the directory symlink,
  so they DO disappear from disk on checkout. Preserved in
  `snapshot/macbook-pro` on origin (rollback path intact). Karabiner
  continues writing new auto-backups (now gitignored per Pass 1).
- `snapshot/README.md`, `snapshot/stash@0.patch` — pro
  snapshot-branch-only artifacts. Preserved in `snapshot/macbook-pro`
  on origin; the stash entry itself also still in pro's local stash
  list (`stash@{0}: WIP on master: bf99485 feat: add setup script`).
- `zsh/.zshenv` — `~/.zshenv` does NOT exist on pro (regular file or
  symlink). Pass 2 will reintroduce a `[ -f ]`-guarded version and
  set up the symlink then.

**Main checkout advance — ATTEMPTED, ROLLED BACK** 2026-05-26. To
attempt the advance, removed the `~/dev/dotfiles-align` worktree
(git refuses to share `align/cleanup` across worktrees), then
`git checkout align/cleanup` in main. Direct checkout (not
`git pull --ff-only`) because `snapshot/macbook-pro` and
`align/cleanup` diverge by construction.

**Smoke test post-advance flagged a regression:**

```
$ zsh -l -i -c 'echo OK'
/Users/dseely/.zshrc:source:95: no such file or directory: /Users/dan/.oh-my-zsh/oh-my-zsh.sh
OK
```

`zsh/.zshrc:12` (master/align-cleanup version) hardcodes
`export ZSH="/Users/dan/.oh-my-zsh"`. Pro's home is `/Users/dseely/`,
so `source $ZSH/oh-my-zsh.sh` at line 95 fails. Shell still exits
0 (source failure is non-fatal), but oh-my-zsh doesn't load — no
p10k prompt, no plugins, no aliases on every new pro terminal.

Pro's snapshot already carries the `$HOME/.oh-my-zsh` portability
fix as a working-tree mod; Pass 3's canonical also lands it (see
§Diff dive — Pass 3 scope, item 2). Air doesn't see the regression
because air's user IS `dan`, so the hardcoded path resolves there.

**Reframed and rolled back.** Dan: this is a recurring class
("cross-Mac username drift"), not a one-off `.zshrc` bug. Added
the username-portability decision (no hardcoded `/Users/<name>/` in
tracked active config — see §Decisions log). Pass 2 + Pass 7 scope
expanded. Reverted main to `snapshot/macbook-pro` (`9ac1d68`) and
recreated the `~/dev/dotfiles-align` worktree on `align/cleanup`
(0b5280b). Pro stays in worktree-authoring pattern.

**Audit** (tracked active config with hardcoded `/Users/<name>/`,
excluding `manifests/`, `.zshrc-backup-24-jan-2022`, snapshot
branches, NOTES/README which are docs):

| File | Lines | Active impact on pro |
|---|---|---|
| `zsh/.zshrc:12` | `export ZSH="/Users/dan/.oh-my-zsh"` | **breaks oh-my-zsh load** (Pass 3 fixes) |
| `zsh/.zshrc:159,162` | gcloud `source` lines | silently no-op (gcloud at `/Users/dseely/google-cloud-sdk/`; Pass 3 → `$HOME/`) |
| `zsh/.zshrc:141,145` | commented gcloud (bash) | inert |
| `.gitconfig:24` | `excludesfile = /Users/dan/.gitignore_global` | silently no-op (Pass 2 → `~/`) |
| `.gitconfig:39` | `template = /Users/dan/.stCommitMsg` | silently no-op (Pass 2 ADDS this fix) |
| `.bash_profile:104,107` | gcloud bash sourcing | pro uses zsh — irrelevant runtime, but Pass 2 ADDS the fix per portability principle |
| `osx.sh:11` | `>> /Users/dan/.zprofile` | setup script only; Pass 2 ADDS the fix |

**What's verified vs deferred on pro:**

| Step | Status |
|---|---|
| Pro symlink manifest committed | ✅ |
| Danger check (deletions × manifest) | ✅ clean |
| Main checkout advance to `align/cleanup` | ⏸️ deferred to post-Pass-3 |
| Smoke test on advanced state | ⏸️ deferred |
| Pass 2+ authoring (in pro worktree) | ✅ unblocked |

Pass 1 verification gap **partially closed** (danger check + manifest
done; advance deferred). Pass 2 content commits can begin on next
BATON cycle; pro authors them from the recreated worktree until Pass
3 lands the portability fixes that unblock pro's main-checkout
advance.

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
- ~~`snapshot/macbook-air` doesn't exist on origin yet.~~ Resolved
  2026-05-22 — pushed at `da6d5bc`. Macbook-pro can now run
  `git diff snapshot/macbook-air..snapshot/macbook-pro -- <file>` for
  Pass 2+ per-file reconciliation.
- ~~Should the Claude Code config be folded into this repo?~~ Resolved
  2026-05-22 — yes, as Pass 6 (deferred to end), selective symlinks
  from `~/.claude/<thing>` → repo's `claude/<thing>`. See Pass 6
  in §Pass plan.

**No live open questions** as of 2026-05-22. New questions go inline
in the relevant pass entry or in this section as they arise.
