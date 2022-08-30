local M = {}

local load_override = require("core.utils").load_override

M.luasnip = function()
  local present, luasnip = pcall(require, "luasnip")

  if not present then
    return
  end

  local options = {
    history = true,
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = true,
  }

  options = load_override(options, "L3MON4D3/LuaSnip")
  luasnip.config.set_config(options)
  --require("luasnip.loaders.from_vscode").lazy_load()
  --require("luasnip.loaders.from_snipmate").lazy_load { paths = "~/.config/nvim/lua/custom/snippets"}
  require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/custom/snippets"})
  require('luasnip').filetype_extend("javascript", { "html" })
  require('luasnip').filetype_extend("javascript", { "javascriptreact" })
  require('luasnip').filetype_extend(".ejs", { "html" })

    -- set keybinds for both INSERT and VISUAL.
  vim.api.nvim_set_keymap("i", "<C-n>", "<Plug>luasnip-jump-next", {})
  vim.api.nvim_set_keymap("s", "<C-n>", "<Plug>luasnip-next-choice", {})
  vim.api.nvim_set_keymap("i", "<C-p>", "<Plug>luasnip-prev-choice", {})
  vim.api.nvim_set_keymap("s", "<C-p>", "<Plug>luasnip-prev-choice", {})

  vim.keymap.set({ "i", "s" }, "<c-k>", function()
    if luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    end
  end,{ silent = true })

  vim.keymap.set({ "i", "s" }, "<c-h>", function()
    if luasnip.jumpable(1) then
      luasnip.jump(1)
    end
  end,{ silent = true })

  vim.keymap.set({ "i", "s" }, "<c-j>", function()
    if luasnip.jumpable(-1) then
      luasnip.jump(-1)
    end
  end,{ silent = true })

  vim.keymap.set({ "i" }, "<c-l>", function()
    if luasnip.choice_active() then
      luasnip.change_choice(1)
    end
  end)

  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      if
        require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require("luasnip").session.jump_active
      then
        require("luasnip").unlink_current()
      end
    end,
  })
end

return M
