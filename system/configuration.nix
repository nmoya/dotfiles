{ config, pkgs, unstablePkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
    ];

    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.initrd.luks.devices."luks-da0ece32-498b-46d5-9685-53c7ce33a1b5".device = "/dev/disk/by-uuid/da0ece32-498b-46d5-9685-53c7ce33a1b5";
    
    # Nixpkgs
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Nix store garbage collection
    nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
    };

    # Networking
    networking.hostName = "nixos";
    networking.firewall.allowedUDPPorts = [ 8211 ];
    networking.networkmanager.enable = true;
    # Uncomment later for VPN manual configs.
    # networking.networkmanager.plugins = with pkgs; [
    #   networkmanager-openvpn
    # ];

    # Timezone and locale
    time.timeZone = "Europe/Amsterdam";
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "nl_NL.UTF-8";
        LC_IDENTIFICATION = "nl_NL.UTF-8";
        LC_MEASUREMENT = "nl_NL.UTF-8";
        LC_MONETARY = "nl_NL.UTF-8";
        LC_NAME = "nl_NL.UTF-8";
        LC_NUMERIC = "nl_NL.UTF-8";
        LC_PAPER = "nl_NL.UTF-8";
        LC_TELEPHONE = "nl_NL.UTF-8";
        LC_TIME = "nl_NL.UTF-8";
    };

    # Keyboard
    services.xserver.xkb = {
        layout = "us";
        variant = "intl";
    };
    console.keyMap = "us";

    # Bluetooth
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true;

    # Desktop
    services.xserver.enable = true;
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    # Printing
    services.printing.enable = true;

    # Audio
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # jack.enable = true;
    };

    # User & Home manager
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = {
        inherit unstablePkgs;
    };
    home-manager.users.nmoya = import ../home/home.nix;
    users.users.nmoya = {
        isNormalUser = true;
        description = "Nikolas Moya";
        extraGroups = [ "networkmanager" "wheel" "dialout" ];
        packages = with pkgs; [
    		
    	];
    };

    # NVIDIA / graphics
    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
        modesetting.enable = true;
        open = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;

        powerManagement.enable = true;
        powerManagement.finegrained = false;
    };
    boot.extraModprobeConfig = ''
        options nvidia NVreg_PreserveVideoMemoryAllocations=1
    '';

    # Programs
    programs.firefox.enable = true;
    programs.steam = {
        enable = true;
        extraPackages = with pkgs; [
        ];
    };

    programs.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        extraOptions = [ "--unsupported-gpu" ];
    };
    xdg.portal = {
        enable = true;
        wlr = {
            enable = true;
            settings.screencast = {
                chooser_type = "dmenu";
                chooser_cmd = "${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt='Share: '";
            };
        };
    };

    fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-color-emoji
        nerd-fonts.jetbrains-mono
        nerd-fonts.symbols-only
    ];

    # System packages
    environment.systemPackages = with pkgs; [
        adwaita-icon-theme
        ncdu # ncurses disk usage analyzer
        htop # interactive process viewer
        mesa-demos # glxgears and other OpenGL demos
        pciutils # list of PCI devices (lspci)
        vim # text editor
        curl
        git
        bluetui # TUI for bluetooth management
        wiremix # TUI tool to configure sound output / input
        tree
        ffmpeg # video editor
        netcat # network debugging tool
        tcpdump # network debugging tool
        net-tools # network debugging tool

        nvd # nixos package diff tool

        # file manager
        nautilus # GNOME Files
        udiskie # Auto mount for external disks
        jq # JSON Preview
        poppler # PDF Preview
        fd # File search
        ripgrep # Content search
        fzf # subtree navigation
        imagemagick # image preview and editor
    ];

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "26.05"; # Did you read the comment?
}
