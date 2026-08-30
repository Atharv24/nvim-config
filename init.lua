-- ===========================================================================
-- Neovim Configuration: init.lua
-- Main entry point
-- ===========================================================================

-- Set leader key before loading anything else
vim.g.mapleader = " "

-- Load core settings
require("options")

-- Load custom keymaps
require("keymaps")

-- Load custom highlights
require("highlights")

-- Autocommands
require("autocmds")

-- ===========================================================================
-- LAZY.NVIM PLUGIN MANAGER SETUP
-- ===========================================================================

-- Safe monkey-patch for Neovim Treesitter get_node_text crash in hover windows
local orig_get_node_text = vim.treesitter.get_node_text
vim.treesitter.get_node_text = function(node, source, opts)
  if type(node) == "table" and not node.range then
    local start_row = node[1] or 0
    local start_col = node[2] or 0
    local end_row = node[3] or start_row
    local end_col = node[4] or start_col

    if type(source) == "number" then
      local status, result = pcall(vim.api.nvim_buf_get_text, source, start_row, start_col, end_row, end_col, {})
      if status then return table.concat(result, "\n") end
    end
    return ""
  end

  local ok, res = pcall(orig_get_node_text, node, source, opts)
  if ok then return res end
  return ""
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(require("plugins"))

-- vim.cmd.colorscheme "tokyonight-storm"
-- vim.cmd.colorscheme "catppuccin"
vim.cmd.colorscheme "kanagawa-wave"

-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { '*' },
--   callback = function() vim.treesitter.start() end,
-- })

