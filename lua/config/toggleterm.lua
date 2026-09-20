local toggleterm = require('toggleterm')
local Terminal = require('toggleterm.terminal').Terminal

local float_opts = {
  border = "curved",
  width = function()
    return math.floor(vim.o.columns * 0.85)
  end,
  height = function()
    return math.floor(vim.o.lines * 0.85)
  end,
}

toggleterm.setup({
  -- Global configuration options
  direction = 'float', -- Set the default direction to 'float', 'horizontal', or 'vertical'
  shell = "pwsh.exe", -- Use your default shell
  float_opts = float_opts,
  start_in_insert = true,
  persist_mode = false,
  on_open = function(term)
    vim.cmd("startinsert!")
  end,
})

function get_symbol_under_cursor()
  return vim.fn.expand('<cword>')
end

-- Autotest current file in toggleterm
function run_autotest_on_current_file(symbol)
  local file_path = get_current_file_relative_path()

  local command = "vpython3 tools/autotest.py -C out/Default " .. file_path

  if symbol then
    command = command .. " --gtest_filter=*" .. symbol .. "*"
  end

  -- Open ToggleTerm and execute the command
  toggleterm.exec(command, 1, 2, nil, 'float')
end

function run_test_on_current_file_filtered_on_symbol()
  local symbol = get_symbol_under_cursor()
  run_autotest_on_current_file(symbol)
end

function build_chrome() 
  local command = "autoninja -C out/Default chrome"

  toggleterm.exec(command, 1, 2, nil, 'float')
end

function run_chrome_with_default_args()
  local command = "out/Default/chrome.exe --user-data-dir=/tmp/chrome"
  toggleterm.exec(command, 1, 2, nil, 'float')
end

vim.keymap.set('n', '<leader>ctf', run_autotest_on_current_file, {
  noremap = true,
  silent = true,
  desc = 'Run autotest.py on current file'
})

vim.keymap.set(
  'n',
  '<leader>cts',
  run_test_on_current_file_filtered_on_symbol,
  {
    noremap = true,
    silent = true,
    desc = 'Run autotest.py on current file filtered on symbol under cursor'
  }
)

vim.keymap.set('n', '<leader>cb', build_chrome, {
  noremap = true,
  silent = true,
  desc = 'Build Chrome in out/Default directory'
})

vim.keymap.set('n', '<leader>cr', run_chrome_with_default_args, {
  noremap = true,
  silent = true,
  desc = 'Run Chrome with default args'
})

-- ===========================================================================
-- Terminals & Toggles (<C-t> for General Shell, <C-y> for Jetski)
-- ===========================================================================

local jetski_term

local function toggle_terminal()
  -- If Jetski is open, close it first before opening/focusing terminal 1
  if jetski_term and jetski_term:is_open() then
    jetski_term:close()
  end
  toggleterm.toggle(1)
end

local function toggle_jetski()
  local cmd = vim.fn.executable("jetski-cli") == 1 and "jetski-cli"
    or (vim.fn.executable("agy") == 1 and "agy" or nil)

  if not cmd then
    vim.notify("jetski-cli and agy are not installed or not in PATH", vim.log.levels.WARN, { title = "Jetski/AGY" })
    return
  end

  if not jetski_term then
    jetski_term = Terminal:new({
      cmd = cmd,
      direction = "float",
      hidden = true,
      count = 9, -- Separate ID from default terminal 1
      float_opts = float_opts,
      on_open = function(term)
        vim.cmd("startinsert!")
        -- Ensure <C-t> inside Jetski directly switches back to general terminal
        vim.keymap.set('t', '<C-t>', toggle_terminal, { buffer = term.bufnr, silent = true, nowait = true })
      end,
      close_on_exit = false,
    })
  end

  -- If any other terminal is open, close it first before opening/focusing Jetski
  local terms = require('toggleterm.terminal')
  for _, t in pairs(terms.get_all(true)) do
    if t.id ~= 9 and t:is_open() then
      t:close()
    end
  end
  jetski_term:toggle()
end

-- <C-t> toggles general terminal in both normal and terminal mode
vim.keymap.set({ 'n', 't' }, '<C-t>', toggle_terminal, {
  noremap = true,
  silent = true,
  desc = 'Toggle general terminal',
})

-- <C-y> toggles Jetski terminal in both normal and terminal mode
vim.keymap.set({ 'n', 't' }, '<C-y>', toggle_jetski, {
  noremap = true,
  silent = true,
  desc = 'Toggle Jetski/AGY terminal',
})

-- User command :Jetski
vim.api.nvim_create_user_command('Jetski', toggle_jetski, {
  desc = 'Toggle Jetski terminal',
})

vim.api.nvim_create_user_command('Agy', toggle_jetski, {
  desc = 'Toggle AGY terminal',
})
