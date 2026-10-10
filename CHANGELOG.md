# Changelog

## 2026.10.10

### What Changed
- **Fixes carried over from kiro-hyprland-dms for the KiroTux Niri DMS ISO:**
  - **Qt apps follow the dark theme:** `kiro-kvantum-default` runs at session start (KvGnomeDark, unless the user
    picked an installed Kvantum theme). Before, Qt apps used Kvantum's built-in look.
  - **The keyboard follows the installer:** new first-login script `scripts/keyboard-from-installer.sh` puts
    `XKBLAYOUT`/`XKBVARIANT` from `/etc/vconsole.conf` into the user's `cfg/input.kdl`. No-op on the live ISO
    (stays `us,be`), on later logins (stamp) and when the user already changed the layout line.
  - **The Kiro wallpaper really shows on first login:** `firstrun-wallpaper.sh` keeps setting it until DMS reports
    it 10 times in a row, because DMS answers `wallpaper set` before its UI has finished starting.
  - **DMS shows its bar in VirtualBox:** DMS runs on Mesa llvmpipe when `systemd-detect-virt` says `oracle`.
  - **Binds:** Super+Shift+X opens `archlinux-logout` (`kiro-powermenu` needs rofi, which the ISO doesn't ship).
    Super+E and Super+F2 open Sublime Text (`subl`) instead of VS Code. New Ctrl+Alt+H opens Kirotux Niri
    Premium when it's installed, else a notification with a **Get KiroTux** button.
- Existing installs keep their `~/.config` copy; these reach new installs and users who copy the new defaults.
- Source repo moved from `~/KIROTUX/kiro-niri-dms` to `~/KIRO/kiro-niri-dms` and its recipe to `~/KIRO-PKG-BUILD-APPS/kiro-niri-dms`: ATT installs it from nemesis_repo, so it is a Kiro package, not KiroTux-only. Paths and links in the docs follow. The package itself is unchanged.

### Files Modified
- `CLAUDE.md`, `CHANGELOG.md`
- `etc/skel/.config/kiro-niri-dms/cfg/autostart.kdl`, `cfg/keybinds.kdl`, `keybindings.txt`
- `etc/skel/.config/kiro-niri-dms/scripts/firstrun-wallpaper.sh`, `scripts/keyboard-from-installer.sh` (new)

## 2026.10.05

### What Changed
- Fixed a possible missing bar at first login, found on kiro-hyprland-dms (same script, same race). `dms run` can
  exit at once with `FATAL extract embedded UI: chtimes .../danklinux-shell/.extract-*/...: no such file or
  directory`. The first-run wallpaper script starts together with `dms run` and calls `dms ipc` straight away, and
  `dms ipc` unpacks the embedded UI itself when it isn't there yet. Two unpacks into
  `$XDG_RUNTIME_DIR/danklinux-shell/` at once make `dms run` fail. That leaves no bar and no wallpaper. The script
  now waits until DMS is up before its first `dms ipc` call.
- Added Variety wallpaper keybindings (same scheme as the Hyprland editions): Alt+N / Alt+Right next, Alt+P /
  Alt+Left previous, Alt+T trash, Alt+F favorite, Alt+Up pause, Alt+Down resume, Alt+W selector. Variety's
  wallpapers now reach DMS (kiro-variety-config, same day).
- **`QT_STYLE_OVERRIDE "kvantum"` moved into the `environment { }` block** of `cfg/misc.kdl`. The Wayland ISOs keep only
  `EDITOR` in `/etc/environment` from now on (`GTK_THEME` and `BROWSER` there caused transparent GTK 4 windows and a
  browser default that couldn't be changed); the Qt variables belong to the session.

### Technical Details
- `firstrun-wallpaper.sh` polls `pgrep -u "$(id -u)" -x qs` every 0.5s, up to 60s, before its loop. `qs` only
  starts after `dms run` has finished unpacking. If `qs` never appears, the script exits without writing the stamp,
  so it tries again at the next login.
- Not reproduced on niri itself; the cause was proven and the fix tested on kiro-hyprland-dms (2026.10.05).
- `cfg/keybinds.kdl` block after the media keys, each with a `hotkey-overlay-title`; the only existing plain-Alt
  bind is Alt+Print, so nothing was taken. `keybindings.txt` gets section 6b. Not run on niri yet: no niri install
  was available to validate the KDL; it follows the file's existing `spawn` syntax.
- Same `KEY "value"` form as the existing lines; not validated with `niri validate` (no niri install at hand).

### Files Modified
- `etc/skel/.config/kiro-niri-dms/scripts/firstrun-wallpaper.sh`
- `etc/skel/.config/kiro-niri-dms/cfg/keybinds.kdl`
- `etc/skel/.config/kiro-niri-dms/keybindings.txt`
- `etc/skel/.config/kiro-niri-dms/cfg/misc.kdl`

## 2026.10.03

### What Changed
- Docs now name `dms-shell` as the DMS dependency instead of `dms-shell-niri`. Arch `extra` folded the split package back
  into `dms-shell` (1.6.2-2) and no longer ships it; the PKGBUILD in `KIROTUX-PKG-BUILD/kiro-niri-dms` was fixed to match.

### Technical Details
- `extra/dms-shell` lists `dms-shell-niri` in `replaces=` but not in `provides=`, so pacman swaps it out on upgrade and any
  `depends` on the old name becomes unsatisfiable.

### Files Modified
- `README.md`
- `CLAUDE.md`

## 2026.09.27

### What Changed
- Reworded the `keybindings.txt` header: dropped "DO NOT EDIT BY HAND" and the generator name, added a line telling users it lists the default bindings and they can edit it to match their own. A user changed a binding, expected the file to update itself, and went looking for a generator that isn't part of Kiro.

### Technical Details
- `Generated:` now carries only the date, so the kiro-keybindings HTML/PDF footer (which prints everything after `Generated:`) shows a clean date. The new line is a `#` comment, which both kiro-keybindings parsers skip. Bindings unchanged.

### Files Modified
- `etc/skel/.config/kiro-niri-dms/keybindings.txt`

## 2026.07.09

### Fix `mds` → `dms` typo throughout the docs

**What Changed**
- The package/edition is **kiro-niri-dms** (niri + **D**ank **M**aterial **S**hell →
  DMS), and every shipped file is named `dms` — but README, CLAUDE.md and the
  earlier CHANGELOG entries had the letters transposed as `mds` (title, config
  path `~/.config/kiro-niri-dms/`, session `kiro-niri-dms.desktop` / "Kiro Niri
  DMS", wrapper `kiro-niri-dms-session`, golden copy, recipe path, flow script).
  Corrected all doc references to `dms`; the actual files were already correct.

**Files Modified**
- `README.md`, `CLAUDE.md`, `CHANGELOG.md`

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
- **Initial config package.** `kiro-niri-dms` — the niri + **DankMaterialShell (DMS)** edition of
  the Kiro Wayland line. Sibling of `kiro-niri` (noctalia-shell) and `kiro-ohmyniri`
  (waybar/kiro-hyprland look): same niri compositor, DMS as the desktop shell instead. Forked from
  `kiro-niri` and re-pointed at DMS.
- **Desktop shell is DankMaterialShell**, started by the single autostart line
  `spawn-sh-at-startup "dms run"`. Launcher (spotlight) / control center / settings / lock /
  wallpaper / clipboard / notifications / volume / brightness / media are all routed through
  `dms ipc call <target> <function>` (see `cfg/keybinds.kdl`).
- **Own config folder + own session entry**, matching the sibling pattern: ships
  `kiro-niri-dms.desktop` ("Kiro Niri DMS") → a `kiro-niri-dms-session` wrapper that points niri
  at `~/.config/kiro-niri-dms/config.kdl` via `NIRI_CONFIG`. All three niri editions coexist and
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
- New source repo `kiro-niri-dms/` (config tree, session wrapper, hide-upstream hook + helper,
  session desktop entry, README/CHANGELOG/CLAUDE) and recipe
  `KIROTUX-PKG-BUILD/kiro-niri-dms/` (PKGBUILD + build.sh + kiro-niri-dms.install).
