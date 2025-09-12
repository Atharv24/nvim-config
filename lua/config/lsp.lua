-- ===========================================================================
-- LSP Configuration (LSP-specific settings should go here)
-- ===========================================================================
-- IMPORTANT: Make sure you have the 'nvim-lspconfig' plugin installed.

-- Automatically clear the LSP log file on exit
vim.api.nvim_create_autocmd("ExitPre", {
  pattern = "*",
  callback = function()
    local log_path = vim.fn.stdpath("data") .. "/lsp.log"
    -- Check if the file exists and is readable before trying to remove it.
    -- vim.uv.fs_stat returns nil if the path does not exist.
    if vim.uv.fs_stat(log_path) then
      os.remove(log_path)
    end
  end,
  desc = "Clear LSP log file on exit",
})

-- Load the lspconfig module
local lspconfig = require('lspconfig')

local on_attach = function(client, bufnr)
  -- Increase timeout for semantic tokens
  client.timeout = 15000

  -- Enable completion
  require("cmp").setup.buffer({
      sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
      }
  })

  -- Enable keybindings
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Go to definition' })
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = 'Go to declaration' })
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr, desc = 'Go to references' })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'Show hover documentation' })
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = 'Rename symbol' })
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'Code action' })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.semanticTokens = {
    dynamicRegistration = true,
    requests = {
        range = true,
        full = true,
    },
    formats = { "relative" },
    multilineTokenSupport = true,
}

-- Configure clangd with a specific path
local user_vars = require('user_vars')
lspconfig.clangd.setup {
  cmd = user_vars.clangd_cmd,
  filetypes = { "c", "cpp", "cc", "h", "objc", "objcpp" },
  on_attach = on_attach,
  capabilities = capabilities,
}

