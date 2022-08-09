local M = {}

M.vimtex = {
  n = {
    ["<leader>ll"] = { "<cmd> VimtexCompile <CR>", "vimtex-compile"},
    ["<leader>lk"] = { "<cmd> VimtexView <CR>", "vimtex-view"}
  }
}

M.general = {
  n = {
    ["<leader>lp"] = { "[s1z=`]a", "spell correction"}
  }
}

return M
