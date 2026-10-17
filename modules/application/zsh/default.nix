{ config, lib, pkgs, targetUser, ... }:

{
  config = lib.mkIf config.application.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = false;
    };
    environment.pathsToLink = [ "/share/zsh" ];
    users.users.${targetUser}.shell = pkgs.zsh;

    home-manager.users.${targetUser} = { lib, ... }: {
      home.packages = [ pkgs.git ];

      home.file.".zimrc".source = ./resources/zimrc;

      home.activation.installZimModules = lib.hm.dag.entryAfter [ "linkGeneration" "installPackages" ] ''
        run ${pkgs.coreutils}/bin/env \
          ZIM_HOME="$HOME/.zim" \
          ZIM_CONFIG_FILE="$HOME/.zimrc" \
          PATH="${lib.makeBinPath [ pkgs.git ]}:$PATH" \
          ${pkgs.zsh}/bin/zsh -c 'source ${pkgs.zimfw}/zimfw.zsh install'
      '';

      programs.zsh = {
        enable = true;
        defaultKeymap = "emacs";
        enableCompletion = false;
        history.ignoreAllDups = true;
        initContent = lib.mkMerge [
          (lib.mkOrder 600 ''
            source ${./resources/init.zsh}
          '')
          (lib.mkOrder 1300 ''
            source ${./resources/keybindings.zsh}
          '')
        ];
      };

      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
        options = [ "--cmd" "j" ];
      };
    };
  };
}
