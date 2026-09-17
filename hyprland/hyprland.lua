-- Hyprland configuration in Lua format for version 0.55.0

-- Monitor configuration
hyprland.monitor {
    name = "DP-1",
    resolution = "3840x2160@144",
    position = "1440x0",
    scale = 1
}

hyprland.monitor {
    name = "DP-2",
    resolution = "2560x1440@144",
    position = "0x0",
    scale = 1,
    transform = 3
}

hyprland.monitor {
    name = "HDMI-A-1",
    resolution = "2560x1440@60",
    position = "0x0",
    scale = 1
}

hyprland.monitor {
    name = "eDP-1",
    resolution = "preferred",
    position = "2560x0",
    scale = 1
}

-- Environment variables
hyprland.env {
    name = "HYPRCURSOR_THEME",
    value = "ArcStarry"
}

hyprland.env {
    name = "HYPRCURSOR_SIZE",
    value = "24"
}

hyprland.env {
    name = "XCURSOR_THEME",
    value = "ArcStarry"
}

hyprland.env {
    name = "XCURSOR_SIZE",
    value = "24"
}

-- General settings
hyprland.general {
    gaps_in = 5,
    gaps_out = 20,
    border_size = 2,
    col_active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg",
    col_inactive_border = "rgba(595959aa)",
    resize_on_border = false,
    allow_tearing = false,
    layout = "dwindle"
}

-- Decoration settings
hyprland.decoration {
    rounding = 10,
    rounding_power = 2,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    shadow = {
        enabled = true,
        range = 4,
        render_power = 3,
        color = "rgba(1a1a1aee)"
    },
    blur = {
        enabled = true,
        size = 3,
        passes = 1,
        vibrancy = 0.1696
    }
}

-- Animations
hyprland.animations {
    enabled = true,
    bezier = {
        easeOutQuint = { 0.23, 1, 0.32, 1 },
        easeInOutCubic = { 0.65, 0.05, 0.36, 1 },
        linear = { 0, 0, 1, 1 },
        almostLinear = { 0.5, 0.5, 0.75, 1 },
        quick = { 0.15, 0, 0.1, 1 }
    },
    animation = {
        global = { 1, 10, "default" },
        border = { 1, 5.39, "easeOutQuint" },
        windows = { 1, 4.79, "easeOutQuint" },
        windowsIn = { 1, 4.1, "easeOutQuint", "popin 87%" },
        windowsOut = { 1, 1.49, "linear", "popin 87%" },
        fadeIn = { 1, 1.73, "almostLinear" },
        fadeOut = { 1, 1.46, "almostLinear" },
        fade = { 1, 3.03, "quick" },
        layers = { 1, 3.81, "easeOutQuint" },
        layersIn = { 1, 4, "easeOutQuint", "fade" },
        layersOut = { 1, 1.5, "linear", "fade" },
        fadeLayersIn = { 1, 1.79, "almostLinear" },
        fadeLayersOut = { 1, 1.39, "almostLinear" },
        workspaces = { 1, 1.94, "almostLinear", "fade" },
        workspacesIn = { 1, 1.21, "almostLinear", "fade" },
        workspacesOut = { 1, 1.94, "almostLinear", "fade" }
    }
}

-- Dwindle layout settings
hyprland.dwindle {
    preserve_split = true
}

-- Master layout settings
hyprland.master {
    new_status = "master"
}

-- Misc settings
hyprland.misc {
    force_default_wallpaper = -1,
    disable_hyprland_logo = false
}

-- Input settings
hyprland.input {
    kb_layout = "us",
    kb_variant = "basic",
    kb_model = "pc105",
    kb_options = "",
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
        natural_scroll = true,
        disable_while_typing = true
    }
}

-- Device-specific input settings
hyprland.device {
    name = "epic-mouse-v1",
    sensitivity = -0.5
}

hyprland.device {
    name = "at-translated-set-2-keyboard",
    kb_layout = "tuxedo_colemak_ansi",
    kb_variant = "basic",
    kb_model = "pc105"
}

-- Keybindings
-- Main modifier is Super
local mod = "SUPER"

-- Basic commands
hyprland.bind {
    mod = mod,
    key = "Return",
    command = "exec, $terminal"
}

hyprland.bind {
    mod = mod,
    key = "Q",
    command = "killactive,"
}

hyprland.bind {
    mod = mod,
    key = "M",
    command = "exec, command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"
}

hyprland.bind {
    mod = mod,
    key = "E",
    command = "exec, $fileManager"
}

hyprland.bind {
    mod = mod,
    key = "V",
    command = "togglefloating,"
}

hyprland.bind {
    mod = mod,
    key = "D",
    command = "exec, $menu"
}

hyprland.bind {
    mod = mod,
    key = "P",
    command = "pseudo, # dwindle"
}

hyprland.bind {
    mod = mod,
    key = "F",
    command = "fullscreen"
}

-- Move focus with arrow keys
hyprland.bind {
    mod = mod,
    key = "left",
    command = "movefocus, l"
}

hyprland.bind {
    mod = mod,
    key = "right",
    command = "movefocus, r"
}

hyprland.bind {
    mod = mod,
    key = "up",
    command = "movefocus, u"
}

hyprland.bind {
    mod = mod,
    key = "down",
    command = "movefocus, d"
}

-- Move windows around
hyprland.bind {
    mod = mod .. "Shift",
    key = "left",
    command = "movewindow, l"
}

hyprland.bind {
    mod = mod .. "Shift",
    key = "right",
    command = "movewindow, r"
}

hyprland.bind {
    mod = mod .. "Shift",
    key = "up",
    command = "movewindow, u"
}

hyprland.bind {
    mod = mod .. "Shift",
    key = "down",
    command = "movewindow, d"
}

-- Switch workspaces
for i = 1, 10 do
    hyprland.bind {
        mod = mod,
        key = tostring(i),
        command = "workspace, " .. tostring(i)
    }
    
    hyprland.bind {
        mod = mod .. "Shift",
        key = tostring(i),
        command = "movetoworkspace, " .. tostring(i)
    }
end

-- Special workspace
hyprland.bind {
    mod = mod,
    key = "S",
    command = "togglespecialworkspace, magic"
}

hyprland.bind {
    mod = mod .. "Shift",
    key = "S",
    command = "movetoworkspace, special:magic"
}

-- Scroll through workspaces
hyprland.bind {
    mod = mod,
    key = "mouse_down",
    command = "workspace, e+1"
}

hyprland.bind {
    mod = mod,
    key = "mouse_up",
    command = "workspace, e-1"
}

-- Move/resize windows with mouse
hyprland.bindm {
    mod = mod,
    mouse = "272",
    command = "movewindow"
}

hyprland.bindm {
    mod = mod,
    mouse = "273",
    command = "resizewindow"
}

-- Use mouse pointer
hyprland.bind {
    mod = mod,
    key = "g",
    command = "exec, wl-kbptr"
}

-- Multimedia keys
hyprland.bindl {
    key = "XF86AudioRaiseVolume",
    command = "exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
}

hyprland.bindl {
    key = "XF86AudioLowerVolume",
    command = "exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
}

hyprland.bindl {
    key = "XF86AudioMute",
    command = "exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
}

hyprland.bindl {
    key = "XF86AudioMicMute",
    command = "exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
}

hyprland.bindl {
    key = "XF86MonBrightnessUp",
    command = "exec, brightnessctl -e4 -n2 set 5%+"
}

hyprland.bindl {
    key = "XF86MonBrightnessDown",
    command = "exec, brightnessctl -e4 -n2 set 5%-"
}

-- Playerctl commands
hyprland.bindl {
    key = "XF86AudioNext",
    command = "exec, mpc next"
}

hyprland.bindl {
    key = "XF86AudioPause",
    command = "exec, mpc toggle"
}

hyprland.bindl {
    key = "XF86AudioPlay",
    command = "exec, mpc toggle"
}

hyprland.bindl {
    key = "XF86AudioPrev",
    command = "exec, mpc prev"
}

-- Window rules
hyprland.windowrulev2 {
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize"
}

hyprland.windowrulev2 {
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false
    },
    no_focus = true
}

hyprland.windowrulev2 {
    name = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move = "20 monitor_h-120",
    float = true
}

-- Autostart
hyprland.exec_once {
    command = "waybar"
}

hyprland.exec_once {
    command = "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE XDG_RUNTIME_DIR"
}

hyprland.exec_once {
    command = "systemctl --user start hyprpaper"
}
