[general]
import = [
    "~/.config/alacritty/solarized-X_THEME_X.toml"
]
live_config_reload = true

[cursor]
unfocused_hollow = true

[font]
size = 11.0

[env]
TERM = "alacritty"
COLORTERM = "true"

[font.normal]
family = "Source Code Pro"

[[hints.enabled]]
command = "xdg-open"
post_processing = true
regex = "(ipfs:|ipns:|magnet:|mailto:|gemini:|gopher:|https:|http:|news:|file:|git:|ssh:|ftp:)[^\u0000-\u001F\u007F-<>\"\\s{-}\\^⟨⟩`]+"

[hints.enabled.binding]
key = "U"
mods = "Control|Shift"

[hints.enabled.mouse]
enabled = true
mods = "None"

[[keyboard.bindings]]
action = "ToggleFullscreen"
key = "F11"
