-- https://wiki.hypr.land/Configuring/Start/

require("dms/cursor")
require("dms/windowrules")

--------------------
---- WINDOW RULES ----
--------------------

-- Emacs slight transparency -- carried over from a prior system's Hyprland
-- config (found in old_home's hyprland.conf: `windowrule = match:class
-- ^(emacs)$, opacity 0.90 0.90`); this build's real live class is "Emacs"
-- (capitalized, confirmed via `hyprctl clients`), not the lowercase the old
-- config used.
hl.window_rule({ name = "emacs-opacity", match = { class = "^(Emacs)$" }, opacity = "0.90 0.90" })


--------------------
---- MONITORS ----
--------------------

hl.monitor({ output = "DP-5",  mode = "1440x900@59.887",  position = "1120x0",    scale = 1, vrr = 0 })
--hl.monitor({ output = "DP-8",  mode = "1440x900@59.887",  position = "1876x427",  scale = 1, vrr = 0 })
--hl.monitor({ output = "DP-7",  mode = "1440x900@59.887",  position = "1876x514",  scale = 1, vrr = 0 })
--hl.monitor({ output = "DP-6",  mode = "1440x900@59.887",  position = "3316x694",  scale = 1, vrr = 0 })
hl.monitor({ output = "DP-3",  mode = "1360x768@60.015",  position = "2560x594",  scale = 1, vrr = 0 })
--hl.monitor({ output = "DP-4",  mode = "1360x768@60.015",  position = "3316x949",  scale = 1, vrr = 0 })
hl.monitor({ output = "eDP-1", disabled = true })
--hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 2 })
--hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto" })


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XDG_CURRENT_DESKTOP",             "Hyprland")
hl.env("XDG_SESSION_TYPE",                "wayland")
hl.env("XDG_SESSION_DESKTOP",             "Hyprland")
hl.env("QT_QPA_PLATFORM",                 "wayland")
hl.env("XDG_SCREENSHOTS_DIR",             "~/screens")
hl.env("MOZ_ENABLE_WAYLAND",              "1")
hl.env("_JAVA_AWT_WM_NONREPARENTING",     "1")
hl.env("SDL_VIDEODRIVER",                 "wayland")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR",     "1")


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    -- gnome-keyring-daemon: pinentry-gnome3's actual pin prompt is
    -- org.gnome.keyring.SystemPrompter, D-Bus-activated on demand via
    -- gcr-prompter (gcr-3's own binary, /usr/libexec/gcr-prompter) --
    -- that part needs no daemon running ahead of time. This line is for
    -- the *other* two components in the same binary: secrets (the Secret
    -- Service API apps use to store arbitrary passwords) and pkcs11.
    -- --components matches this build's own systemd --user unit
    -- (/usr/lib/systemd/user/gnome-keyring-daemon.service); ssh is left
    -- out since gnome-keyring wasn't built with ssh-agent support here.
    hl.exec_cmd("gnome-keyring-daemon --start --components=pkcs11,secrets")
    hl.exec_cmd("swayidle -w timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'")
    hl.exec_cmd("dms run")
    hl.exec_cmd("wlsunset -l 35.46 -L -97.32")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("dbus-update-activation-environment DISPLAY I3SOCK SWAYSOCK WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    -- No-op on this box as it stands: there are no xdg-desktop-portal user
    -- units and no xdg-desktop-portal-hyprland binary installed. Left in
    -- place for whenever the portal gets built.
    hl.exec_cmd("systemctl --user restart xdg-desktop-portal.service xdg-desktop-portal-hyprland.service")
    hl.exec_cmd("sleep 1 && /usr/libexec/xdg-desktop-portal-hyprland &")

    -- prime the automation pass store's passphrase cache once at login (8h
    -- ttl, see ~/.gnupg-auto/gpg-agent.conf) so scripts/cron never prompt
    -- afterward
    hl.exec_cmd("/home/john/.local/bin/pass-auto show ifd-vault/token >/dev/null 2>&1")
end)


----------------
---- CONFIG ----
----------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_options = "caps:escape",
    },
    general = {
        gaps_in     = 5,
        gaps_out    = 20,
        border_size = 3,
        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        layout = "dwindle",
    },
    decoration = {
        rounding = 10,
        blur     = { enabled = false },
        shadow   = { enabled = false },
    },
    animations = {
        enabled = true,
    },
    dwindle = {
        preserve_split = true,
    },
    misc = {
        animate_manual_resizes       = true,
        animate_mouse_windowdragging = true,
        enable_swallow               = true,
        disable_hyprland_logo        = true,
    },
    debug = {
        disable_logs = false,
    },
})


--------------------
---- ANIMATIONS ----
--------------------

hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

hl.animation({ leaf = "windows",    enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",     enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade",       enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6,  bezier = "default" })


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + Return",       hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + Q",            hl.dsp.window.close())
hl.bind(mainMod .. " + M",            hl.dsp.exit())
hl.bind(mainMod .. " + V",            hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D",            hl.dsp.exec_cmd("wofi --show drun"))
hl.bind(mainMod .. " + P",            hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J",            hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F",            hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + B",    hl.dsp.exec_cmd("env GTK_CSD=0 firefox"))
hl.bind(mainMod .. " + B",            hl.dsp.exec_cmd("env GTK_CSD=0 firefox"))

-- Focus
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Swap windows
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.swap({ direction = "down" }))

-- Resize
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.resize({ x = -60, y = 0,   relative = true }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x =  60, y = 0,   relative = true }))
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.window.resize({ x = 0,   y = -60, relative = true }))
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.window.resize({ x = 0,   y =  60, relative = true }))

-- Workspaces
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Mouse move/resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Keyboard backlight
hl.bind(mainMod .. " + F3", hl.dsp.exec_cmd("brightnessctl -d '*::kbd_backlight' set +33%"))
hl.bind(mainMod .. " + F2", hl.dsp.exec_cmd("brightnessctl -d '*::kbd_backlight' set 33%-"))

-- Volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"),                { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"),                { locked = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("pamixer -t"),                  { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("pamixer --default-source -m"), { locked = true })

-- Screenshots
hl.bind(mainMod .. " + PRINT",             hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind("PRINT",                           hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind(mainMod .. " + SHIFT + PRINT",     hl.dsp.exec_cmd("hyprshot -m region"))

require("dms.outputs")
require("dms.layout")
