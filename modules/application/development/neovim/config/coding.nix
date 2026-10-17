{ config, ... }:

{
  imports = [
    ./lsp/nix.nix
    ./lsp/bash.nix
    ./lsp/python.nix
    ./lsp/lua.nix
    ./lsp/json.nix
    ./lsp/yaml.nix
    ./lsp/toml.nix
    ./lsp/typescript.nix
    ./lsp/rust.nix
    ./lsp/cpp.nix
    ./lsp/markdown.nix
  ];

  # Load server defaults for the native LSP configuration API.
  plugins.lspconfig.enable = true;

  lsp = {
    codelens.enable = true;
    semanticTokens.enable = true;
    inlayHints = {
      enable = true;
      activate = false;
    };
  };

  plugins.blink-cmp = {
    enable = true;
    setupLspCapabilities = false;
    settings = {
      completion.list.selection = {
        preselect = false;
        auto_insert = false;
      };
      sources = {
        default = [
          "lazydev"
          "lsp"
          "path"
          "buffer"
          "snippets"
        ];
        providers.buffer.opts.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
        providers.lazydev = {
          name = "LazyDev";
          module = "lazydev.integrations.blink";
          score_offset = 100;
        };
      };
      snippets.preset = "default";
      enabled.__raw = "function() return vim.b.completion ~= false end";
      fuzzy.implementation = "rust";
    };
  };
  plugins.friendly-snippets.enable = true;
  plugins.treesitter = {
    enable = true;
    grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      nix
      lua
      luap
      python
      rust
      c
      cpp
      bash
      cmake
      markdown
      markdown_inline
      json
      yaml
      toml
      javascript
      typescript
      tsx
      html
      css
      vim
      vimdoc
      regex
    ];
    highlight.enable = true;
    indent.enable = true;
    nixvimInjections = false;
  };
  plugins.treesitter-textobjects.enable = true;
  # The modern textobjects API requires its own setup call.
  extraConfigLua = ''
    require('nvim-treesitter-textobjects').setup({
      select = { lookahead = true },
      move = { set_jumps = true },
    })
  '';
  plugins.ts-autotag = {
    enable = true;
    settings.opts = {
      enable_close = true;
      enable_rename = true;
      enable_close_on_slash = true;
    };
  };

  plugins = {
    aerial = {
      enable = true;
      settings = {
        backends = [
          "lsp"
          "treesitter"
          "markdown"
          "man"
        ];
        layout.default_direction = "right";
      };
    };
    guess-indent.enable = true;
    highlight-colors.enable = true;
    lazydev = {
      enable = true;
      settings.integrations = {
        cmp = false;
        lspconfig = false;
      };
    };
    conform-nvim = {
      enable = true;
      autoInstall.enable = true;
      settings = {
        default_format_opts.lsp_format = "fallback";
        formatters_by_ft = {
          nix = [ "nixfmt" ];
          lua = [ "stylua" ];
          python = [ "ruff_format" ];
          sh = [ "shfmt" ];
          bash = [ "shfmt" ];
          rust = [ "rustfmt" ];
          c = [ "clang_format" ];
          cpp = [ "clang_format" ];
          javascript = [ "prettier" ];
          typescript = [ "prettier" ];
          javascriptreact = [ "prettier" ];
          typescriptreact = [ "prettier" ];
          json = [ "prettier" ];
          yaml = [ "prettier" ];
          markdown = [ "prettier" ];
          html = [ "prettier" ];
          css = [ "prettier" ];
        };
      };
    };
  };
  autoGroups.Coding.clear = true;
  autoCmd = [
    {
      group = "Coding";
      event = [
        "BufEnter"
        "LspAttach"
      ];
      callback.__raw = ''
        function(args)
          if vim.g.disable_rooter then
            return
          end
          local path = vim.api.nvim_buf_get_name(args.buf)
          if path == "" or vim.bo[args.buf].buftype ~= "" then
            return
          end
          local dir
          for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
            if client.config.root_dir then
              dir = client.config.root_dir
              break
            end
          end
          dir = dir
            or vim.fs.root(path, {
              ".git",
              ".hg",
              "flake.nix",
              "package.json",
              "Cargo.toml",
              "pyproject.toml",
              "Makefile",
            })
          if dir and vim.fn.getcwd() ~= dir then
            vim.api.nvim_set_current_dir(dir)
          end
        end
      '';
    }
    {
      group = "Coding";
      event = [ "FileType" ];
      callback.__raw = ''
        function(args)
          vim.b[args.buf].disable_autoformat = true
          vim.b[args.buf].completion = false
        end
      '';
      pattern = "bigfile";
    }
  ];

  plugins.nvim-autopairs = {
    enable = true;
    settings.check_ts = true;
  };
  plugins.nvim-surround.enable = true;
}
