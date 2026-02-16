-- ------------------------------------------
-- Additional Telescope plugins
--
-- AstroNvim provides telescope and many plugins
-- Include extra telescope plugins within the `return` map
--
-- https://github.com/nvim-telescope/telescope.nvim
-- ------------------------------------------

-- if true then return {} end -- WARN: COMMENT THIS LINE TO ACTIVATE THIS FILE

return {
  {
    -- Browse directory structure & create files
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup {
        extensions = {
          file_browser = {
            hidden = true,
          },
        },
      }
      require("telescope").load_extension "file_browser"
    end,
    event = "User AstroFile",
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts.pickers = opts.pickers or {}
      opts.pickers.find_files = vim.tbl_extend("force", opts.pickers.find_files or {}, {
        hidden = true,
        no_ignore = false,
        no_ignore_parent = false,
      })
      return opts
    end,
  },
}
