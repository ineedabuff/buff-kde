# buff-KDE

```
Un rice KDE Plasma Wayland complet
Conçu sur Kubuntu 26.04 — ASUS Vivobook V16 2025
```

---

## L'histoire

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
« watcher » qui recharge Waybar à chaque changement de bureau, ce qui fait
tourner les pixels sous la barre et évite la rétention statique. Il sert aussi de
déclencheur d'animation : la barre glisse depuis le haut à chaque changement de
bureau.

L'essentiel a dû être adapté de zéro. Les dotfiles Arch/AUR que je trouvais ne
fonctionnaient pas tels quels sur Kubuntu, donc tout ce qui n'existait que dans
l'AUR a dû être compilé depuis les sources ou remplacé par un équivalent `apt`.

---

## Contenu du dépôt

```
buff-kde/
├── HackerCyan-Spicetify-main/   Thème Spotify HackerCyan (Spicetify)
├── waybar/                      Barre Waybar personnalisée + suite de scripts
├── klassy/                      Config de décoration de fenêtres Klassy
├── krohnkite/                   Script de tiling KWin
├── kde/                         Configs globales KDE
├── themes/                      Schémas de couleurs et réglages GTK
├── wallpapers/                  Fonds d'écran utilisés dans le setup
└── README.md                    Ce fichier
```

---

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

---

## Waybar

La pièce maîtresse de ce rice. Une Waybar entièrement personnalisée qui tourne
sous KDE Plasma Wayland — ce que presque personne n'avait documenté avant,
surtout sur une base Debian/Ubuntu.

**Principaux défis résolus :**

- Scripts de bureaux réécrits du `hyprctl` de Hyprland vers le DBus de KWin
  (`qdbus6`) — les bureaux détectent le bureau actif et se mettent en surbrillance
- Prévention de la rémanence OLED via un script watcher qui recharge Waybar à
  chaque changement de bureau (signal `SIGUSR2`, sans tuer le process)
- Animation de glissement (effet rideau) au changement de bureau
- Luminosité d'un écran externe via DDC/CI (`ddcutil`) sans X11
- Module média basé sur MPRIS (`playerctl`), avec priorité à Spotify
- Déclencheur d'enregistrement OBS via le serveur WebSocket (`obs-cmd`)

> **Modules ASUS / spécifiques au matériel.** Certains modules dépendent de ton
> matériel exact (un dGPU + interrupteur MUX, des contrôles firmware propres à
> ASUS, etc.). Sur le Vivobook V16 ils peuvent ne pas s'appliquer — ils sont
> optionnels.

**Modules :**

- Horloge — heure 24 h + date complète en français
- Météo (wttr.in) avec icône dynamique jour/nuit
- Réseau : adresse IP affichée + sélecteur Wi-Fi (rofi, icônes de force du signal)
- Bluetooth avec icône de type d'appareil, nom et niveau de batterie
- Média : lecture en cours via MPRIS (`playerctl`), priorité à Spotify
- OBS : déclencheur et état d'enregistrement (`obs-cmd` + WebSocket)
- Sélecteur de bureaux (1-4, DBus KWin)
- Batterie avec barre ASCII, puissance de décharge, tension
- Volume avec barre ASCII (3 couleurs selon le niveau) et sélecteur de sortie audio
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

## Klassy

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

```bash
mkdir -p ~/.config/klassy
cp klassy/klassyrc ~/.config/klassy/klassyrc
```

Applique dans Configuration du système → Décorations de fenêtres → Klassy.

---

## Krohnkite

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

---

## Configs KDE

Le dossier `kde/` contient :

| Fichier              | Rôle                                                      |
| -------------------- | -------------------------------------------------------- |
| `kdeglobals`         | Réglages globaux KDE — couleurs, polices, thème d'icônes |
| `kwinrc`             | Config KWin — effets, tiling, règles de fenêtres         |
| `plasmarc`           | Réglages du thème Plasma                                 |
| `plasmashellrc`      | Disposition et visibilité des panneaux                   |
| `kglobalshortcutsrc` | Tous les raccourcis clavier                              |
| `kscreenlockerrc`    | Config de l'écran de verrouillage                        |

**Appliquer :**

```bash
cp kde/kdeglobals ~/.config/kdeglobals
cp kde/kwinrc ~/.config/kwinrc
cp kde/plasmarc ~/.config/plasmarc
cp kde/plasmashellrc ~/.config/plasmashellrc
cp kde/kglobalshortcutsrc ~/.config/kglobalshortcutsrc
```

Déconnecte-toi puis reconnecte-toi après application.

---

## Thèmes

Le dossier `themes/` contient :

- `color-schemes/Main.colors` — le schéma de couleurs principal utilisé dans tout
  le setup
- `gtk/gtk3-settings.ini` — thème des applis GTK3 (icônes, police, curseur)
- `gtk/gtk4-settings.ini` — thème des applis GTK4

**Installer le schéma de couleurs :**

```bash
mkdir -p ~/.local/share/color-schemes
cp themes/color-schemes/Main.colors ~/.local/share/color-schemes/
```

Applique ensuite dans Configuration du système → Couleurs et thèmes → Couleurs →
Main.

**Installer les réglages GTK :**

```bash
cp themes/gtk/gtk3-settings.ini ~/.config/gtk-3.0/settings.ini
cp themes/gtk/gtk4-settings.ini ~/.config/gtk-4.0/settings.ini
```

**Icônes / police (depuis les dépôts Ubuntu) :**

```bash
sudo apt install papirus-icon-theme fonts-jetbrains-mono
```

---

## Spotify — Spicetify + HackerCyan

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
> `HackerCyan-Spicetify-main/`. Si Spotify a été installé en Snap/Flatpak, repasse
> d'abord sur la version `.deb` (Spicetify ne peut pas modifier un Spotify Snap/Flatpak).

---

## Fonds d'écran

Le dossier `wallpapers/` contient les fonds d'écran utilisés dans le setup :

```bash
mkdir -p ~/.local/share/wallpapers
cp wallpapers/* ~/.local/share/wallpapers/
```

Puis clic droit sur le bureau → Configurer le bureau et le fond d'écran → choisis-en
un.

---

## Installation rapide

Clone le dépôt, copie la config Waybar puis lance l'installeur :

```bash
git clone https://github.com/ineedabuff/buff-kde ~/buff-kde
cp -r ~/buff-kde/waybar ~/.config/waybar
chmod +x ~/.config/waybar/install.sh
~/.config/waybar/install.sh
```

L'installeur gère les dépendances, détecte automatiquement les chemins matériels
et met en place les services systemd. Pour le reste du setup (Klassy, Krohnkite,
thèmes, Spicetify), suis les sections ci-dessus.

---

## Prérequis

- Kubuntu 26.04, ou une autre distribution basée sur Ubuntu/Debian
- KDE Plasma 6 sous Wayland
- `apt` pour la plupart des paquets ; quelques composants (Klassy, Sweet,
  capitaine-cursors) sont compilés ou installés depuis les sources car ils ne
  sont pas dans les dépôts Ubuntu

> La plupart des choses fonctionnent sur n'importe quel setup KDE Wayland. Les
> modules spécifiques au matériel (changement de GPU dGPU/MUX, aura clavier) sont
> optionnels.

---

## Utilisateurs OLED

Si tu es sur un écran OLED, garde le service watcher de Waybar activé. Il
recharge Waybar à chaque changement de bureau, ce qui fait tourner les pixels
sous la barre et évite la rémanence. Si tu n'es **pas** sur OLED, tu peux le
désactiver :

```bash
systemctl --user disable --now waybar-watcher.service
```

---

## Crédits

Ce rice est adapté à Kubuntu / KDE Plasma Wayland depuis
[prudhvibungatavula/socrates-KDE](https://github.com/prudhvibungatavula/socrates-KDE),
dont la structure de configuration Waybar s'inspirait à l'origine de
[pewdiepie-archdaemon/dionysus](https://github.com/pewdiepie-archdaemon/dionysus).
Scripts et étapes d'installation retravaillés pour une base Debian/Ubuntu.
