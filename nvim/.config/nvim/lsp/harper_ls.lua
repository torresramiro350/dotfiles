local Lsp = require("utils.lsp")
return {
	filetypes = { "markdown" },
	cmd = { "harper-ls", "--stdio" },
	settings = {
		["harper-ls"] = {
			linters = {
				SentenceCapitalization = true,
				SpellCheck = true,
				UnclosedQuotes = true,
				WrongQuotes = false,
				LongSentences = true,
				RepeatedWords = true,
				Spaces = true,
				Matcher = true,
			},
		},
	},
}
