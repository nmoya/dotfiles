{ config, pkgs, ... }:

let
    localVpinball = pkgs.callPackage /home/nmoya/Projects/nixpkgs/pkgs/by-name/vp/vpinball/package.nix { };
    customScript = name: runtimeInputs: pkgs.writeShellApplication {
        inherit name runtimeInputs;
        text = builtins.readFile ./.tool_scripts/${name};
    };
    swayDisplayInputs = with pkgs; [ sway procps ];
    swayMirrorInputs = with pkgs; [ sway procps util-linux coreutils wl-mirror ];
    displayMenuInputs = with pkgs; [ fuzzel ];
    displayStatusInputs = [ ];
    micInputs = with pkgs; [ pulseaudio gnugrep ];
    audioInputs = with pkgs; [ pulseaudio gnugrep coreutils ];
    hardwareStatsInputs = with pkgs; [ coreutils gawk ];
    powerMenuInputs = with pkgs; [ fuzzel sway systemd ];
    iplayedInputs = with pkgs; [ uv alacritty ];
    vpinballMenuInputs = with pkgs; [ fuzzel ];
in
{
    home.username = "nmoya";
    home.homeDirectory = "/home/nmoya";
    home.packages = with pkgs; [
        # Sway specific
        alacritty # terminal emulator super + enter opens a terminal
        fuzzel # application launcher super + d opens fuzzel
        waybar # status bar for sway
        swaybg # set a background image for sway
        grim # screenshot tool for sway
        slurp # select an area of the screen for grim to capture
        wl-clipboard # clipboard utilities for wayland, used by grim and slurp
        wlr-randr # utility to manage outputs in sway
        wl-mirror
        procps
        util-linux

        # visual pinball # eventually replace to vpinball when the PR is merged
        localVpinball

        opencode # TUI client for LLMs
        vesktop # open source client for discord
        vscode # Text editor
        github-desktop # GUI client for github
        spotify # Sound player
        godot # Gamedev engine
        bazecor # Keyboard configuration tool
        telegram-desktop # Messaging app

        # Python stack
        python314
        uv

        ffmpeg

        # Custom scripts
        (customScript "display-4k-240-1.5x" swayDisplayInputs)
        (customScript "display-4k-240-1x" swayDisplayInputs)
        (customScript "display-tv-4k-120-1x" swayDisplayInputs)
        (customScript "display-mirror-4k-120-1.5x" swayMirrorInputs)
        (customScript "display-mirror-4k-120-1x" swayMirrorInputs)
        (customScript "display-menu" displayMenuInputs)
        (customScript "display-restore" swayDisplayInputs)
        (customScript "display-status" displayStatusInputs)
        (customScript "mic-toggle" micInputs)
        (customScript "audio-status" audioInputs)
        (customScript "hardware-cpu" hardwareStatsInputs)
        (customScript "hardware-gpu" hardwareStatsInputs)
        (customScript "hardware-ram" hardwareStatsInputs)
        (customScript "hardware-storage" hardwareStatsInputs)
        (customScript "hardware-network" hardwareStatsInputs)
        (customScript "power-menu" powerMenuInputs)
        (customScript "iplayed" iplayedInputs)
        (customScript "vpinball-menu" vpinballMenuInputs)
    ];

    xdg.configFile."sway/config".source = ./.config/sway/config;
    xdg.configFile."alacritty/alacritty.toml".source = ./.config/alacritty/alacritty.toml;
    xdg.configFile."fuzzel/fuzzel.ini".source = ./.config/fuzzel/fuzzel.ini;
    xdg.configFile."waybar/config".source = ./.config/waybar/config;
    xdg.configFile."waybar/style.css".source = ./.config/waybar/style.css;

    home.sessionVariables.XCOMPOSEFILE = "${config.home.homeDirectory}/.XCompose";
    home.file.".XCompose".source = ./.XCompose;
    home.file.".emacs".source = ./.emacs;
    home.file.".gitconfig".source = ./.gitconfig;
    home.file.".inputrc".source = ./.inputrc;
    home.file.".bashrc".source = ./.bashrc;
    home.file.".vimrc".source = ./.vimrc;

    xdg.desktopEntries.iplayed = {
        name = "iplayed";
        exec = "iplayed";
        terminal = false;
        type = "Application";
        categories = [ "Game" ];
    };

    xdg.desktopEntries.display-menu = {
        name = "Display Menu";
        exec = "display-menu";
        terminal = false;
        type = "Application";
        categories = [ "Settings" ];
    };

    xdg.desktopEntries.power-menu = {
        name = "Power Menu";
        exec = "power-menu";
        terminal = false;
        type = "Application";
        categories = [ "System" ];
    };

    xdg.desktopEntries.vpinball-menu = {
        name = "VPinball";
        exec = "vpinball-menu";
        terminal = false;
        type = "Application";
        categories = [ "Game" ];
    };

    systemd.user.services.waybar = {
        Unit = {
            Description = "Waybar";
            PartOf = [ "sway-session.target" ];
            After = [ "sway-session.target" ];
        };

        Service = {
            ExecStart = "${pkgs.waybar}/bin/waybar";
            Restart = "always";
            RestartSec = 1;
        };

        Install.WantedBy = [ "sway-session.target" ];
    };

    home.stateVersion = "26.05";
}
