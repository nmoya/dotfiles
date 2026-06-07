{ config, pkgs, ... }:

let
    customScript = name: runtimeInputs: pkgs.writeShellApplication {
        inherit name runtimeInputs;
        text = builtins.readFile ./.tool_scripts/${name};
    };
    styledWmenu = customScript "styled-wmenu" (with pkgs; [ wmenu ]);
    styledWmenuRun = customScript "styled-wmenu-run" (with pkgs; [ wmenu ]);
    swayDisplayInputs = with pkgs; [ sway procps ];
    swayMirrorInputs = with pkgs; [ sway procps util-linux coreutils wl-mirror ];
    displayMenuInputs = [ styledWmenu ];
    displayStatusInputs = [ ];
    micInputs = with pkgs; [ pulseaudio gnugrep ];
    audioInputs = with pkgs; [ pulseaudio gnugrep coreutils ];
    hardwareStatsInputs = with pkgs; [ coreutils ];
    powerMenuInputs = [ styledWmenu ] ++ (with pkgs; [ sway systemd ]);
in
{
    home.username = "nmoya";
    home.homeDirectory = "/home/nmoya";
    home.packages = with pkgs; [
        # Sway specific
        alacritty # terminal emulator super + enter opens a terminal
        wmenu # application launcher super + d opens wmenu
        waybar # status bar for sway
        swaybg # set a background image for sway
        grim # screenshot tool for sway
        slurp # select an area of the screen for grim to capture
        wl-clipboard # clipboard utilities for wayland, used by grim and slurp
        wlr-randr # utility to manage outputs in sway
        wl-mirror
        procps
        util-linux

        opencode # TUI client for LLMs
        vesktop # open source client for discord
        vscode # Text editor
        spotify # Sound player
        godot # Gamedev engine
        bazecor # Keyboard configuration tool
        telegram-desktop # Messaging app

        # Custom scripts
        styledWmenu
        styledWmenuRun
        (customScript "display-daily" swayDisplayInputs)
        (customScript "display-monitor-gaming" swayDisplayInputs)
        (customScript "display-tv-gaming" swayDisplayInputs)
        (customScript "display-mirror-casual" swayMirrorInputs)
        (customScript "display-mirror-gaming" swayMirrorInputs)
        (customScript "display-menu" displayMenuInputs)
        (customScript "display-status" displayStatusInputs)
        (customScript "mic-toggle" micInputs)
        (customScript "audio-status" audioInputs)
        (customScript "hardware-stats" hardwareStatsInputs)
        (customScript "power-menu" powerMenuInputs)
    ];

    xdg.configFile."sway/config".source = ./.config/sway/config;
    xdg.configFile."waybar/config".source = ./.config/waybar/config;
    xdg.configFile."waybar/style.css".source = ./.config/waybar/style.css;

    home.stateVersion = "26.05";
}
