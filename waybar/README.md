# Waybar sur KDE Plasma Wayland
```
 Conçu pour Debian 13 / Kubuntu 26.04 / Ubuntu 26.04 - KDE Plasma 6 (KWin Wayland)
```

## C'est quoi ?

La plupart des dotfiles Waybar sont faits pour Hyprland. Ici, c'est une configuration Waybar entièrement personnalisée qui tourne sous **KDE Plasma Wayland** : tu obtiens le look d'un bureau Hyprland fortement « ricé » tout en gardant la commodité de KDE (installation d'applis facile, widgets Plasma, meilleure autonomie, stabilité).

Inspiré du rice Arch/Hyprland de PewDiePie, mais reconstruit de zéro pour KDE, adapté pour **Debian 13 / Kubuntu 26.04 / Ubuntu 26.04** (apt à la place de pacman) et Plasma 6, puis personnalisé (météo, horloge française, couleurs sur mesure).

---

## À quoi ça ressemble

La barre est divisée en trois sections :

**Gauche :** Horloge → Météo → Réseau → Bluetooth → Média → OBS

**Centre :** *(vide)*

**Droite :** Bureau 1 → Bureau 2 → Bureau 3 → Bureau 4 → Batterie → Volume → Luminosité

---

## Fonctionnalités

### Horloge
Heure au format **24 h** suivie de la **date complète en français** : `HH:MM  •  mercredi 10 juin 2026`. La couleur est forcée en `#ddff24`. L'infobulle affiche un calendrier.

> La date en français nécessite une locale FR générée sur le système (`fr_FR.UTF-8`) **et** le drapeau `L` dans le format (`{:L%H:%M …}`, déjà en place). Voir [Locale française](#locale-française-pour-la-date) si la date reste en anglais.

### Météo
Affiche la météo de ta localisation (par défaut **Montréal**) via `wttr.in`.
- **La barre affiche** : une **icône dynamique** selon les conditions (soleil ☀ le jour / lune ☾ la nuit, nuageux, pluie, neige, brouillard, couvert, orage) suivie de la **température** en °C.
- Couleur forcée en `#ddff24` ; en cas d'absence de réseau, repli discret (`N/A`) en rouge.
- Se met à jour toutes les 30 minutes (wttr.in limite les requêtes fréquentes).
- **Clic gauche** : ouvre la météo détaillée dans le navigateur.
- Les icônes sont générées par codepoint Unicode (jeu Material Design, comme les icônes wifi/volume) pour éviter toute perte de glyphe.

> Nécessite `curl` et `python3` (présents par défaut sur Kubuntu).

### Bureaux (workspaces)
Des scripts personnalisés remplacent le `hyprctl` de Hyprland par l'interface DBus `qdbus6` de KDE. Chaque bureau affiche `[1] [2] [3] [4]` quand il est inactif (cyan `#56b6c2`), et un cercle plein `[●]` en `#ddff24` quand il est actif. Un clic change de bureau. Les UUID sont propres à KDE et doivent être mis à jour sur une nouvelle installation (voir plus bas).

> **Note Ubuntu :** sur Kubuntu, le binaire Qt6 `qdbus` est fourni par le paquet `qdbus-qt6`, mais il **ne s'appelle pas** `qdbus6` et **n'est pas** dans ton `PATH`. L'installeur crée un lien `/usr/local/bin/qdbus6` pour que les scripts de bureaux et le watcher fonctionnent. Sans ça, les bureaux restent vides.

### Animation de glissement
Quand tu changes de bureau, Waybar se **recharge** (signal `SIGUSR2`) et rejoue l'animation de rideau depuis le haut. Un script « watcher » interroge KWin toutes les 150 ms et ne réagit **qu'à un vrai changement de bureau virtuel** (avec une vérification de stabilisation de 150 ms) — fermer ou déplacer une fenêtre ne déclenche donc plus rien.

> **Pourquoi `SIGUSR2` ?** L'ancienne version tuait puis relançait Waybar, ce qui pouvait faire disparaître la barre (par ex. en fermant une appli). Le rechargement par signal recrée la fenêtre sans jamais quitter le process : la barre ne peut plus rester éteinte.

> **Tu ne veux pas l'animation ?** Désactive le service watcher :
> ```bash
> systemctl --user disable --now waybar-watcher.service
> ```

### Protection contre la rémanence OLED
Sur un écran OLED, les éléments statiques (comme une barre toujours visible) peuvent causer une rémanence (« burn-in »). Le rechargement de la barre à chaque changement de bureau fait brièvement « tourner » les pixels situés dessous. Si tu n'es **pas** sur OLED, tu peux désactiver le watcher comme ci-dessus.

### Média (lecture en cours)
Lit la lecture de n'importe quel lecteur compatible MPRIS via `playerctl`.
- **La barre affiche** : icône du lecteur + icône lecture/pause + `Artiste — Titre`
- Donne la priorité à **Spotify** s'il tourne, sinon revient au lecteur actif le plus récent (navigateurs, VLC, mpv, etc.)
- Se masque automatiquement quand rien ne joue
- **Clic gauche** : lecture / pause — **Molette** : piste suivante / précédente
- Les titres longs sont tronqués ; les caractères `& < >` sont correctement échappés

> Nécessite `playerctl`. Spotify expose MPRIS nativement ; pour Firefox, active `media.hardwaremediakeys.enabled` dans `about:config` si les commandes ne répondent pas.

### Enregistrement OBS
Déclenche et suit l'enregistrement OBS Studio directement depuis la barre, via le serveur **WebSocket** d'OBS piloté par `obs-cmd` (approche fiable sous Wayland, contrairement aux raccourcis clavier).
- **OBS fermé / WebSocket injoignable** → module masqué
- **OBS prêt** → `○ REC` en jaune `#ddff24`
- **Enregistrement en cours** → `● 00:01:23` en rouge `#f50a1c` clignotant, avec le chrono
- **Clic gauche** : démarre / arrête l'enregistrement
- Interrogé toutes les 2 s

> Nécessite OBS Studio ≥ 28 (serveur WebSocket intégré) et l'utilitaire `obs-cmd`. Voir [Module OBS (enregistrement)](#module-obs-enregistrement) pour l'installation et la configuration du port / mot de passe.

### Bluetooth
- **La barre affiche** : icône du type d'appareil + nom court + % de batterie avec icône colorée
  - Vert = au-dessus de 50 %, Orange = 20–50 %, Rouge = en dessous de 20 %
  - Icônes : casque `󰋋`, souris `󰍽`, clavier `󰌌`, téléphone `󰄜`, enceinte `󰓃`
- **Clic gauche** : active/désactive le Bluetooth et reconnecte les appareils appairés
- **Clic droit** : sélecteur rofi des appareils appairés
- **Infobulle** : appareils connectés et appairés avec leur niveau de batterie

### Wi‑Fi / Réseau
- **La barre affiche** : l'icône de signal Wi‑Fi (`󰤨 󰤥 󰤢 󰤟 󰤯`) **suivie de l'adresse IP** (en filaire : l'icône ethernet + l'IP)
- **Clic gauche** : ouvre les réglages réseau de KDE (`kcmshell6 kcm_networkmanagement`)
- **Clic droit** : sélecteur de réseaux rofi trié par force du signal (connexion, invite de mot de passe, déconnexion)
- **Infobulle** : SSID, force du signal, IP/CIDR, débits descendant/montant

### Volume
- **La barre affiche** : icône de volume + barre ASCII + pourcentage
- **Couleur selon le niveau** : `0–30 %` vert `#4bff21`, `31–45 %` jaune `#ddff24`, `46–100 %` rouge `#f50a1c`
- **Clic gauche** : couper/rétablir le son — **Clic droit** : sélecteur de sortie audio rofi — **Molette** : ±5 %

### Batterie
- **La barre affiche** : icône + barre ASCII + pourcentage avec seuils colorés
- **Clic gauche** : ouvre les réglages d'énergie de KDE (`kcmshell6 powerdevilprofilesconfig`)
- **Infobulle** : état de charge, temps restant, puissance de décharge (watts), tension
- Détecte automatiquement le chemin de la batterie (BAT0, BAT1, …) et ignore les batteries non-portable

### Luminosité
Un seul module qui passe d'un écran à l'autre avec le **clic gauche** :
- 💻 **Écran du portable** (`intel_backlight`) : molette pour ajuster
- 🖥️ **Écran externe** (DDC/CI via `ddcutil`) : molette pour ajuster
- ⌨️ **Rétroéclairage du clavier** (ASUS uniquement, `asus::kbd_backlight`) : molette pour ajuster

**Clic droit** : sélecteur de modes aura du clavier (ASUS).

> La luminosité de l'écran externe nécessite le DDC/CI et l'utilisateur dans le groupe `i2c`. Sans écran DDC, seuls le portable (et le clavier ASUS) fonctionnent.

---

## Structure des fichiers

```
~/.config/waybar/
├── config                          # Configuration principale de Waybar
├── style.css                       # Tout le style et les animations
├── install.sh                      # Installeur Kubuntu/Ubuntu (apt)
├── waybar.service                  # Service systemd utilisateur pour Waybar
├── waybar-watcher.service          # Service systemd pour le watcher d'animation
├── README.md
└── scripts/
    ├── audio-switcher.sh           # Sélecteur de sortie audio rofi
    ├── battery.sh                  # État batterie avec barre ASCII
    ├── bluetooth-menu.sh           # Sélecteur d'appareils Bluetooth rofi
    ├── bluetooth-status.sh         # État Bluetooth (appareil + batterie)
    ├── bluetooth-toggle.sh         # Bascule Bluetooth + reconnexion auto
    ├── brightness-scroll-down.sh   # Baisser la luminosité de l'écran actif
    ├── brightness-scroll-up.sh     # Monter la luminosité de l'écran actif
    ├── brightness-toggle-display.sh # Cycle portable/écran externe/clavier
    ├── brightness.sh               # État de luminosité de l'écran actif
    ├── kbd-aura.sh                 # Sélecteur de modes/couleurs aura clavier (ASUS)
    ├── media.sh                    # Module lecture en cours (MPRIS via playerctl)
    ├── obs.sh                       # État/déclencheur d'enregistrement OBS (obs-cmd)
    ├── volume.sh                   # État volume (barre ASCII + couleur par niveau)
    ├── weather.sh                  # Module météo (wttr.in, icône dynamique)
    ├── waybar-watcher.sh           # Watcher de changement de bureau KWin (SIGUSR2)
    ├── wifi-menu.sh                # Sélecteur de réseaux Wi‑Fi rofi
    └── workspaces/
        ├── switch.sh               # Basculer vers un bureau KWin donné
        ├── workspace-1.sh          # État du bureau 1 (KWin)
        ├── workspace-2.sh          # État du bureau 2 (KWin)
        ├── workspace-3.sh          # État du bureau 3 (KWin)
        └── workspace-4.sh          # État du bureau 4 (KWin)
```

> Modules retirés par rapport à l'origine : **menu d'extinction**, **micro** et **mode GPU SuperGFX**. Les scripts devenus inutiles peuvent être supprimés : `powermenu.sh`, `mic.sh`, `asus-profile.sh`, `asus-gpu-switch.sh`, ainsi que les anciens `protonvpn-*.sh` et `vpn-countries.sh`.

---

## Dépendances

Tout installer avec apt :
```bash
sudo apt update
sudo apt install -y waybar brightnessctl ddcutil rofi network-manager \
                    pipewire wireplumber pipewire-pulse pulseaudio-utils \
                    bluez upower playerctl qdbus-qt6 kde-cli-tools \
                    fontconfig curl unzip python3 language-pack-fr
```

Ajoute-toi au groupe `i2c` pour la luminosité de l'écran externe (DDC) :
```bash
sudo usermod -aG i2c $USER
sudo modprobe i2c-dev
```

**Polices :** la barre utilise JetBrainsMono Nerd Font, absente d'apt. L'installeur la télécharge depuis [nerd-fonts](https://github.com/ryanoasis/nerd-fonts) ; à la main : place la police dans `~/.local/share/fonts/` puis lance `fc-cache -f`.

**`qdbus6` :** fourni par `qdbus-qt6`, mais hors du `PATH` sur Ubuntu ; crée le lien que fait l'installeur :
```bash
sudo ln -sf /usr/lib/qt6/bin/qdbus /usr/local/bin/qdbus6
```

---

## Installation

### 1. Cloner et copier
```bash
git clone https://github.com/ineedabuff/buff-kde ~/buff-kde
cp -r ~/buff-kde/waybar ~/.config/waybar
```

### 2. Lancer l'installeur (recommandé)
Gère les dépendances, le lien `qdbus6`, la police, la détection batterie/rétroéclairage et les services systemd :
```bash
chmod +x ~/.config/waybar/install.sh
~/.config/waybar/install.sh
```

### 3. Rendre les scripts exécutables
**Étape importante** — à refaire chaque fois que tu remplaces un script (la copie perd souvent le bit exécutable) :
```bash
chmod +x ~/.config/waybar/scripts/*.sh
chmod +x ~/.config/waybar/scripts/workspaces/*.sh
```

### 4. Mettre à jour les UUID des bureaux
KDE attribue des UUID uniques aux bureaux virtuels. Récupère les tiens :
```bash
qdbus6 --literal org.kde.KWin /VirtualDesktopManager \
  org.freedesktop.DBus.Properties.Get \
  org.kde.KWin.VirtualDesktopManager desktops
```
Mets à jour l'UUID dans chaque `scripts/workspaces/workspace-*.sh`.

### 5. Générer la locale française (pour l'horloge)
```bash
sudo locale-gen fr_FR.UTF-8
sudo update-locale
```
Vérifie avec `locale -a | grep -i fr` (tu devrais voir `fr_FR.utf8`).

### 6. Installer les services systemd (optionnel mais recommandé)
```bash
cp ~/.config/waybar/waybar.service ~/.config/systemd/user/
cp ~/.config/waybar/waybar-watcher.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now waybar.service waybar-watcher.service
```

### 7. Ou lancer manuellement
```bash
waybar &
```

> Assure-toi d'être connecté sur la session **Plasma (Wayland)**, et non X11.

---

## Configuration

### Locale française pour la date
Si la date s'affiche en anglais, c'est que la locale FR n'est pas générée. Lance les commandes de l'étape 5, puis recharge Waybar (`killall waybar; waybar &`). Au Québec tu as peut-être `fr_CA.UTF-8` : dans ce cas mets cette valeur dans la ligne `"locale"` du module `clock` (les noms de jours/mois sont identiques).

### Changer la ville de la météo
Édite `scripts/weather.sh` et modifie la ligne :
```bash
LOC="Montreal"   # ville, code postal ou aéroport
```

### Désactiver l'animation des bureaux
```bash
systemctl --user disable --now waybar-watcher.service
```
Waybar restera lancé en permanence sans se recharger.

### Module OBS (enregistrement)
Le module pilote OBS via son serveur WebSocket et l'utilitaire `obs-cmd`.

**1. Installer `obs-cmd`** (pas dans apt — binaire à télécharger) :
```bash
cd /tmp
curl -L https://github.com/grigio/obs-cmd/releases/latest/download/obs-cmd-x64-linux.tar.gz | tar xz
chmod +x obs-cmd && sudo mv obs-cmd /usr/local/bin/
```
Repli si l'archive change de nom : `cargo install --git https://github.com/grigio/obs-cmd` puis `sudo ln -sf ~/.cargo/bin/obs-cmd /usr/local/bin/obs-cmd`.

**2. Activer le serveur WebSocket dans OBS** : *Outils → Réglages du serveur WebSocket → Activer*. Note le **port** (4455 par défaut) et le **mot de passe** (« Afficher les informations de connexion »).

**3. Tester** (OBS ouvert) :
```bash
obs-cmd --websocket obsws://localhost:4455/secret info
```

**Port / mot de passe différents** : reporte-les à **deux** endroits — la variable `WS=` en haut de `scripts/obs.sh`, et la ligne `on-click` du module `custom/obs` dans `config`. Si l'authentification est désactivée, utilise `obsws://localhost:4455` (sans mot de passe).

**Déplacer le module** : il est dans `modules-left`, après `custom/media`. Déplace `"custom/obs"` où tu veux dans `config` (par ex. dans `modules-right`).

### Choisir le lecteur média suivi par la barre
Par défaut `media.sh` privilégie Spotify puis le lecteur le plus récent. Pour le fixer, édite `scripts/media.sh` :
```bash
player="firefox"   # à la place du bloc de détection automatique
```
(`playerctl -l` liste les lecteurs disponibles.)

### Désactiver la luminosité de l'écran externe
Édite `brightness-toggle-display.sh` et supprime le cas `monitor` : le cycle se fera entre portable et clavier seulement.

### Personnalisation des couleurs
- **Horloge, météo, bureau actif** : `#ddff24` (dans `style.css` pour `#clock`/`#custom-weather`, dans `workspaces/workspace-*.sh` pour le `[●]` actif)
- **Volume** : seuils dans `scripts/volume.sh` (`#4bff21` / `#ddff24` / `#f50a1c`)
- Les couleurs forcées au survol sont gérées par des règles `#clock:hover` / `#custom-weather:hover` (GTK n'accepte pas `!important`).

---

## Notes

- Les UUID des bureaux changent à chaque nouvelle installation de KDE : pense à les mettre à jour.
- Sur Ubuntu, `qdbus6` n'est pas dans le `PATH` par défaut : l'installeur ajoute le lien `/usr/local/bin/qdbus6`.
- La date française nécessite la locale `fr_FR.UTF-8` (ou `fr_CA.UTF-8`) générée **et** le drapeau `L` dans le format de l'horloge.
- Les icônes (météo, etc.) sont des glyphes Nerd Font / Material Design : assure-toi que **JetBrainsMono Nerd Font** est installée, sinon elles apparaissent en carrés.
- Le rétroéclairage et l'aura du clavier ne concernent que les portables **ASUS** ; le reste fonctionne sur n'importe quel matériel.
- Le module OBS reste **masqué tant qu'OBS n'est pas lancé** avec le serveur WebSocket activé ; il nécessite `obs-cmd` (hors apt). Voir [Module OBS](#module-obs-enregistrement).
- Testé sur KDE Plasma 6 avec KWin Wayland (Kubuntu 26.04).

---

## Crédits

Fait partie de [ineedabuff/buff-kde](https://github.com/ineedabuff/buff-kde). Configuration dérivée de [prudhvibungatavula/socrates-KDE](https://github.com/prudhvibungatavula/socrates-KDE), elle-même inspirée de [pewdiepie-archdaemon/dionysus](https://github.com/pewdiepie-archdaemon/dionysus) : scripts réécrits pour KDE Plasma Wayland, portés sur Debian/Ubuntu, puis personnalisés.
