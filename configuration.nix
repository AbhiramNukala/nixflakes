# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./config/nix
    ./hardware-configuration.nix
  ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "moipc"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/mnt/Localdisk" = {
    device = "/dev/disk/by-uuid/F21C2B081C2AC805";
    fsType = "ntfs-3g";
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  services.displayManager.sddm.enable = true;
  services.xserver = {
    enable = true;
    excludePackages = with pkgs; [
      xterm
    ];
  };
  # services.desktopManager.cosmic.enable = true;
  # environment.cosmic.excludePackages = with pkgs; [
  #   cosmic-edit
  # ];
  # services.emacs = {
  #   enable = true;
  #   defaultEditor = true;
  #   package = pkgs.emacs-pgtk;
  # };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.dconf.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = 1;
    # ANDROID_SDK_ROOT = "${pkgs.androidsdk}/libexec/android-sdk";
  };
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;
  services.gvfs.enable = true;

  users.defaultUserShell = pkgs.zsh;
  programs.nix-ld.enable = true;
  environment.shells = with pkgs; [
    # fish
    zsh
  ];
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # Enables gabbar's systemd --user instance to start at boot, without a
  # login session — required for user-level services (e.g. hermes-gateway)
  # to run headless/on boot. Equivalent to `loginctl enable-linger gabbar`.
  systemd.tmpfiles.rules = [
    "f /var/lib/systemd/linger/gabbar 0644 root root -"
  ];

  users.users.gabbar = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "gabbar";
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
      "kvm"
      "libvirtd"
      "hermes"
    ];
    packages = with pkgs; [
      vesktop
      kitty
      rofi
      waybar

      zed-editor

      maven
      gradle
      jdt-language-server

      awww
      networkmanagerapplet
      dunst
      nautilus
      cmake
      libvterm
      hyprshot
      wl-clipboard
      clipman
      dysk

      btop

      devenv
      direnv

      brave
      nodejs

      nil
      nixd

      zip
      unzip

      qbittorrent

      dnsmasq
      virglrenderer

      ani-cli

      pkgs.jellyfin
      pkgs.jellyfin-web
      pkgs.jellyfin-ffmpeg
      lavat
      inputs.antigravity-nix.packages.${system}.google-antigravity-cli

      obsidian
      scrcpy
      localsend
      jetbrains.idea
      obs-studio
      # kdePackages.kdenlive

      google-chrome

      telegram-desktop
      pnpm
      imagemagick
      # firefox
    ];
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    # android_sdk.accept_license = true;
  };

  programs.kdeconnect.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
  ];

#   virtualisation.libvirtd = {
#     enable = true;
#
#     qemu = {
#       package = pkgs.qemu_kvm;
#       runAsRoot = true;
#
#       # 🔥 THIS helps with graphics acceleration
#       swtpm.enable = true;
#     };
#   };
  # programs.virt-manager.enable = true;
  # services.qemuGuest.enable = true;
  # services.spice-vdagentd.enable = true;

  hardware.graphics = {
    enable = true;
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  security = {
    polkit.enable = true;
    pam.services.hyprlock = { };
  };

  services.flatpak = {
    enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.java = {
    enable = true;
    package = pkgs.openjdk25;
  };

  fonts.packages = [
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.vista-fonts
    pkgs.corefonts
    pkgs.font-awesome
    pkgs.nerd-fonts.iosevka
    pkgs.material-design-icons
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  # hardware.graphics.enable = true;

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8081 8096 8920 ];
  networking.firewall.allowedUDPPorts = [ 1900 7359 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
