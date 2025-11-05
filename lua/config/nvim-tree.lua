local function set_keymaps(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return {
      desc = "nvim-tree: " .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true
    }
  end
  
  local function use_native_add_file()
    -- Get the full path of the currently selected directory
    local node = api.tree.get_node_under_cursor()
    local path = node.link_to or node.absolute_path

    -- Check if the node is a file (not a directory)
    if not is_directory then
        path = vim.fn.fnamemodify(path, ":h")
    end

    -- Prompt the user for the new filename
    local new_file_name = vim.fn.input("New File: " .. path .. "/")

    if new_file_name and new_file_name ~= "" then
      -- Execute the native :edit command on the *new, non-existent* file path.
      -- This is the crucial step that triggers your BufNewFile Autocommand.
      vim.cmd("edit " .. path .. "/" .. new_file_name)
    end
  end

  -- use all default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- =========================================================
  -- Override 'a' to use native :edit command (for Autocmd template)
  -- =========================================================
  vim.keymap.set("n", "a",
    use_native_add_file,
    opts("Add new file/dir (Triggers Autocmd Template)")
  )
  -- =========================================================
end

require('nvim-tree').setup({
  on_attach = set_keymaps,
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  git = {
    -- Disable since slow in Chromium codebase,
    enable = false,
  }
})

