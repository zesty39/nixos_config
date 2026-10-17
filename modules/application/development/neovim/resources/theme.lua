local M = {}

-- Keep official integrations and adjust only the accent colors.
function M.highlights(colors)
  return {
    FloatBorder = { fg = colors.mauve, bg = 'NONE' },
    WhichKeyBorder = { fg = colors.mauve, bg = 'NONE' },
    WhichKey = { fg = colors.mauve },
    WhichKeyGroup = { fg = colors.mauve },
    BlinkCmpMenuBorder = { link = 'FloatBorder' },
    SnacksPickerBorder = { fg = colors.mauve, bg = 'NONE' },
    SnacksPickerInputBorder = { fg = colors.mauve, bg = 'NONE' },
    SnacksPickerBoxBorder = { fg = colors.mauve, bg = 'NONE' },
    SnacksPickerPrompt = { fg = colors.mauve },
    SnacksPickerMatch = { fg = colors.mauve, bold = true },
    SnacksPickerDir = { fg = colors.mauve },
    SnacksDirectory = { fg = colors.mauve },
    SnacksDashboardHeader = { fg = colors.mauve },
    SnacksDashboardIcon = { fg = colors.mauve },
    SnacksDashboardKey = { fg = colors.mauve },
    SnacksDashboardDesc = { fg = colors.mauve },
  }
end

function M.lualine(colors)
  return {
    normal = {
      a = { bg = colors.mauve },
      b = { fg = colors.mauve },
    },
  }
end

function M.bufferline()
  local colors = require('catppuccin.palettes').get_palette()
  return require('catppuccin.special.bufferline').get_theme({
    custom = {
      all = {
        buffer_selected = { fg = colors.mauve },
        indicator_selected = { fg = colors.mauve },
      },
    },
  })()
end

return M
