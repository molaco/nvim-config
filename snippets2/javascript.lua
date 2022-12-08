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

local function cs(trigger, nodes, opts) --{{{
	local snippet = s(trigger, nodes)
	local target_table = snippets

	local pattern = file_pattern
	local keymaps = {}

	if opts ~= nil then
		-- check for custom pattern
		if opts.pattern then
			pattern = opts.pattern
		end

		-- if opts is a string
		if type(opts) == "string" then
			if opts == "auto" then
				target_table = autosnippets
			else
				table.insert(keymaps, { "i", opts })
			end
		end

		-- if opts is a table
		if opts ~= nil and type(opts) == "table" then
			for _, keymap in ipairs(opts) do
				if type(keymap) == "string" then
					table.insert(keymaps, { "i", keymap })
				else
					table.insert(keymaps, keymap)
				end
			end
		end

		-- set autocmd for each keymap
		if opts ~= "auto" then
			for _, keymap in ipairs(keymaps) do
				vim.api.nvim_create_autocmd("BufEnter", {
					pattern = pattern,
					group = group,
					callback = function()
						vim.keymap.set(keymap[1], keymap[2], function()
							ls.snip_expand(snippet)
						end, { noremap = true, silent = true, buffer = true })
					end,
				})
			end
		end
	end

	table.insert(target_table, snippet) -- insert snippet into appropriate table
end --}}}

-- Start Refactoring --

-- End Refactoring --

local arrowFunction = s("af", fmt( -- Description
[[
({}) => {{{}}}
]], {
  i(1, ""),
  i(2, ""),
  }))

table.insert(snippets, arrowFunction)

local constantArrowFunction = s("caf", fmt([[
const {} = ({}) => {{
  {}
}}
]], {
  i(1, "_name_"),
  c(2, { t"", i(nil, "_name_") }),
  c(3, { t"", t"return "}),
}
))

table.insert(snippets, constantArrowFunction)

--Hacer const function con argumento function arrow opcional y dentro de este argumentos opcionales como sin texto: "" ó paréntesis: () ó return etc

local importReact = s("impr", fmt( -- Description
[[
import {} from 'react'
]], {
  c(1, {sn(nil, fmt([[
  {{ {} }}
  ]], {
    i(1,""),
  })), i(nil, "")})
  }))

table.insert(snippets, importReact)

local importComponent = s("impc", fmt( -- Description
[[
import {} from './{}'
]], {
  i(1, ""),
  rep(1)
  }))

table.insert(snippets, importComponent)

local ifStatement = s("iff", fmt( -- Description
[[
if ({}) {{
  {}
}}
]], {
  i(1, ""),
  i(2, ""),
  }))

table.insert(snippets, ifStatement)

local div = s("div<", fmt( -- Description
[[
<div{}>{}</div>
]], {
  i(1, ""),
  i(2, ""),
  }))

table.insert(snippets, div)

local reactFunctionalComponent = s("rfc", fmt( -- Creates a React Functional COmponent with ES7 module system
[[
import React from 'react'

export default function {}() {{
  return (
    <div{}>{}</div>  
  )
}}
]], {
  i(1, ""),
  i(2, ""),
  c(3, { rep(1), i(nil, "")}),
  }))

table.insert(snippets, reactFunctionalComponent)

local reactClassComponent = s("rcc", fmt( -- Description
[[
import React from 'react'

class {} extends React.Component{{
  render(){{
    return (
      <div{}>{}</div>
    )
  }}
}}

export default {}
]], {
  i(1, ""),
  i(2, ""),
  i(3, ""),
  rep(1),
  }))

table.insert(snippets, reactClassComponent)

local componentTags = postfix( ".rc", fmt([[
<{} {}/>
]], {
  d(1, function(_, parent)
    return sn(nil, {t(parent.snippet.env.POSTFIX_MATCH)})
  end),
  i(2, ""),
  }))

table.insert(autosnippets, componentTags)

local anchorTags = postfix( ".<", fmt([[
<{}{}>{}</{}>
]], {
  d(1, function(_, parent)
    return sn(nil, {t(parent.snippet.env.POSTFIX_MATCH)})
  end),
  i(2, ""),
  i(3, ""),
  rep(1),
  }))

table.insert(autosnippets, anchorTags)

local useState = s("ust", fmt( -- Description
[[
const [{}, {}] = useState({})
]], {
  i(1, ""),
  d(2, function (arg, _)
    return sn(nil, {t("set" .. arg[1][1]:gsub("^%l", string.upper))})
  end, {1}),
  i(3, ""),
  }))

table.insert(snippets, useState)

local useEffect = s("usf", fmt( -- Description
[[
useEffect(({}) => {{{}}}, [{}])
]], {
  i(1, ""),
  i(2, ""),
  i(3, ""),
  }))

table.insert(snippets, useEffect)

local h1 = s("h1<", fmt( -- Description
[[
<h1{}>{}</h1>
]], {
  i(1, ""),
  i(2, ""),
  }))

table.insert(snippets, h1)

local p = s("p<", fmt( -- Description
[[
<p{}>{}</p>
]], {
  i(1, ""),
  i(2, ""),
  }))

table.insert(snippets, p)

return snippets, autosnippets
