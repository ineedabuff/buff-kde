#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────
#  waybar-watcher.sh
#  Recharge Waybar (rejoue l'animation de glissement) UNIQUEMENT lorsqu'on
#  change réellement de bureau virtuel KWin.
#
#  Corrige le bug où fermer une fenêtre (ex. Chrome) faisait disparaître la
#  barre : on ne réagit plus au focus/aux fenêtres, et on RECHARGE au lieu de
#  tuer le process -> la barre ne peut plus rester éteinte.
# ──────────────────────────────────────────────────────────────────────────

# Résout qdbus6 même s'il n'est pas dans le PATH (cas Ubuntu/Kubuntu)
QDBUS="$(command -v qdbus6 || command -v qdbus-qt6 || true)"
[ -z "$QDBUS" ] && [ -x /usr/local/bin/qdbus6 ] && QDBUS=/usr/local/bin/qdbus6
[ -z "$QDBUS" ] && [ -x /usr/lib/qt6/bin/qdbus ] && QDBUS=/usr/lib/qt6/bin/qdbus
[ -z "$QDBUS" ] && { echo "qdbus6 introuvable"; exit 1; }

# Identifiant du bureau virtuel actuellement actif (UUID renvoyé par KWin)
current_desktop() {
  "$QDBUS" org.kde.KWin /VirtualDesktopManager \
    org.freedesktop.DBus.Properties.Get \
    org.kde.KWin.VirtualDesktopManager current 2>/dev/null
}

reload_waybar() {
  # SIGUSR2 = rechargement : Waybar recrée sa fenêtre et rejoue l'animation
  # curtainDrop, sans jamais quitter le process.
  killall -SIGUSR2 waybar 2>/dev/null
}

last="$(current_desktop)"

while true; do
  sleep 0.15
  now="$(current_desktop)"

  # Lecture vide = KWin momentanément indisponible -> on ignore (pas de réaction)
  [ -z "$now" ] && continue

  if [ "$now" != "$last" ]; then
    # Anti-rebond : on attend que le bureau se stabilise (changements rapides)
    while true; do
      sleep 0.15
      check="$(current_desktop)"
      [ -z "$check" ] && check="$now"
      [ "$check" = "$now" ] && break
      now="$check"
    done
    last="$now"
    reload_waybar
  fi
done
