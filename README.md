# buff-KDE

```
A complete KDE Plasma Wayland rice
Built on Kubuntu 26.04 — ASUS Vivobook V16 2025
```

---

## The Story

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

---

## What this repo contains

```
buff-kde/
├── HackerCyan-Spicetify-main/   HackerCyan Spotify (Spicetify) theme
├── waybar/                      Custom Waybar bar with full script suite
├── klassy/                      Klassy window decoration config
├── krohnkite/                   KWin tiling script
├── kde/                         KDE global configs
├── themes/                      Color schemes and GTK settings
├── wallpapers/                  Wallpapers used in the setup
└── README.md                    This file
```

---

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

---

## Waybar

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

See `waybar/README.md` for full documentation and install instructions.

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

```bash
mkdir -p ~/.config/klassy
cp klassy/klassyrc ~/.config/klassy/klassyrc
```

Apply in System Settings → Window Decorations → Klassy.

---

## Krohnkite

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

---

## KDE Configs

The `kde/` folder contains:

| File                 | What it does                                    |
| -------------------- | ----------------------------------------------- |
| `kdeglobals`         | Global KDE settings - colors, fonts, icon theme |
| `kwinrc`             | KWin config - effects, tiling, window rules     |
| `plasmarc`           | Plasma theme settings                           |
| `plasmashellrc`      | Panel layout and visibility settings            |
| `kglobalshortcutsrc` | All keyboard shortcuts                          |
| `kscreenlockerrc`    | Lock screen config                              |

**Apply:**

```bash
cp kde/kdeglobals ~/.config/kdeglobals
cp kde/kwinrc ~/.config/kwinrc
cp kde/plasmarc ~/.config/plasmarc
cp kde/plasmashellrc ~/.config/plasmashellrc
cp kde/kglobalshortcutsrc ~/.config/kglobalshortcutsrc
```

Log out and back in after applying.

---

## Themes

The `themes/` folder contains:

- `color-schemes/Main.colors` — the primary color scheme used across the whole
  setup
- `gtk/gtk3-settings.ini` — GTK3 app theming (icon theme, font, cursor)
- `gtk/gtk4-settings.ini` — GTK4 app theming

**Install color scheme:**

```bash
mkdir -p ~/.local/share/color-schemes
cp themes/color-schemes/Main.colors ~/.local/share/color-schemes/
```

Then apply in System Settings → Colors & Themes → Colors → Main.

**Install GTK settings:**

```bash
cp themes/gtk/gtk3-settings.ini ~/.config/gtk-3.0/settings.ini
cp themes/gtk/gtk4-settings.ini ~/.config/gtk-4.0/settings.ini
```

**Icons / font (from the Ubuntu repos):**

```bash
sudo apt install papirus-icon-theme fonts-jetbrains-mono
```

---

## Spotify — Spicetify + HackerCyan

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
mkdir -p ~/.local/share/wallpapers
cp wallpapers/* ~/.local/share/wallpapers/
```

Then right click the desktop → Configure Desktop and Wallpaper → pick one.

---

## Quick Install

Clone the repo and run the Waybar install script to get started:

```bash
git clone https://github.com/ineedabuff/buff-kde ~/buff-kde
cd ~/buff-kde/waybar
./install.sh
```

The install script handles dependencies, auto-detects hardware paths, and sets
up systemd services. For the rest of the setup (Klassy, Krohnkite, themes,
Spicetify) follow the sections above.

---

## Requirements

- Kubuntu 26.04, or another Ubuntu/Debian-based distro
- KDE Plasma 6 on Wayland
- `apt` for most packages; a few components (Klassy, Sweet, capitaine-cursors)
  are built or installed from source because they aren't in the Ubuntu repos

> Most things work on any KDE Wayland setup. Hardware-specific modules
> (dGPU/MUX GPU switching, keyboard aura) are optional and the install script
> will ask about them.

---

## OLED Users

If you are on an OLED display, keep the Waybar watcher service enabled. It
restarts Waybar on every workspace switch, which cycles the pixels under the bar
and prevents burn-in. If you are not on OLED, you can disable it:

```bash
systemctl --user disable waybar-watcher.service
systemctl --user stop waybar-watcher.service
```

---

## Credits

This rice is adapted to Kubuntu / KDE Plasma Wayland from
[prudhvibungatavula/socrates-KDE](https://github.com/prudhvibungatavula/socrates-KDE),
whose Waybar config structure was originally inspired by
[pewdiepie-archdaemon/dionysus](https://github.com/pewdiepie-archdaemon/dionysus).
Scripts and install steps were reworked for a Debian/Ubuntu base.
