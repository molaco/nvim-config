local new_cmd = vim.api.nvim_create_user_command
local api = vim.api

local autocmd = api.nvim_create_autocmd
local opt_local = vim.opt_local

new_cmd("EnableAutosave", function()
  require("autosave").setup()
end, {})
