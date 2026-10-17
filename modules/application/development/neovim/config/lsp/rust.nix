{ ... }:

{
  lsp.servers.rust_analyzer = {
    enable = true;
    config.settings."rust-analyzer" = {
      files.exclude = [
        ".direnv"
        ".git"
        "target"
      ];
      check = {
        command = "clippy";
        extraArgs = [ "--no-deps" ];
      };
    };
  };
}
