-- ===========================================================================
-- Neovim Keymaps
-- ===========================================================================

local keymap = vim.keymap.set

-- Clear search highlights with <CR>
-- keymap('n', '<CR>', ':noh<CR>', { noremap = true, silent = true, desc = "Clear search highlights" })

-- Save and close the current buffer
keymap('n', '<leader>w', ':w<CR>:bd<CR>', { noremap = true, silent = true, desc = "Save and close buffer" })
