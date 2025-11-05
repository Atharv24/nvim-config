-- ===========================================================================
-- NATIVE FILE TEMPLATING (Replaces new-file-template.nvim)
-- ===========================================================================

local TEMPLATE_GROUP = vim.api.nvim_create_augroup("ChromiumTemplates", { clear = true })
local CURRENT_YEAR = os.date("%Y")
local COPYRIGHT_HEADER = string.format(
    [=[// Copyright %s The Chromium Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
]=],
    CURRENT_YEAR
)

-- Helper function to generate the Chromium-style include guard (same as before)
local function generate_chromium_guard(filepath)
    local relative_path = vim.fn.fnamemodify(filepath, ":.")
    relative_path = relative_path:gsub("%.h$", "")
    relative_path = relative_path:upper()
    relative_path = relative_path:gsub("[^%w/]", "_")
    relative_path = relative_path:gsub("/", "_")
    return relative_path .. "_H_"
end

-- Function to run for ALL new files
local function apply_generic_template(args)
    -- Insert the generic copyright header at the top (line 0)
    vim.api.nvim_buf_set_lines(args.buf, 0, 0, false, vim.split(COPYRIGHT_HEADER, "\n"))
end

-- 1. GENERIC TEMPLATE: Apply Copyright to ALL new files
vim.api.nvim_create_autocmd("BufNewFile", {
    group = TEMPLATE_GROUP,
    pattern = "*",
    callback = apply_generic_template,
})

-- 2. C++ HEADER TEMPLATE: Add Include Guard to .h files
vim.api.nvim_create_autocmd("BufNewFile", {
    group = TEMPLATE_GROUP,
    pattern = "*.h",
    callback = function(args)
        local guard = generate_chromium_guard(args.file)
        local header_template = string.format(
            [=[
#ifndef %s
#define %s

// Your code here

#endif  // %s
]=],
            guard, guard, guard
        )
        -- Append the header guard content after the copyright
        -- The copyright is 3 lines + 2 newlines = 5 lines. Insert after line 5.
        vim.api.nvim_buf_set_lines(args.buf, 5, 5, false, vim.split(header_template, "\n"))
        
        -- Set cursor (Line 7 is the first 'code' line: // Your code here)
        vim.api.nvim_win_set_cursor(0, {7, 1})
    end,
})

-- 3. C++ IMPLEMENTATION TEMPLATE: Add corresponding header to .cc files
vim.api.nvim_create_autocmd("BufNewFile", {
    group = TEMPLATE_GROUP,
    pattern = "*.cc",
    callback = function(args)
        -- Get the full path of the new file
        local full_filepath = args.file

        -- Get the path *relative to the current working directory* (repo root)
        local relative_path = vim.fn.fnamemodify(full_filepath, ":.")

        -- Replace all backslashes (\) with forward slashes (/)
        local normalized_path = relative_path:gsub("\\", "/")

        -- Replace the .cc extension with .h
        local full_header_path = normalized_path:gsub("%.cc$", ".h")
        
        local cc_template = string.format(
            [=[
#include "%s"

// Your code here

]=],
            full_header_path
        )
        -- Append the CC content after the copyright
        vim.api.nvim_buf_set_lines(args.buf, 5, 5, false, vim.split(cc_template, "\n"))
        
        -- Set cursor (Line 7 is the first 'code' line: // Your code here)
        vim.api.nvim_win_set_cursor(0, {7, 1})
    end,
})
