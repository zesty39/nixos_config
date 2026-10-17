{ pkgs, ... }:

{
  extraPackages = [ pkgs.shellcheck ];
  lsp.servers.bashls = {
    enable = true;
    config.filetypes = [
      "sh"
      "bash"
      "zsh"
    ];
  };
}
