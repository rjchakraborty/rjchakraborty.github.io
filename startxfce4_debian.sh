#!/bin/bash

# Display (do NOT change unless you know why)
export DISPLAY=:0

# Required runtime dir (GNOME/XFCE both need this)
export XDG_RUNTIME_DIR=/tmp/runtime-$USER
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

# Prevent accessibility + system bus noise
export NO_AT_BRIDGE=1
export DBUS_SESSION_BUS_ADDRESS=

# XFCE must not try Wayland or fancy backends
export XDG_SESSION_TYPE=x11
export GDK_BACKEND=x11
export QT_QPA_PLATFORM=xcb

# Hard cleanup (important)
pkill -9 xfce4-session 2>/dev/null
pkill -9 xfwm4 2>/dev/null
pkill -9 xfce4-panel 2>/dev/null
pkill -9 dbus-daemon 2>/dev/null

# Disable components that REQUIRE systemd
rm -f ~/.config/autostart/light-locker.desktop
rm -f ~/.config/autostart/xfce4-power-manager.desktop

# Clear broken sessions
rm -rf ~/.cache/sessions/*

# Start XFCE with a session-only DBus
exec dbus-launch --exit-with-session startxfce4
