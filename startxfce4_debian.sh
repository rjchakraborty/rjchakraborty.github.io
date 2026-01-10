#!/data/data/com.termux/files/usr/bin/bash
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
# Kill open X11 processes
kill -9 $(pgrep -f "termux.x11") 2>/dev/null

# Enable PulseAudio over Network
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1

# Prepare termux-x11 session
export XDG_RUNTIME_DIR=${TMPDIR}
termux-x11 :0 >/dev/null &

# Wait a bit until termux-x11 gets started.
sleep 3

# Launch Termux X11 main activity
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity > /dev/null 2>&1
sleep 1

# Login in PRoot Environment. Do some initialization for PulseAudio, /tmp directory
# and run XFCE4 as user rj.
# See also: https://github.com/termux/proot-distro
# Argument -- acts as terminator of proot-distro login options processing.
# All arguments behind it would not be treated as options of PRoot Distro.
proot-distro login debian --shared-tmp -- /bin/bash -c  'export PULSE_SERVER=127.0.0.1 && export XDG_RUNTIME_DIR=${TMPDIR} && su - rj -c "env DISPLAY=:0 startxfce4"'

exit 0
