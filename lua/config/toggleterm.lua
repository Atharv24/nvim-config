local toggleterm = require('toggleterm')

toggleterm.setup({
  -- Global configuration options
  direction = 'float', -- Set the default direction to 'float', 'horizontal', or 'vertical'
  open_mapping = [[<C-t>]], -- Key mapping to toggle the terminal window
  shell = "pwsh.exe", -- Use your default shell (likely Zsh, based on your interests)
})

-- Autotest current file in toggleterm
function run_autotest_on_current_file()
  local file_path = get_current_file_relative_path()

  local command = "vpython3 tools/autotest.py -C out/Default " .. file_path

  -- Open ToggleTerm and execute the command
  toggleterm.exec(command, 1, 2, nil, 'float')
end

function build_chrome() 
  local command = "autoninja -C out/Default chrome"

  toggleterm.exec(command, 1, 2, nil, 'float')
end

function run_chrome_with_default_args()
  local command = "out/Default/chrome.exe --user-data-dir=/tmp/chrome"
  toggleterm.exec(command, 1, 2, nil, 'float')
end

vim.keymap.set('n', '<leader>ct', run_autotest_on_current_file, {
  noremap = true,
  silent = true,
  desc = 'Run autotest.py on current file'
})

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
