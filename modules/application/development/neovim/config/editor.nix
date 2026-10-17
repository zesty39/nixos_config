{ pkgs, ... }:

{
  extraPackages = [
    pkgs.ripgrep
    pkgs.fd
  ];
  extraFiles."lua/theme.lua".source = ../resources/theme.lua;
  colorschemes.catppuccin = {
    enable = true;
    settings = {
      flavour = "mocha";
      transparent_background = true;
      float.transparent = true;
      term_colors = true;
      default_integrations = false;
      integrations = {
        blink_cmp = {
          style = "bordered";
        };
        gitsigns = true;
        treesitter = true;
        which_key = true;
        native_lsp.enabled = true;
        noice = true;
        snacks = {
          enabled = true;
          indent_scope_color = "mauve";
        };
        lualine.all.__raw = "require('theme').lualine";
      };
      custom_highlights.__raw = "require('theme').highlights";
    };
  };
  plugins.web-devicons.enable = true;
  plugins.gitsigns.enable = true;
  plugins.noice = {
    enable = true;
    settings = {
      cmdline = {
        enabled = true;
        view = "cmdline_popup";
      };
      presets.bottom_search = false;
      views.cmdline_popup = {
        position = {
          row = "50%";
          col = "50%";
        };
        size = {
          width = 60;
          height = "auto";
        };
        border.style = "rounded";
      };
      messages.enabled = false;
      notify.enabled = false;
      lsp = {
        progress.enabled = false;
        hover.enabled = false;
        signature.enabled = false;
        message.enabled = false;
      };
    };
  };
  plugins.snacks = {
    enable = true;
    settings = {
      explorer.enabled = true;
      indent.enabled = true;
      picker = {
        enabled = true;
        ui_select = true;
        prompt = "  ";
        layouts = {
          default.layout.backdrop = false;
          default.layout.border = "none";
          vertical.layout.border = "rounded";
        };
        sources.explorer = {
          hidden = false;
          ignored = false;
          follow_file = true;
          watch = true;
          auto_close = true;
          jump.close = true;
          layout = {
            preset = "vertical";
            preview = false;
            layout = {
              width = 0.65;
              height = 0.8;
            };
          };
        };
      };
      dashboard = {
        enabled = true;
        preset.keys = [
          {
            icon = " ";
            key = "n";
            desc = "New file";
            action = ":enew";
          }
          {
            icon = " ";
            key = "f";
            desc = "Find files";
            action = "<leader>ff";
          }
          {
            icon = " ";
            key = "o";
            desc = "Recent files";
            action = "<leader>fo";
          }
          {
            icon = " ";
            key = "w";
            desc = "Find words";
            action = "<leader>fw";
          }
          {
            icon = " ";
            key = "'";
            desc = "Bookmarks";
            action = "<leader>f'";
          }
          {
            icon = " ";
            key = "?";
            desc = "Key mappings";
            action = "<leader>fk";
          }
          {
            icon = " ";
            key = "q";
            desc = "Quit";
            action = ":qa";
          }
        ];
        sections = [
          { section = "header"; }
          {
            section = "keys";
            gap = 1;
            padding = 1;
          }
        ];
      };
      notifier.enabled = true;
      input.enabled = true;
      terminal = {
        enabled = true;
        win = {
          position = "bottom";
          height = 10;
        };
      };
      bigfile.enabled = true;
      quickfile.enabled = true;
      styles = {
        notification.border = "rounded";
        input.border = "rounded";
        terminal.border = "rounded";
      };
    };
  };
  plugins.bufferline = {
    enable = true;
    settings = {
      highlights.__raw = "require('theme').bufferline";
      options = {
        always_show_bufferline = false;
        diagnostics = "nvim_lsp";
        close_command.__raw = "function(buf) Snacks.bufdelete(buf) end";
        right_mouse_command.__raw = "function(buf) Snacks.bufdelete(buf) end";
      };
    };
  };
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        theme = "catppuccin-nvim";
        globalstatus = true;
        section_separators = {
          left = "";
          right = "";
        };
        component_separators = {
          left = "";
          right = "";
        };
        disabled_filetypes.statusline = [ "snacks_dashboard" ];
      };
      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [
          "branch"
          "diff"
          "diagnostics"
        ];
        lualine_c = [ "filename" ];
        lualine_x = [
          "encoding"
          "fileformat"
          "filetype"
        ];
        lualine_y = [ "progress" ];
        lualine_z = [ "location" ];
      };
    };
  };
  plugins.which-key.settings.win = {
    border = "rounded";
    wo.winblend = 0;
  };
  plugins.blink-cmp.settings.completion = {
    menu.border = "rounded";
    documentation = {
      auto_show = true;
      window.border = "rounded";
    };
  };

  extraConfigLuaPost = ''
    do
      local search_keys = { n = true, N = true, ["*"] = true, ["#"] = true, ["/"] = true, ["?"] = true }
      vim.on_key(function(key)
        if vim.api.nvim_get_mode().mode == "n" then
          vim.opt.hlsearch = search_keys[vim.fn.keytrans(key)] == true
        end
      end, vim.api.nvim_create_namespace("WorkflowSearch"))
    end
  '';
}
