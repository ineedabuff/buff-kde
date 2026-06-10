# Waybar sur KDE Plasma Wayland
```
 Conçu pour Kubuntu 26.04 / Ubuntu - KDE Plasma 6 (KWin Wayland)
```

## C'est quoi ?

La plupart des dotfiles Waybar sont faits pour Hyprland. Ici, c'est une configuration Waybar entièrement personnalisée qui tourne sous **KDE Plasma Wayland** : tu obtiens le look d'un bureau Hyprland fortement « ricé » tout en gardant la commodité de KDE (installation d'applis facile, widgets Plasma, meilleure autonomie, stabilité).

Inspiré du rice Arch/Hyprland de PewDiePie, mais reconstruit de zéro pour KDE. Cette branche est adaptée pour **Kubuntu 26.04 / Ubuntu** (apt à la place de pacman) et Plasma 6.

---

## À quoi ça ressemble

La barre est divisée en trois sections :

**Gauche :** Horloge → Menu d'extinction → Réseau → Bluetooth → Micro → Média

**Centre :** Bureau 1 → Bureau 2 → Mode GPU → Bureau 3 → Bureau 4

**Droite :** Batterie → Volume → Luminosité

---

## Fonctionnalités

### Horloge
Heure au format 24 h (`HH:MM`). Le clic gauche bascule vers la date complète (`jour, JJ mois AAAA`) ; l'infobulle affiche un calendrier.

### Bureaux (workspaces)
Des scripts personnalisés remplacent le `hyprctl` de Hyprland par l'interface DBus `qdbus6` de KDE. Chaque bureau affiche un chiffre télougou (`1 2 3 4`) quand il est inactif, et un cercle plein (`⬤`) orange quand il est actif. Un clic change de bureau. Les UUID sont propres à KDE et doivent être mis à jour sur une nouvelle installation (voir plus bas).

> **Note Ubuntu :** sur Kubuntu, le binaire Qt6 `qdbus` est fourni par le paquet `qdbus-qt6`, mais il **ne s'appelle pas** `qdbus6` et **n'est pas** dans ton `PATH`. L'installeur crée un lien `/usr/local/bin/qdbus6` pour que les scripts de bureaux et le watcher fonctionnent. Sans ça, les bureaux restent vides.

### Animation de glissement
Quand tu changes de bureau, Waybar redémarre et glisse depuis le haut comme un rideau. Un script « watcher » interroge KWin toutes les 150 ms, avec une vérification de stabilisation de 150 ms : si tu changes rapidement de bureau, il attend que tu t'arrêtes avant de redémarrer. Ça évite les saccades tout en gardant l'animation réactive.

> **Tu ne veux pas l'animation ?** Désactive simplement le service watcher et lance Waybar normalement : tout le reste continue de fonctionner parfaitement.
> ```bash
> systemctl --user disable waybar-watcher.service
> systemctl --user stop waybar-watcher.service
> waybar &
> ```

### Protection contre la rémanence OLED
Sur un écran OLED, les éléments statiques (comme une barre toujours visible) peuvent causer une rémanence (« burn-in ») avec le temps. Le watcher redémarre Waybar à chaque changement de bureau : la barre disparaît puis réapparaît brièvement, ce qui fait naturellement « tourner » les pixels situés sous la barre. Combiné à l'animation de glissement, la barre ne reste jamais complètement statique trop longtemps. Si tu n'es **pas** sur OLED, tu peux désactiver ce comportement comme ci-dessus.

### Média (lecture en cours)
Remplace l'ancien module ProtonVPN. Lit la lecture de n'importe quel lecteur compatible MPRIS via `playerctl`.
- **La barre affiche** : icône du lecteur + icône lecture/pause + `Artiste — Titre` (ex. `  Daft Punk — Get Lucky`)
- Donne la priorité à **Spotify** s'il tourne, sinon revient au lecteur actif le plus récent (navigateurs, VLC, mpv, etc.)
- Se masque automatiquement quand rien ne joue
- **Clic gauche** : lecture / pause
- **Molette vers le haut** : piste suivante
- **Molette vers le bas** : piste précédente
- Les titres longs sont tronqués ; les titres contenant `& < >` sont correctement échappés

> Nécessite `playerctl` (installé par le script). Spotify expose MPRIS nativement ; pour Firefox, active `media.hardwaremediakeys.enabled` dans `about:config` si les commandes ne répondent pas.

### Bluetooth
- **La barre affiche** : icône du type d'appareil + nom court + % de batterie avec icône colorée
  - Vert = au-dessus de 50 %, Orange = 20–50 %, Rouge = en dessous de 20 %
  - Icônes : casque `󰋋`, souris `󰍽`, clavier `󰌌`, téléphone `󰄜`, enceinte `󰓃`
- **Clic gauche** : active/désactive le Bluetooth et reconnecte automatiquement les appareils appairés
- **Clic droit** : sélecteur rofi listant tous les appareils appairés avec leur icône de type
- **Infobulle** : liste tous les appareils connectés et appairés avec leur niveau de batterie

### Wi‑Fi / Réseau
- **La barre affiche** : l'icône de signal Wi‑Fi (`󰤨 󰤥 󰤢 󰤟 󰤯`) **suivie de l'adresse IP** courante (en filaire : l'icône ethernet + l'IP)
- **Clic gauche** : ouvre les réglages réseau de KDE (`kcmshell6 kcm_networkmanagement`)
- **Clic droit** : ouvre un sélecteur de réseaux rofi trié par force du signal
  - Clic sur un réseau connu → connexion immédiate
  - Clic sur un réseau inconnu → invite de mot de passe
  - Clic sur le réseau connecté → déconnexion
- **Infobulle** : SSID, force du signal, IP/CIDR, et débits descendant/montant

### Luminosité
Un seul module qui passe d'un écran à l'autre avec le **clic gauche** :
- 💻 **Écran du portable** (`intel_backlight`) : molette pour ajuster
- 🖥️ **Écran externe** (DDC/CI via `ddcutil`) : molette pour ajuster
- ⌨️ **Rétroéclairage du clavier** (`asus::kbd_backlight`, niveaux : Off/Low/Mid/High) : molette pour ajuster

**Clic droit** : ouvre le sélecteur de modes aura du clavier (couleur fixe, respiration, vague arc-en-ciel, cycle arc-en-ciel, pulsation).

> La luminosité de l'écran externe nécessite la prise en charge DDC/CI et l'utilisateur dans le groupe `i2c`.
> Si ton écran ne gère pas le DDC, seules la luminosité du portable et du clavier fonctionneront.

### Volume
- **La barre affiche** : icône de volume + barre ASCII + pourcentage
- **Clic gauche** : couper/rétablir le son
- **Clic droit** : sélecteur de sortie audio rofi (casque, enceintes, HDMI… déplace tous les flux actifs instantanément)
- **Molette** : volume +/- par pas de 5 %

### Batterie
- **La barre affiche** : icône de batterie + barre ASCII + pourcentage avec seuils colorés (cyan/orange/rouge)
- **Clic gauche** : ouvre les réglages d'énergie de KDE (`kcmshell6 powerdevilprofilesconfig`)
- **Infobulle** : état de charge, temps restant (décharge/charge), puissance de décharge (watts), tension
- Détecte automatiquement le chemin de la batterie (BAT0, BAT1, etc.) et ignore les batteries non-portable (ex. une souris Bluetooth)

### Mode GPU SuperGFX (ASUS uniquement)
- **La barre affiche** : le mode GPU courant : `[ IGP ]` (intégré), `[ HYB ]` (hybride), `[ dGPU ]` (MUX)
- **Clic gauche** : sélecteur rofi pour changer de mode
- Nécessite `supergfxctl`/`asusctl`, qui **ne sont pas packagés sur Ubuntu**. Sur une machine non-ASUS (ou sans ces outils), le module reste simplement inactif — voir [Retirer le module GPU](#retirer-le-module-gpu-asus).

### Micro
- **Clic gauche** : couper/rétablir le micro par défaut via `pactl`

### Menu d'extinction
- **Clic gauche** : ouvre un menu d'extinction rofi via `powermenu.sh`

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
    ├── asus-gpu-switch.sh          # Sélecteur de mode GPU SuperGFX (ASUS)
    ├── asus-profile.sh             # État du mode GPU SuperGFX (ASUS)
    ├── audio-switcher.sh           # Sélecteur de sortie audio rofi
    ├── battery.sh                  # État batterie avec barre ASCII
    ├── bluetooth-menu.sh           # Sélecteur d'appareils Bluetooth rofi
    ├── bluetooth-status.sh         # État Bluetooth (appareil + batterie)
    ├── bluetooth-toggle.sh         # Bascule Bluetooth + reconnexion auto
    ├── brightness-scroll-down.sh   # Baisser la luminosité de l'écran actif
    ├── brightness-scroll-up.sh     # Monter la luminosité de l'écran actif
    ├── brightness-toggle-display.sh # Cycle portable/écran externe/clavier
    ├── brightness.sh               # État de luminosité de l'écran actif
    ├── kbd-aura.sh                 # Sélecteur de modes/couleurs aura clavier
    ├── media.sh                    # Module lecture en cours (MPRIS via playerctl)
    ├── mic.sh                      # État de coupure du micro
    ├── powermenu.sh                # Menu d'extinction rofi
    ├── volume.sh                   # État volume avec barre ASCII
    ├── waybar-watcher.sh           # Watcher de changement de bureau KWin
    ├── wifi-menu.sh                # Sélecteur de réseaux Wi‑Fi rofi
    └── workspaces/
        ├── switch.sh               # Basculer vers un bureau KWin donné
        ├── workspace-1.sh          # État du bureau 1 (KWin)
        ├── workspace-2.sh          # État du bureau 2 (KWin)
        ├── workspace-3.sh          # État du bureau 3 (KWin)
        └── workspace-4.sh          # État du bureau 4 (KWin)
```

> Les anciens scripts `protonvpn-status.sh`, `protonvpn-toggle.sh` et `vpn-countries.sh` ne sont plus utilisés et peuvent être supprimés.

---

## Dépendances

Tout installer avec apt :
```bash
sudo apt update
sudo apt install -y waybar brightnessctl ddcutil rofi network-manager \
                    pipewire wireplumber pipewire-pulse pulseaudio-utils \
                    bluez upower playerctl qdbus-qt6 kde-cli-tools \
                    fontconfig curl unzip
```

Ajoute-toi au groupe `i2c` pour la luminosité de l'écran externe (DDC) :
```bash
sudo usermod -aG i2c $USER
sudo modprobe i2c-dev
```

**Polices :** la barre utilise JetBrainsMono Nerd Font, qui n'est pas dans apt. L'installeur la télécharge automatiquement depuis [nerd-fonts](https://github.com/ryanoasis/nerd-fonts) ; pour le faire à la main, place la police dans `~/.local/share/fonts/` puis lance `fc-cache -f`.

**`qdbus6` :** fourni par `qdbus-qt6`. Sur Ubuntu, le binaire se trouve hors du `PATH` ; crée donc le lien que fait l'installeur :
```bash
sudo ln -sf /usr/lib/qt6/bin/qdbus /usr/local/bin/qdbus6
```

---

## Installation

### 1. Cloner le dépôt
```bash
git clone https://github.com/prudhvibungatavula/socrates-KDE ~/socrates-KDE
cp -r ~/socrates-KDE/waybar ~/.config/waybar
```

### 2. Lancer l'installeur (recommandé)
Il gère les dépendances, le lien `qdbus6`, la police Nerd Font, la détection batterie/rétroéclairage, et les services systemd :
```bash
chmod +x ~/.config/waybar/install.sh
~/.config/waybar/install.sh
```

### 3. Rendre les scripts exécutables (installation manuelle)
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
Mets à jour l'UUID dans chaque `scripts/workspaces/workspace-*.sh` et dans les lignes `on-click` du `config`.

### 5. Installer les services systemd (optionnel mais recommandé)
```bash
cp ~/.config/waybar/waybar.service ~/.config/systemd/user/
cp ~/.config/waybar/waybar-watcher.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable waybar.service waybar-watcher.service
systemctl --user start waybar.service waybar-watcher.service
```

### 6. Ou lancer manuellement
```bash
waybar &
```

> Assure-toi d'être connecté sur la session **Plasma (Wayland)**, et non X11.

---

## Configuration

### Désactiver l'animation des bureaux (hors OLED)
```bash
systemctl --user disable waybar-watcher.service
systemctl --user stop waybar-watcher.service
```
Waybar restera lancé en permanence sans redémarrer.

### Choisir le lecteur média suivi par la barre
Par défaut, `media.sh` privilégie Spotify puis revient au lecteur le plus récent. Pour le fixer sur un lecteur précis, édite `scripts/media.sh` et force le nom du lecteur :
```bash
player="firefox"   # à la place du bloc de détection automatique
```
Lance `playerctl -l` pour lister les lecteurs disponibles.

### Retirer le module GPU (ASUS)
Si tu n'es pas sur un portable ASUS, retire `"custom/asus-profile"` de `modules-center` dans `config` (le centre ne contient alors plus que les quatre bureaux).

### Désactiver la luminosité de l'écran externe
Si tu n'as pas d'écran compatible DDC, édite `brightness-toggle-display.sh` et supprime le cas `monitor` : le cycle se fera entre portable et clavier seulement.

### Changer les couleurs aura du clavier
Édite `kbd-aura.sh` pour ajouter ou retirer des couleurs de la palette (valeurs hexa standard, ex. `ff00ff`).

---

## Notes

- Les UUID des bureaux changent à chaque nouvelle installation de KDE : pense à les mettre à jour
- Sur Ubuntu, `qdbus6` n'est pas dans le `PATH` par défaut : l'installeur ajoute le lien `/usr/local/bin/qdbus6`
- `supergfxctl`/`asusctl` ne sont pas dans les dépôts Ubuntu : compile-les ou utilise un PPA si tu as besoin du changement de GPU
- Testé sur KDE Plasma 6 avec KWin Wayland (Kubuntu 26.04)

---

## Crédits

Structure de configuration inspirée de [pewdiepie-archdaemon/dionysus](https://github.com/pewdiepie-archdaemon/dionysus) : tous les scripts réécrits pour KDE Plasma Wayland, puis portés sur Kubuntu/Ubuntu.
