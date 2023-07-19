require('rose-pine').setup({
    disable_background = true
})

require('2077')

require('tokyodark')

require('onedarkpro')

require('kanagawa')

function ModTheme(color)
	color = color or "kanagawa-wave" or "onedark" or "tokyodark" or "2077" or "rose-pine"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", {bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", {bg = "none" })
end

ModTheme()
