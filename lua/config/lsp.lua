-- ===========================================================================
-- LSP Configuration (LSP-specific settings should go here)
-- ===========================================================================
-- IMPORTANT: Make sure you have the 'nvim-lspconfig' plugin installed.

vim.lsp.set_log_level("off")

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
local clangd_executable_path = ""
local compile_commands_dir = ""

-- 1. Determine the root of the Chromium checkout based on the current directory
-- This logic assumes you are running Neovim from within the 'src' directory of a worktree,
-- e.g., C:/src/chrome/src or C:/src/chrome3/src.

-- Check if the current directory ends with '/src' or '\src'
if current_dir:match("[/\\]src$") then
    -- The root is one level up (e.g., C:/src/chrome or C:/src/chrome3)
    root_dir = current_dir:gsub("[/\\]src$", "")
    
    -- Construct the required paths
    clangd_executable_path = root_dir .. "/src/third_party/llvm-build/Release+Asserts/bin/clangd.exe"
    
    -- The compile commands file is usually placed next to the 'src' folder itself,
    -- or within the build output folder, but for clangd in Chromium, 
    -- the --compile-commands-dir argument should point to the build directory 
    -- (e.g., C:/src/chrome3/src/out/Default) or the src folder itself depending on your setup.
    -- Sticking to your original setup:
    compile_commands_dir = root_dir .. "/src/out/Default"
    
else
    -- Fallback or error handling if not opened in a Chromium 'src' folder
    print("Warning: Not opened in a known Chromium 'src' directory. Using default config.")
    -- Use a default path or simply return if you don't want to start clangd
    return
end

vim.lsp.config("clangd", {
  cmd = {
    clangd_executable_path,
    "--compile-commands-dir=" .. compile_commands_dir,
  },
  filetypes = { "c", "cpp", "cc", "h", "objc", "objcpp" },
  on_attach = on_attach,
  capabilities = capabilities,
})
vim.lsp.enable("clangd")

vim.lsp.config("gnls", {
  cmd = {
    "node",
    "C:/Users/atharvmaan/.vscode/extensions/msedge-dev.gnls-0.1.4/build/server.js", 
    "--stdio"
  }
})

vim.lsp.enable("gnls")

