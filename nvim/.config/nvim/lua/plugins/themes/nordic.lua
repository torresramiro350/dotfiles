return {
	"AlexvZyl/nordic.nvim",
	lazy = false,
	enabled = false,
	priority = 1000,
	config = function()
		-- nord-inspired theme
		require("nordic").load()
	end,
}
