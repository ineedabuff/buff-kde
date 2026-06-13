#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────
#  obs.sh — état d'enregistrement OBS pour Waybar (via obs-cmd + obs-websocket)
#
#  Affiche :
#    • rien            -> OBS fermé / WebSocket injoignable (module masqué)
#    • ○ REC           -> OBS prêt (clic = démarrer)
#    • ● 00:01:23      -> enregistrement en cours (clic = arrêter), avec chrono
#
#  Dépendances : obs-cmd  (https://github.com/grigio/obs-cmd, binaire unique)
#                + OBS Studio avec le serveur WebSocket activé
#                (OBS -> Outils -> Réglages du serveur WebSocket)
# ──────────────────────────────────────────────────────────────────────────

export LC_ALL=C.UTF-8

# URL WebSocket d'OBS. Si ton mot de passe n'est pas "secret", change-le ici
# ET dans la ligne "on-click" du module custom/obs dans le config.
WS="obsws://localhost:4455/secret"
OBS="obs-cmd --websocket $WS"

# obs-cmd installé ?
command -v obs-cmd >/dev/null 2>&1 || { echo '{"text":"", "class":"off"}'; exit 0; }

# OBS joignable ? sinon on masque le module
if ! $OBS info >/dev/null 2>&1; then
  echo '{"text":"", "tooltip":"OBS non lancé", "class":"off"}'
  exit 0
fi

status="$($OBS recording status 2>/dev/null)"

if printf '%s' "$status" | grep -qiE 'active:?[[:space:]]*true'; then
  # Enregistrement en cours : afficher le chrono si présent dans la sortie
  tc="$(printf '%s' "$status" | grep -oE '[0-9]{2}:[0-9]{2}:[0-9]{2}' | head -1)"
  [ -z "$tc" ] && tc="REC"
  printf '{"text":"● %s", "tooltip":"OBS enregistre — clic pour arrêter", "class":"recording"}\n' "$tc"
else
  printf '{"text":"○ REC", "tooltip":"OBS prêt — clic pour enregistrer", "class":"idle"}\n'
fi
