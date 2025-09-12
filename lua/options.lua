-- ===========================================================================
-- Neovim Options
-- ===========================================================================

-- Disable netrw for nvim-tree
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- Enable 24-bit color
vim.opt.termguicolors = true

-- --- UI / Appearance ---
vim.opt.number = true             -- Show line numbers
vim.opt.relativenumber = true     -- Show relative line numbers
vim.opt.cursorline = true         -- Highlight the current line
vim.opt.colorcolumn = "80"        -- Show a column at 80 characters
vim.opt.scrolloff = 8             -- Keep 8 lines visible above/below the cursor
vim.opt.signcolumn = "yes"        -- Always show the sign column
vim.opt.showmode = false          -- Don't show the mode in the command line
vim.opt.showcmd = true            -- Show command in the last line of the screen

-- --- Indentation ---
vim.opt.tabstop = 2               -- Number of spaces that a <Tab> in a file counts for
vim.opt.softtabstop = 2           -- Number of spaces to insert for a <Tab>
vim.opt.shiftwidth = 2            -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true          -- Use spaces instead of tabs
vim.opt.autoindent = true
vim.opt.smartindent = true

-- --- Search ---
vim.opt.ignorecase = true         -- Ignore case in search patterns
vim.opt.smartcase = true          -- Override 'ignorecase' if search pattern contains uppercase letters
vim.opt.incsearch = true          -- Show search results as you type
vim.opt.hlsearch = true           -- Highlight all matches on search

-- --- Behavior ---
vim.opt.hidden = true             -- Allow buffer switching without saving
vim.opt.errorbells = false        -- Disable error bells
vim.opt.visualbell = false        -- Disable visual bell
vim.opt.swapfile = false          -- Do not create a swapfile
vim.opt.backup = false            -- Do not create a backup file
vim.opt.undofile = true           -- Enable persistent undo
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.mouse = "n"               -- Enable mouse in normal mode
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.encoding = "UTF-8"
vim.opt.fileformat = "unix"
vim.opt.fileformats = "unix,dos,mac"
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Use LSP for the 'gq' formatting command
vim.opt.formatexpr = "v:lua.vim.lsp.formatexpr()"

-- --- OS Specific Settings ---
if vim.fn.has('win32') or vim.fn.has('win64') then
  -- Point to the Python interpreter for Neovim Python support
  vim.g.python3_host_prog = 'C:\\Users\\atharvmaan\\AppData\\Local\\Programs\\Python\\Python313\\python.exe'
  -- Use Git Bash as the shell
    vim.g.shell = 'C:\\Program Files\\Git\\bin\\bash.exe'
    vim.g.BASH = vim.g.shell
end

-- --- Diagnostic Configuration ---
vim.diagnostic.config({
  virtual_text = true, -- Enable inline error messages
  signs = true,        -- Show signs in the gutter (e.g., error/warning icons)
  underline = true,    -- Underline problematic text
})

