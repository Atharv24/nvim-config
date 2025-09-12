-- ========== Telescope ==========
local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup({
  defaults = {
    -- Smartly shorten paths in the previewer
    path_display = { "truncate" },
    mappings = {
      i = {
        -- Map Enter to open, Ctrl-v to open in a vertical split
        ["<CR>"] = actions.select_default,
        -- ["<C-v>"] = actions.select_vet,
      },
    },
  },
  pickers = {
    find_files = {
      find_command = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git' },
    },
  },
  extensions = {
    -- Load the fzy extension for better sorting, if you installed it
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    }
  }
})
-- Load the extension after setup
telescope.load_extension('fzy_native')

-- The KEY keymap for finding files!
vim.keymap.set('n', '<leader>ff',
  require('telescope.builtin').find_files,
  { desc = 'Find files' }
)

vim.keymap.set('n', '<leader>fo',
  require('telescope.builtin').oldfiles,
  { desc = 'Find Old Files' }
)

vim.keymap.set('n', '<leader>ft',
  require('telescope.builtin').treesitter,
  { desc = 'Find in Treesitter' }
)

vim.keymap.set('n', '<leader>fh',
  require('telescope.builtin').highlights,
  { desc = 'Find Highlights' }
)


