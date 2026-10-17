{ pkgs, ... }:

{
  extraPackages = [ pkgs.nixfmt ];
  lsp.servers.nixd = {
    enable = true;
    config = {
      cmd = [
        "${pkgs.nixd}/bin/nixd"
        "--nixpkgs-expr"
        "import ${pkgs.path} { }"
        "--nixos-options-expr"
        "{ }"
      ];
      filetypes = [ "nix" ];
      settings.nixd.formatting.command = [ "${pkgs.nixfmt}/bin/nixfmt" ];
      root_dir.__raw = ''
        function(bufnr, on_dir)
          local path = vim.api.nvim_buf_get_name(bufnr)
          on_dir(vim.fs.root(path, { 'flake.nix', '.git' }) or vim.fs.dirname(path))
        end
      '';
      before_init.__raw = ''
        function(_, server)
          server.settings.nixd = {
            nixpkgs = { expr = 'import ${pkgs.path} { }' },
            formatting = { command = { '${pkgs.nixfmt}/bin/nixfmt' } },
          }
          if not vim.uv.fs_stat(vim.fs.joinpath(server.root_dir, 'flake.nix')) then
            return
          end
          local flake = '(builtins.getFlake ' .. vim.json.encode(server.root_dir) .. ')'
          local options = '(let configurations = builtins.attrValues (' .. flake .. '.nixosConfigurations or {}); in if configurations == [] then {} else (builtins.head configurations).options)'
          server.settings.nixd.nixpkgs = { expr = 'import ' .. flake .. '.inputs.nixpkgs { }' }
          server.settings.nixd.options = {
              nixos = { expr = options },
              ['home-manager'] = { expr = '(let options = ' .. options .. '; in if options ? home-manager then options.home-manager.users.type.getSubOptions [] else {})' },
          }
        end
      '';
    };
  };
}
