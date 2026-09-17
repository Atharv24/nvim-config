local refactoring = require('refactoring')

refactoring.setup({
  -- Prompt for return/param types in C++
  prompt_func_return_type = { cpp = true, c = true, h = true, hpp = true },
  prompt_func_param_type = { cpp = true, c = true, h = true, hpp = true },
})


-- Extract function supports visual mode
vim.keymap.set("x", "<leader>re", function() refactoring.refactor('Extract Function') end)
vim.keymap.set("x", "<leader>rf", function() refactoring.refactor('Extract Function To File') end)

-- Extract variable supports visual mode
vim.keymap.set("x", "<leader>rv", function() refactoring.refactor('Extract Variable') end)

-- Inline variable supports both normal and visual mode
vim.keymap.set({ "n", "x" }, "<leader>ri", function() refactoring.refactor('Inline Variable') end)

vim.keymap.set("x", "<leader>rr", function() 
    refactoring.select_refactor() 
end)
