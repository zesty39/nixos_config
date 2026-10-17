{ ... }:

{
  lsp.servers.basedpyright = {
    enable = true;
    config = {
      before_init.__raw = ''
        function(_, server)
          server.settings = server.settings or {}
          server.settings.python = server.settings.python or {}
          local python = vim.fn.exepath('python')
          if python == "" then
            python = vim.fn.exepath('python3')
          end
          if python ~= "" and not server.settings.python.pythonPath then
            server.settings.python.pythonPath = python
          end
        end
      '';
      settings.basedpyright.analysis = {
        typeCheckingMode = "basic";
        autoImportCompletions = true;
        diagnosticSeverityOverrides = {
          reportUnusedImport = "information";
          reportUnusedFunction = "information";
          reportUnusedVariable = "information";
          reportGeneralTypeIssues = "none";
          reportOptionalMemberAccess = "none";
          reportOptionalSubscript = "none";
          reportPrivateImportUsage = "none";
        };
      };
    };
  };
}
