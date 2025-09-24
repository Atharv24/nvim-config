-- ===========================================================================
-- Neovim Keymaps
-- ===========================================================================

local keymap = vim.keymap.set

-- Clear search highlights with <CR>
-- keymap('n', '<CR>', ':noh<CR>', { noremap = true, silent = true, desc = "Clear search highlights" })

-- Save and close the current buffer
keymap('n', '<leader>w', ':w<CR>:bd<CR>', { noremap = true, silent = true, desc = "Save and close buffer" })

-- Close the current buffer without saving
keymap('n', '<leader>q', ':bd!<CR>', { noremap = true, silent = true, desc = "Close buffer without saving" })

keymap("n", "<leader>cf", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format file with LSP" })

-- Copy relative path to the system clipboard
vim.keymap.set("n", "<leader>cp", function()
  -- Get the file path relative to the current working directory.
  local relative_path = vim.fn.expand("%:.")
  -- Replace backslashes with forward slashes for Unix-style path
  local unix_path = string.gsub(relative_path, "\\", "/")
  -- Put the Unix-style path into the system clipboard register.
  vim.fn.setreg("+", unix_path)
end, { desc = "Copy relative path" })

vim.keymap.set(
  'n', '<leader>dl', vim.diagnostic.setloclist, 
  { desc = "Show buffer diagnostics (location list)" }
)

-- Git hunk navigation
keymap('n', '[g', ':Gitsigns prev_hunk<CR>', { noremap = true, silent = true, desc = "Jump to previous git hunk" })
keymap('n', ']g', ':Gitsigns next_hunk<CR>', { noremap = true, silent = true, desc = "Jump to next git hunk" })

-- Diagnostic navigation
keymap('n', '[e', vim.diagnostic.goto_prev, { desc = "Jump to previous diagnostic" })
keymap('n', ']e', vim.diagnostic.goto_next, { desc = "Jump to next diagnostic" })
