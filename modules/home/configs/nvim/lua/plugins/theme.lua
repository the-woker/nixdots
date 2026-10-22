return {
	"bjarneo/ash.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		disable = {
			background = true, -- Disables ash's solid background, using your terminal's transparent background
		},
	},
	config = function(_, opts)
		require("ash").setup(opts)
		vim.cmd("colorscheme ash")
	end,
}
