# kiro-niri-dms

The **niri + DankMaterialShell edition** of Kiro — the scrollable-tiling, Material-3 member of
the Kiro Wayland line (sibling to [kiro-niri](https://github.com/kirodubes/kiro-niri) and
[kiro-ohmyniri](https://github.com/kirodubes/kiro-ohmyniri)).

## What it is

A configuration package: the source-of-truth config tree for Kiro's niri "DMS" edition. niri is a
scrollable-tiling Wayland compositor; the desktop shell (bar, launcher, lock screen,
notifications, wallpaper, control center, session menu, polkit agent) is provided by
**DankMaterialShell (DMS)** — a Quickshell + Material 3 shell — driven over
`dms ipc call <target> <function>`. niri is the compositor; DMS is everything else.

This is the sibling of `kiro-niri` (same compositor, [noctalia-shell](https://github.com/noctalia-dev/noctalia-shell)
instead of DMS). All three niri editions coexist on one system, each in its own config folder,
picked per-login.

## What it ships

- `etc/skel/.config/kiro-niri-dms/` — the niri config, modular: `config.kdl` `include`s
  `cfg/*.kdl` (`keybinds`, `input`, `layout`, `rules`, `misc`, `animation`, `autostart`,
  `display`), plus a `keybindings.txt` cheat sheet, the Kiro wallpaper (`bg/kiro.jpg`) and a
  first-run script that points DMS's wallpaper at it.
- `usr/bin/kiro-niri-dms-session` + `usr/share/wayland-sessions/kiro-niri-dms.desktop` — the
  "Kiro Niri DMS" login entry, which points niri at this edition's own config folder.
- A pacman hook that keeps upstream's plain "Niri" session hidden.

## How to install

```sh
sudo pacman -S kiro-niri-dms
```

`kiro-niri-dms` depends on `niri` + `dms-shell-niri` (both in Arch `extra`) plus the usual
Wayland helpers. On a fresh login niri starts DMS (`dms run`), which paints the bar and
wallpaper and derives its Material palette from it. Press **Super + Ctrl + S** for the searchable
keybindings cheat sheet, or **Super + Shift + /** for niri's built-in hotkey overlay.

A pristine copy of the config is kept at `/usr/share/kiro/kiro-niri-dms/` so it can be restored.
