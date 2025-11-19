local M = {
  -- Cache structure: { [id] = { busy = false, last_check = 0, checking = false, job_id = -1, pid = -1 } }
  _cache = {}
}

local function check_status_async(id, shell_pid)
  local state = M._cache[id]
  state.checking = true

  local get_pid
  local process_id
  if not state.pid then
    process_id = shell_pid
    get_pid = true
  else
    process_id = state.pid
    get_pid = false
  end


  local cmd
  if vim.fn.has('win32') == 1 then
    -- Windows: wmic is slow, so async is crucial here
    cmd = 'wmic process where (ParentProcessId=' .. process_id .. ') get ProcessId'
  else
    -- Linux/MacOS: pgrep
    cmd = 'pgrep -P ' .. shell_pid
  end

  local output_found = false
  -- Spawn a background job (non-blocking)
  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      -- Scan output for valid PIDs
      for _, line in ipairs(data) do
        if line ~= "" then
          if vim.fn.has('win32') == 1 then
            -- Windows Filtering Logic
            -- line syntax: pwsh.exe  26288
            -- Use match("(%d+)") to reliably extract only the numbers (PID) from line, ignoring spaces/tabs.
            local lower = line:lower()
            local pid = lower:match("(%d+)")
            if pid then
              if get_pid then
                M._cache[id].pid = pid
                get_pid = false
              else
                output_found = true
              end
            end
         else
            -- Linux: pgrep outputs digits if found
            if line:match("%d+") then
              output_found = true
            end
          end
        end
      end
    end,
    on_exit = function(_, code)
      -- Update the cache
      if vim.fn.has('win32') == 1 then
        state.busy = output_found
      else
        -- pgrep returns exit code 0 if children found, 1 if not
        state.busy = (code == 0)
      end
      
      state.last_check = vim.loop.now()
      state.checking = false
    end,
    stdout_buffered = true, 
  })
end

--- Check if the terminal is busy (Async + Cached)
--- Returns the cached value immediately and updates in background
--- @param id number|nil The terminal ID
--- @return boolean True if busy, False if idle
local function is_terminal_busy(id)
  id = id or 1
  local now = vim.loop.now()
  
  -- Initialize cache for this terminal ID
  if not M._cache[id] then
    M._cache[id] = { busy = false, last_check = 0, checking = false }
  end
  local state = M._cache[id]

  -- 1. Get Terminal Info
  local ok, terminal = pcall(require, "toggleterm.terminal")
  if not ok then return false end
  local term = terminal.get(id)
  
  -- If terminal closed or invalid, reset busy state
  if not term or not term.job_id then
    state.busy = false
    return false
  end

  if not state.checking and (now - state.last_check > 1000) then
    local shell_pid = vim.fn.jobpid(term.job_id)
    check_status_async(id, shell_pid)
  end

  -- 3. Always return the cached value immediately (Non-blocking)
  return state.busy
end

-- =========================================
-- Lualine Components
-- =========================================

--- Returns a formatted string with icon for Lualine
--- @param id number|nil
function lualine_text(id)
  local busy = is_terminal_busy()
  -- Icon:  (Terminal) | Status Icons:  (Watch/Waiting) vs  (Check/Idle)
  if busy then
    return " Busy "
  else
    return " Idle "
  end
end

--- Returns the color highlight for Lualine
--- @param id number|nil
function lualine_color(id)
  -- id = id or 1
  local busy = is_terminal_busy()
  if busy then
    return { fg = "#ff9e64", gui = "bold" } -- Orange for Busy
  else
    return { fg = "#9ece6a", gui = "bold" } -- Green for Idle
  end
end

require('lualine').setup {
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'filetype'},
    lualine_y = {
      {
        function() return lualine_text(1) end,
        color = function() return lualine_color(1) end,
      },
    },
    lualine_z = {'location'}
  },
}
