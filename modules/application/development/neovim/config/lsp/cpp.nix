{ pkgs, ... }:

{
  lsp.servers.neocmake.enable = true;
  lsp.servers.clangd = {
    enable = true;
    config = {
      cmd = [
        "${pkgs.clang-tools}/bin/clangd"
        "--header-insertion=never"
      ];
      capabilities.offsetEncoding = "utf-8";
    };
  };
}
