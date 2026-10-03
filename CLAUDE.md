# kiro-niri-dms — Claude project instructions

## Overview
Config package for the **Kiro niri + DankMaterialShell edition** — the Material-3 member of the
KIROTUX Wayland line, sibling to [kiro-niri](../kiro-niri/CLAUDE.md) (noctalia-shell) and
[kiro-ohmyniri](../kiro-ohmyniri/CLAUDE.md) (waybar/kiro-hyprland look). Same niri compositor, DMS
as the shell. Public, open-core, shipped via `nemesis_repo`. Research on the niri line lives in
`Kiro-HQ/Kirotux/study-of-niri.md`.

## Edition spec (the WM-variable matrix)
- **Compositor:** niri (scrollable-tiling, Smithay-based — *not* wlroots).
- **Config language:** KDL. `etc/skel/.config/kiro-niri-dms/config.kdl` `include`s `cfg/*.kdl`
  (`animation, autostart, keybinds, input, display, layout, rules, misc`). Edit the `cfg/` file,
  not a monolith. niri is pointed at this folder by the `kiro-niri-dms-session` wrapper via
  `NIRI_CONFIG`.
- **Desktop shell:** **DankMaterialShell (DMS)** — a Quickshell + Material 3 shell (`dms-shell`
  from Arch `extra`). Provides bar, launcher (spotlight), lock, notifications, wallpaper, control
  center, session menu, polkit agent. Driven over `dms ipc call <target> <function>`
  (docs: danklinux.com/docs/dankmaterialshell; local `IPC.md` in the upstream clone). Started with
  `dms run`.
- **Autostart:** `spawn-sh-at-startup "dms run"` (+ the guarded first-run wallpaper script, explicit
  `xdg-user-dirs-update`, the xwayland-satellite bridge, + the archiso-gated Calamares line). niri
  does **not** process `/etc/xdg/autostart`.
- **Theming:** DMS owns runtime accent colours (runs matugen internally) for its bar + GTK apps.
  niri's focus-ring is a **static** Kiro colour (DMS Material default `#d0bcff`), NOT matugen-driven
  — see gotcha below. Base GTK look + cursor (dark adw-gtk3, Bibata-Modern-Ice) shipped via
  `/etc/dconf/`, owned by `kiro-wayland-dotfiles` (this edition is a partial consumer — dconf only).
- **Dependency note:** `dms-shell` (+ `quickshell`, `dgop`, `accountsservice`) all
  come from **Arch `extra`** — nothing repackaged by Kiro. `matugen`, `cava`, `kimageformats` added.
  `power-profiles-daemon` is an **optdepend** (DMS `powerprofile` IPC); `tuned-ppd` rejected (it
  conflicts with `power-profiles-daemon`).

## Keybindings
- niri-native window/column/workspace management (column model: `focus-column-*`, `move-column-*`,
  consume/expel) **kept verbatim**; Kiro's app scheme layered on a collision-free space: CTRL+ALT
  launchers + SUPER+F1..F12 + `kiro-keybindings` on SUPER+CTRL+S.
- Shell binds route to DMS: launcher `spotlight toggle`, control center `control-center toggle`,
  settings `settings toggle`, lock `lock lock`, wallpaper `dankdash wallpaper`, clipboard
  `clipboard toggle`, notifications `notifications toggle`; media/volume/brightness via
  `audio`/`mpris`/`brightness` targets.
- `keybindings.txt` mirrors `cfg/keybinds.kdl` — keep them in lockstep; a duplicate-chord scan must
  pass. (`kiro-keybindings` and `/kiro-create-keybindings` still need **niri** in their
  WM-detection table — known line-wide gap.)
- Mod = Super. Belgian `be,us` layout (matches the rest of the Kiro line).

## Patterns / gotchas
- **DMS pins its generated niri colour/blur includes to `~/.config/niri/dms/`** — a hardcoded path
  (`core/cmd/dms/commands_setup.go`) that this edition's own-folder design does NOT use. So do
  **not** add any `include "./dms/*.kdl"` line (it would fail `niri validate`). The trade: niri's
  focus-ring is static instead of wallpaper-derived. DMS still themes its bar + GTK apps fine.
- niri `spawn` is **argv, no shell**; use `spawn-sh "…"` for the `dms ipc call …` binds and the
  archiso-gated installer line.
- niri has **no native lock/idle** — DMS provides both; do not add swaylock/swayidle.
- `debug { honor-xdg-activation-with-invalid-serial }` is in DMS's own blessed niri config (needed
  for its notification actions / window activation) — keep it.
- Wallpaper is drawn by DMS into niri's backdrop via `layer-rule { match namespace="^quickshell$";
  place-within-backdrop true }` (DMS's Quickshell layer namespace is `quickshell`, **not** noctalia's)
  + `layout { background-color "transparent" }` — no separate wallpaper daemon.
- No DMS `settings.json` is seeded (runtime-generated; partial seed risks its schema). Wallpaper is
  branded once via `scripts/firstrun-wallpaper.sh` (guarded, polls for `dms ipc` readiness).

## Sibling editions
- **`kiro-niri`** (noctalia-shell) and **`kiro-ohmyniri`** (waybar/kiro-hyprland look) — same
  compositor, different shells. All three ship **their own** config folder
  (`~/.config/kiro-niri-dms/` vs `kiro-niri/` vs `kiro-ohmyniri/`), session `.desktop`, wrapper and
  hook — **no shared files, no conflicts** — so all coexist and are picked per-login.
- The remove-hook un-hide of upstream "Niri" is guarded to only fire when neither sibling is still
  installed. **Known follow-up:** the siblings' own `.install` unhide checks don't yet know about
  `kiro-niri-dms.desktop`; patch them when they're next touched (would need rebuilding those pkgs).

## Build / delivery
- Source-of-truth for the config; delivered as the `kiro-niri-dms` package via
  `../KIROTUX-PKG-BUILD/kiro-niri-dms/build.sh` (public recipe → `~/EDU/nemesis_repo/`). After
  editing here: rebuild the package (recipe `build.sh` or `flow-kiro-niri-dms`), then the ISO to
  test a fresh install.
- See [../CLAUDE.md](../CLAUDE.md) for the full KIROTUX delivery architecture.
