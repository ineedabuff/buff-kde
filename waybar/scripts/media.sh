#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────
#  media.sh — module "lecture en cours" pour Waybar (MPRIS via playerctl)
#  Remplace l'ancien module ProtonVPN.
#  Fonctionne avec Spotify, les navigateurs, VLC, mpv, etc.
#
#  Sortie : texte simple avec balisage pango (le module config a "markup":"pango")
#  Dépendance : playerctl   ->   sudo apt install playerctl
# ──────────────────────────────────────────────────────────────────────────

# Glyphes Nerd Font
ICON_SPOTIFY=""   # logo Spotify
ICON_MUSIC="󰝚"     # note de musique générique
ICON_PLAYING=""   # ▶ en lecture
ICON_PAUSED=""    # ⏸ en pause

# Longueur max du libellé affiché dans la barre
MAX=40

# playerctl est requis
command -v playerctl >/dev/null 2>&1 || { echo ""; exit 0; }

# Choix du lecteur : Spotify en priorité, sinon le lecteur actif le plus récent
player="$(playerctl -l 2>/dev/null | grep -im1 spotify)"
[ -z "$player" ] && player="$(playerctl -l 2>/dev/null | head -n1)"
[ -z "$player" ] && { echo ""; exit 0; }

# État de lecture
status="$(playerctl -p "$player" status 2>/dev/null)"
case "$status" in
  Playing) sicon="$ICON_PLAYING" ;;
  Paused)  sicon="$ICON_PAUSED" ;;
  *)       echo ""; exit 0 ;;   # Stopped / rien -> module masqué
esac

# Icône du lecteur
case "$player" in
  spotify*) picon="$ICON_SPOTIFY" ;;
  *)        picon="$ICON_MUSIC" ;;
esac

# Métadonnées brutes
artist="$(playerctl -p "$player" metadata artist 2>/dev/null)"
title="$(playerctl -p "$player" metadata title 2>/dev/null)"

# Si pas de titre, rien à afficher
[ -z "$title" ] && { echo ""; exit 0; }

# Libellé : "Artiste — Titre" (ou juste le titre s'il n'y a pas d'artiste)
if [ -n "$artist" ]; then
  label="$artist — $title"
else
  label="$title"
fi

# Troncature SUR LE TEXTE BRUT (avant échappement, pour ne pas couper une entité)
if [ "${#label}" -gt "$MAX" ]; then
  label="${label:0:MAX}…"
fi

# Échappement pango via sed (l'esperluette d'abord ; \& = & littéral en sed)
label="$(printf '%s' "$label" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g')"

printf '[ %s %s  %s ]\n' "$picon" "$sicon" "$label"
