-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    -- change colorscheme
    colorscheme = "catppuccin",
    -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
    highlights = {
      init = { -- this table overrides highlights in all themes
        -- Make Telescope use the same background as the editor instead of the darker NormalFloat bg
        TelescopeNormal = { link = "Normal" },
        TelescopePromptNormal = { link = "Normal" },
        TelescopeResultsNormal = { link = "Normal" },
        TelescopePreviewNormal = { link = "Normal" },
        -- Use a subtle accent color for borders to visually separate the popup
        TelescopeBorder = { fg = "#8aadf4", bg = "NONE" }, -- Catppuccin Macchiato blue
        TelescopePromptBorder = { fg = "#8aadf4", bg = "NONE" },
        TelescopeResultsBorder = { fg = "#8aadf4", bg = "NONE" },
        TelescopePreviewBorder = { fg = "#8aadf4", bg = "NONE" },
        TelescopeTitle = { fg = "#8aadf4", bold = true },
        TelescopePromptTitle = { fg = "#8aadf4", bold = true },
        TelescopeResultsTitle = { fg = "#8aadf4", bold = true },
        TelescopePreviewTitle = { fg = "#8aadf4", bold = true },
      },
      astrotheme = { -- a table of overrides/changes when applying the astrotheme theme
        -- Normal = { bg = "#000000" },
      },
    },
    -- Icons can be configured throughout the interface
    icons = {
      -- configure the loading of the lsp in the status line
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",
    },
  },
}
