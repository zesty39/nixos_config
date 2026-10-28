{ config, lib, sharedLib, ... }:

let
  dconf = sharedLib.dconf;
  scratchClasses = [
    "gthumb"
    "gpaste-ui"
    "gnome-tweaks"
    "gnome-terminal-preferences"
    "gnome-system-monitor"
    "yelp"
    "GdmSettings"
    "gsconnect-preferences"
    "com.usebottles.bottles"
    "ulauncher"
    "Ulauncher"
  ];
  gnomeScratchClasses = [
    "Settings"
    "tweaks"
    "Calculator"
    "SystemMonitor"
    "baobab"
    "Logs"
  ];
  fileDialogTitles = [
    "Open File"
    "Choose File"
    "Select File"
    "File Upload"
    "Save File"
    "Save As"
    "打开文件"
    "选择文件"
    "上传文件"
    "保存文件"
    "另存为"
    "文件上传"
    "Select Project Root"
    "Open Folder"
    "Pick Files"
    "Pick a File"
  ];
  winprops = map builtins.toJSON [
    {
      title = "/^(flameshot|flameshot-pin)$/i";
      scratch_layer = true;
    }
    {
      wm_class = "/(${lib.concatStringsSep "|" scratchClasses})/";
      scratch_layer = true;
    }
    {
      wm_class = "*";
      preferredWidth = "50%";
    }
    {
      wm_class = "/org.gnome.(${lib.concatStringsSep "|" gnomeScratchClasses})/";
      scratch_layer = true;
    }
    {
      wm_class = "org.gnome.Nautilus";
      title = "/^(?!.*(?:${lib.concatStringsSep "|" fileDialogTitles})).+$/";
      scratch_layer = true;
    }
    {
      wm_class = "md.obsidian.Obsidian";
      title = "/^(?:Settings|设置)(?: - .+ - Obsidian [0-9.]+)?$/";
      scratch_layer = true;
    }
    {
      wm_class = "zen-twilight";
      title = "/(Library)/";
      scratch_layer = true;
    }
    {
      wm_class = "/^(?!steam$).*$/";
      title = "/Steam/";
      scratch_layer = true;
    }
    {
      wm_class = "steam";
      title = "/^(?!Steam$).*$/";
      scratch_layer = true;
    }
  ];
in
{
  config = lib.mkIf (config.desktop.gnome.enabled) {
    programs.dconf.profiles.user.databases = dconf.mkLockedDatabases {
      "org/gnome/shell/extensions/paperwm" = {
        only-scratch-in-overview = true;
        show-open-position-icon = false;
        show-window-position-bar = false;
        show-workspace-indicator = false;
        inherit winprops;
      };

      "org/gnome/shell/extensions/paperwm/keybindings" = {
        close-window = [ "<Shift><Super>c" ];
        cycle-height-backwards = [ "" ];
        cycle-width-backwards = [ "" ];
        live-alt-tab = [ "<Alt>Tab" ];
        live-alt-tab-backward = [ "" ];
        live-alt-tab-scratch = [ "" ];
        live-alt-tab-scratch-backward = [ "" ];
        move-down = [ "" ];
        move-down-workspace = [ "<Shift><Super>j" ];
        move-left = [ "<Shift><Super>h" ];
        move-monitor-above = [ "<Shift><Alt><Super>k" ];
        move-monitor-below = [ "<Shift><Alt><Super>j" ];
        move-monitor-left = [ "<Shift><Alt><Super>h" ];
        move-monitor-right = [ "<Shift><Alt><Super>l" ];
        move-previous-workspace = [ "" ];
        move-previous-workspace-backward = [ "" ];
        move-right = [ "<Shift><Super>l" ];
        move-up = [ "" ];
        move-up-workspace = [ "<Shift><Super>k" ];
        new-window = [ "<Super>n" ];
        previous-workspace = [ "<Super>Tab" ];
        previous-workspace-backward = [ "" ];
        resize-h-dec = [ "" ];
        resize-h-inc = [ "" ];
        resize-w-dec = [ "" ];
        resize-w-inc = [ "" ];
        switch-down-workspace = [ "<Super>j" ];
        switch-focus-mode = [ "<Shift><Super>m" ];
        switch-monitor-above = [ "<Alt><Super>k" ];
        switch-monitor-below = [ "<Alt><Super>j" ];
        switch-monitor-left = [ "<Alt><Super>h" ];
        switch-monitor-right = [ "<Alt><Super>l" ];
        switch-next = [ "<Super>l" ];
        switch-previous = [ "<Super>h" ];
        switch-up-workspace = [ "<Super>k" ];
        toggle-scratch = [ "<Super>space" ];
        toggle-scratch-layer = [ "<Alt><Super>space" ];
      };
    };
  };
}
