local M = {}

M.vimtex = {
  n = {
    ["<leader>ll"] = { "<cmd> VimtexCompile <CR>", "vimtex-compile"},
    ["<leader>lk"] = { "<cmd> VimtexView <CR>", "vimtex-view"},
    ["<leader>kk"] = { "<cmd> set spell spelllang=es <CR>", "set spell"},
    ["<leader>kl"] = { "<cmd> set nospell <CR>", "set spell"},
  }
}

M.general = {
  n = {
    ["<leader>lp"] = { "[s1z=`]a", "spell correction"}
  }
}

M.luasnip = {
  n = {
    ["<C-{>"] = { "<Plug>luasnip-next-choice", "luasnip next choice"}
  }
}

return M
