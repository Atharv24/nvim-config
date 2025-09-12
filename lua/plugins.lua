-- This file specifies your plugins.
-- It's meant to be loaded by lazy.nvim.

return {
  -- Tabs
  {
    'akinsho/bufferline.nvim',
    requires = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('bufferline').setup{}
    end
  },

  -- GN Syntax
  { "https://gn.googlesource.com/gn", rtp = "misc/vim" },

  -- LSP & Autocompletion
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

  -- UI & Theme
  { "rebelot/kanagawa.nvim", priority = 1000, lazy = false },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000, lazy = false },
  {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup
    priority = 1000, -- make sure to load this before other plugins
  },

  -- Helper
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        require('config.whichkey') 
    end
  },

  -- File Explorer
  -- {
  --   "nvim-tree/nvim-tree.lua",
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons", -- optional, for file icons
  --   },
  --   config = function()
  --     require('config.nvim-tree')
  --   end
  -- },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    tag = 'v0.10.0',
    build = ':TSUpdate',
    config = function()
      require('config.treesitter')
    end
  },

  -- Git Integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('config.gitsigns')
    end
  },

  -- Fuzzy file finder
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

  -- For session management
  {
    "rmagatti/auto-session",
    config = function()
      require('config.auto-session')
    end
  },

  -- For marking files and jumping between them
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require('config.harpoon')
    end
  },
}
