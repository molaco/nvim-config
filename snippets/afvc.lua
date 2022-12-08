local ls = require("luasnip") --{{{
local s = ls.s
local i = ls.i
local t = ls.t

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local extras = require("luasnip.extras")
local l = extras.l
local postfix = require("luasnip.extras.postfix").postfix
local conditions = require("luasnip.extras.expand_conditions")

local snippets, autosnippets = {}, {} --}}}

local group = vim.api.nvim_create_augroup("Lua Snippets", { clear = true })
local file_pattern = "*.lua"

local function math()
    return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
end

-- Start Refactoring --

-- End Refactoring --


local seriePotencias = s("spc", fmt([[
\sum_{{n = 0}}^{{\infty}} {} {}
]], {
    i(1, "a_{n}"),
    i(2, "z^{n}"),
}), {condition = math})
table.insert(autosnippets, seriePotencias)

return snippets, autosnippets

