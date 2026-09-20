-- ===========================================================================
-- LSP Configuration (LSP-specific settings should go here)
-- ===========================================================================
-- IMPORTANT: Make sure you have the 'nvim-lspconfig' plugin installed.

-- vim.lsp.set_log_level("off")

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
  vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'Code action' })

  -- Add keymap for ClangdSwitchSourceHeader
  if client.name == 'clangd' then
    vim.api.nvim_buf_create_user_command(
      bufnr,
      'ClangdSwitchSourceHeader',
      function()
        client.request('textDocument/switchSourceHeader', {
          uri = vim.uri_from_bufnr(bufnr),
        }, function(err, result)
          if err then
            vim.notify(
              'Clangd: Failed to switch source/header (' .. err.message .. ')',
              vim.log.levels.WARN
            )
            return
          end
          if result then
            vim.cmd.edit(vim.uri_to_fname(result))
          else
            vim.notify('Clangd: No corresponding file found', vim.log.levels.INFO)
          end
        end)
      end,
      { desc = 'Clangd: Switch Source/Header' }
    )

    vim.keymap.set('n', '<leader>ch', '<cmd>ClangdSwitchSourceHeader<CR>',
      { buffer = bufnr, desc = 'Switch source/header (Clangd)' }
    )
  end
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

local current_dir = vim.fn.getcwd()
local root_dir = ""
local clangd_executable_folder = ""

-- 1. Determine the root of the Chromium checkout based on the current directory
-- This logic assumes you are running Neovim from within the 'src' directory of a worktree,
-- e.g., C:/src/chrome/src or C:/src/chrome3/src.

-- Check if the current directory ends with '/src' or '\src'
if current_dir:match("[/\\]src$") then
    -- The root is one level up (e.g., C:/src/chrome or C:/src/chrome3)
    root_dir = current_dir:gsub("[/\\]src$", "")
    
    -- Construct the required paths
    clangd_executable_folder = root_dir .. "/src/third_party/llvm-build/Release+Asserts/bin/"

    vim.lsp.config("clangd", {
      cmd = {
        clangd_executable_folder .. "clangd.exe",
        "--background-index",
      },
      filetypes = { "c", "cpp", "cc", "h", "objc", "objcpp" },
      on_attach = on_attach,
      capabilities = capabilities,
    })
    vim.lsp.enable("clangd")
else
    -- Fallback or error handling if not opened in a Chromium 'src' folder
    print("Warning: Not opened in a known Chromium 'src' directory. Using default config.")
    -- Use a default path or simply return if you don't want to start clangd
end

-- ===========================================================================
-- Python LSP Configuration
-- ===========================================================================

local custom_pyright_on_attach = function(client, bufnr)
  if on_attach then on_attach(client, bufnr) end

  client.server_capabilities.documentFormmatingProvider = false
end

vim.lsp.config("pyright", {
  cmd = {
    "C:/Users/athar/AppData/Local/Packages/PythonSoftwareFoundation.Python.3.12_qbz5n2kfra8p0/LocalCache/local-packages/Python312/Scripts/pyright-langserver.exe",
    "--stdio"
  },
  filetypes = { "python" },
  on_attach = custom_pyright_on_attach,
  capabilities = capabilities,
})
vim.lsp.enable("pyright")

-- 2. Add the Ruff LSP Configuration
local ruff_on_attach = function(client, bufnr)
  if on_attach then on_attach(client, bufnr) end

  -- Disable hover from Ruff to keep Pyright's hover documentation
  client.server_capabilities.hoverProvider = false

  -- Auto-format on save using Ruff
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format({ async = false })
    end,
  })
end

vim.lsp.config("ruff", {
  cmd = { "ruff", "server" }, -- Assumes ruff is in your Windows PATH
  filetypes = { "python" },
  on_attach = ruff_on_attach,
  capabilities = capabilities,
})
vim.lsp.enable("ruff")

-- ===========================================================================
-- GN LSP Configuration
-- ===========================================================================
vim.lsp.config("gn", {
  cmd = { 'C:/src/gn/gn-language-server.exe' },
  filetypes = { 'gn', 'gni' },
  -- root_dir is important: it looks for .gn (repo root) or BUILD.gn files
  root_dir = root_dir .. '\\src',
  single_file_support = true,
  capabilities = capabilities,
  on_attach = on_attach,
})

vim.lsp.enable("gn")

vim.lsp.config("lua", {
  cmd = { 'lua-language-server.exe' },
  filetypes = { 'lua' },
  root_markers = { '.git' },
  on_attach = on_attach,
  capabilities = capabilities,
  -- Add the settings block below:
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT', -- Neovim runs on LuaJIT
      },
      diagnostics = {
        globals = { 'vim' }, -- Stops the "undefined global 'vim'" error
      },
      workspace = {
        -- This teaches the LSP all built-in Neovim commands, APIs, and options
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false, -- Disables annoying popups asking to configure your workspace
      },
    },
  },
})
vim.lsp.enable("lua")

