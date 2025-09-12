-- Create an autocommand group to ensure this only runs once
local highlight_group = vim.api.nvim_create_augroup('CustomHighlights', { clear = true })

-- Keymap to inspect syntax highlight group under the cursor
vim.keymap.set('n', '<leader>i', function()
  local group = vim.fn.synIDattr(vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 1), "name")
  if group ~= "" then
    print("Highlight Group: " .. group)
  else
    print("No highlight group found")
  end
end, { silent = true, desc = "Inspect Highlight Group" })

-- This command will run every time you set a colorscheme
vim.api.nvim_create_autocmd('ColorScheme', {
  group = highlight_group,
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, '@lsp.typemod.method.readonly.cpp', { fg = '#5E84CF' })

    vim.api.nvim_set_hl(0, '@lsp.typemod.property.readonly.cpp', { fg = '#EBD09E'})
    
    vim.api.nvim_set_hl(0, '@lsp.typemod.variable.readonly.cpp', { fg = '#DBAB51'})
  end,
})
