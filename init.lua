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

-- ===========================================================================
-- LAZY.NVIM PLUGIN MANAGER SETUP
-- ===========================================================================

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

