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

local function get_symbol_chain_at_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- Lua strings are 1-indexed

  -- Define what constitutes a "part of the chain"
  -- Allowed: Alphanumeric, underscore, and colons (::)
  local function is_valid_char(char)
    return char:match("[%w_:]")
  end

  -- 1. Scan Left
  local start_idx = col
  while start_idx > 0 do
    local char = line:sub(start_idx, start_idx)
    if not is_valid_char(char) then
      start_idx = start_idx + 1 -- Backup one step
      break
    end
    start_idx = start_idx - 1
  end
  -- Handle edge case where we hit the start of the line
  if start_idx == 0 then start_idx = 1 end

  -- 2. Scan Right
  local end_idx = col
  while end_idx <= #line do
    local char = line:sub(end_idx, end_idx)
    if not is_valid_char(char) then
      end_idx = end_idx - 1 -- Backup one step
      break
    end
    end_idx = end_idx + 1
  end

  return line:sub(start_idx, end_idx)
end

local function open_chromium_codesearch(symbol)
  local url 
  if not symbol then
    local relative_path = get_current_file_relative_path()
    local line_num = vim.fn.line('.')
    url = string.format(
      "https://source.chromium.org/chromium/chromium/src/+/main:%s;l=%d",
      relative_path,
      line_num
    )
    -- vim.print("Opening in Chromium Code Search: " .. relative_path)
  else
    url = string.format(
      "https://source.chromium.org/search?q=%s&ss=chromium/chromium/src",
      symbol
    )
    -- vim.print("Opening in Chromium Code Search: " .. symbol)
  end

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
end

local function open_codesearch_for_symbol() 
  local symbol = get_symbol_chain_at_cursor()
  open_chromium_codesearch(symbol)
end

vim.keymap.set('n', '<leader>sf', open_chromium_codesearch,
  { desc = 'Open in Chromium Code Search' }
)

vim.keymap.set('n', '<leader>ss', open_codesearch_for_symbol,
  { desc = 'Open in Chromium Code Search for hovered symbol' }
)
