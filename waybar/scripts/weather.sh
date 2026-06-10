#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────
#  weather.sh — météo courante pour Waybar (source : wttr.in)
#  Remplace l'ancien module "power menu".
#
#  Dépendances : curl, python3 (déjà présents sur Kubuntu)
#  Sortie : JSON  {"text":..., "tooltip":..., "class":...}
# ──────────────────────────────────────────────────────────────────────────

# Ta localisation (change-la si besoin : ville, code postal, aéroport, etc.)
LOC="Montreal"

# Une seule requête : Condition|Temp|Ressenti|Humidité|Vent (unités métriques)
data="$(curl -fs -m 8 "https://wttr.in/${LOC}?format=%C|%t|%f|%h|%w&m" 2>/dev/null)"

# Échec réseau / réponse vide ou d'erreur -> module en repli
if [ -z "$data" ] || printf '%s' "$data" | grep -qiE 'unknown|sorry|error|not found'; then
  printf '{"text":"  N/A", "tooltip":"Météo indisponible", "class":"error"}\n'
  exit 0
fi

# Découpe les champs séparés par |
IFS='|' read -r cond temp feels hum wind <<EOF
$data
EOF

# Nettoyage des espaces parasites de wttr.in
temp="$(printf '%s' "$temp" | tr -d ' ')"
feels="$(printf '%s' "$feels" | tr -d ' ')"

# Condition -> icône Nerd Font
shopt -s nocasematch
case "$cond" in
  *thunder*|*storm*)               icon="" ;;  # orage
  *snow*|*sleet*|*blizzard*|*ice*) icon="" ;;  # neige
  *rain*|*drizzle*|*shower*)       icon="" ;;  # pluie
  *fog*|*mist*|*haze*|*smoke*)     icon="" ;;  # brouillard
  *overcast*)                      icon="" ;;  # couvert
  *cloud*|*partly*)                icon="" ;;  # nuageux
  *clear*|*sunny*)                 icon="" ;;  # dégagé
  *)                               icon="" ;;  # défaut
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
