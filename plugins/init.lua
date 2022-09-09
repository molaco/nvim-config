return {

  ["Pocco81/AutoSave.nvim"] = {
    module = "autosave",
    config = function()
      require("custom.plugins.smolconfigs").autosave()
    end,
  },

  --format & linting
  ["jose-elias-alvarez/null-ls.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require "custom.plugins.null-ls"
    end,
  },

  --Enable which-key
  ['folke/which-key.nvim'] = { disable = false  },

  --vimtex
    -- setlocal spell
  ["lervag/vimtex"] = {
    config = function()
      vim.cmd [[
        let g:tex_flavor='latex'
        let g:vimtex_view_method='zathura'
        let g:vimtex_quickfix_mode=0
        let g:tex_conceal='abdmg'
        set spelllang=es
      ]]
    end,
  },

  --Luasnips
  ["L3MON4D3/LuaSnip"] = {
    wants = "friendly-snippets",
    after = "nvim-cmp",
    config = function()
      require("custom.plugins.others").luasnip()
    end,
  },

  -- autoclose tags in html, jsx etc
  ["windwp/nvim-ts-autotag"] = {
    ft = { "html", "javascriptreact" },
    after = "nvim-treesitter",
    config = function()
      require("custom.plugins.smolconfigs").autotag()
    end,
  },

  --lsp
  ["neovim/nvim-lspconfig"] = {
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.lspconfig"
    end,
  },
}
