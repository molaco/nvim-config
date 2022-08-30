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

local rec_ls
rec_ls = function()
	return sn(nil, {
		c(1, {
			-- important!! Having the sn(...) as the first choice will cause infinite recursion.
			t({""}),
			-- The same dynamicNode as in the snippet (also note: self reference).
			sn(nil, {t({"", "\t\\item "}), i(1), d(2, rec_ls, {})}),
		}),
	});
end

local infiniteItemize = s("ls", {
	t({"\\begin{itemize}",
	"\t\\item "}), i(1), d(2, rec_ls, {}),
	t({"", "\\end{itemize}"}), i(0)
})
table.insert(snippets, infiniteItemize)

local infiniteEnum = s("enum", {
	t({"\\begin{enumerate}[label=(\\roman*)]",
	"\t\\item "}), i(1), d(2, rec_ls, {}),
	t({"", "\\end{enumerate}"}), i(0)
})
table.insert(snippets, infiniteEnum)

local environment = s({ trig = "beg"}, fmt([[
\begin{{{}}}
  {}
\end{{{}}}
]], {
  i(1, "_environment" ),
  i(2, "_content" ),
  rep(1),
    }
  )
)
table.insert(snippets, environment)

local inlineMath = s("mk", fmt([[
${}$
]], {
  i(1, t"")
} ))

table.insert(autosnippets, inlineMath)

local displayMath = s("dm", fmt( -- Display math equations
[[
\[
{}
\] {}
]], {
  i(1),
  i(2),
  }))

table.insert(autosnippets, displayMath)

local subscript = s({ trig = "a([%d]+)", regTrig = true, hidden = true}, fmt( -- Description
[[
a_{{{}}}
]], {
  d(1, function(_, snip)
    return sn(1, i(1, snip.captures[1]))
  end),
  }))

table.insert(snippets, subscript)

local hat = postfix(".ht", { l( "\\hat{" .. l.POSTFIX_MATCH .. "}"), })
table.insert(autosnippets, hat)

local overline = postfix(".ol", { l( "\\overline{" .. l.POSTFIX_MATCH .. "}"), })
table.insert(autosnippets, overline)

local toSquare = postfix(".p2", { l(l.POSTFIX_MATCH .. "^{2}"), })
table.insert(autosnippets, toSquare)

local vector = postfix(".v", { l( "\\vec{" .. l.POSTFIX_MATCH .. "}"), })
table.insert(autosnippets, vector)

local toCube = 	postfix(".p3", {
  d(1, function (_, parent)
    return sn(nil, {t(parent.env.POSTFIX_MATCH .. "^{3}")})
  end)
  })

table.insert(autosnippets, toCube)

local fraction = s("//", fmt( -- Description
[[
\frac{{{}}}{{{}}}
]], {
  i(1),
  i(2),
  }))

table.insert(autosnippets, fraction)

local masterTemplate = s("mtt", fmt( -- Create subject template for master.tex
[[
\documentclass[a4paper]{{report}}
\input{{../preamble.tex}}

\DeclareMathOperator{{\length}}{{length}}
\DeclareMathOperator{{\Aut}}{{Aut}}
\DeclareMathOperator{{\diam}}{{diam}}
\DeclareMathOperator*{{\res}}{{res}}
\title{{{}}}

\begin{{document}}
    \maketitle
    \tableofcontents
    {}
    % start lectures
    % end lectures
\end{{document}}
]], {
  i(1, "course_name"),
  i(2, "lecture_input"),
  }))

table.insert(snippets, masterTemplate)

local lectureTemplate = s("ltt", fmt( -- Create a subject template for lecture_{%}.tex
[[
\documentclass[a4paper]{{article}}

\usepackage[utf8]{{inputenc}}
\usepackage[T1]{{fontenc}}
\usepackage{{textcomp}}
\usepackage[spanish]{{babel}}
\usepackage{{amsmath, amssymb}}

\begin{{document}}
  {}
\end{{document}}
]], {
  i(1, "document_contents")
  }))

table.insert(snippets, lectureTemplate)

local inputTexFile = s("nif", fmt( -- Import a tex file
[[
\input{{{}.tex}}
]], {
  i(1, "file_name")
  }))

table.insert(snippets, inputTexFile)

local boldText = s("bt", fmt(
[[
\textbf{{{}}}
]], {
  i(1, "")
}))
table.insert(snippets, boldText)

local italicText = s("it", fmt(
[[
\textit{{{}}}
]], {
  i(1, "")
}))
table.insert(snippets, italicText)

local productoEscalar = s("pe", fmt(
[[
\langle {}{{ , }}{} \rangle
]], {
  i(1, "x"),
  i(2, "y"),
}))
table.insert(snippets, productoEscalar)

local dotProduct = s("dp", fmt( -- Description
[[
{} \cdot {}
]], {
  i(1, "x"),
  i(2, "y")
  }))

table.insert(snippets, dotProduct)

local norma = s("nor", fmt( -- Description
[[
||{}||
]], {
  i(1, "x")
  }))

table.insert(snippets, norma)

return snippets, autosnippets
