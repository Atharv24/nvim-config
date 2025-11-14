require('toggleterm').setup({
  -- Global configuration options
  direction = 'float', -- Set the default direction to 'float', 'horizontal', or 'vertical'
  open_mapping = [[<C-t>]], -- Key mapping to toggle the terminal window
  shell = "pwsh.exe", -- Use your default shell (likely Zsh, based on your interests)
})
