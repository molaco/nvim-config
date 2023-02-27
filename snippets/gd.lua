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

local aplDifGeo = s("dX", fmt([[
(d {})_{{{}}}
]], {
  i(1, "X"),
  i(2, "p"),
}), {condition = math})
table.insert(autosnippets, aplDifGeo)

local aplDifGeo2 = s("DX", fmt([[
d({})_{{{}}}
]], {
  i(1, "X"),
  i(2, "p"),
}), {condition = math})
table.insert(autosnippets, aplDifGeo2)

local espacioTangente = s("te", fmt([[
T_{{{}}}({})
]], {
  i(1, "p"),
  i(2, "S"),
}), {condition = math})
table.insert(autosnippets, espacioTangente)

local vector3 = s("vxyz", fmt([[
({}, {}, {})
]], {
  i(1, "x"),
  i(2, "y"),
  i(3, "z"),
}), {condition = math})
table.insert(autosnippets, vector3)

local covariantDerivative = s("cd", fmt([[
\frac{{D {}}}{{d {}}}
]], {
    i(1, ""),
    i(2, ""),
}), {condition = math})
table.insert(autosnippets, covariantDerivative)

local ppa = s("paa", fmt([[
p.p.a.
]], {
  
}))
table.insert(autosnippets, ppa)

return snippets, autosnippets
