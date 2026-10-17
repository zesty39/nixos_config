{ ... }:

{
  lsp.servers.lua_ls = {
    enable = true;
    config.settings.Lua = {
      hint = {
        enable = true;
        arrayIndex = "Disable";
      };
      diagnostics.globals = [ "vim" ];
      workspace.checkThirdParty = false;
      telemetry.enable = false;
    };
  };
}
