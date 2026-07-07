# Changelog

## 2026.07.07

### Keyboard: US default + normalized Alt+Shift toggle

**What Changed**
- Flipped the layout order `be,us` → **`us,be`**: US QWERTY is now the default at login, Belgian AZERTY the secondary layout.
- Normalized the layout-switch option from `grp:alts_toggle` (press both Alts) to **`grp:alt_shift_toggle`** (Alt+Shift), matching the rest of the KIROTUX line. Options now `grp:alt_shift_toggle,compose:caps`.

**Technical Details**
- `grp:alt_shift_toggle` matches the CachyOS Calamares reference (`keyboard/Config.cpp` defaults the group switcher to it when a second layout exists). `compose:caps` (Caps = Compose) unchanged. `layout` / `options` in `cfg/input.kdl`.

**Files Modified**
- `etc/skel/.config/kiro-niri-dms/cfg/input.kdl`

## 2026.07.04

### What Changed
- **Initial config package.** `kiro-niri-mds` — the niri + **DankMaterialShell (DMS)** edition of
  the Kiro Wayland line. Sibling of `kiro-niri` (noctalia-shell) and `kiro-ohmyniri`
  (waybar/kiro-hyprland look): same niri compositor, DMS as the desktop shell instead. Forked from
  `kiro-niri` and re-pointed at DMS.
- **Desktop shell is DankMaterialShell**, started by the single autostart line
  `spawn-sh-at-startup "dms run"`. Launcher (spotlight) / control center / settings / lock /
  wallpaper / clipboard / notifications / volume / brightness / media are all routed through
  `dms ipc call <target> <function>` (see `cfg/keybinds.kdl`).
- **Own config folder + own session entry**, matching the sibling pattern: ships
  `kiro-niri-mds.desktop` ("Kiro Niri MDS") → a `kiro-niri-mds-session` wrapper that points niri
  at `~/.config/kiro-niri-mds/config.kdl` via `NIRI_CONFIG`. All three niri editions coexist and
  are switchable per-login. The upstream plain "Niri" greeter entry is hidden with a
  `NoDisplay=true` pacman hook; the remove-hook un-hide is guarded to only fire when neither
  sibling (`kiro-niri`, `kiro-ohmyniri`) is still installed.
- **Static Kiro focus-ring** using DMS's Material 3 default accent (`#d0bcff`). DMS pins its
  generated niri colour include to `~/.config/niri/dms/`, a path this edition does not use, so the
  focus-ring stays fixed while DMS themes its own bar + GTK apps from the wallpaper via matugen at
  runtime.
- **DMS wallpaper backdrop** wired via `layer-rule { match namespace="^quickshell$";
  place-within-backdrop true }` + `layout { background-color "transparent" }` (DMS's own blessed
  niri rule), so the wallpaper shows through the overview. A guarded first-run script
  (`scripts/firstrun-wallpaper.sh`) points DMS's wallpaper at the shipped `bg/kiro.jpg` once, on
  first login only.

### Technical Details
- `depends` swaps `noctalia-shell` → `dms-shell-niri` (Arch `extra`; pulls `dms-shell`,
  `quickshell`, `dgop`, `accountsservice`, `niri`) and adds `matugen`, `cava`, `kimageformats`.
  `power-profiles-daemon` is an **optdepend** (DMS `powerprofile` IPC talks to it) — `tuned-ppd`
  from the upstream DMS package list was rejected because it conflicts with `power-profiles-daemon`.
  `xdg-desktop-portal-gnome` stays an optdepend (screencast only; pulls GNOME/nautilus).
- No DMS `settings.json` is shipped — DMS generates its own at runtime, and a hand-seeded partial
  file risks breaking its schema; the wallpaper is set over IPC by the first-run script instead.

### Files Modified
- New source repo `kiro-niri-mds/` (config tree, session wrapper, hide-upstream hook + helper,
  session desktop entry, README/CHANGELOG/CLAUDE) and recipe
  `KIROTUX-PKG-BUILD/kiro-niri-mds/` (PKGBUILD + build.sh + kiro-niri-mds.install).
