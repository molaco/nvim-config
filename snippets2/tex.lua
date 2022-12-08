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
\[ 
  {} 
\] 
]], {
  i(1),
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

local hat = postfix(",ht", { l( "\\hat{" .. l.POSTFIX_MATCH .. "}"), }, {condition = math})
table.insert(autosnippets, hat)

local overline = postfix(",ol", { l( "\\overline{" .. l.POSTFIX_MATCH .. "}"), }, {condition = math})
table.insert(autosnippets, overline)

local frontera = s("Fr", fmt([[
\Fr({})
]], {
    i(1, ""),
}), {condition = math})
table.insert(autosnippets, frontera)

local mathring = postfix(",mr", { l( "\\mathring{" .. l.POSTFIX_MATCH .. "}"), }, {condition = math})
table.insert(autosnippets, mathring)

--local toSquare = postfix(".p2", { l(l.POSTFIX_MATCH .. "^{2}"), })
--table.insert(autosnippets, toSquare)

--local toNthSquare = postfix(".pn", { l(l.POSTFIX_MATCH .. "^{n}"), })
--table.insert(autosnippets, toNthSquare)

local vector = postfix(",ve", { l( "\\vec{" .. l.POSTFIX_MATCH .. "}"), }, {condition = math})
table.insert(autosnippets, vector)

--local toCube = 	postfix(".p3", {
--  d(1, function (_, parent)
--    return sn(nil, {t(parent.env.POSTFIX_MATCH .. "^{3}")})
--  end)
--  })

--table.insert(autosnippets, toCube)

local fraction = s("fr", fmt( -- Description
[[
\frac{{{}}}{{{}}}
]], {
  i(1),
  i(2),
  }), {condition = math} )

table.insert(autosnippets, fraction)

local productoEscalar = s("*e", fmt(
[[
\langle {}{{ , }}{} \rangle
]], {
  i(1, "x"),
  i(2, "y"),
}), {condition = math} )
table.insert(autosnippets, productoEscalar)

local dotProduct = s("*.", fmt( -- Description
[[
{} \cdot {}
]], {
  i(1, "x"),
  i(2, "y")
  }), {condition = math} )

table.insert(autosnippets, dotProduct)

local norma = s("nr", fmt( -- Description
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

local forAllPInN = s("fffffm", fmt( -- Description
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

local threeByThreeMatrix = s("3pm", fmt( -- Description
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

local matrixv3x3 = s("3vm", fmt( -- Description
[[
\begin{{vmatrix}}
   {} & {} & {}\\
   {} & {} & {}\\
   {} & {} & {}
\end{{vmatrix}}
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

table.insert(autosnippets, matrixv3x3)

local functionDeclaration = s("fun", fmt( -- Description
[[
{}: {} \to {}
]], {
  i(1, "f"),
  i(2, "\\mathbb{R}"),
  i(3, "\\mathbb{R}"),
  }), {condition = math} )

table.insert(autosnippets, functionDeclaration)

local ssubScript = postfix( ",fd", fmt([[
{} : {} \to {}
]], {
  d(1, function(_, parent)
    return sn(nil, {t(parent.snippet.env.POSTFIX_MATCH)})
  end),
  i(2, ""),
  i(3, ""),
  }), {condition = math} )

table.insert(autosnippets, ssubScript)

local subset = s("cc", t"\\subset", {condition = math})
table.insert(autosnippets, subset)

local supset = s("cb", t"\\supset", {condition = math})
table.insert(autosnippets, supset)

local realNumbers = s("rn", t"\\mathbb{R}", {condition = math})
table.insert(autosnippets, realNumbers)

local mapsTo = s("mt", t"\\mapsto", {condition = math})
table.insert(autosnippets, mapsTo)

local superScript = postfix( { trig = "pp([%w_]+)", regTrig = true, hidden = true }, {
  f(function(_, parent)
    return parent.snippet.env.POSTFIX_MATCH .. "^{" .. parent.captures[1] .. "}"
  end, {}),
}, {condition = math})

table.insert(autosnippets, superScript)

--local func = postfix( { trig = ".ff([%w_]+)", regTrig = true, hidden = true }, {
--  f(function(_, parent)
--    return paren.snippet.env.POSTFIX_MATCH .. "(" .. parent.captures[1] .. ")"
--  end, {}),
--}, { condition = math})
--
--table.insert(autosnippets, func)

--local funcc = s("pf", fmt(
--[[
--{}({})
--]]--, {
--    i(1, "f"),
--    i(2, "x"),
--}), {condition = math})
--table.insert(autosnippets, funcc)

local subScript = postfix( { trig = "_([%w_]+)", regTrig = true, hidden = true }, {
  f(function(_, parent)
    return parent.snippet.env.POSTFIX_MATCH .. "_{" .. parent.captures[1] .. "}"
  end, {}),
}, { condition = math})

table.insert(autosnippets, subScript)


local ssuperScript = postfix( "po", fmt([[
{}^{{{}}}
]], {
  d(1, function(_, parent)
    return sn(nil, {t(parent.snippet.env.POSTFIX_MATCH)})
  end),
  i(2, ""),
  }), {condition = math} )

table.insert(autosnippets, ssuperScript)

local funcValue = postfix( ",b", fmt([[
{}({})
]], {
  d(1, function(_, parent)
    return sn(nil, {t(parent.snippet.env.POSTFIX_MATCH)})
  end),
  i(2, ""),
  }), {condition = math} )

table.insert(autosnippets, funcValue)

local ssubScript = postfix( ",-", fmt([[
{}_{{{}}}
]], {
  d(1, function(_, parent)
    return sn(nil, {t(parent.snippet.env.POSTFIX_MATCH)})
  end),
  i(2, ""),
  }), {condition = math} )

table.insert(autosnippets, ssubScript)

-- doble es \iint triple \iiint
local integral = s("bin", fmt( -- Description
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

local integersNumbers = s("zn", t"\\mathbb{Z}", {condition = math} )
table.insert(autosnippets, integersNumbers)

local naturalNumbers = s("nn", t"\\mathbb{N}", {condition = math} )
table.insert(autosnippets, naturalNumbers)

local mathCal = s("cl", fmt( -- Description
[[
\mathcal{{{}}}
]], {
  i(1, "_txt_")
  }), {condition = math} )

table.insert(autosnippets, mathCal)

local partiaDerivative = s("pd1", fmt( -- Description
[[
\frac{{\partial{{{}}}}}{{\partial{{{}}}}}{}
]], {
  c(1, { i(nil, "f(x)"), i(nil, "")}),
  c(2, { i(nil, "y"), i(nil, "") }),
  c(3, { i(nil, ""), i(nil, "f(x)")}),
  }), {condition = math} )

table.insert(autosnippets, partiaDerivative)

local partiaDerivative2 = s("pd2", fmt( -- Description
[[
\frac{{\partial^2{{{}}}}}{{\partial{{{}}}}}^2{}
]], {
  c(1, { i(nil, "f(x)"), i(nil, "")}),
  c(2, { i(nil, "y"), i(nil, "") }),
  c(3, { i(nil, ""), i(nil, "f(x)")}),
  }), {condition = math} )

table.insert(autosnippets, partiaDerivative2)

local derivative = s("dd", fmt( -- Description
[[
\frac{{d{{{}}}}}{{d{{{}}}}}{}
]], {
  c(1, { i(nil, "f(x)"), i(nil, "")}),
  c(2, { i(nil, "y"), i(nil, "") }),
  c(3, { i(nil, ""), i(nil, "f(x)")}),
  }), {condition = math} )

table.insert(autosnippets, derivative)

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
  c(1, { i(nil, "f"), i("")}),
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

local limit = s("limn", fmt( -- Description
[[
\lim_{{{} \to {}}}
]], {
  c(1, { i(nil, "n"), i(nil, "")}),
  c(2, { i(nil, "\\infty"), i(nil, "")}),
  }), {condition = math} )

table.insert(autosnippets, limit)

local sumation = s("sumn", fmt( -- Description
[[
\sum_{{{}}}^{{{}}}
]], {
  c(1, { i(nil, "n = 0"), i(nil, "n = 1"), i("")}),
  c(2, { i(nil, "\\infty"), i("")}),
  }), {condition = math} )

table.insert(autosnippets, sumation)

local sumation2 = s("sumk", fmt( -- Description
[[
\sum_{{{}}}^{{{}}}
]], {
  c(1, { i(nil, "k = 0"), i(nil, "k = 1"), i("")}),
  c(2, { i(nil, "\\infty"), i("")}),
  }), {condition = math} )

table.insert(autosnippets, sumation2)

local sumation3 = s("sumj", fmt( -- Description
[[
\sum_{{{}}}^{{{}}}
]], {
  c(1, { i(nil, "j = 0"), i(nil, "j = 1"), i("")}),
  c(2, { i(nil, "\\infty"), i("")}),
  }), {condition = math} )

table.insert(autosnippets, sumation3)

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

local ejercicio = s("ejr", fmt( -- Description
[[
\begin{{ejr}}{}
  {}
\end{{ejr}}
]], {
  c(1, { t"", sn(nil, fmt([[
  [{}]
  ]], {
    i(1, "title")
    }))
  }),
  i(2, "content")
}))

table.insert(snippets, ejercicio)

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

local belongsTo2 = s("ni", t"\\ni", {condition = math})
table.insert(autosnippets, belongsTo2)

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

local ifThen = s("La", t"\\Leftarrow", {condition = math})
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

local parentesis = s("bp", fmt([[
{}
]], {
    c(1, {

      sn(nil, fmt([[
      ( {} )
      ]], {
          i(1, "")
        })),

      sn(nil, fmt([[
      \big ( {} \big )
      ]], {
          i(1, "")
        })),

      sn(nil, fmt([[
      \Big ( {} \Big )
      ]], {
          i(1, "")
        })),

      sn(nil, fmt([[
      \Bigg ( {} \Bigg )
      ]], {
          i(1, "")
        })),
    }),
}), {condition = math})
table.insert(autosnippets, parentesis)

local brackets = s("bb", fmt([[
{}
]], {
    c(1, {

      sn(nil, fmt([[
      [ {} ]
      ]], {
          i(1, "")
        })),

      sn(nil, fmt([[
      \big [ {} \big ]
      ]], {
          i(1, "")
        })),

      sn(nil, fmt([[
      \Big [ {} \Big ]
      ]], {
          i(1, "")
        })),

      sn(nil, fmt([[
      \Bigg [ {} \Bigg ]
      ]], {
          i(1, "")
        })),
    }),
}), {condition = math})
table.insert(autosnippets, brackets)

local set = s("bc", fmt([[
{}
]], {
    c(1, {

      sn(nil, fmt([[
      \{{ {} \}}
      ]], {
          i(1, "")
        })),

      sn(nil, fmt([[
      \big\{{ {} \big\}}
      ]], {
          i(1, "")
        })),

      sn(nil, fmt([[
      \Big\{{ {} \Big\}}
      ]], {
          i(1, "")
        })),
    }),
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

local crossProduct = s("*c", t"\\times", {condition = math})
table.insert(autosnippets, crossProduct)

--local absoluteValue = s("av", fmt([[
--|{}|
--]], {
--  i(1, ""),
--}), {condition = math})
--table.insert(autosnippets, absoluteValue)

local absoluteValue = s("av", fmt([[
{}
]], {
    c(1, {

      sn(nil, fmt([[
      | {} |
      ]], {
          i(1, "")
        })),

      sn(nil, fmt([[
      \big | {} \big |
      ]], {
          i(1, "")
        })),

      sn(nil, fmt([[
      \Big | {} \Big |
      ]], {
          i(1, "")
        })),

      sn(nil, fmt([[
      \Bigg | {} \Bigg |
      ]], {
          i(1, "")
        })),
    }),
}), {condition = math})
table.insert(autosnippets, absoluteValue)

local rowVector = s("rv", fmt( -- Description
[[
\begin{{pmatrix}}
  {}
\end{{pmatrix}}
]], {
    c(1, {

      sn(nil, fmt(
      [[
      {}_{}, & \cdots, & {}_{}
      ]], {
          i(1, "x"),
          i(2, "1"),
          i(3, "x"),
          i(4, "n"),
        })),

      i(nil, ""),
    })
  }), {condition = math})

table.insert(snippets, rowVector)

local cases = s("cs", fmt( -- Description
[[
{} =
\begin{{aligned}}
  \begin{{cases}}
    {}
  \end{{cases}}
\end{{aligned}}
]], {
  i(1, ""),
  i(2, ""),
}), {condition = math})

table.insert(autosnippets, cases)

--local pair = s("pr", fmt( -- Description
--[[
--({}, {})
--]] --, {
--  i(1, ""),
--  i(2, ""),
--  }), {condition = math})
--
--table.insert(autosnippets, pair)

local dotProduct = s("**", t"\\cdot", {condition = math})
table.insert(autosnippets, dotProduct)

local newItem = s("itt", t"\\item")
table.insert(snippets, newItem)

local realPart = s("rp", fmt(
[[
\Re({})
]], {
  i(1, ""),
}), {condition = math})
table.insert(autosnippets, realPart)

local imaginaryPart = s("ip2", fmt(
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

local exists = s("exi", t"\\exists", {condition = math})
table.insert(autosnippets, exists)

--Partes de t"X" mathcal(P)
--Espacio Topológico/Espacio asecas
--epsilom
--Overline no postfix
--hacer postfix supscript/superscript que tome solo un número regTrig (para no hacer C-K)

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

--local sistEntorno = s("see", fmt( -- Description
--[[
--\mathcal{{{}}}({})
--]]--,{
--    i(1, ""),
--    i(2, ""),
--  }), {condition = math})
--
--table.insert(autosnippets, sistEntorno)
--
--local sistEntorno2 = s("ses", fmt( -- Description
--[[
--\mathcal{{{}}}^{{{}}}
--]]--, {
--    i(1, "U"),
--    i(2, "x"),
--  }), { condition = math})
--
--table.insert(autosnippets, sistEntorno2)

local log = s("lg", fmt([[
\log({})
]], {
    i(1, "x"),
  }), {condition = math})
table.insert(autosnippets, log)

local dot = s("dot", fmt([[
\dot{{{}}}
]], {
  i(1, ""),
}), {condition = math})
table.insert(autosnippets, dot)

--local efc = s("efc", fmt([[
--\mathcal{{{}}}({};{})
--]], {
--    i(1, "C"),
--    i(2, "[0,T]"),
--    i(3, "\\mathbb{R}^d"),
--}), {condition = math})
--table.insert(autosnippets, efc)

local norm = s("||", fmt([[
\| {} \|
]], {
    i(1,""),
}), {condition = math})
table.insert(autosnippets, norm)

local sucesion = s("ssn", fmt([[
({}_{{{}}})_{{{}}}
]], {
    i(1, "f"),
    i(2, "n"),
    i(3, "n \\in \\mathbb{N}"),
}), {condition = math})
table.insert(autosnippets, sucesion)

local cdots = s("...", fmt([[
\cdots
]], {
}), {condition = math})
table.insert(autosnippets, cdots)

local curva = s("cf", fmt([[
{} {} : {} \to {}
]], {
    i(1, "\\alpha"),
    c(2, { t"", t"'"}),
    i(3, "I \\subset \\mathbb{R}"),
    i(4, "\\mathbb{R}^{3}"),
}), {condition = math})
table.insert(autosnippets, curva)

local curvaAlpha = s("aal", fmt([[
{}
]], {
    c(1, {
      sn(nil, fmt([[
      {}{}({})
      ]], {
          i(1, "\\alpha"),
          c(2, {
            i(nil, ""),
            i(nil, "'"),
            i(nil, "''"),
          }),
          i(3, "t"),
        })),
      sn(nil, fmt([[
      {}{}
      ]], {
          i(1, "\\alpha"),
          c(2, {
            i(nil, ""),
            i(nil, "'"),
            i(nil, "''"),
          })
        }))
    })
}), {condition = math})
table.insert(autosnippets, curvaAlpha)

local diedroDeFrenet = s("df", fmt([[
{}{}
]], {
    c(1, {
      t"N_{\\alpha}",
      t"K_{\\alpha}",
      t"T_{\\alpha}"
    }),
    c(2, {
      i(nil, ""),
      sn(nil, fmt([[
      ({})
      ]], {
          i(1, ""),
        }))
    })
}), {condition = math})
table.insert(autosnippets, diedroDeFrenet)

local greekLetters = s({ trig= "gk([%w_]+)", regTrig = true }, fmt([[
{}
]], {
    f(function (_, snip)
      W = snip.captures[1]
      if W == "a" then
        return "\\alpha"
      elseif W == "b" then
        return "\\beta"
      elseif W == "g" then
        return "\\gamma"
      elseif W == "G" then
        return "\\Gamma"
      elseif W == "d" then
        return "\\delta"
      elseif W == "D" then
        return "\\Delta"
      elseif W == "e" then
        return "\\epsilon"
      elseif W == "z" then
        return "\\theta"
      elseif W == "Z" then
        return "\\Theta"
      elseif W == "k" then
        return "\\kappa"
      elseif W == "K" then
        return "\\Kappa"
      elseif W == "l" then
        return "\\lambda"
      elseif W == "L" then
        return "\\Lambda"
      elseif W == "m" then
        return "\\mu"
      elseif W == "p" then
        return "\\pi"
      elseif W == "t" then
        return "\\tau"
      elseif W == "v" then
        return "\\varphi"
      elseif W == "c" then
        return "\\chi"
      elseif W == "o" then
        return "\\omega"
      elseif W == "O" then
        return "\\Omega"
      elseif W == "f" then
        return "\\phi"
      elseif W == "r" then
        return "\\rho"
      elseif W == "s" then
        return "\\sigma"
      elseif W == "n" then
        return "\\eta"
      elseif W == "x" then
        return "\\xi"
      end
    end)
}), {condition = math})
table.insert(autosnippets, greekLetters)

-- funcionamiento deseado ffh -> h({}) ffh1 -> h'({}) ffh_gka -> h_{\alpha}({})
-- fff'a -> f'(a), ffgp2a -> f^{2}(a)

local functions = s({ trig = "ff([%w_]+)", regTrig = true }, fmt([[
{}
]], {
    d(1, function (_, snip)
      -- type of function
      -- añadir sub indices (curva)
      -- añadir superindices (inverso)
      W = snip.captures
      F = ""
      N = {}

      function CHR(W)
        L = {}
        for C in W[1]:gmatch"." do
          table.insert(L, C)
        end
        return L
      end

      L = CHR(W)

      function SNP(F,N)
        return sn(nil, fmt(F, N))
      end

      if L[1] == "1" then
        F = [[
        {}caca
        ]]

        N = {
          i(1, "")
        }

      elseif L[1] == "r" then --function restriction

          F = [[
          {}|_{{{}}}
          ]]

          N = {
            i(1, ""),
            i(2, ""),
          }

      elseif L[1] == "d" then

        if L[2] == "1" then
          F = [[
          {}'
          ]]

          N = {
                i(1, ""),
          }
        elseif L[2] == "2" then
          F = [[
          {}''
          ]]

          N = {
                i(1, ""),
          }
        end

      elseif L[1] == "c" then
        F = [[
        ({} \circ {})
        ]]

        N = {
          i(1, ""),
          i(2, ""),
        }

      end

    return SNP(F,N)
    end)

}), {condition = math})
table.insert(snippets, functions)

local entornos = s({ trig = "en([%w_]+)", regTrig = true }, fmt([[
{}
]], {
    d(1, function (_, snip)
      -- type of function
      -- añadir sub indices (curva)
      -- añadir superindices (inverso)
      W = snip.captures
      F = ""
      N = {}

      function CHR(W)
        L = {}
        for C in W[1]:gmatch"." do
          table.insert(L, C)
        end
        return L
      end

      L = CHR(W)

      function SNP(F,N)
        return sn(nil, fmt(F, N))
      end

      if L[1] == "2" then
        F = [[
        \mathcal{{{}}}({})
        ]]

        N = {
          i(1, "V"),
          i(2, "x"),
        }
      elseif L[1] == "1" then
        F = [[
        \mathcal{{{}}}^{{{}}}
        ]]

        N = {
          i(1, "U"),
          i(2, "x"),
        }

      end

    return SNP(F,N)
    end)

}), {condition = math})
table.insert(autosnippets, entornos)

local topologia = s({ trig = "to([%w_]+)", regTrig = true }, fmt([[
{}
]], {
    d(1, function (_, snip)
      -- type of function
      -- añadir sub indices (curva)
      -- añadir superindices (inverso)
      W = snip.captures
      F = ""
      N = {}

      function CHR(W)
        L = {}
        for C in W[1]:gmatch"." do
          table.insert(L, C)
        end
        return L
      end

      L = CHR(W)

      function SNP(F,N)
        return sn(nil, fmt(F, N))
      end

      if L[1] == "1" then
        F = [[
        \mathcal{{{}}}
        ]]

        N = {
          i(1, "T"),
        }

      elseif L[1] == "2" then
        F = [[
        \mathcal{{{}}}'
        ]]

        N = {
          i(1, "T"),
        }

      elseif L[1] == "d" then
        F = [[
        \mathcal{{{}}}_{{d}}
        ]]

        N = {
          i(1, "T"),
        }

      elseif L[1] == "3" then
        F = [[
        \mathcal{{{}}}''
        ]]

        N = {
          i(1, "T"),
        }

      elseif L[1] == "r" then
        F = [[
        \mathcal{{{}}}|_{{{}}}
        ]]

        N = {
          i(1, "T"),
          i(2, "S"),
        }

      elseif L[1] == "j" then
        F = [[
        \mathcal{{{}}}_{{{}}}
        ]]

        N = {
          i(1, "T"),
          i(2, "j"),
        }

      elseif L[1] == "p" then
        F = [[
        \prod_{{j \in J}} \mathcal{{{}}}_{{j}}
        ]]

        N = {
          i(1, "T"),
        }

      elseif L[1] == "m" then
        F = [[ 
        \sum_{{{}}} \mathcal{{{}}}_{{{}}}
        ]]

        N = {
          i(1, "j \\in J"),
          i(1, "T"),
          i(1, "j"),
        }

      elseif L[1] == "c" then
        F = [[ 
        \mathcal{{{}}}_{{{}}}
        ]]

        N = {
          i(1, "T"),
          i(2, "f"),
        }

      end

    return SNP(F,N)
    end)

}), {condition = math})
table.insert(autosnippets, topologia)

--ESPACIO TOPO

local espacioTopologico = s({ trig = "et([%w_]+)", regTrig = true }, fmt([[
{}
]], {
    d(1, function (_, snip)
      -- type of function
      -- añadir sub indices (curva)
      -- añadir superindices (inverso)
      W = snip.captures
      F = ""
      N = {}

      function CHR(W)
        L = {}
        for C in W[1]:gmatch"." do
          table.insert(L, C)
        end
        return L
      end

      L = CHR(W)

      function SNP(F,N)
        return sn(nil, fmt(F, N))
      end

      if L[1] == "2" then
      -- añadir regtrig directamente a \mathcal{{{ regtrig }}}

        F = [[
        ( {}', \mathcal{{{}}}' )
        ]]

        N = {
          i(1, "X"),
          i(2, "T"),
        }

      elseif L[1] == "3" then

        F = [[
        ( {}^*, \mathcal{{{}}}^* )
        ]]

        N = {
          i(1, "X"),
          i(2, "T"),
        }

      elseif L[1] == "1" then

        F = [[
        ( {}, \mathcal{{{}}} )
        ]]

        N = {
          i(1, "X"),
          i(2, "T"),
        }

      elseif L[1] == "y" then

        F = [[
        ( {}, \mathcal{{{}}} )
        ]]

        N = {
          i(1, "Y"),
          i(2, "S"),
        }

      elseif L[1] == "r" then

        F = [[
        ( {}, \mathcal{{{}}}|_{{{}}})
        ]]

        N = {
          i(1, "S"),
          i(2, "T"),
          rep(1),
        }

      elseif L[1] == "j" then

        F = [[
        ( {}_{{{}}}, \mathcal{{{}}}_{{{}}} )
        ]]

        N = {
          i(1, "X"),
          i(2, "j"),
          i(3, "T"),
          rep(2),
        }

      elseif L[1] == "p" then

        F = [[
        ( \prod_{{j \in J}} {}_{{j}}, \prod_{{j \in J}} \mathcal{{{}}}_{{j}} )
        ]]

        N = {
          i(1, "X"),
          i(2, "T"),
        }
      elseif L[1] == "s" then

        F = [[
        ( {}_{{j}}, \mathcal{{{}}}_{{j}} )
        ]]

        N = {
          i(1, "X"),
          i(2, "T"),
        }

      elseif L[1] == "c" then

        F = [[
        ( {} , \mathcal{{{}}}_{{{}}})
        ]]

        N = {
          i(1, "X"),
          i(2, "T"),
          i(3, "f"),
        }

      elseif L[1] == "m" then

        F = [[
        ( \sum_{{{}}} {}, \sum_{{{}}} {})
        ]]

        N = {
          i(1, "k \\in J"),
          i(2, "X_{k}"),
          rep(1),
          i(3, "\\mathcal{T}_{k}"),
        }

      elseif L[1] == "0" then

        F = [[
        ( {}_{{{}_{{0}}}}, \mathcal{{{}}}_{{{}_{{0}}}} )
        ]]

        N = {
          i(1, "X"),
          i(2, "j"),
          i(3, "T"),
          rep(2)
        }

      elseif L[1] == "e" then

        F = [[
        ( {}/\mathcal{{R}}, \mathcal{{{}}}/\mathcal{{R}} )
        ]]

        N = {
          i(1, "X"),
          i(2, "T"),
        }

      end

    return SNP(F,N)
    end)

}), {condition = math})
table.insert(autosnippets, espacioTopologico)

local inverse = postfix("iv", {
  f(function(_, parent)
    return parent.snippet.env.POSTFIX_MATCH .. "^{-1}"
  end, {}),
}, { condition = math})
table.insert(autosnippets, inverse)

local subj = postfix(",j", {
  f(function(_, parent)
    return parent.snippet.env.POSTFIX_MATCH .. "_{j}"
  end, {}),
}, { condition = math})
table.insert(autosnippets, subj)

local subjinJ = postfix("-j", {
  f(function(_, parent)
    return parent.snippet.env.POSTFIX_MATCH .. "_{j \\in J}"
  end, {}),
}, { condition = math})
table.insert(autosnippets, subjinJ)

local forallJ = postfix("fj", {
  f(function(_, parent)
    return parent.snippet.env.POSTFIX_MATCH .. "\\forall j \\in J"
  end, {}),
}, { condition = math})
table.insert(autosnippets, forallJ)

local forallN = postfix("fn", {
  f(function(_, parent)
    return parent.snippet.env.POSTFIX_MATCH .. "\\forall n \\in \\mathbb{{N}}"
  end, {}),
}, { condition = math})
table.insert(autosnippets, forallN)

local subseuenceiIndex = postfix("sbk", {
  f(function(_, parent)
    return parent.snippet.env.POSTFIX_MATCH .. "_{n_{k}}"
  end, {}),
}, { condition = math})
table.insert(autosnippets, subseuenceiIndex)

local prod = s("pro", t"\\prod", { condition = math})
table.insert(autosnippets, prod)

local vectorProduct = s("*v", t"\\wedge", { condition = math})
table.insert(autosnippets, vectorProduct)

local vector3 = s("v3", fmt([[
( {}, {}, {})
]], {
    i(1, ""),
    i(2, ""),
    i(3, ""),
}), {condition = math})
table.insert(autosnippets, vector3)

local espacioFuncionesContinuas = s({ trig = "efc([%w_]+)", regTrig = true }, fmt([[
{}
]], {
    d(1, function (_, snip)
      -- type of function
      -- añadir sub indices (curva)
      -- añadir superindices (inverso)
      W = snip.captures
      F = ""
      N = {}

      function CHR(W)
        L = {}
        for C in W[1]:gmatch"." do
          table.insert(L, C)
        end
        return L
      end

      L = CHR(W)

      function SNP(F,N)
        return sn(nil, fmt(F, N))
      end

      if L[1] == "1" then
        F = [[
        C(J, \mathbb{{R}}_{{+}})
        ]]

      elseif L[1] == "2" then
        F = [[
        C(\mathbb{{R}}_{{+}}, \mathbb{{R}}_{{+}})
        ]]

      elseif L[1] == "l" then
        F = [[
        C^{{{}}}({}, {})
        ]]

        N = {
          c(1, {
            i(nil, ""),
            i(nil, "0,1-"),
            i(nil, "1-"),
            i(nil, "0,1")
          }),
          c(2, {
            sn(nil, fmt([[
            {} \times {}
            ]], {
                i(1, "T"),
                i(2, "X")
              })),
            i(nil, "X"),
          }),
          i(3, "Y"),
        }

      end

    return SNP(F,N)
    end)

}), {condition = math})
table.insert(autosnippets, espacioFuncionesContinuas)

local sucesionj = s("sj1", fmt([[
\{{ {} \}}_{{j \in J}}
]], {
  i(1, ""),
}), {condition = math})
table.insert(autosnippets, sucesionj)

local sucesionn = s("sn1", fmt([[
\{{ {} \}}_{{n \in \mathbb{{N}}}}
]], {
  i(1, ""),
}), {condition = math})
table.insert(autosnippets, sucesionn)

local sucesionj2 = s("sj2", fmt([[
( {} )_{{j \in J}}
]], {
  i(1, ""),
}), {condition = math})
table.insert(autosnippets, sucesionj2)

local sucesionn2 = s("sn2", fmt([[
( {} )_{{n \in \mathbb{{N}}}}
]], {
  i(1, ""),
}), {condition = math})
table.insert(autosnippets, sucesionn2)

local sucesionn3 = s("snn", fmt([[
{{ {} }}_{{i = 1}}^{{n}}
]], {
  i(1, ""),
}), {condition = math})
table.insert(autosnippets, sucesionn3)

local righleftdem = s("rld", fmt([[
{}
]], {
  c(1, {
      t("[($\\Rightarrow$)]"),
      t("[($\\Leftarrow$)]"),
    })

}))
table.insert(autosnippets, righleftdem)

local convergenciaInline = s("rr", fmt([[
\xrightarrow[]{{ {} \rightarrow {} }}
]], {
    i(1, ""),
    i(2, ""),
}), {condition = math})
table.insert(autosnippets, convergenciaInline)

local converTopo = s("ret", fmt([[
\xrightarrow[]{{ {} }}
]], {
    i(1, ""),
}), {condition = math})
table.insert(autosnippets, converTopo )

local convergenciaInline2 = s("Rr", fmt([[
\xRightarrow[]{{ {} }}
]], {
    i(1, ""),
}), {condition = math})
table.insert(autosnippets, convergenciaInline2)

local sumaj = s("ssj", fmt([[
\sum_{{ {} }}
]], {
    i(1, "j \\in J"),
}), {condition = math})
table.insert(autosnippets, sumaj)

local bigcupj = s("cuj", fmt([[
\bigcup_{{{}}}
]], {
  i(1, "j \\in J"),
}), {condition = math})
table.insert(autosnippets, bigcupj)

local circ = s("cr", fmt([[
\circ
]], {

}), {condition = math})
table.insert(autosnippets, circ)

-- lim sup/ inf

local limsup = s("ls", fmt([[
\lim \sup {}
]], {
  i(1, "A_n")
}), {condition = math})
table.insert(autosnippets, limsup)

local liminf = s("li2", fmt([[
\lim \inf {}
]], {
  i(1, "A_n")
}), {condition = math})
table.insert(autosnippets, liminf)

local bigcupk = s("cuk", fmt([[
\bigcup_{{{}}}^{{{}}} {}
]], {
  i(1, "n = 1"),
  i(2, "\\infty"),
  i(3, ""),
}), {condition = math})
table.insert(autosnippets, bigcupk)

local bigcapk = s("cak", fmt([[
\bigcap_{{{}}}^{{{}}} {}
]], {
  i(1, "n = 1"),
  i(2, "\\infty"),
  i(3, ""),
}), {condition = math})
table.insert(autosnippets, bigcapk)

local liminf2 = s("c1s", fmt([[
\bigcap_{{k=1}}^{{\infty}} \bigcup_{{n=k}}^{{\infty}} A_{{n}}
]], {
  
}), {condition = math})
table.insert(autosnippets, liminf2)

local limsup2 = s("c1i", fmt([[
\bigcup_{{k=1}}^{{\infty}} \bigcap_{{n=k}}^{{\infty}} A_{{n}}
]], {
  
}), {condition = math})
table.insert(autosnippets, limsup2)

local espacioProbabilidad = s("esp", fmt([[
(\Omega, \mathcal{{A}}, P )
]], {
  
}), {condition = math})
table.insert(autosnippets, espacioProbabilidad)

local hat2 = s("hat", fmt([[
\hat{{ {} }}
]], {
    i(1, "")
}), {condition = math})
table.insert(autosnippets, hat2)

local equiv = s("eq", fmt([[
\equiv
]], {
  
}), {condition = math})
table.insert(autosnippets, equiv)

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

local binom = s("bn", fmt([[
\binom{{{}}}{{{}}}
]], {
  i(1 , "N"),
  i(2 , "n"),
}), {condition = math})
table.insert(autosnippets, binom)

local iInNelementes = s("fiN", fmt([[
\forall {} \in \{{ 1, 2, \cdots, {} \}}
]], {
    i(1, "i"),
    i(2, "n"),
}), {condition = math})
table.insert(autosnippets, iInNelementes)

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

local box = s("bx", fmt([[
\fbox{{{}}}
]], {
  i(1, ""),
}))
table.insert(autosnippets, box)

local seriePotencias = s("spc", fmt([[
\sum_{{n = 0}}^{{\infty}} {} {}
]], {
    i(1, "a_{n}"),
    i(2, "z^{n}"),
}), {condition = math})
table.insert(autosnippets, seriePotencias)

local demos = s("dd", fmt([[
  \begin{{enumerate}}[label=(\roman*)]
    \item []
    \item [$(\Rightarrow)$] {}
    \item [$(\Leftarrow)$] {}
  \end{{enumerate}}
]], {
    i(1, ""),
    i(2, ""),
  }))

table.insert(snippets, demos)

local mathbb = s("mb", fmt([[
\mathbb{{{}}}
]], {
  i(1, ""),
}), {condition = math})
table.insert(autosnippets, mathbb)

local tripleEqual = s("3=", fmt([[
\equiv
]], {
}), {condition = math})
table.insert(autosnippets, tripleEqual)

local notN = s("!!", fmt([[
\not
]], {
}), {condition = math})
table.insert(autosnippets, notN)

local nm = s("nm", fmt([[
\{{ 1, \cdots, {} \}}
]], {
  i(1, "n")
}), {condition = math})
table.insert(autosnippets, nm)

local talque = s("tq", fmt([[
tal que
]], {
}))
table.insert(autosnippets, talque)

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

local quad = s("qq", fmt([[
\quad
]], {
  
}), {condition = math})
table.insert(autosnippets, quad)

local esperanza = s("ee", fmt([[
\mathbb{{E}} [ {} ]
]], {
    i(1, "")
}), {condition = math})
table.insert(autosnippets, esperanza)

local probabilidd = s("prr", fmt([[
\mathbb{{P}} \{{ {} \}}
]], {
    i(1, "")
}), {condition = math})
table.insert(autosnippets, probabilidd)

local compactacion2 = s("ck2", fmt([[
( {}, {} )
]], {
  i(1, "K"),
  i(2, "f"),
}), {condition = math})
table.insert(autosnippets, compactacion2)

local espacioTangente = s("te", fmt([[
T_{{{}}}({})
]], {
  i(1, "p"),
  i(2, "S"),
}), {condition = math})
table.insert(autosnippets, espacioTangente)

return snippets, autosnippets
