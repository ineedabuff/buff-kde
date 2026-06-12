# Themes

## Color Scheme
- Main.colors — primary color scheme used
- Install: copy to ~/.local/share/color-schemes/
- Apply: System Settings -> Colors & Themes -> Colors

```bash
mkdir -p ~/.local/share/color-schemes
cp themes/color-schemes/Main.colors ~/.local/share/color-schemes/
```

## GTK Theme
- gtk-theme: Breeze
- icon-theme: Papirus-Dark
- cursor: capitaine-cursors-light
- font: JetBrains Mono Medium 11

## Install GTK theme

```bash
# Icons (in the Ubuntu repos)
sudo apt install papirus-icon-theme

# Font (in the Ubuntu repos)
sudo apt install fonts-jetbrains-mono

# Breeze GTK theme already ships with KDE Plasma on Kubuntu.
# If it is missing, install it explicitly:
sudo apt install breeze-gtk-theme
```

> For the very latest Papirus icons you can use the upstream PPA instead:
> `sudo add-apt-repository ppa:papirus/papirus && sudo apt update && sudo apt install papirus-icon-theme`

### capitaine-cursors (manual — not in the Ubuntu repos)
There is no `apt` package, so install the cursor theme from the upstream
release:

```bash
mkdir -p ~/.local/share/icons
cd /tmp
curl -fLO https://github.com/keeferrourke/capitaine-cursors/releases/latest/download/capitaine-cursors.tar.gz
tar -xf capitaine-cursors.tar.gz -C ~/.local/share/icons/
fc-cache -f   # (cursors don't need this, but harmless)
```

> Make sure the extracted folder name matches what the config expects
> (`capitaine-cursors-light`). Rename the extracted directory if needed:
> `mv ~/.local/share/icons/"Capitaine Cursors - White" ~/.local/share/icons/capitaine-cursors-light`
> Then set it in System Settings -> Colors & Themes -> Cursors.

## Apply settings
```bash
cp themes/gtk/gtk3-settings.ini ~/.config/gtk-3.0/settings.ini
cp themes/gtk/gtk4-settings.ini ~/.config/gtk-4.0/settings.ini
```

## Plasma Theme
- Sweet

Not packaged for Ubuntu. Easiest is the GUI:
System Settings -> Colors & Themes -> Plasma Style -> "Get New…" and search
for **Sweet** (by EliverLara).

Or install manually from the upstream repo:

```bash
git clone https://github.com/EliverLara/Sweet
cd Sweet
# follow the repo's install notes, e.g. copy the Plasma style into:
#   ~/.local/share/plasma/desktoptheme/
```
