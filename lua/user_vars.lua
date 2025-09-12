-- ===========================================================================
-- User Variables
-- ===========================================================================
-- This file is for user-specific variables, like paths to tools.
-- It is not intended to be committed to version control.

return {
  -- Path to the Python interpreter for Neovim Python support
  python_host_prog = 'C:\Users\atharvmaan\AppData\Local\Programs\Python\Python313\python.exe',

  -- Path to the shell
  shell = 'C:\Program Files\Git\bin\bash.exe',

  -- Clangd configuration
  clangd_cmd = {
    "C:/src/chrome/src/third_party/llvm-build/Release+Asserts/bin/clangd.exe",
    "--compile-commands-dir=C:/src/chrome/src",
  },
}

