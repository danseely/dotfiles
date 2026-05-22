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
| Merge cadence | one merge `align/cleanup` → `master` at project end (master = clean rollback target throughout) | **confirmed 2026-05-22** |
| `.gitconfig` identity | global `dan@danseely.net`; `includeIf "gitdir:~/dev/adadapted/"` overrides to `dseely@adadapted.com` via repo-internal `gitconfig/adadapted` (referenced as `path = ~/dev/dotfiles/gitconfig/adadapted`). Byte-identical `.gitconfig` ships on both Macs; inert on machines without `~/dev/adadapted/`. | **confirmed 2026-05-22** |
| Verification protocol | receiving Mac pulls into worktree first, runs danger check (deleted-files × symlink manifest), optionally tests selective symlinks, only then advances main checkout | **confirmed 2026-05-22** |
| Symlink manifest | per-Mac `manifests/symlinks-<host>.txt` committed to repo as LOSE-NO-DATA pre-flight inventory of symlinks-into-repo | **confirmed 2026-05-22** |
| `.bash_profile`, `.zshrc-backup-24-jan-2022` | keep as-is, no content review | confirmed 2026-05-22 |
| `~/.claude/` config in repo | yes — Pass 6 (deferred to end), selective symlinks pattern | confirmed 2026-05-22 |
| Graveyard pattern (`archived/`) | for files queued for deletion but not yet yanked (honors LOSE-NO-DATA). Move to `archived/<filename>`; deletion happens as a separate operation later. Empty for now. | **confirmed 2026-05-22** |

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

    BATON: macbook-air (Pass 1.5 — 2026-05-22)

### BATON history

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
3. **Selective live test** (higher-risk passes only — Karabiner, .zshrc).
   Temporarily `ln -sf <worktree-path> <live-path>` for the affected
   file, exercise behavior, revert symlink if broken. Examples:
   - `.zshrc`: `ln -sf ~/dev/dotfiles-align/zsh/.zshrc ~/.zshrc; zsh -l -i -c true; <revert if errors>`
   - `karabiner.json`: `ln -sf ~/dev/dotfiles-align/karabiner/karabiner.json ~/.config/karabiner/karabiner.json` (karabiner auto-reloads); revert if remap behavior broken.
4. **Advance main checkout**: in main, `git pull --ff-only origin align/cleanup`.
5. **Smoke test** the pass-specific behavior in main; mark verified in NOTES.
6. **Rollback if needed**: `git checkout snapshot/<host>` restores all
   repo content to pre-cleanup state. Symlinks in `~` are untouched
   throughout — only the *content at their targets* changes, which
   reverts with the checkout.

**Authoring-Mac protocol**: author's choice on main-checkout vs worktree.
Main-checkout authoring means continuous self-test (live config reflects
every commit) which has been working for macbook-air. Worktree authoring
is also fine and matches macbook-pro's pattern.

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
      - ⚠️ NOT YET VERIFIED on macbook-pro: its main checkout is still
        at `8deec2b` (pre-cleanup). Verification folded into Pass 1.5
        below (worktree-first protocol applies).
- [ ] **Pass 1.5 — Reality check, scope freeze, pre-flight inventory**
      (no `align/cleanup` content commits — only NOTES + manifests)
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
- [ ] **Pass 2 — Env & identity** (low-risk: shells + git config)
      - `.gitconfig`: main file at repo root + `gitconfig/adadapted`
        (3 lines, work-email override), referenced via
        `[includeIf "gitdir:~/dev/adadapted/"] path = ~/dev/dotfiles/gitconfig/adadapted`.
        Byte-identical `.gitconfig` on both Macs; inert on machines
        without `~/dev/adadapted/`.
      - `.zprofile`: brew shellenv. Apple-Silicon `/opt/homebrew` path
        same on both Macs (both are Apple-Silicon per Hosts entries).
      - `.zshenv`: decide adopt (pro's content) / omit / merge.
      - `Brewfile`: reconcile pro's 3-line diff.
      - `README.md` whitespace.
      - VERIFICATION GATE: receiving Mac → worktree pull → danger
        check → main pull → both Macs confirm `git -C ~/dev/adadapted
        config user.email` returns work email, `git -C ~/anywhere-else
        config user.email` returns personal email, shells open clean,
        `brew bundle check` passes.
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
- [ ] **Pass 5 — Editor & tool config**
      - `zed/keymap.json`, `zed/settings.json`: pro has them, air
        doesn't. Adopt on air? gitignore? Decide based on whether
        air uses Zed.
      - `fzf/` subdir vs root `.fzf.zsh` (already gitignored at root):
        canonical location for fzf init shell loader.
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
- [ ] **Final — Merge `align/cleanup` → `master`** in one commit,
      after all passes verified green on both Macs.
      - Delete `snapshot/macbook-air`, `snapshot/macbook-pro`.
      - Delete `NOTES.md`.
      - `manifests/`: decide at merge time — keep as setup reference
        or delete with NOTES.
      - Tag known-good state (e.g., `aligned-2026-05`).

## Pass 1.5 analysis (in progress, macbook-air, 2026-05-22)

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

### Legacy WIP assessment — not yet started

### Macbook-pro Pass 1 verification — not yet started

(blocked on macbook-pro's next Claude session pulling latest
`align/cleanup` into worktree and running the receiving-Mac
protocol — see §Hardened verification protocol)

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
