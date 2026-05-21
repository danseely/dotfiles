# `snapshot/` directory

Throwaway data captured by the `snapshot/macbook-pro` (and sibling) branches as
part of the dotfiles alignment project. See top-level `NOTES.md`.

Contents:

- `stash@0.patch` — `git stash show -p stash@{0}` of the local stash on
  `macbook-pro` at snapshot time (2026-05-21). Pre-`@adadapted` era; touches
  `.bash_profile` (`. "$HOME/.cargo/env"`) and `.gitconfig` (sets email to
  `dan@danseely.net`, adds 1Password SSH signing key, switches lfs filter to
  `git-lfs filter-process`). Captured as a file so the data travels with the
  branch and survives any local clone destruction. The stash entry itself is
  also left intact on `macbook-pro`'s local clone.

Delete this directory along with the snapshot branches at the end of the
alignment project.
