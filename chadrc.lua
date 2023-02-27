-- Just an example, supposed to be placed in /lua/custom/

local M = {}
local override = require "custom.override"

-- make sure you maintain the structure of `core/default_config.lua` here,
-- example of changing theme:

M.plugins = {
  user = require "custom.plugins",
  override = {
    ["kyazdani42/nvim-tree.lua"] = override.nvimtree,
    ["williamboman/mason.nvim"] = override.mason,
  }
}

M.ui = {
  theme = "doomchad",
}

M.mappings = require "custom.mappings"

return M
