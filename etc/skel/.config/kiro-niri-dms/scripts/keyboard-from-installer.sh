#!/bin/sh
#####################################################################
# Author    : Erik Dubois
# Website   : https://kiroproject.be
#####################################################################
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
# Purpose:
#   At login on an installed system, set niri's keyboard layout to the one picked in the installer.
#   Calamares (kiro_final) writes XKBLAYOUT / XKBVARIANT to /etc/vconsole.conf; this script puts them
#   into the user's own cfg/input.kdl in place of the shipped us,be default. niri reloads its config
#   when the file changes, so the layout applies straight away.
# Why:
#   niri's KDL config can't read a file at runtime (kiro-hyprland-dms does this in Lua), so a user who
#   picked e.g. Belgian still typed US. It only replaces the untouched shipped line, so a layout the user
#   set is never overwritten. There is deliberately no "done" stamp: `skell` (kiro-skell) copies
#   /etc/skel back over ~/.config and restores the shipped line, and a stamp that survives that copy
#   made the installer layout disappear for good (test box, 2026-10-10). To keep us,be on purpose, change
#   the line in any way, e.g. add a comment: layout "us,be" // mine
#   No-op on the live ISO (no XKBLAYOUT there).
#####################################################################

dir="$HOME/.config/kiro-niri-dms"
input="$dir/cfg/input.kdl"
default='            layout "us,be"'

# Older versions kept a stamp; it is no longer used.
rm -f "$dir/.keyboard-from-installer-done"

[ -f "$input" ] || exit 0
[ -r /etc/vconsole.conf ] || exit 0

layout=$(sed -n 's/^XKBLAYOUT="\{0,1\}\([^"]*\)"\{0,1\}$/\1/p' /etc/vconsole.conf | head -n1)
variant=$(sed -n 's/^XKBVARIANT="\{0,1\}\([^"]*\)"\{0,1\}$/\1/p' /etc/vconsole.conf | head -n1)

# Live ISO / no installer choice, or the installer picked exactly the shipped default: nothing to do.
[ -n "$layout" ] || exit 0
[ "$layout" = "us,be" ] && [ -z "$variant" ] && exit 0

# Only replace the untouched shipped line; a user-edited layout stays as it is.
grep -qxF "$default" "$input" || exit 0
new="            layout \"$layout\""
[ -n "$variant" ] && new="$new
            variant \"$variant\""
tmp="$input.tmp.$$"
awk -v def="$default" -v new="$new" '$0 == def { print new; next } { print }' "$input" > "$tmp" \
    && mv "$tmp" "$input"
exit 0
