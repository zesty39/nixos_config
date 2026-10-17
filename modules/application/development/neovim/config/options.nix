{ pkgs, ... }:

{
  extraPackages = [ pkgs.wl-clipboard ];
  viAlias = true;
  vimAlias = false;
  globals.mapleader = " ";
  opts = {
    undofile = true;
    confirm = true;
    ignorecase = true;
    smartcase = true;
    splitbelow = true;
    splitright = true;
    expandtab = true;
    tabstop = 2;
    shiftwidth = 0;
    copyindent = true;
    preserveindent = true;
    shiftround = true;
    cursorline = true;
    cmdheight = 0;
    timeoutlen = 500;
    updatetime = 300;
    winborder = "rounded";
    breakindent = true;
    linebreak = true;
    title = true;
    diffopt = "internal,filler,closeoff,algorithm:histogram,linematch:60";
    clipboard = "unnamedplus";
    number = true;
    relativenumber = false;
    termguicolors = true;
    showmode = false;
    laststatus = 3;
    spell = false;
    wrap = false;
    signcolumn = "yes:1";
    virtualedit = "onemore";
    fileencodings = "utf-8,gbk,chinese,latin1";
    list = true;
    listchars = {
      tab = "   ";
      extends = "›";
      precedes = "‹";
      trail = "·";
      nbsp = "␣";
    };
    guicursor = "n-v-sm:block,i-c-ci-ve:ver25,r-cr-o:hor20";
  };
  extraConfigLuaPost = ''
    vim.diagnostic.config({ virtual_text = true, virtual_lines = false, signs = false, underline = true })
    vim.api.nvim_create_autocmd('VimLeave', {
      group = vim.api.nvim_create_augroup('RestoreCursorOnExit', { clear = true }),
      desc = 'Restore the terminal default cursor on interactive exit',
      callback = function()
        if #vim.api.nvim_list_uis() > 0 then
          vim.opt.guicursor = ""
        end
      end,
    })
    vim.api.nvim_create_user_command('TrimFile', function()
      if vim.bo.readonly or not vim.bo.modifiable then
        error('TrimFile requires a writable, modifiable buffer')
      end
      local view = vim.fn.winsaveview()
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      local changed = false
      for index, line in ipairs(lines) do
        local cleaned = line:gsub('[ \t\r]+$', "")
        if cleaned ~= line then changed = true end
        lines[index] = cleaned
      end
      if changed then vim.api.nvim_buf_set_lines(0, 0, -1, false, lines) end
      vim.bo.fileformat = 'unix'
      vim.fn.winrestview(view)
      vim.notify('Trailing whitespace removed; line endings set to LF')
    end, { desc = 'Clean trailing whitespace and use LF without saving' })
    vim.api.nvim_create_user_command('Filename', function()
      local filename = vim.api.nvim_buf_get_name(0)
      vim.notify(filename == "" and 'Unnamed buffer' or ('File name: ' .. filename))
    end, { desc = 'Show the full current file path' })
  '';

  autoGroups.EditorBehavior.clear = true;
  autoCmd = [
    {
      group = "EditorBehavior";
      event = [ "TextYankPost" ];
      callback.__raw = ''
        function()
          vim.hl.on_yank()
        end
      '';
    }
    {
      group = "EditorBehavior";
      event = [
        "FocusGained"
        "TermClose"
        "TermLeave"
      ];
      callback.__raw = ''
        function()
          if vim.bo.buftype == "" then
            vim.cmd.checktime()
          end
        end
      '';
    }
    {
      group = "EditorBehavior";
      event = [ "BufWritePre" ];
      callback.__raw = ''
        function(args)
          if vim.bo[args.buf].buftype ~= "" or args.match:match("^%w+://") then
            return
          end
          vim.fn.mkdir(vim.fs.dirname(vim.fs.abspath(args.match)), "p")
        end
      '';
    }
    {
      group = "EditorBehavior";
      event = [ "BufReadPost" ];
      callback.__raw = ''
        function(args)
          if vim.bo[args.buf].filetype == "gitcommit" then
            return
          end
          local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
          if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
          end
        end
      '';
    }
  ];
}
