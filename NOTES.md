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
- [~] **Pass 1.5 — Reality check, scope freeze, pre-flight inventory**
      (mostly done; pro side still pending)
      - ✅ macbook-air: manifest committed, full diff dive analysis
        for Pass 2-5 in NOTES, secrets scans clean, ALL Dan decisions
        in (Pass 2, Pass 3, Pass 4 rule [1] = disabled, Pass 5 Zed
        dock = right), WIP assessment resolved. Air side fully done.
      - ⏳ macbook-pro: needs to generate its own manifest, run Pass 1
        verification protocol, and confirm Pass 0 + Pass 1 + 1.5
        analyses are coherent on its side before Pass 2 begins.
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
      - VERIFICATION GATE: README's documented symlinks/steps match reality
        on BOTH Macs.
- [ ] **Final — Merge `align/cleanup` → `master`** in one commit,
      after all passes verified green on both Macs.
      - Delete `snapshot/macbook-air`, `snapshot/macbook-pro`.
      - Delete `NOTES.md`.
      - `manifests/`: decide at merge time — keep as setup reference
        or delete with NOTES.
      - Tag known-good state (e.g., `aligned-2026-05`).

## Pass 1.5 analysis (air-side DONE 2026-05-23; pro-side pending)

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

### Macbook-pro Pass 1 verification — STILL PENDING

Blocked on macbook-pro's next Claude session. Pro needs to:
1. Generate its symlink manifest (`manifests/symlinks-<host>.txt`).
2. Pull latest `align/cleanup` (including Pass 0's dynamic profile
   file + Pass 1's gitignore + all Pass 1.5 analysis) into its
   worktree at `~/dev/dotfiles-align`.
3. Run danger check on its main checkout (currently at `8deec2b`,
   way behind).
4. Advance main checkout once green. Symlinks (TBD from pro's
   manifest) will reflect the new state.
5. Confirm Pass 0's dynamic profile work + Pass 1 gitignore + Pass
   1.5 analyses all land cleanly. Mark Pass 1 verified in NOTES.

This is the gate before Pass 2 content commits begin.

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
