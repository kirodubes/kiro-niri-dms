#!/bin/sh
#####################################################################
# Author    : Erik Dubois
# Website   : https://kiroproject.be
#####################################################################
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
# Purpose:
#   On the first login of an installed system, set niri's keyboard layout to the one picked in the
#   installer. Calamares (kiro_final) writes XKBLAYOUT / XKBVARIANT to /etc/vconsole.conf; this
#   script puts them into the user's own cfg/input.kdl in place of the shipped us,be default.
#   niri reloads its config when the file changes, so the layout applies straight away.
# Why:
#   niri's KDL config can't read a file at runtime (kiro-hyprland-dms does this in Lua), so a user
#   who picked e.g. German still typed US/Belgian. The script is a no-op on the live ISO (no
#   XKBLAYOUT there), on every later login (stamp file) and when the user already changed the
#   layout line, so it never overwrites a user's own choice.
#####################################################################

dir="$HOME/.config/kiro-niri-dms"
input="$dir/cfg/input.kdl"
stamp="$dir/.keyboard-from-installer-done"
default='            layout "us,be"'

[ -e "$stamp" ] && exit 0
[ -f "$input" ] || exit 0
[ -r /etc/vconsole.conf ] || exit 0

layout=$(sed -n 's/^XKBLAYOUT="\{0,1\}\([^"]*\)"\{0,1\}$/\1/p' /etc/vconsole.conf | head -n1)
variant=$(sed -n 's/^XKBVARIANT="\{0,1\}\([^"]*\)"\{0,1\}$/\1/p' /etc/vconsole.conf | head -n1)

# Live ISO / no installer choice: keep the shipped default and try again next login.
[ -n "$layout" ] || exit 0

# Only replace the untouched default line; a user-edited layout stays as it is.
if grep -qxF "$default" "$input"; then
    new="            layout \"$layout\""
    [ -n "$variant" ] && new="$new
            variant \"$variant\""
    tmp="$input.tmp.$$"
    awk -v def="$default" -v new="$new" '$0 == def { print new; next } { print }' "$input" > "$tmp" \
        && mv "$tmp" "$input"
fi

: > "$stamp"
exit 0
