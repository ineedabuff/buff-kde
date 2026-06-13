# buff-KDE

```
<<<<<<< HEAD
Un rice KDE Plasma Wayland complet
Conçu sur Kubuntu 26.04 — ASUS Vivobook V16 2025
=======
A complete KDE Plasma Wayland rice
Built on Kubuntu 26.04 — ASUS Vivobook V16 2025
>>>>>>> 7d725b6865da7c46b2ceb0dc9bb46f030e066317
```

---

## L'histoire

<<<<<<< HEAD
Je tourne sous Kubuntu sur un ASUS Vivobook V16 (2025). Quand je me suis mis au
ricing sous Linux, presque tout ce que je trouvais en ligne était fait pour
Hyprland — les dotfiles, les guides, les vidéos YouTube. Quasiment personne ne
documentait comment obtenir le même rendu sous **KDE Plasma Wayland**, et encore
moins sur une base Debian/Ubuntu plutôt qu'Arch.

Je ne voulais pas quitter KDE. Il m'apporte des choses sur lesquelles je compte :
installation d'applis stable via `apt`, widgets Plasma, bonne autonomie d'origine,
et une vraie interface de réglages quand j'en ai besoin. Mais je voulais quand
même que mon bureau ait l'allure d'un vrai rice. Inspiré par le setup Arch/Hyprland
de PewDiePie, j'ai décidé de reconstruire ce style moi-même sur Kubuntu.

L'écran OLED a ajouté un autre problème. Les éléments d'interface statiques qui
restent au même endroit pendant des heures provoquent une rémanence (« burn-in »)
sur les dalles OLED. Je n'ai trouvé aucune solution documentée pour empêcher la
rémanence de Waybar sous KDE Wayland, alors j'en ai construit une — un script
« watcher » qui redémarre Waybar à chaque changement de bureau, ce qui fait
tourner les pixels sous la barre et évite la rétention statique. Il sert aussi de
déclencheur d'animation : la barre glisse depuis le haut à chaque changement de
bureau.

L'essentiel a dû être adapté de zéro. Les dotfiles Arch/AUR que je trouvais ne
fonctionnaient pas tels quels sur Kubuntu, donc tout ce qui n'existait que dans
l'AUR a dû être compilé depuis les sources ou remplacé par un équivalent `apt`.
=======
I run Kubuntu on an ASUS Vivobook V16 (2025). When I got into Linux ricing,
almost everything I found online was built for Hyprland — the dotfiles, the
guides, the YouTube videos. Almost nobody documented how to get the same look
and feel on **KDE Plasma Wayland**, and even fewer people did it on a
Debian/Ubuntu base instead of Arch.

I didn't want to leave KDE. It gives me things I rely on: stable app installs
through `apt`, Plasma widgets, good battery life out of the box, and a proper
settings GUI when I need one. But I still wanted my desktop to look and feel
like a real rice. Inspired by PewDiePie's Arch/Hyprland setup, I decided to
rebuild that vibe on Kubuntu myself.

The OLED screen added another problem. Static UI elements sitting in the same
position for hours cause burn-in on OLED panels. I couldn't find a single
documented solution for preventing Waybar burn-in on KDE Wayland, so I built
one — a watcher script that restarts Waybar on every workspace switch, cycling
the pixels under the bar and preventing static retention. It doubles as a
slide-down animation trigger, so the bar drops from the top every time you
switch desktops.

Most of this had to be adapted from scratch. The Arch/AUR dotfiles I found
didn't work on Kubuntu out of the box, so anything that lived only in the AUR
had to be built from source or swapped for an `apt` equivalent.
>>>>>>> 7d725b6865da7c46b2ceb0dc9bb46f030e066317

---

## Contenu du dépôt

```
buff-kde/
<<<<<<< HEAD
├── HackerCyan-Spicetify-main/   Thème Spotify HackerCyan (Spicetify)
├── waybar/                      Barre Waybar personnalisée + suite de scripts
├── klassy/                      Config de décoration de fenêtres Klassy
├── krohnkite/                   Script de tiling KWin
├── kde/                         Configs globales KDE
├── themes/                      Schémas de couleurs et réglages GTK
├── wallpapers/                  Fonds d'écran utilisés dans le setup
└── README.md                    Ce fichier
=======
├── HackerCyan-Spicetify-main/   HackerCyan Spotify (Spicetify) theme
├── waybar/                      Custom Waybar bar with full script suite
├── klassy/                      Klassy window decoration config
├── krohnkite/                   KWin tiling script
├── kde/                         KDE global configs
├── themes/                      Color schemes and GTK settings
├── wallpapers/                  Wallpapers used in the setup
└── README.md                    This file
>>>>>>> 7d725b6865da7c46b2ceb0dc9bb46f030e066317
```

---

<<<<<<< HEAD
## Composants

| Composant              | Valeur                       |
| ---------------------- | ---------------------------- |
| OS                     | Kubuntu 26.04 (base Ubuntu)  |
| Bureau                 | KDE Plasma 6 sous Wayland    |
| Barre                  | Waybar                       |
| Décoration de fenêtres | Klassy                       |
| Schéma de couleurs     | Main (inclus dans le dépôt)  |
| Thème Plasma           | Sweet                        |
| Icônes                 | Papirus-Dark                 |
| Police                 | JetBrains Mono Medium 11     |
| Curseur                | capitaine-cursors-light      |
| Tiling                 | Krohnkite (script KWin)      |
| Terminal               | Konsole                      |
| Spotify                | Spicetify + HackerCyan       |
=======
## Theme Stack

| Component         | Value                       |
| ----------------- | --------------------------- |
| OS                | Kubuntu 26.04 (Ubuntu-based)|
| Desktop           | KDE Plasma 6 on Wayland     |
| Bar               | Waybar                      |
| Window decoration | Klassy                      |
| Color scheme      | Main (included in repo)     |
| Plasma theme      | Sweet                       |
| Icons             | Papirus-Dark                |
| Font              | JetBrains Mono Medium 11    |
| Cursor            | capitaine-cursors-light     |
| Tiling            | Krohnkite (KWin script)     |
| Terminal          | Konsole                     |
| Spotify           | Spicetify + HackerCyan      |
>>>>>>> 7d725b6865da7c46b2ceb0dc9bb46f030e066317

---

## Waybar

<<<<<<< HEAD
La pièce maîtresse de ce rice. Une Waybar entièrement personnalisée qui tourne
sous KDE Plasma Wayland — ce que presque personne n'avait documenté avant,
surtout sur une base Debian/Ubuntu.

**Principaux défis résolus :**

- Scripts de bureaux réécrits du `hyprctl` de Hyprland vers le DBus de KWin
  (`qdbus6`) — les bureaux détectent le bureau actif et se mettent en surbrillance
- Prévention de la rémanence OLED via un script watcher qui redémarre Waybar à
  chaque changement de bureau
- Animation de glissement (effet rideau) au changement de bureau
- Luminosité d'un écran externe via DDC/CI (`ddcutil`) sans X11
- Module média basé sur MPRIS (`playerctl`), avec priorité à Spotify
=======
The centerpiece of this rice. A fully custom Waybar running on KDE Plasma
Wayland — something almost nobody had documented before, especially on a
Debian/Ubuntu base.

**Key challenges solved:**

- Workspace scripts rewritten from Hyprland (`hyprctl`) to KWin DBus (`qdbus6`) —
  workspaces detect the active desktop and highlight accordingly
- OLED burn-in prevention via a watcher script that restarts Waybar on every
  workspace switch
- Slide-down curtain animation on workspace switch
- External monitor brightness via DDC/CI (`ddcutil`) without X11
- ProtonVPN CLI/GUI conflict resolution

> **ASUS / hardware-specific modules.** Some modules depend on your exact
> hardware (a dGPU + MUX switch, ASUS-specific firmware controls, etc.). On the
> Vivobook V16 they may not apply — they are optional and the install script
> asks before enabling them.

**Modules:**

- Clock with calendar tooltip
- Power menu (rofi)
- Network with WiFi picker (rofi, signal strength icons)
- Bluetooth with device type icon, name and battery level
- Microphone mute indicator
- ProtonVPN with country picker (60+ countries, Secure Core, P2P, Tor)
- Workspace switcher (1-4, KWin DBus)
- GPU mode indicator *(optional, ASUS dGPU/MUX only)*
- Battery with ASCII bar, discharge rate, voltage
- Volume with ASCII bar and audio output switcher
- Brightness cycling between laptop screen, external monitor and keyboard
  backlight *(keyboard aura picker is ASUS-only)*
>>>>>>> 7d725b6865da7c46b2ceb0dc9bb46f030e066317

> **Modules ASUS / spécifiques au matériel.** Certains modules dépendent de ton
> matériel exact (un dGPU + interrupteur MUX, des contrôles firmware propres à
> ASUS, etc.). Sur le Vivobook V16 ils peuvent ne pas s'appliquer — ils sont
> optionnels et le script d'installation demande avant de les activer.

**Modules :**

- Horloge avec calendrier en infobulle
- Menu d'extinction (rofi)
- Réseau avec sélecteur Wi-Fi (rofi, icônes de force du signal)
- Bluetooth avec icône de type d'appareil, nom et niveau de batterie
- Indicateur de coupure du micro
- Média : lecture en cours via MPRIS (`playerctl`), priorité à Spotify
- Sélecteur de bureaux (1-4, DBus KWin)
- Indicateur de mode GPU *(optionnel, ASUS dGPU/MUX uniquement)*
- Batterie avec barre ASCII, puissance de décharge, tension
- Volume avec barre ASCII et sélecteur de sortie audio
- Luminosité cyclant entre écran du portable, écran externe et rétroéclairage
  clavier *(le sélecteur d'aura clavier est ASUS uniquement)*

Voir `waybar/README.md` pour la documentation complète et les instructions
d'installation.

---

## Installation — paquets

Kubuntu n'a pas l'AUR : les paquets viennent d'`apt` quand ils existent, et
quelques composants sont compilés depuis les sources ou installés manuellement.

**Depuis les dépôts Ubuntu :**

```bash
sudo apt update
sudo apt install waybar rofi ddcutil papirus-icon-theme fonts-jetbrains-mono
```

> Le paquet `waybar` des dépôts Ubuntu peut être en retard sur l'amont. Si un
> module se comporte mal, compile plutôt la dernière version de Waybar depuis
> les sources.

**Compilés depuis les sources / installés manuellement** (absents des dépôts
Ubuntu) :

- **Klassy** — voir la section *Klassy* ci-dessous
- Thème Plasma **Sweet** — à installer via Configuration du système → Obtenir du
  nouveau contenu, ou depuis le projet d'origine
- **capitaine-cursors** — à installer depuis les releases d'origine si `apt` ne
  le propose pas sur ta version

---

## Install — packages

Kubuntu doesn't have the AUR, so packages come from `apt` where they exist, and
a few components are built from source or installed manually.

**From the Ubuntu repos:**

```bash
sudo apt update
sudo apt install waybar rofi ddcutil papirus-icon-theme fonts-jetbrains-mono
```

> `waybar` in the Ubuntu repos can lag behind upstream. If a module misbehaves,
> build the latest Waybar from source instead.

**Built from source / installed manually** (not in the Ubuntu repos):

- **Klassy** — see the *Klassy* section below
- **Sweet** Plasma theme — install from System Settings → Get New, or from the
  upstream project
- **capitaine-cursors** — install from the upstream releases if `apt` doesn't
  carry it on your release

---

## Klassy

<<<<<<< HEAD
Klassy est une décoration de fenêtres KDE qui donne un contrôle précis sur le
style de la barre de titre, l'apparence des boutons, les espacements et les
bordures. La config dans `klassy/klassyrc` est mon réglage perso — des barres de
titre minimales avec des bordures nettes assorties au schéma de couleurs.

Klassy n'est **pas packagé pour Ubuntu**, il faut donc le compiler depuis les
sources :

```bash
# installe d'abord les dépendances de build KDE/Qt6, puis :
git clone https://github.com/paulmcauley/klassy
cd klassy
./install.sh        # suis les instructions de build du README de Klassy
```

> Les dépendances de build exactes dépendent de ta version de Plasma/Qt — suis
> les instructions à jour du dépôt Klassy plutôt qu'une liste de paquets figée.

Applique ensuite la config et active-la :
=======
Klassy is a KDE window decoration that gives precise control over title bar
style, button appearance, spacing and borders. The config in `klassy/klassyrc`
is my personal setup — minimal title bars with clean borders that match the
color scheme.

Klassy is **not packaged for Ubuntu**, so build it from source:

```bash
# install the KDE/Qt6 build dependencies, then:
git clone https://github.com/paulmcauley/klassy
cd klassy
./install.sh        # follow the build instructions in the Klassy README
```

> The exact build dependencies depend on your Plasma/Qt version — follow the
> current instructions in the Klassy repo rather than a fixed package list.

Then apply the config and enable it:
>>>>>>> 7d725b6865da7c46b2ceb0dc9bb46f030e066317

```bash
mkdir -p ~/.config/klassy
cp klassy/klassyrc ~/.config/klassy/klassyrc
```

<<<<<<< HEAD
Applique dans Configuration du système → Décorations de fenêtres → Klassy.
=======
Apply in System Settings → Window Decorations → Klassy.
>>>>>>> 7d725b6865da7c46b2ceb0dc9bb46f030e066317

---

## Krohnkite

<<<<<<< HEAD
Krohnkite est un script de tiling KWin qui ajoute le tiling dynamique à KDE —
proche d'i3 ou Hyprland, mais tournant nativement dans KWin. Les fenêtres se
placent automatiquement à l'ouverture et tu peux redimensionner par glissement.

Krohnkite est un `.kwinscript` indépendant de la distribution, donc pas besoin de
l'AUR — installe la copie incluse dans ce dépôt :

```bash
kpackagetool6 --type=KWin/Script --install krohnkite/krohnkite
# ou, manuellement :
cp -r krohnkite/krohnkite ~/.local/share/kwin/scripts/
```

Active-le ensuite dans Configuration du système → Gestion des fenêtres → Scripts
KWin → Krohnkite.
=======
Krohnkite is a KWin tiling script that adds dynamic tiling to KDE — similar to
i3 or Hyprland but running natively inside KWin. Windows tile automatically when
you open them and you can drag to resize.

Krohnkite is a distro-independent `.kwinscript`, so no AUR needed — install the
copy included in this repo:

```bash
kpackagetool6 --type=KWin/Script --install krohnkite/krohnkite
# or, manually:
cp -r krohnkite/krohnkite ~/.local/share/kwin/scripts/
```

Then enable in System Settings → Window Management → KWin Scripts → Krohnkite.
>>>>>>> 7d725b6865da7c46b2ceb0dc9bb46f030e066317

---

## Configs KDE

Le dossier `kde/` contient :

<<<<<<< HEAD
| Fichier              | Rôle                                                  |
| -------------------- | ----------------------------------------------------- |
| `kdeglobals`         | Réglages globaux KDE — couleurs, polices, thème d'icônes |
| `kwinrc`             | Config KWin — effets, tiling, règles de fenêtres      |
| `plasmarc`           | Réglages du thème Plasma                              |
| `plasmashellrc`      | Disposition et visibilité des panneaux                |
| `kglobalshortcutsrc` | Tous les raccourcis clavier                           |
| `kscreenlockerrc`    | Config de l'écran de verrouillage                     |

**Appliquer :**

=======
| File                 | What it does                                    |
| -------------------- | ----------------------------------------------- |
| `kdeglobals`         | Global KDE settings - colors, fonts, icon theme |
| `kwinrc`             | KWin config - effects, tiling, window rules     |
| `plasmarc`           | Plasma theme settings                           |
| `plasmashellrc`      | Panel layout and visibility settings            |
| `kglobalshortcutsrc` | All keyboard shortcuts                          |
| `kscreenlockerrc`    | Lock screen config                              |

**Apply:**

>>>>>>> 7d725b6865da7c46b2ceb0dc9bb46f030e066317
```bash
cp kde/kdeglobals ~/.config/kdeglobals
cp kde/kwinrc ~/.config/kwinrc
cp kde/plasmarc ~/.config/plasmarc
cp kde/plasmashellrc ~/.config/plasmashellrc
cp kde/kglobalshortcutsrc ~/.config/kglobalshortcutsrc
```

<<<<<<< HEAD
Déconnecte-toi puis reconnecte-toi après application.
=======
Log out and back in after applying.
>>>>>>> 7d725b6865da7c46b2ceb0dc9bb46f030e066317

---

## Thèmes

Le dossier `themes/` contient :

<<<<<<< HEAD
- `color-schemes/Main.colors` — le schéma de couleurs principal utilisé dans tout
  le setup
- `gtk/gtk3-settings.ini` — thème des applis GTK3 (icônes, police, curseur)
- `gtk/gtk4-settings.ini` — thème des applis GTK4

**Installer le schéma de couleurs :**

=======
- `color-schemes/Main.colors` — the primary color scheme used across the whole
  setup
- `gtk/gtk3-settings.ini` — GTK3 app theming (icon theme, font, cursor)
- `gtk/gtk4-settings.ini` — GTK4 app theming

**Install color scheme:**

>>>>>>> 7d725b6865da7c46b2ceb0dc9bb46f030e066317
```bash
mkdir -p ~/.local/share/color-schemes
cp themes/color-schemes/Main.colors ~/.local/share/color-schemes/
```
<<<<<<< HEAD

Applique ensuite dans Configuration du système → Couleurs et thèmes → Couleurs →
Main.

**Installer les réglages GTK :**
=======

Then apply in System Settings → Colors & Themes → Colors → Main.

**Install GTK settings:**
>>>>>>> 7d725b6865da7c46b2ceb0dc9bb46f030e066317

```bash
cp themes/gtk/gtk3-settings.ini ~/.config/gtk-3.0/settings.ini
cp themes/gtk/gtk4-settings.ini ~/.config/gtk-4.0/settings.ini
```

<<<<<<< HEAD
**Icônes / police (depuis les dépôts Ubuntu) :**
=======
**Icons / font (from the Ubuntu repos):**
>>>>>>> 7d725b6865da7c46b2ceb0dc9bb46f030e066317

```bash
sudo apt install papirus-icon-theme fonts-jetbrains-mono
```

---

## Spotify — Spicetify + HackerCyan
<<<<<<< HEAD

Le dossier `HackerCyan-Spicetify-main/` est le thème HackerCyan pour Spotify,
appliqué via Spicetify.

**Installer Spicetify** (indépendant de la distribution) :

```bash
curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
```

**Appliquer le thème HackerCyan :**

```bash
# copie le dossier du thème dans le répertoire Themes de Spicetify
cp -r HackerCyan-Spicetify-main/HackerCyan ~/.config/spicetify/Themes/

spicetify config current_theme HackerCyan
spicetify apply
```

> Ajuste le chemin source pour correspondre au nom réel du dossier de thème dans
> `HackerCyan-Spicetify-main/`. Si Spotify a été installé en Snap/Flatpak, pointe
> d'abord Spicetify vers le bon chemin `prefs`/Apps (`spicetify config`).

---

## Fonds d'écran

Le dossier `wallpapers/` contient les fonds d'écran utilisés dans le setup :

```bash
=======

The `HackerCyan-Spicetify-main/` folder is the HackerCyan theme for Spotify,
applied through Spicetify.

**Install Spicetify** (distro-independent):

```bash
curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
```

**Apply the HackerCyan theme:**

```bash
# copy the theme folder into Spicetify's Themes directory
cp -r HackerCyan-Spicetify-main/HackerCyan ~/.config/spicetify/Themes/

spicetify config current_theme HackerCyan
spicetify apply
```

> Adjust the source path to match the actual theme folder name inside
> `HackerCyan-Spicetify-main/`. If Spotify was installed as a Snap/Flatpak,
> point Spicetify at the right `prefs`/Apps path first (`spicetify config`).

---

## Wallpapers

The `wallpapers/` folder contains the wallpapers used in the setup:

```bash
>>>>>>> 7d725b6865da7c46b2ceb0dc9bb46f030e066317
mkdir -p ~/.local/share/wallpapers
cp wallpapers/* ~/.local/share/wallpapers/
```

<<<<<<< HEAD
Puis clic droit sur le bureau → Configurer le bureau et le fond d'écran → choisis-en
un.
=======
Then right click the desktop → Configure Desktop and Wallpaper → pick one.
>>>>>>> 7d725b6865da7c46b2ceb0dc9bb46f030e066317

---

## Installation rapide

Clone le dépôt, copie la config Waybar puis lance l'installeur :

```bash
git clone https://github.com/ineedabuff/buff-kde ~/buff-kde
<<<<<<< HEAD
cp -r ~/buff-kde/waybar ~/.config/waybar
chmod +x ~/.config/waybar/executable_install.sh
~/.config/waybar/executable_install.sh
```

L'installeur gère les dépendances, détecte automatiquement les chemins matériels
et met en place les services systemd. Pour le reste du setup (Klassy, Krohnkite,
thèmes, Spicetify), suis les sections ci-dessus.
=======
cd ~/buff-kde/waybar
./install.sh
```

The install script handles dependencies, auto-detects hardware paths, and sets
up systemd services. For the rest of the setup (Klassy, Krohnkite, themes,
Spicetify) follow the sections above.
>>>>>>> 7d725b6865da7c46b2ceb0dc9bb46f030e066317

---

## Prérequis

<<<<<<< HEAD
- Kubuntu 26.04, ou une autre distribution basée sur Ubuntu/Debian
- KDE Plasma 6 sous Wayland
- `apt` pour la plupart des paquets ; quelques composants (Klassy, Sweet,
  capitaine-cursors) sont compilés ou installés depuis les sources car ils ne
  sont pas dans les dépôts Ubuntu

> La plupart des choses fonctionnent sur n'importe quel setup KDE Wayland. Les
> modules spécifiques au matériel (changement de GPU dGPU/MUX, aura clavier) sont
> optionnels et le script d'installation pose la question.
=======
- Kubuntu 26.04, or another Ubuntu/Debian-based distro
- KDE Plasma 6 on Wayland
- `apt` for most packages; a few components (Klassy, Sweet, capitaine-cursors)
  are built or installed from source because they aren't in the Ubuntu repos

> Most things work on any KDE Wayland setup. Hardware-specific modules
> (dGPU/MUX GPU switching, keyboard aura) are optional and the install script
> will ask about them.
>>>>>>> 7d725b6865da7c46b2ceb0dc9bb46f030e066317

---

## Utilisateurs OLED

<<<<<<< HEAD
Si tu es sur un écran OLED, garde le service watcher de Waybar activé. Il
redémarre Waybar à chaque changement de bureau, ce qui fait tourner les pixels
sous la barre et évite la rémanence. Si tu n'es **pas** sur OLED, tu peux le
désactiver :
=======
If you are on an OLED display, keep the Waybar watcher service enabled. It
restarts Waybar on every workspace switch, which cycles the pixels under the bar
and prevents burn-in. If you are not on OLED, you can disable it:
>>>>>>> 7d725b6865da7c46b2ceb0dc9bb46f030e066317

```bash
systemctl --user disable waybar-watcher.service
systemctl --user stop waybar-watcher.service
```

---

## Crédits

<<<<<<< HEAD
Ce rice est adapté à Kubuntu / KDE Plasma Wayland depuis
[prudhvibungatavula/socrates-KDE](https://github.com/prudhvibungatavula/socrates-KDE),
dont la structure de configuration Waybar s'inspirait à l'origine de
[pewdiepie-archdaemon/dionysus](https://github.com/pewdiepie-archdaemon/dionysus).
Scripts et étapes d'installation retravaillés pour une base Debian/Ubuntu.
=======
This rice is adapted to Kubuntu / KDE Plasma Wayland from
[prudhvibungatavula/socrates-KDE](https://github.com/prudhvibungatavula/socrates-KDE),
whose Waybar config structure was originally inspired by
[pewdiepie-archdaemon/dionysus](https://github.com/pewdiepie-archdaemon/dionysus).
Scripts and install steps were reworked for a Debian/Ubuntu base.
>>>>>>> 7d725b6865da7c46b2ceb0dc9bb46f030e066317
