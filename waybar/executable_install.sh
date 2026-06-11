#!/bin/bash
# ──────────────────────────────────────────────────────────────────────────
#  Waybar KDE Plasma Wayland — Install Script
#  Adapté pour Kubuntu 26.04 / Ubuntu (KDE Plasma 6, KWin Wayland) — apt
# ──────────────────────────────────────────────────────────────────────────

set -e

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Waybar KDE Plasma Wayland -- Installer (Kubuntu)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── 1. Check we are on KDE Wayland ────────────────────────────────────────
if [ "$XDG_SESSION_TYPE" != "wayland" ]; then
    echo "WARNING: Not running on Wayland. Connecte-toi sur la session 'Plasma (Wayland)'."
fi

if [ -z "$KDE_FULL_SESSION" ]; then
    echo "WARNING: KDE session not detected. This config is built for KDE Plasma 6."
fi

# ── 2. Install dependencies (apt) ─────────────────────────────────────────
echo "-> Installing dependencies via apt..."

if command -v apt &>/dev/null; then
    sudo apt update
    sudo apt install -y \
        waybar \
        brightnessctl \
        ddcutil \
        rofi \
        network-manager \
        pipewire \
        wireplumber \
        pipewire-pulse \
        pulseaudio-utils \
        bluez \
        upower \
        playerctl \
        qdbus-qt6 \
        kde-cli-tools \
        fontconfig \
        curl \
        unzip
    echo "   Done."
else
    echo "WARNING: apt not found. Installe les paquets manuellement :"
    echo "   waybar brightnessctl ddcutil rofi network-manager pipewire wireplumber"
    echo "   pipewire-pulse pulseaudio-utils bluez upower playerctl qdbus-qt6"
    echo "   kde-cli-tools fontconfig curl unzip"
fi

# ── 3. Fix qdbus6 on Ubuntu/Kubuntu (binaire hors PATH) ───────────────────
# Sur Ubuntu, qdbus-qt6 installe le binaire sous /usr/lib/qt6/bin/qdbus et NE
# crée PAS de 'qdbus6' dans le PATH. Les scripts de workspaces / le watcher
# appellent 'qdbus6' -> on crée le lien manquant.
echo ""
echo "-> Vérification de qdbus6..."
if command -v qdbus6 &>/dev/null; then
    echo "   qdbus6 déjà présent."
else
    QDBUS_BIN=""
    for c in \
        /usr/lib/qt6/bin/qdbus \
        /usr/lib/x86_64-linux-gnu/qt6/bin/qdbus \
        /usr/bin/qdbus-qt6 ; do
        [ -x "$c" ] && QDBUS_BIN="$c" && break
    done
    [ -z "$QDBUS_BIN" ] && QDBUS_BIN="$(find /usr/lib -name qdbus -path '*qt6*' 2>/dev/null | head -1)"

    if [ -n "$QDBUS_BIN" ]; then
        sudo ln -sf "$QDBUS_BIN" /usr/local/bin/qdbus6
        echo "   Lien créé : /usr/local/bin/qdbus6 -> $QDBUS_BIN"
    else
        echo "WARNING: binaire qdbus Qt6 introuvable. Les workspaces ne fonctionneront pas."
        echo "         Installe 'qdbus-qt6' puis relance ce script."
    fi
fi

# ── 4. Install JetBrainsMono Nerd Font ────────────────────────────────────
# Pas de paquet Nerd Font dans apt -> téléchargement depuis ryanoasis/nerd-fonts.
echo ""
echo "-> Vérification de la police JetBrainsMono Nerd Font..."
if fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd Font"; then
    echo "   Déjà installée."
else
    FONT_DIR="$HOME/.local/share/fonts/JetBrainsMonoNerd"
    mkdir -p "$FONT_DIR"
    TMP="$(mktemp -d)"
    echo "   Téléchargement..."
    if curl -fLo "$TMP/JetBrainsMono.zip" \
        https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip 2>/dev/null; then
        unzip -o "$TMP/JetBrainsMono.zip" -d "$FONT_DIR" >/dev/null
        echo "   Police installée dans $FONT_DIR"
    else
        echo "WARNING: téléchargement échoué. Installe JetBrainsMono Nerd Font manuellement"
        echo "         depuis https://www.nerdfonts.com puis lance 'fc-cache -f'."
    fi
    rm -rf "$TMP"
fi

# ── 5. Install optional ASUS dependencies ─────────────────────────────────
# supergfxctl / asusctl ne sont pas dans les dépôts Ubuntu officiels.
echo ""
read -p "-> Es-tu sur un portable ASUS avec supergfxctl/asusctl ? (y/n): " asus_answer
if [ "$asus_answer" = "y" ]; then
    echo "   Note : asusctl/supergfxctl ne sont pas packagés sur Ubuntu."
    echo "   Vois https://gitlab.com/asus-linux/asusctl (build manuel / PPA non officiel)."
    echo "   Le module GPU restera inactif tant qu'ils ne sont pas installés."
fi

# ── 6. Add user to i2c group for DDC monitor brightness ───────────────────
echo ""
echo "-> Adding user to i2c group for external monitor brightness..."
sudo usermod -aG i2c "$USER" 2>/dev/null && echo "   Done." || echo "WARNING: Could not add to i2c group."
sudo modprobe i2c-dev 2>/dev/null || true

# ── 7. Make scripts executable ────────────────────────────────────────────
echo ""
echo "-> Making scripts executable..."
chmod +x ~/.config/waybar/scripts/*.sh 2>/dev/null || true
chmod +x ~/.config/waybar/scripts/workspaces/*.sh 2>/dev/null || true
echo "   Done."

# ── 8. Auto-detect battery path ───────────────────────────────────────────
echo ""
echo "-> Detecting battery..."
BAT=$(ls /sys/class/power_supply/ 2>/dev/null | grep -iE '^BAT' | grep -iv mouse | head -1)
if [ -n "$BAT" ]; then
    echo "   Battery found: $BAT"
    sed -i "s|bat_path=\"/sys/class/power_supply/BAT.*\"|bat_path=\"/sys/class/power_supply/$BAT\"|g" \
        ~/.config/waybar/scripts/battery.sh 2>/dev/null || true
else
    echo "WARNING: No battery found -- may be a desktop system."
fi

# ── 9. Auto-detect backlight ──────────────────────────────────────────────
echo ""
echo "-> Detecting backlight..."
BL=$(ls /sys/class/backlight/ 2>/dev/null | grep -v nvidia | head -1)
if [ -n "$BL" ]; then
    echo "   Backlight found: $BL"
    sed -i "s|brightnessctl -d intel_backlight|brightnessctl -d $BL|g" \
        ~/.config/waybar/scripts/brightness.sh \
        ~/.config/waybar/scripts/brightness-scroll-up.sh \
        ~/.config/waybar/scripts/brightness-scroll-down.sh \
        ~/.config/waybar/scripts/brightness-toggle-display.sh 2>/dev/null || true
else
    echo "WARNING: No backlight found."
fi

# ── 10. Set up KWin virtual desktop count ─────────────────────────────────
echo ""
echo "-> Checking KWin virtual desktops..."
DESKTOP_COUNT=$(qdbus6 org.kde.KWin /VirtualDesktopManager org.freedesktop.DBus.Properties.Get org.kde.KWin.VirtualDesktopManager count 2>/dev/null)
if [ -z "$DESKTOP_COUNT" ]; then
    echo "WARNING: Could not detect KWin desktops -- make sure KDE Plasma is running."
else
    echo "   Found $DESKTOP_COUNT virtual desktops."
    if [ "$DESKTOP_COUNT" -lt 4 ]; then
        echo "   Less than 4 desktops detected. Adding more..."
        for i in $(seq "$DESKTOP_COUNT" 3); do
            qdbus6 org.kde.KWin /VirtualDesktopManager org.kde.KWin.VirtualDesktopManager.createDesktop "$i" "Desktop $((i+1))" 2>/dev/null || true
        done
        echo "   Now have 4 virtual desktops."
    fi
fi

# ── 11. Install systemd services ──────────────────────────────────────────
echo ""
read -p "-> Install systemd services for autostart and workspace animation? (y/n): " systemd_answer
if [ "$systemd_answer" = "y" ]; then
    mkdir -p ~/.config/systemd/user

    # waybar.service — copie si présent, sinon génère un fallback
    if [ -f ~/.config/waybar/waybar.service ]; then
        cp ~/.config/waybar/waybar.service ~/.config/systemd/user/
    else
        cat > ~/.config/systemd/user/waybar.service << 'SVCEOF'
[Unit]
Description=Waybar
After=graphical-session.target
PartOf=graphical-session.target

[Service]
ExecStart=/usr/bin/waybar
Restart=on-failure
RestartSec=2

[Install]
WantedBy=graphical-session.target
SVCEOF
    fi

    # waybar-watcher.service — copie si présent, sinon génère un fallback.
    # On utilise %h (home de l'utilisateur, résolu par systemd) plutôt qu'un
    # chemin /home/xxx codé en dur.
    if [ -f ~/.config/waybar/waybar-watcher.service ]; then
        cp ~/.config/waybar/waybar-watcher.service ~/.config/systemd/user/
    else
        cat > ~/.config/systemd/user/waybar-watcher.service << 'SVCEOF'
[Unit]
Description=Waybar Desktop Switch Watcher
After=waybar.service

[Service]
ExecStart=%h/.config/waybar/scripts/waybar-watcher.sh
Restart=on-failure
RestartSec=2

[Install]
WantedBy=graphical-session.target
SVCEOF
    fi

    # Répare tout chemin /home/<user>/ resté codé en dur dans le watcher
    # (ex. /home/akash/ hérité du repo d'origine) -> %h, valable pour tous.
    sed -i "s|ExecStart=/home/[^/]*/|ExecStart=%h/|" \
        ~/.config/systemd/user/waybar-watcher.service 2>/dev/null || true

    systemctl --user daemon-reload
    systemctl --user enable waybar.service waybar-watcher.service
    systemctl --user start  waybar.service waybar-watcher.service
    echo "   Systemd services installed and started."
else
    echo "   Skipping systemd services. Launch Waybar manually with: waybar &"
fi

# ── 12. Font cache refresh ────────────────────────────────────────────────
echo ""
echo "-> Refreshing font cache..."
fc-cache -f &>/dev/null || true
echo "   Done."

# ── Done ──────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Installation complete."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Next steps:"
echo "  1. Log out and back in (i2c group + Wayland session 'Plasma (Wayland)')"
echo "  2. If not using systemd: run 'waybar &' to start"
echo "  3. Media module: lance Spotify (ou un autre lecteur) -> il apparaît dans la barre"
echo "     Clic = lecture/pause, molette = piste suivante/précédente"
echo "  4. Right click Waybar modules to access menus"
echo "  5. Repo: https://github.com/ineedabuff/buff-kde"
echo ""
