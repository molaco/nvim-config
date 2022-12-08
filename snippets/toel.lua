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

local baseDeX = s("bs", fmt([[
\mathcal{{B}} ({})
]], {
    c(1, { i(nil, "x"), i(nil, "") })
}), {condition = math})
table.insert(autosnippets, baseDeX)

local numerable = s("nmb", fmt([[
\mathcal{{X}}_0
]], {
  
}), {condition = math})
table.insert(autosnippets, numerable)

local cardinal = s("caa", fmt([[
\card({})
]], {
  i(1, ""),
}), {condition = math})
table.insert(autosnippets, cardinal)

local compactacion = s("ckk", fmt([[
( {}, {} )
]], {
  i(1, "K"),
  i(2, "f"),
}), {condition = math})
table.insert(autosnippets, compactacion)

local compactacion1 = s("ck1", fmt([[
( {}_{{{}}}, {}_{{{}}} )
]], {
  i(1, "K"),
  i(2, "1"),
  i(3, "f"),
  rep(2),
}), {condition = math})
table.insert(autosnippets, compactacion1)

local compactacion2 = s("ck2", fmt([[
( {}, {} )
]], {
  i(1, "K"),
  i(2, "f"),
}), {condition = math})
table.insert(autosnippets, compactacion2)

local filtro = s("fil", fmt([[
\mathcal{{{}}}
]], {
  i(1, "F")
}), {condition = math})
table.insert(autosnippets, filtro)

local red = s("red", fmt([[
s = (s_{{{}}})_{{{}}}
]], {
  i(1, "d"),
  i(2, "d \\in D"),
}), {condition = math})
table.insert(autosnippets, red)

local simeq = s("hmt", fmt([[
\simeq
]], {
  
}), {condition = math})
table.insert(autosnippets, simeq)

local grupoFundamental = s("gf", fmt([[
\pi_{{1}}({}, {})
]], {
    i(1, 'X'),
    i(2, 'x')
}), {condition = math})
table.insert(autosnippets, grupoFundamental)

local esfera = s("sf1", fmt([[
\mathbb{{S}}^{{1}}
]], {
  
}), {condition = math})
table.insert(autosnippets, esfera)

return snippets, autosnippets
