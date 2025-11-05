-- This file specifies your plugins.
-- It's meant to be loaded by lazy.nvim.

return {
  -- =======================================================================
  -- UI & THEME
  -- =======================================================================
  { "rebelot/kanagawa.nvim", priority = 1000, lazy = false },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000, lazy = false },
  {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup
    priority = 1000, -- make sure to load this before other plugins
  },
  {
    'akinsho/bufferline.nvim',
    requires = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('bufferline').setup{}
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch'},
          lualine_c = {'filename'},
          lualine_x = {'filetype'},
          lualine_y = {'diff'},
          lualine_z = {'diagnostics'},
        }
      }
    end
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
    config = function()
      require('config.nvim-tree')
    end
  },

  -- =======================================================================
  -- LSP & AUTOCOMPLETION
  -- =======================================================================
  {
    "neovim/nvim-lspconfig",
    config = function()
      require('config.lsp')
    end
  },
  {
    "hrsh7th/nvim-cmp",
    -- These plugins will be loaded whenever nvim-cmp is loaded
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
  },

  -- =======================================================================
  -- HELPER & UTILITIES
  -- =======================================================================
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        require('config.whichkey')
    end
  },
  {
    "rmagatti/auto-session",
    config = function()
      require('config.auto-session')
    end
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require('config.harpoon')
    end
  },

  -- =======================================================================
  -- SYNTAX & TREESITTER
  -- =======================================================================
  { "https://gn.googlesource.com/gn", rtp = "misc/vim" },
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    tag = 'v0.10.0',
    build = ':TSUpdate',
    config = function()
      require('config.treesitter')
    end
  },

  -- =======================================================================
  -- GIT INTEGRATION
  -- =======================================================================
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('config.gitsigns')
    end
  },

  -- =======================================================================
  -- FUZZY FINDER
  -- =======================================================================
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- This extension requires a build step
      { "nvim-telescope/telescope-fzy-native.nvim", build = "make" },
    },
    config = function()
      require('config.telescope')
    end
  },
}
