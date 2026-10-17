{ ... }:

{
  keymaps = [
    # Files and buffers
    {
      mode = "n";
      key = "H";
      action = "<Cmd>BufferLineCyclePrev<CR>";
      options.desc = "Previous buffer";
    }
    {
      mode = "n";
      key = "L";
      action = "<Cmd>BufferLineCycleNext<CR>";
      options.desc = "Next buffer";
    }
    {
      mode = "n";
      key = "<leader>w";
      action = "<Cmd>write<CR>";
      options.desc = "Save file";
    }
    {
      mode = "n";
      key = "<leader>n";
      action = "<Cmd>enew<CR>";
      options.desc = "New file";
    }
    {
      mode = "n";
      key = "<leader>c";
      action.__raw = "function() Snacks.bufdelete() end";
      options.desc = "Close buffer";
    }
    {
      mode = "n";
      key = "<leader>C";
      action.__raw = "function() Snacks.bufdelete({ force = true }) end";
      options.desc = "Force close buffer";
    }
    {
      mode = "n";
      key = "<leader>bd";
      action.__raw = "function() Snacks.bufdelete() end";
      options.desc = "Delete buffer";
    }
    {
      mode = "n";
      key = "<leader>o";
      action.__raw = "function() Snacks.explorer.reveal() end";
      options.desc = "Focus file tree";
    }
    {
      mode = "n";
      key = "<leader>e";
      action.__raw = "function() Snacks.explorer() end";
      options.desc = "Toggle file tree";
    }

    # Windows
    {
      mode = "n";
      key = "<leader>q";
      action = "<Cmd>quit<CR>";
      options.desc = "Quit window";
    }
    {
      mode = "n";
      key = "|";
      action = "<Cmd>vsplit<CR>";
      options.desc = "Vertical split";
    }
    {
      mode = "n";
      key = "\\";
      action = "<Cmd>split<CR>";
      options.desc = "Horizontal split";
    }
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options.desc = "Focus left window";
    }
    {
      mode = "t";
      key = "<C-h>";
      action = "<C-\\><C-n><C-w>h";
      options.desc = "Focus left window";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options.desc = "Focus lower window";
    }
    {
      mode = "t";
      key = "<C-j>";
      action = "<C-\\><C-n><C-w>j";
      options.desc = "Focus lower window";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options.desc = "Focus upper window";
    }
    {
      mode = "t";
      key = "<C-k>";
      action = "<C-\\><C-n><C-w>k";
      options.desc = "Focus upper window";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options.desc = "Focus right window";
    }
    {
      mode = "t";
      key = "<C-l>";
      action = "<C-\\><C-n><C-w>l";
      options.desc = "Focus right window";
    }
    {
      mode = "n";
      key = "<C-Up>";
      action = "<Cmd>resize +2<CR>";
      options.desc = "Increase window height";
    }
    {
      mode = "n";
      key = "<C-Down>";
      action = "<Cmd>resize -2<CR>";
      options.desc = "Decrease window height";
    }
    {
      mode = "n";
      key = "<C-Left>";
      action = "<Cmd>vertical resize -2<CR>";
      options.desc = "Decrease window width";
    }
    {
      mode = "n";
      key = "<C-Right>";
      action = "<Cmd>vertical resize +2<CR>";
      options.desc = "Increase window width";
    }

    # Editing
    {
      mode = "n";
      key = "<Esc>";
      action = "<Cmd>nohlsearch<CR>";
      options.desc = "Clear search highlighting";
    }
    {
      mode = [
        "i"
        "s"
      ];
      key = "<Esc>";
      action = "<Cmd>lua vim.snippet.stop()<CR><Esc>";
      options.desc = "Stop snippet and leave insert mode";
    }
    {
      mode = "x";
      key = "<";
      action = "<gv";
      options.desc = "Indent left";
    }
    {
      mode = "x";
      key = ">";
      action = ">gv";
      options.desc = "Indent right";
    }

    # Find and search
    {
      mode = "n";
      key = "<leader>fn";
      action.__raw = "function() Snacks.picker.notifications() end";
      options.desc = "Find notifications";
    }
    {
      mode = "n";
      key = "<leader>fc";
      action.__raw = "function() Snacks.picker.grep_word() end";
      options.desc = "Find word under cursor";
    }
    {
      mode = "n";
      key = "<leader>fk";
      action.__raw = "function() Snacks.picker.keymaps() end";
      options.desc = "Find keymaps";
    }
    {
      mode = "n";
      key = "<leader>fh";
      action.__raw = "function() Snacks.picker.help() end";
      options.desc = "Find help";
    }
    {
      mode = "n";
      key = "<leader>fC";
      action.__raw = "function() Snacks.picker.commands() end";
      options.desc = "Find commands";
    }
    {
      mode = "n";
      key = "<leader>f'";
      action.__raw = "function() Snacks.picker.marks() end";
      options.desc = "Find marks";
    }
    {
      mode = "n";
      key = "<leader>fr";
      action.__raw = "function() Snacks.picker.registers() end";
      options.desc = "Find registers";
    }
    {
      mode = "n";
      key = "<leader>f<CR>";
      action.__raw = "function() Snacks.picker.resume() end";
      options.desc = "Resume previous search";
    }
    {
      mode = "n";
      key = "<leader>fF";
      action.__raw = "function() Snacks.picker.files({ hidden = true, ignored = true }) end";
      options.desc = "Find all files";
    }
    {
      mode = "n";
      key = "<leader>fb";
      action.__raw = "function() Snacks.picker.buffers() end";
      options.desc = "Find buffers";
    }
    {
      mode = "n";
      key = "<leader>fo";
      action.__raw = "function() Snacks.picker.recent() end";
      options.desc = "Find recent files";
    }
    {
      mode = "n";
      key = "<leader>fw";
      action.__raw = "function() Snacks.picker.grep() end";
      options.desc = "Search project text";
    }
    {
      mode = "n";
      key = "<leader>f?";
      action.__raw = "function() Snacks.picker.keymaps() end";
      options.desc = "Find keymaps";
    }
    {
      mode = "n";
      key = "<leader>ff";
      action.__raw = "function() Snacks.picker.files() end";
      options.desc = "Find files";
    }
    {
      mode = "n";
      key = "<leader>fg";
      action.__raw = "function() Snacks.picker.grep() end";
      options.desc = "Search project text";
    }

    # Language and diagnostics
    {
      mode = "n";
      key = "<leader>ls";
      action.__raw = "function() Snacks.picker.lsp_symbols() end";
      options.desc = "Find document symbols";
    }
    {
      mode = "n";
      key = "<leader>lS";
      action.__raw = "function() Snacks.picker.lsp_workspace_symbols() end";
      options.desc = "Find workspace symbols";
    }
    {
      mode = "n";
      key = "gD";
      action.__raw = "function() Snacks.picker.lsp_declarations() end";
      options.desc = "Go to declaration";
    }
    {
      mode = "n";
      key = "gi";
      action.__raw = "function() Snacks.picker.lsp_implementations() end";
      options.desc = "Go to implementation";
    }
    {
      mode = "n";
      key = "gr";
      action.__raw = "function() Snacks.picker.lsp_references() end";
      options.desc = "Find references";
    }
    {
      mode = "n";
      key = "gy";
      action.__raw = "function() Snacks.picker.lsp_type_definitions() end";
      options.desc = "Go to type definition";
    }
    {
      mode = "x";
      key = "<leader>la";
      action.__raw = "vim.lsp.buf.code_action";
      options.desc = "Code action";
    }
    {
      mode = "n";
      key = "<leader>la";
      action.__raw = "vim.lsp.buf.code_action";
      options.desc = "Code action";
    }
    {
      mode = "n";
      key = "<leader>lr";
      action.__raw = "vim.lsp.buf.rename";
      options.desc = "Rename symbol";
    }
    {
      mode = "n";
      key = "<leader>ld";
      action.__raw = "function() Snacks.picker.lsp_definitions() end";
      options.desc = "Go to definition";
    }
    {
      mode = "n";
      key = "<leader>lh";
      action.__raw = "vim.lsp.buf.signature_help";
      options.desc = "Signature help";
    }
    {
      mode = "n";
      key = "<leader>lR";
      action.__raw = "function() Snacks.picker.lsp_references() end";
      options.desc = "Find references";
    }
    {
      mode = "n";
      key = "<leader>lf";
      action.__raw = "function() require('conform').format({ async = false, timeout_ms = 10000, lsp_format = 'fallback' }) end";
      options.desc = "Format buffer";
    }
    {
      mode = "n";
      key = "<leader>lD";
      action.__raw = "function() Snacks.picker.diagnostics() end";
      options.desc = "Find diagnostics";
    }
    {
      mode = "n";
      key = "<leader>le";
      action.__raw = "vim.diagnostic.open_float";
      options.desc = "Show diagnostic";
    }
    {
      mode = "n";
      key = "]d";
      action.__raw = "function() vim.diagnostic.jump({ count = 1, float = false }) end";
      options.desc = "Next diagnostic";
    }
    {
      mode = "n";
      key = "[d";
      action.__raw = "function() vim.diagnostic.jump({ count = -1, float = false }) end";
      options.desc = "Previous diagnostic";
    }
    {
      mode = "n";
      key = "<leader>fm";
      action.__raw = "function() require('conform').format({ async = false, timeout_ms = 10000, lsp_format = 'fallback' }) end";
      options.desc = "Format Nix buffer";
    }
    {
      mode = "n";
      key = "gd";
      action.__raw = "function() Snacks.picker.lsp_definitions() end";
      options.desc = "Go to definition";
    }
    {
      mode = "n";
      key = "K";
      action.__raw = "vim.lsp.buf.hover";
      options.desc = "Show documentation";
    }

    # Git
    {
      mode = "n";
      key = "<leader>gt";
      action.__raw = "function() Snacks.picker.git_status() end";
      options.desc = "View changed Git files";
    }
    {
      mode = "n";
      key = "[g";
      action.__raw = "function() require('gitsigns').nav_hunk('prev') end";
      options.desc = "Previous Git hunk";
    }
    {
      mode = "n";
      key = "]g";
      action.__raw = "function() require('gitsigns').nav_hunk('next') end";
      options.desc = "Next Git hunk";
    }
    {
      mode = "n";
      key = "[G";
      action.__raw = "function() require('gitsigns').nav_hunk('first') end";
      options.desc = "First Git hunk";
    }
    {
      mode = "n";
      key = "]G";
      action.__raw = "function() require('gitsigns').nav_hunk('last') end";
      options.desc = "Last Git hunk";
    }
    {
      mode = "n";
      key = "<leader>gl";
      action.__raw = "function() require('gitsigns').blame_line() end";
      options.desc = "Blame line";
    }
    {
      mode = "n";
      key = "<leader>gL";
      action.__raw = "function() require('gitsigns').blame_line({ full = true }) end";
      options.desc = "Full blame line";
    }
    {
      mode = "n";
      key = "<leader>gd";
      action.__raw = "function() Snacks.picker.git_diff() end";
      options.desc = "View Git diff";
    }
    {
      mode = "x";
      key = "<leader>gs";
      action.__raw = "function() require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end";
      options.desc = "Stage selected Git hunk";
    }
    {
      mode = "x";
      key = "<leader>gr";
      action.__raw = "function() require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end";
      options.desc = "Reset selected Git hunk";
    }
    {
      mode = "n";
      key = "<leader>gj";
      action.__raw = "function() require('gitsigns').nav_hunk('next') end";
      options.desc = "Next Git hunk";
    }
    {
      mode = "n";
      key = "<leader>gk";
      action.__raw = "function() require('gitsigns').nav_hunk('prev') end";
      options.desc = "Previous Git hunk";
    }
    {
      mode = "n";
      key = "<leader>gp";
      action.__raw = "function() require('gitsigns').preview_hunk() end";
      options.desc = "Preview Git hunk";
    }
    {
      mode = "n";
      key = "<leader>gb";
      action.__raw = "function() require('gitsigns').blame_line({ full = true }) end";
      options.desc = "Blame line";
    }
    {
      mode = "n";
      key = "<leader>gs";
      action.__raw = "function() require('gitsigns').stage_hunk() end";
      options.desc = "Stage Git hunk";
    }
    {
      mode = "n";
      key = "<leader>gr";
      action.__raw = "function() require('gitsigns').reset_hunk() end";
      options.desc = "Reset Git hunk";
    }
    {
      mode = "n";
      key = "<leader>gS";
      action.__raw = "function() require('gitsigns').stage_buffer() end";
      options.desc = "Stage Git buffer";
    }

    # Terminal
    {
      mode = [
        "n"
        "t"
        "i"
      ];
      key = "<M-=>";
      action.__raw = "function() Snacks.terminal.toggle(nil, { count = 2, win = { position = 'float', height = 0.8, width = 0.8 } }) end";
      options.desc = "Toggle float terminal";
    }
    {
      mode = "t";
      key = "<Esc>";
      action = "<C-\\><C-n>";
      options.desc = "Leave terminal mode";
    }
    {
      mode = "n";
      key = "<leader>tf";
      action.__raw = "function() Snacks.terminal.toggle(nil, { count = 2, win = { position = 'float', height = 0.8, width = 0.8 } }) end";
      options.desc = "Toggle float terminal";
    }
    {
      mode = "n";
      key = "<leader>th";
      action.__raw = "function() Snacks.terminal.toggle() end";
      options.desc = "Toggle horizontal terminal";
    }
    {
      mode = "n";
      key = "<leader>tv";
      action.__raw = "function() Snacks.terminal.toggle(nil, { count = 3, win = { position = 'right', width = 80, height = 0 } }) end";
      options.desc = "Toggle vertical terminal";
    }
    {
      mode = [
        "n"
        "t"
      ];
      key = "<leader>tt";
      action.__raw = "function() Snacks.terminal.toggle() end";
      options.desc = "Toggle terminal";
    }

    # UI toggles
    {
      mode = "n";
      key = "<leader>ut";
      action.__raw = "function() Snacks.picker.colorschemes() end";
      options.desc = "Choose theme";
    }
    {
      mode = "n";
      key = "<leader>uw";
      action.__raw = "function() Snacks.toggle.option('wrap'):toggle() end";
      options.desc = "Toggle line wrapping";
    }
    {
      mode = "n";
      key = "<leader>us";
      action.__raw = "function() Snacks.toggle.option('spell'):toggle() end";
      options.desc = "Toggle spelling";
    }
    {
      mode = "n";
      key = "<leader>un";
      action.__raw = "function() Snacks.toggle.option('number'):toggle() end";
      options.desc = "Toggle line numbers";
    }
    {
      mode = "n";
      key = "<leader>ur";
      action.__raw = "function() Snacks.toggle.option('relativenumber'):toggle() end";
      options.desc = "Toggle relative line numbers";
    }

    # Keymap help
    {
      mode = "n";
      key = "<leader>?";
      action.__raw = "function() require('which-key').show({ global = false }) end";
      options.desc = "Show buffer keymaps";
    }

    # Syntax-aware editing
    {
      mode = [
        "x"
        "o"
      ];
      key = "af";
      action.__raw = "function() require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects') end";
      options.desc = "Select outer function";
    }
    {
      mode = [
        "x"
        "o"
      ];
      key = "if";
      action.__raw = "function() require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects') end";
      options.desc = "Select inner function";
    }
    {
      mode = [
        "x"
        "o"
      ];
      key = "ac";
      action.__raw = "function() require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects') end";
      options.desc = "Select outer class";
    }
    {
      mode = [
        "x"
        "o"
      ];
      key = "ic";
      action.__raw = "function() require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects') end";
      options.desc = "Select inner class";
    }
    {
      mode = [
        "x"
        "o"
      ];
      key = "aa";
      action.__raw = "function() require('nvim-treesitter-textobjects.select').select_textobject('@parameter.outer', 'textobjects') end";
      options.desc = "Select outer parameter";
    }
    {
      mode = [
        "x"
        "o"
      ];
      key = "ia";
      action.__raw = "function() require('nvim-treesitter-textobjects.select').select_textobject('@parameter.inner', 'textobjects') end";
      options.desc = "Select inner parameter";
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "]f";
      action.__raw = "function() require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects') end";
      options.desc = "Next function start";
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "[f";
      action.__raw = "function() require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects') end";
      options.desc = "Previous function start";
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "]F";
      action.__raw = "function() require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects') end";
      options.desc = "Next function end";
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "[F";
      action.__raw = "function() require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects') end";
      options.desc = "Previous function end";
    }
    {
      mode = "n";
      key = ">A";
      action.__raw = "function() require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner') end";
      options.desc = "Swap with next parameter";
    }
    {
      mode = "n";
      key = "<A";
      action.__raw = "function() require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.inner') end";
      options.desc = "Swap with previous parameter";
    }
    # Additional syntax-aware selections, movements, and swaps.
    {
      mode = [
        "x"
        "o"
      ];
      key = "ak";
      action.__raw = "function() require('nvim-treesitter-textobjects.select').select_textobject('@block.outer', 'textobjects') end";
      options.desc = "Select outer block";
    }
    {
      mode = [
        "x"
        "o"
      ];
      key = "ik";
      action.__raw = "function() require('nvim-treesitter-textobjects.select').select_textobject('@block.inner', 'textobjects') end";
      options.desc = "Select inner block";
    }
    {
      mode = [
        "x"
        "o"
      ];
      key = "ao";
      action.__raw = "function() require('nvim-treesitter-textobjects.select').select_textobject('@loop.outer', 'textobjects') end";
      options.desc = "Select outer loop";
    }
    {
      mode = [
        "x"
        "o"
      ];
      key = "io";
      action.__raw = "function() require('nvim-treesitter-textobjects.select').select_textobject('@loop.inner', 'textobjects') end";
      options.desc = "Select inner loop";
    }
    {
      mode = [
        "x"
        "o"
      ];
      key = "a?";
      action.__raw = "function() require('nvim-treesitter-textobjects.select').select_textobject('@conditional.outer', 'textobjects') end";
      options.desc = "Select outer conditional";
    }
    {
      mode = [
        "x"
        "o"
      ];
      key = "i?";
      action.__raw = "function() require('nvim-treesitter-textobjects.select').select_textobject('@conditional.inner', 'textobjects') end";
      options.desc = "Select inner conditional";
    }
    {
      mode = [
        "x"
        "o"
      ];
      key = "au";
      action.__raw = "function() require('nvim-treesitter-textobjects.select').select_textobject('@call.outer', 'textobjects') end";
      options.desc = "Select outer call";
    }
    {
      mode = [
        "x"
        "o"
      ];
      key = "iu";
      action.__raw = "function() require('nvim-treesitter-textobjects.select').select_textobject('@call.inner', 'textobjects') end";
      options.desc = "Select inner call";
    }
    {
      mode = [
        "x"
        "o"
      ];
      key = "a=";
      action.__raw = "function() require('nvim-treesitter-textobjects.select').select_textobject('@assignment.outer', 'textobjects') end";
      options.desc = "Select outer assignment";
    }
    {
      mode = [
        "x"
        "o"
      ];
      key = "i=";
      action.__raw = "function() require('nvim-treesitter-textobjects.select').select_textobject('@assignment.inner', 'textobjects') end";
      options.desc = "Select inner assignment";
    }
    {
      mode = [
        "x"
        "o"
      ];
      key = "a/";
      action.__raw = "function() require('nvim-treesitter-textobjects.select').select_textobject('@comment.outer', 'textobjects') end";
      options.desc = "Select comment";
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "]c";
      action.__raw = "function() if vim.wo.diff then vim.cmd('normal! ]c') else require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects') end end";
      options.desc = "Go to next class start";
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "]C";
      action.__raw = "function() if vim.wo.diff then vim.cmd('normal! ]C') else require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects') end end";
      options.desc = "Go to next class end";
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "[c";
      action.__raw = "function() if vim.wo.diff then vim.cmd('normal! [c') else require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects') end end";
      options.desc = "Go to previous class start";
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "[C";
      action.__raw = "function() if vim.wo.diff then vim.cmd('normal! [C') else require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects') end end";
      options.desc = "Go to previous class end";
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "]a";
      action.__raw = "function() require('nvim-treesitter-textobjects.move').goto_next_start('@parameter.inner', 'textobjects') end";
      options.desc = "Go to next parameter start";
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "]A";
      action.__raw = "function() require('nvim-treesitter-textobjects.move').goto_next_end('@parameter.inner', 'textobjects') end";
      options.desc = "Go to next parameter end";
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "[a";
      action.__raw = "function() require('nvim-treesitter-textobjects.move').goto_previous_start('@parameter.inner', 'textobjects') end";
      options.desc = "Go to previous parameter start";
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "[A";
      action.__raw = "function() require('nvim-treesitter-textobjects.move').goto_previous_end('@parameter.inner', 'textobjects') end";
      options.desc = "Go to previous parameter end";
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "]k";
      action.__raw = "function() require('nvim-treesitter-textobjects.move').goto_next_start('@block.outer', 'textobjects') end";
      options.desc = "Go to next block start";
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "]K";
      action.__raw = "function() require('nvim-treesitter-textobjects.move').goto_next_end('@block.outer', 'textobjects') end";
      options.desc = "Go to next block end";
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "[k";
      action.__raw = "function() require('nvim-treesitter-textobjects.move').goto_previous_start('@block.outer', 'textobjects') end";
      options.desc = "Go to previous block start";
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "[K";
      action.__raw = "function() require('nvim-treesitter-textobjects.move').goto_previous_end('@block.outer', 'textobjects') end";
      options.desc = "Go to previous block end";
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "]o";
      action.__raw = "function() require('nvim-treesitter-textobjects.move').goto_next_start('@loop.outer', 'textobjects') end";
      options.desc = "Go to next loop start";
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "[o";
      action.__raw = "function() require('nvim-treesitter-textobjects.move').goto_previous_start('@loop.outer', 'textobjects') end";
      options.desc = "Go to previous loop start";
    }
    {
      mode = "n";
      key = ">F";
      action.__raw = "function() require('nvim-treesitter-textobjects.swap').swap_next('@function.outer') end";
      options.desc = "Swap with next function";
    }
    {
      mode = "n";
      key = "<F";
      action.__raw = "function() require('nvim-treesitter-textobjects.swap').swap_previous('@function.outer') end";
      options.desc = "Swap with previous function";
    }

    # Additional editor actions and toggles
    {
      mode = "n";
      key = "<leader>lO";
      action = "<Cmd>AerialToggle<CR>";
      options = {
        desc = "Toggle code outline";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>li";
      action = "<Cmd>checkhealth vim.lsp<CR>";
      options = {
        desc = "LSP information";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>R";
      action.__raw = ''
        function()
          Snacks.rename.rename_file()
        end
      '';
      options = {
        desc = "Rename file";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>Q";
      action = "<Cmd>confirm qall<CR>";
      options = {
        desc = "Quit all windows";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>xq";
      action = "<Cmd>copen<CR>";
      options = {
        desc = "Open quickfix list";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>xl";
      action = "<Cmd>lopen<CR>";
      options = {
        desc = "Open location list";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>bc";
      action.__raw = ''
        function()
          Snacks.bufdelete.other()
        end
      '';
      options = {
        desc = "Close other buffers";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>bC";
      action.__raw = ''
        function()
          Snacks.bufdelete.all()
        end
      '';
      options = {
        desc = "Close all buffers";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>bl";
      action = "<Cmd>BufferLineCloseLeft<CR>";
      options = {
        desc = "Close buffers to the left";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>br";
      action = "<Cmd>BufferLineCloseRight<CR>";
      options = {
        desc = "Close buffers to the right";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>bse";
      action = "<Cmd>BufferLineSortByExtension<CR>";
      options = {
        desc = "Sort buffers by extension";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>bsd";
      action = "<Cmd>BufferLineSortByDirectory<CR>";
      options = {
        desc = "Sort buffers by directory";
        silent = true;
      };
    }
    {
      mode = "n";
      key = ">b";
      action = "<Cmd>BufferLineMoveNext<CR>";
      options = {
        desc = "Move buffer right";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<b";
      action = "<Cmd>BufferLineMovePrev<CR>";
      options = {
        desc = "Move buffer left";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>/";
      action = "gcc";
      options = {
        desc = "Toggle comment line";
        silent = true;
        remap = true;
      };
    }
    {
      mode = "x";
      key = "<leader>/";
      action = "gc";
      options = {
        desc = "Toggle comment";
        silent = true;
        remap = true;
      };
    }
    {
      mode = "n";
      key = "[e";
      action.__raw = ''
        function()
          vim.diagnostic.jump({ count = -1 * vim.v.count1, severity = vim.diagnostic.severity.ERROR })
        end
      '';
      options = {
        desc = "Previous error";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "]e";
      action.__raw = ''
        function()
          vim.diagnostic.jump({ count = 1 * vim.v.count1, severity = vim.diagnostic.severity.ERROR })
        end
      '';
      options = {
        desc = "Next error";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "[w";
      action.__raw = ''
        function()
          vim.diagnostic.jump({ count = -1 * vim.v.count1, severity = vim.diagnostic.severity.WARN })
        end
      '';
      options = {
        desc = "Previous warning";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "]w";
      action.__raw = ''
        function()
          vim.diagnostic.jump({ count = 1 * vim.v.count1, severity = vim.diagnostic.severity.WARN })
        end
      '';
      options = {
        desc = "Next warning";
        silent = true;
      };
    }
    {
      mode = "n";
      key = ">K";
      action.__raw = ''
        function()
          require("nvim-treesitter-textobjects.swap").swap_next("@block.outer")
        end
      '';
      options = {
        desc = "Swap block";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<K";
      action.__raw = ''
        function()
          require("nvim-treesitter-textobjects.swap").swap_previous("@block.outer")
        end
      '';
      options = {
        desc = "Swap block";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>uv";
      action.__raw = ''
        function()
          Snacks.toggle({
            name = "Virtual text",
            get = function()
              return vim.diagnostic.config().virtual_text ~= false
            end,
            set = function(value)
              vim.diagnostic.config({ virtual_text = value })
            end,
          }):toggle()
        end
      '';
      options = {
        desc = "Toggle virtual text";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>uV";
      action.__raw = ''
        function()
          Snacks.toggle({
            name = "Virtual lines",
            get = function()
              return vim.diagnostic.config().virtual_lines ~= false
            end,
            set = function(value)
              vim.diagnostic.config({ virtual_lines = value })
            end,
          }):toggle()
        end
      '';
      options = {
        desc = "Toggle virtual lines";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>uN";
      action.__raw = ''
        (function()
          local notify = vim.notify
          return function()
            Snacks.toggle({
              name = "Notifications",
              get = function()
                return not vim.g.disable_notifications
              end,
              set = function(value)
                vim.g.disable_notifications = not value
                vim.notify = value and notify or function() end
              end,
            }):toggle()
          end
        end)()
      '';
      options = {
        desc = "Toggle notifications";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ud";
      action.__raw = ''
        function()
          Snacks.toggle.diagnostics():toggle()
        end
      '';
      options = {
        desc = "Toggle diagnostics";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>uH";
      action.__raw = ''
        function()
          Snacks.toggle.inlay_hints():toggle()
        end
      '';
      options = {
        desc = "Toggle inlay hints";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>uI";
      action.__raw = ''
        function()
          Snacks.toggle.indent():toggle()
        end
      '';
      options = {
        desc = "Toggle indent guides";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>uS";
      action.__raw = ''
        function()
          Snacks.toggle.option("conceallevel", { off = 0, on = 2, name = "Conceal" }):toggle()
        end
      '';
      options = {
        desc = "Toggle conceal";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ug";
      action.__raw = ''
        function()
          Snacks.toggle.option("signcolumn", { off = "no", on = "yes:1", name = "Sign column" }):toggle()
        end
      '';
      options = {
        desc = "Toggle sign column";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>uA";
      action.__raw = ''
        function()
          Snacks.toggle({
            name = "Project root",
            get = function()
              return not vim.g.disable_rooter
            end,
            set = function(value)
              vim.g.disable_rooter = not value
            end,
          }):toggle()
        end
      '';
      options = {
        desc = "Toggle project root";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>uc";
      action.__raw = ''
        function()
          Snacks.toggle({
            name = "Completion",
            get = function()
              return vim.b.completion ~= false
            end,
            set = function(value)
              vim.b.completion = value
            end,
          }):toggle()
        end
      '';
      options = {
        desc = "Toggle completion";
        silent = true;
      };
    }
  ];
  plugins.which-key = {
    enable = true;
    settings.spec = [
      {
        __unkeyed-1 = "<leader>u";
        group = "UI toggles";
      }
      {
        __unkeyed-1 = "<leader>b";
        group = "Buffers";
      }
      {
        __unkeyed-1 = "<leader>f";
        group = "Find";
      }
      {
        __unkeyed-1 = "<leader>t";
        group = "Terminal";
      }
      {
        __unkeyed-1 = "<leader>l";
        group = "Language and diagnostics";
      }
      {
        __unkeyed-1 = "<leader>g";
        group = "Git";
      }
      {
        __unkeyed-1 = "<leader>x";
        group = "Lists";
      }
      {
        __unkeyed-1 = "<leader>bs";
        group = "Sort buffers";
      }
    ];
  };

  autoGroups.KeymapWindows.clear = true;
  autoCmd = [
    {
      group = "KeymapWindows";
      event = [ "FileType" ];
      callback.__raw = ''
        function(args)
          if vim.tbl_contains({ "help", "man", "qf", "checkhealth", "aerial" }, vim.bo[args.buf].filetype) then
            vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = args.buf, silent = true, desc = "Close window" })
          end
        end
      '';
    }
  ];

  plugins.blink-cmp.settings = {
    keymap = {
      preset = "none";
      "<C-Space>" = [
        "show"
        "fallback"
      ];
      "<CR>" = [
        "accept"
        "fallback"
      ];
      "<C-n>" = [
        "select_next"
        "fallback"
      ];
      "<C-p>" = [
        "select_prev"
        "fallback"
      ];
      "<C-e>" = [
        "cancel"
        "fallback"
      ];
      "<Tab>" = [
        "select_next"
        "snippet_forward"
        "fallback"
      ];
      "<S-Tab>" = [
        "select_prev"
        "snippet_backward"
        "fallback"
      ];
    };
  };
  plugins.snacks.settings.picker.sources.explorer = {
    win.list.keys = {
      O = "explorer_open";
      "<S-CR>" = "explorer_open";
    };
  };
  plugins.snacks.settings.terminal.win = {
    keys.term_normal = {
      __unkeyed-1 = "<Esc>";
      __unkeyed-2 = "<C-\\><C-n>";
      mode = "t";
      expr = false;
      desc = "Leave terminal mode";
    };
  };
}
