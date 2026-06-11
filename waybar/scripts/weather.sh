#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────
#  weather.sh — météo courante pour Waybar (source : wttr.in)
#  Remplace l'ancien module "power menu".
#
#  Dépendances : curl, python3 (déjà présents sur Kubuntu)
#  Sortie : JSON  {"text":..., "tooltip":..., "class":...}
# ──────────────────────────────────────────────────────────────────────────

# Garantit une locale UTF-8 pour que les glyphes (icônes) s'affichent correctement
export LC_ALL=C.UTF-8

# Ta localisation (change-la si besoin : ville, code postal, aéroport, etc.)
LOC="Montreal"

# Une seule requête : Condition|Temp|Ressenti|Humidité|Vent (unités métriques)
data="$(curl -fs -m 8 "https://wttr.in/${LOC}?format=%C|%t|%f|%h|%w&m" 2>/dev/null)"

# Échec réseau / réponse vide ou d'erreur -> module en repli
if [ -z "$data" ] || printf '%s' "$data" | grep -qiE 'unknown|sorry|error|not found'; then
  err_icon=$'\U000F0590'
  printf '{"text":"%s  N/A", "tooltip":"Météo indisponible", "class":"error"}\n' "$err_icon"
  exit 0
fi

# Découpe les champs séparés par |
IFS='|' read -r cond temp feels hum wind <<EOF
$data
EOF

# Nettoyage des espaces parasites de wttr.in
temp="$(printf '%s' "$temp" | tr -d ' ')"
feels="$(printf '%s' "$feels" | tr -d ' ')"

# Jour ou nuit (pour l'icône de ciel dégagé)
hour=$(date +%H)
night=0
{ [ "$hour" -ge 20 ] || [ "$hour" -lt 6 ]; } && night=1

# Condition -> icône Nerd Font (Material Design, générée par codepoint pour
# éviter toute perte de glyphe). Bloc météo MDI contigu U+F0590..U+F0599.
shopt -s nocasematch
case "$cond" in
  *thunder*|*storm*)               icon=$'\U000F0593' ;;  # orage / éclair
  *snow*|*sleet*|*blizzard*|*ice*) icon=$'\U000F0598' ;;  # neige
  *rain*|*drizzle*|*shower*)       icon=$'\U000F0596' ;;  # pluie
  *fog*|*mist*|*haze*|*smoke*)     icon=$'\U000F0591' ;;  # brouillard
  *overcast*)                      icon=$'\U000F0590' ;;  # couvert
  *cloud*|*partly*)                icon=$'\U000F0595' ;;  # nuageux (partiel)
  *clear*|*sunny*)
      if [ "$night" -eq 1 ]; then
        icon=$'\U000F0594'                                # nuit (lune)
      else
        icon=$'\U000F0599'                                # soleil
      fi
      ;;
  *)                               icon=$'\U000F0590' ;;  # défaut : nuageux
esac
shopt -u nocasematch

# Texte de la barre + infobulle, JSON émis proprement par python3
text="${icon}  ${temp}"
tip="${cond} — ${temp}
Ressenti : ${feels}
Humidité : ${hum}
Vent : ${wind}
${LOC}"

python3 -c 'import json,sys; print(json.dumps({"text":sys.argv[1],"tooltip":sys.argv[2],"class":"weather"}))' \
  "$text" "$tip"
