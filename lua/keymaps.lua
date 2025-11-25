-- ===========================================================================
-- Neovim Keymaps
-- ===========================================================================

local keymap = vim.keymap.set

-- Clear search highlights with <CR>
-- keymap('n', '<CR>', ':noh<CR>',
--   { noremap = true, silent = true, desc = "Clear search highlights" }
-- )

-- ===========================================================================
-- Buffer
-- ===========================================================================
-- Save and close the current buffer
keymap('n', '<leader>w', ':w<CR>:bd<CR>',
  { noremap = true, silent = true, desc = "Save and close buffer" }
)
-- Close the current buffer without saving
keymap('n', '<leader>q', ':bd!<CR>',
  { noremap = true, silent = true, desc = "Close buffer without saving" }
)
-- Next and previous buffer
keymap('n', '<Tab>', ':BufferLineCycleNext<CR>',
  { noremap = true, silent = true, desc = "Cycle to next buffer (BufferLine)" }
)
keymap('n', '<S-Tab>', ':BufferLineCyclePrev<CR>',
  { noremap = true, silent = true, desc = "Cycle to previous buffer (BufferLine)" }
)

keymap("n", "<leader>cf", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format file with LSP" })

-- Copy relative path to the system clipboard
function get_current_file_relative_path()
  -- Get the file path relative to the current working directory.
  local relative_path = vim.fn.expand("%:.")
  -- Replace backslashes with forward slashes for Unix-style path
  return string.gsub(relative_path, "\\", "/")
end

keymap("n", "<leader>cp", function()
  local file_path = get_current_file_relative_path()
  vim.fn.setreg("+", file_path)
end, { desc = "Copy relative path" })

keymap(
  'n', '<leader>dl', vim.diagnostic.setloclist, 
  { desc = "Show buffer diagnostics (location list)" }
)

-- Git hunk navigation
keymap('n', '[g', ':Gitsigns prev_hunk<CR>',
  { noremap = true, silent = true, desc = "Jump to previous git hunk" }
)
keymap('n', ']g', ':Gitsigns next_hunk<CR>',
  { noremap = true, silent = true, desc = "Jump to next git hunk" }
)

-- Diagnostic navigation
keymap('n', '[e', vim.diagnostic.goto_prev,
  { desc = "Jump to previous diagnostic" }
)
keymap('n', ']e', vim.diagnostic.goto_next,
  { desc = "Jump to next diagnostic" }
)

-- Toggle File Explorer (Nvim-Tree)
keymap('n', '<leader>e', ':NvimTreeToggle<CR>',
  { noremap = true, silent = true, desc = 'Toggle File Explorer (Nvim-Tree)' }
)
keymap('n', '<leader>E', ':NvimTreeFocus<CR>', {
    noremap = true, 
    silent = true,
    desc = 'Focus File Explorer (Nvim-Tree)', 
})

local function open_chromium_codesearch()
  local relative_path = get_current_file_relative_path()
  local line_num = vim.fn.line('.')

  -- Construct the Chromium Code Search URL
  -- defaults to 'main' branch; you can make this dynamic if needed
  local url = string.format(
    "https://source.chromium.org/chromium/chromium/src/+/main:%s;l=%d",
    relative_path,
    line_num
  )
    
  -- Open the URL (system agnostic)
  local open_cmd
  if vim.fn.has("mac") == 1 then
    open_cmd = "open"
  elseif vim.fn.has("unix") == 1 then
    open_cmd = "xdg-open"
  else
    open_cmd = "start chrome"
  end
    
  os.execute(string.format("%s %s", open_cmd, url))
  print("Opened in Chromium Code Search: " .. relative_path)
end

vim.keymap.set('n', '<leader>cs', open_chromium_codesearch, { desc = 'Open in Chromium Code Search' })
