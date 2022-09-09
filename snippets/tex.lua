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
  }))
table.insert(snippets, environment)

local inlineMath = s("mk", fmt([[
${}$
]], {
  i(1, t"")
  }))

table.insert(autosnippets, inlineMath)

local displayMath = s("dm", fmt( -- Display math equations
[[
\[ {} \] {}
]], {
  i(1),
  i(2),
  }))

table.insert(autosnippets, displayMath)

--local subscript = s({ trig = "a([%d]+)", regTrig = true, hidden = true}, fmt( -- Description
--[[
--a_{{{}}}
--]]--, {
--  d(1, function(_, snip)
--    return sn(1, i(1, snip.captures[1]))
--  end),
--  }))

--table.insert(snippets, subscript)

local hat = postfix(".ht", { l( "\\hat{" .. l.POSTFIX_MATCH .. "}"), }, {condition = math})
table.insert(autosnippets, hat)

local overline = postfix(".ol", { l( "\\overline{" .. l.POSTFIX_MATCH .. "}"), }, {condition = math})
table.insert(autosnippets, overline)

local frontera = postfix(".fr", { l( "Fr(" .. l.POSTFIX_MATCH .. ")"), }, {condition = math})
table.insert(autosnippets, frontera)

local mathring = postfix(".mr", { l( "\\mathring{" .. l.POSTFIX_MATCH .. "}"), }, {condition = math})
table.insert(autosnippets, mathring)

--local toSquare = postfix(".p2", { l(l.POSTFIX_MATCH .. "^{2}"), })
--table.insert(autosnippets, toSquare)

--local toNthSquare = postfix(".pn", { l(l.POSTFIX_MATCH .. "^{n}"), })
--table.insert(autosnippets, toNthSquare)

local vector = postfix(".v", { l( "\\vec{" .. l.POSTFIX_MATCH .. "}"), }, {condition = math})
table.insert(autosnippets, vector)

--local toCube = 	postfix(".p3", {
--  d(1, function (_, parent)
--    return sn(nil, {t(parent.env.POSTFIX_MATCH .. "^{3}")})
--  end)
--  })

--table.insert(autosnippets, toCube)

local fraction = s("//", fmt( -- Description
[[
\frac{{{}}}{{{}}}
]], {
  i(1),
  i(2),
  }), {condition = math} )

table.insert(autosnippets, fraction)

local masterTemplate = s("mtt", fmt( -- Create subject template for master.tex
[[
\documentclass[a4paper]{{report}}
\input{{../preamble.tex}}

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

local boldText = s("tb", fmt(
[[
\textbf{{{}}}
]], {
  i(1, "")
}))
table.insert(snippets, boldText)

local italicText = s("ti", fmt(
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
}), {condition = math} )
table.insert(autosnippets, productoEscalar)

local dotProduct = s("dp2", fmt( -- Description
[[
{} \cdot {}
]], {
  i(1, "x"),
  i(2, "y")
  }), {condition = math} )

table.insert(autosnippets, dotProduct)

local norma = s("nor", fmt( -- Description
[[
||{}||
]], {
  i(1, "x")
  }), {condition = math} )

table.insert(autosnippets, norma)

local bigMatrix = s("bm", fmt( -- Description
[[
\begin{{pmatrix}}
   {} & \cdots & {} \\
   \vdots & \ddots & \vdots \\
   {} & \cdots & {}
\end{{pmatrix}}
]], {
  i(1, "a"),
  i(2, "b"),
  i(3, "c"),
  i(4, "d"),
  }), {condition = math} )

table.insert(autosnippets, bigMatrix)

local forAllPInN = s("fm", fmt( -- Description
[[
\forall {}=1, \ldots,n.
]], {
  i(1, "var")
  }), {condition = math} )

table.insert(autosnippets, forAllPInN)

local twoByTwoMatrix = s("2m", fmt( -- Description
[[
\begin{{pmatrix}}
   {} & {} \\
   {} & {}
\end{{pmatrix}}
]], {
  i(1, "a"),
  i(2, "b"),
  i(3, "c"),
  i(4, "d"),
  }), {condition = math} )

table.insert(autosnippets, twoByTwoMatrix)

local threeByThreeMatrix = s("3m", fmt( -- Description
[[
\begin{{pmatrix}}
   {} & {} & {}\\
   {} & {} & {}\\
   {} & {} & {}
\end{{pmatrix}}
]], {
  i(1, "a1"),
  i(2, "a2"),
  i(3, "a3"),
  i(4, "a4"),
  i(5, "a5"),
  i(6, "a6"),
  i(7, "a7"),
  i(8, "a8"),
  i(9, "a9"),
  }), {condition = math} )

table.insert(autosnippets, threeByThreeMatrix)

local functionDeclaration = s("fun", fmt( -- Description
[[
{}: {} \to {}
]], {
  i(1, "f"),
  i(2, "\\mathbb{R}"),
  i(3, "\\mathbb{R}"),
  }), {condition = math} )

table.insert(autosnippets, functionDeclaration)

local subset = s("cc", t"\\subset", {condition = math})
table.insert(autosnippets, subset)

local realNumbers = s("rn", t"\\mathbb{R}", {condition = math})
table.insert(autosnippets, realNumbers)

local mapsTo = s("mt", t"\\mapsto", {condition = math})
table.insert(autosnippets, mapsTo)

local superScript = postfix( { trig = ".ss([%w_]+)", regTrig = true, hidden = true }, {
  f(function(_, parent)
    return parent.snippet.env.POSTFIX_MATCH .. "^{" .. parent.captures[1] .. "}"
  end, {}),
}, {condition = math})

table.insert(autosnippets, superScript)

local subScript = postfix( { trig = "_([%w_]+)", regTrig = true, hidden = true }, {
  f(function(_, parent)
    return parent.snippet.env.POSTFIX_MATCH .. "_{" .. parent.captures[1] .. "}"
  end, {}),
}, { condition = math})

table.insert(autosnippets, subScript)


local ssuperScript = postfix( ".p", fmt([[
{}^{{{}}}
]], {
  d(1, function(_, parent)
    return sn(nil, {t(parent.snippet.env.POSTFIX_MATCH)})
  end),
  i(2, ""),
  }), {condition = math} )

table.insert(autosnippets, ssuperScript)

local ssubScript = postfix( "._", fmt([[
{}_{{{}}}
]], {
  d(1, function(_, parent)
    return sn(nil, {t(parent.snippet.env.POSTFIX_MATCH)})
  end),
  i(2, ""),
  }), {condition = math} )

table.insert(autosnippets, ssubScript)

-- doble es \iint triple \iiint
local integral = s("int", fmt( -- Description
[[
{}{}
]], {
  c(1, { t("\\int"), t("\\iint"), t("\\iiint") }),
  i(2, ""),
  }), {condition = math})

table.insert(autosnippets, integral)

local intEval = s("evl", fmt( -- Description
[[
\Big|_{{{}}}^{{{}}}
]], {
  i(1, "a"),
  i(2, "b"),
  }), {condition = math} )

table.insert(autosnippets, intEval)

local infinity = s("oo", t"\\infty", {condition = math} )

table.insert(autosnippets, infinity)

local rationalNumbers = s("qn", t"\\mathbb{Q}", {condition = math} )
table.insert(autosnippets, rationalNumbers)

local complexNumbers = s("cn", t"\\mathbb{C}", {condition = math} )
table.insert(autosnippets, complexNumbers)

local integersNumbers = s("ent", t"\\mathbb{Z}", {condition = math} )
table.insert(autosnippets, integersNumbers)

local naturalNumbers = s("nn", t"\\mathbb{N}", {condition = math} )
table.insert(autosnippets, naturalNumbers)

local mathCal = s("cali", fmt( -- Description
[[
\mathcal{{{}}}
]], {
  i(1, "_txt_")
  }), {condition = math} )

table.insert(autosnippets, mathCal)

local partiaDerivative = s("pd", fmt( -- Description
[[
\frac{{\partial{{{}}}}}{{\partial{{{}}}}}{}
]], {
  c(1, { i(nil, "f(x)"), i(nil, "")}),
  c(2, { i(nil, "y"), i(nil, "") }),
  c(3, { i(nil, ""), i(nil, "f(x)")}),
  }), {condition = math} )

table.insert(autosnippets, partiaDerivative)

local derivativeWithRespectTo = s("nd", fmt( -- Description
[[
\frac{{d{{{}}}}}{{d{{{}}}}}{}
]], {
  c(1, { i(nil, "f(x)"), i(nil, "")}),
  c(2, { i(nil, "y"), i(nil, "") }),
  c(3, { i(nil, ""), i(nil, "f(x)")}),
  }), {condition = math} )

table.insert(autosnippets, derivativeWithRespectTo)

local funcionDerivative = s("fn", fmt( -- Description
[[
{}{}({})
]], {
  c(1, { t("f"), i("")}),
  c(2, { t"",
    sn(1, fmt([[
    ^{{({})}}
    ]], {
      i(1, "n"),
    }))
  }),
  i(3, "x")
}), {condition = math} )

table.insert(autosnippets, funcionDerivative)

local partial = s("pv", fmt( -- Description
[[
\partial{{{}}}
]], {
  i(1, "")
  }), {condition = math} )

table.insert(autosnippets, partial)

local limit = s("lm", fmt( -- Description
[[
\lim_{{{} \to {}}}
]], {
  c(1, { t"n", i("")}),
  c(2, { t"\\infty", i("")}),
  }), {condition = math} )

table.insert(autosnippets, limit)

local sumation = s("sum", fmt( -- Description
[[
\sum_{{{}}}^{{{}}}
]], {
  c(1, { t"n=1", i("")}),
  c(2, { t"\\infty", i("")}),
  }), {condition = math} )

table.insert(autosnippets, sumation)

local part = s("prt", fmt( -- Description
[[
\part{{{}}}
]], {
  i(1, "")
  }))

table.insert(snippets, part)

local chapter = s("chp", fmt( -- Description
[[
\chapter{{{}}}
]], {
  i(1, "")
  }))

table.insert(snippets, chapter)

local section = s("sec", fmt( -- Description
[[
\section{{{}}}
]], {
  i(1, "")
  }))

table.insert(snippets, section)

local subSection = s("ssec", fmt( -- Description
[[
\subsection{{{}}}
]], {
  i(1, "")
  }))

table.insert(snippets, subSection)

local theorem = s("th", fmt( -- Description
[[
\begin{{theo}}{}
  {}
\end{{theo}}
]], {
  c(1, { t"", sn(nil, fmt([[
  [{}]
  ]], {
    i(1, "title")
    }))
  }),
  i(2, "content")
}))

table.insert(snippets, theorem)

local corolary = s("co", fmt( -- Description
[[
\begin{{cor}}{}
  {}
\end{{cor}}
]], {
  c(1, { t"", sn(nil, fmt([[
  [{}]
  ]], {
    i(1, "title")
    }))
  }),
  i(2, "content")
}))

table.insert(snippets, corolary)

local lemma = s("le", fmt( -- Description
[[
\begin{{lem}}{}
  {}
\end{{lem}}
]], {
  c(1, { t"", sn(nil, fmt([[
  [{}]
  ]], {
    i(1, "title")
    }))
  }),
  i(2, "content")
}))

table.insert(snippets, lemma)

local definition = s("def", fmt( -- Description
[[
\begin{{defn}}{}
  {}
\end{{defn}}
]], {
  c(1, { t"", sn(nil, fmt([[
  [{}]
  ]], {
    i(1, "title")
    }))
  }),
  i(2, "content")
}))

table.insert(snippets, definition)

local proposition = s("pro", fmt( -- Description
[[
\begin{{prop}}{}
  {}
\end{{prop}}
]], {
  c(1, { t"", sn(nil, fmt([[
  [{}]
  ]], {
    i(1, "title")
    }))
  }),
  i(2, "content")
}))

table.insert(snippets, proposition)

local observation = s("obs", fmt( -- Description
[[
\begin{{obs}}{}
  {}
\end{{obs}}
]], {
  c(1, { t"", sn(nil, fmt([[
  [{}]
  ]], {
    i(1, "title")
    }))
  }),
  i(2, "content")
}))

table.insert(snippets, observation)

local notation = s("not", fmt( -- Description
[[
\begin{{nota}}{}
  {}
\end{{nota}}
]], {
  c(1, { t"", sn(nil, fmt([[
  [{}]
  ]], {
    i(1, "title")
    }))
  }),
  i(2, "content")
}))

table.insert(snippets, notation)

local proof = s("dem", fmt( -- Description
[[
\begin{{dem}}{}
  {}
\end{{dem}}
]], {
  c(1, { t"", sn(nil, fmt([[
  [{}]
  ]], {
    i(1, "title")
    }))
  }),
  i(2, "content")
}))

table.insert(snippets, proof)

local example = s("ej", fmt( -- Description
[[
\begin{{ejm}}{}
  {}
\end{{ejm}}
]], {
  c(1, { t"", sn(nil, fmt([[
  [{}]
  ]], {
    i(1, "title")
    }))
  }),
  i(2, "content")
}))

table.insert(snippets, example)

local notEqual = s("!=", t"\\neq", {condition = math})
table.insert(autosnippets, notEqual)

local greaterThanOrEqual = s(">=", t"\\geq", {condition = math})
table.insert(autosnippets, greaterThanOrEqual)

local lessThanOrEqual = s("<=", t"\\leq", {condition = math})
table.insert(autosnippets, lessThanOrEqual)

local belongsTo = s("in", t"\\in", {condition = math})
table.insert(autosnippets, belongsTo)

local doesNotBelongsTo = s("nin", t"\\not\\in", {condition = math})
table.insert(autosnippets, doesNotBelongsTo)

local doesNot = s("!!", t"\\not", {condition = math})
table.insert(autosnippets, doesNot)

local nabla = s("nb", t"\\nabla", {condition = math})
table.insert(autosnippets, nabla)

local limSup = s("lims", fmt( -- Description
[[
\limsup_{{{} \to {}}}
]], {
  c(1, { t"n", i("")}),
  c(2, { t"\\infty", i("")}),
  }), {condition = math} )

table.insert(autosnippets, limSup)

local limInf = s("limi", fmt( -- Description
[[
\liminf_{{{} \to {}}}
]], {
  c(1, { t"n", i("")}),
  c(2, { t"\\infty", i("")}),
}), { condition = math })

table.insert(autosnippets, limInf)

local forAll = s("fa", t"\\forall", {condition = math})
table.insert(autosnippets, forAll)

local ifAndOnlyIf = s("iff", t"\\Leftrightarrow", {condition = math})
table.insert(autosnippets, ifAndOnlyIf)

local ifThen = s("Ra", t"\\Rightarrow", {condition = math})
table.insert(autosnippets, ifThen)

local ifThen = s("ra", t"\\rightarrow", {condition = math})
table.insert(autosnippets, ifThen)

local eulerPower = s("epp", fmt( -- Description
[[
e^{{{}}}
]], {
  i(1, "")
  }), {condition = math} )

table.insert(autosnippets, eulerPower)

local nLog = s("ln", fmt( -- Description
[[
\ln({})
]], {
  i(1, "")
  }), {condition = math} )

table.insert(autosnippets, nLog)

local emptySet = s("!0", t"\\emptyset", {condition = math})
table.insert(autosnippets, emptySet)

--arreglar esto

local omega = s("ome", fmt([[{}]], {c(1, {t"\\omega",t"\\Omega"})}), {condition = math})
table.insert(autosnippets, omega)

local lambda = s("lam", fmt([[{}]], {c(1, {t"\\lambda",t"\\Lambda"})}), {condition = math})
table.insert(autosnippets, lambda)

local theta = s("the", c(1, {t"\\theta",t"\\Theta"}), {condition = math})
table.insert(autosnippets, theta)

local squareRoot = s("sqr", fmt( -- Description
[[
\sqrt{{{}}}
]], {
  i(1, "")
  }), {condition = math})

table.insert(autosnippets, squareRoot)

local integral2 = s("iint", fmt( -- Description
[[
\int_{{{}}}^{{{}}} {} d{}
]], {
  i(1, ""),
  i(2, ""),
  i(3, ""),
  i(4, ""),
}), {condition = math})

table.insert(autosnippets, integral2)

local textInMath = s("tt", fmt([[
\text{{{}}}
]], {
  i(1, "")
}), {condition = math})
table.insert(autosnippets, textInMath)

local plusMinus = s("+-", t"\\pm", {condition = math})
table.insert(autosnippets, plusMinus)

local bigParenthesis = s("bp", fmt([[
\{}( {} \{})
]], {
  c(1, { t"big", t"Big", t"Bigg"}),
  i(2, ""),
  rep(1),
}), {condition = math})
table.insert(autosnippets, bigParenthesis)

local bigBrackets = s("bb", fmt([[
\{}[ {} \{}]
]], {
  c(1, { t"big", t"Big", t"Bigg"}),
  i(2, ""),
  rep(1),
}), {condition = math})
table.insert(autosnippets, bigBrackets)

local set = s("bc", fmt([[
{}\{{ {} {}\}}
]], {
  c(1, { t"", t"\\big", t"\\Big", t"\\Bigg"}),
  i(2, ""),
  rep(1),
}), {condition = math})
table.insert(autosnippets, set)

local nThRoot = s("nrt", fmt( -- Description
[[
\sqrt[{}]{{{}}}
]], {
  i(1, ""),
  i(2, ""),
}), {condition = math})

table.insert(autosnippets, nThRoot)

--local bigUnion = s("bU", fmt( -- Description
--[[
--\bigcup_{{{}}}^{{{}}}{}
--]]--, {
--  i(1, ""),
--  i(2, ""),
--  i(3, ""),
--}), {condition = math})
--
--table.insert(autosnippets, bigUnion)

--local bigIntersection = s("bI", fmt( -- Description
--[[
--\bigcap_{{{}}}^{{{}}}{}
--]]--, {
--  i(1, ""),
--  i(2, ""),
--  i(3, ""),
--}), {condition = math})

--table.insert(autosnippets, bigIntersection)

local bigcap = s("bI", t"\\bigcap", {conditions = math})
table.insert(autosnippets, bigcap)

local bigcup = s("bU", t"\\bigcup", {conditions = math})
table.insert(autosnippets, bigcup)

local crossProduct = s("cp", t"\\times", {condition = math})
table.insert(autosnippets, crossProduct)

local absoluteValue = s("av", fmt([[
|{}|
]], {
  i(1, ""),
}), {condition = math})
table.insert(autosnippets, absoluteValue)

local rowVector = s("rv", fmt( -- Description
[[
\begin{{pmatrix}}
  {}
\end{{pmatrix}}
]], {
  i(1, "ej.: a_1 & a_2 \\cdots & a_n")
  }), {condition = math})

table.insert(snippets, rowVector)

local cases = s("cs", fmt( -- Description
[[
{} =
\begin{{cases}}
  {}
\end{{cases}}
]], {
  i(1, ""),
  i(2, ""),
}), {condition = math})

table.insert(autosnippets, cases)

local pair = s("pr", fmt( -- Description
[[
({}, {})
]], {
  i(1, ""),
  i(2, ""),
  }), {condition = math})

table.insert(autosnippets, pair)

local dotProduct = s("dp", t"\\cdot", {condition = math})
table.insert(autosnippets, dotProduct)

local newItem = s("it", t"\\item")
table.insert(autosnippets, newItem)

local realPart = s("rp", fmt(
[[
\Re({})
]], {
  i(1, ""),
}), {condition = math})
table.insert(autosnippets, realPart)

local imaginaryPart = s("ip", fmt(
[[
\Im({})
]], {
  i(1, ""),
}), {condition = math})
table.insert(autosnippets, imaginaryPart)

local tau = s("tt", t"\\tau", {condition = math})
table.insert(autosnippets, tau)

local cap = s("cap", t"\\cap", {condition = math})
 table.insert(autosnippets, cap)

local cup = s("cup", t"\\cup", {condition = math})
table.insert(autosnippets, cup)

local exists = s("ex", t"\\exists", {condition = math})
table.insert(autosnippets, exists)

--Partes de t"X" mathcal(P)
--Espacio Topológico/Espacio asecas
--epsilom
--Overline no postfix
--hacer postfix supscript/superscript que tome solo un número regTrig (para no hacer C-K)

local espTopologico = s("et", fmt([[
\big( X, \mathcal{{{}}} \big)
]], {
  i(1, "T"),
}), { condition = math })
table.insert(autosnippets, espTopologico)

local overLine = s("ol", fmt(
[[
\overline{{{}}}
]], {
  i(1, ""),
}), {condition = math})
table.insert(autosnippets, overLine)

local mathRing = s("mr", fmt(
[[
\mathring{{{}}}
]], {
  i(1, ""),
}), {condition = math})
table.insert(autosnippets, mathRing)

local seno = s("sen", fmt([[
\sen({})
]], {
    i(1, ""),
  }), {condition = math})
table.insert(autosnippets, seno)

local coseno = s("cos", fmt([[
\cos({})
]], {
    i(1, ""),
  }), {condition = math})
table.insert(autosnippets, coseno)

local tangente = s("tan", fmt([[
\tan({})
]], {
    i(1, ""),
  }), {condition = math})
table.insert(autosnippets, tangente)

local setminus = s("sm", t"\\setminus", { condition = math})
table.insert(autosnippets, setminus)

local sistEntorno = s("se", fmt( -- Description
[[
\mathcal{{{}}}({})
]], {
    i(1, ""),
    i(2, ""),
  }), {condition = math})

table.insert(autosnippets, sistEntorno)

return snippets, autosnippets
