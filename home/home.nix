{ config, pkgs, ... }:

{
    home.username = "nmoya";
    home.homeDirectory = "/home/nmoya";
    home.sessionPath = [
        "$HOME/.local/bin"
    ];
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
    ];

    home.file.".local/bin/display-daily" = {
        source = ./.tool_scripts/display-daily;
        executable = true;
    };
    home.file.".local/bin/display-monitor-gaming" = {
        source = ./.tool_scripts/display-monitor-gaming;
        executable = true;
    };
    home.file.".local/bin/display-tv-gaming" = {
        source = ./.tool_scripts/display-tv-gaming;
        executable = true;
    };
    home.file.".local/bin/display-mirror-casual" = {
        source = ./.tool_scripts/display-mirror-casual;
        executable = true;
    };
    home.file.".local/bin/display-mirror-gaming" = {
        source = ./.tool_scripts/display-mirror-gaming;
        executable = true;
    };

    xdg.configFile."sway/config".source = ./.config/sway/config;

    home.stateVersion = "26.05";
}