return {
	'theprimeagen/harpoon',
	dependencies = {
		'nvim-lua/plenary.nvim',
	},
	branch = 'harpoon2',
	config = function()
		require("harpoon"):setup()
	end,
	keys = {
		{ "<leader>a", function() require("harpoon"):list():append() end },
		{ "<C-x>", function()
			local harpoon = require("harpoon")
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end },
		{ "<C-j>", function()
			local harpoon = require("harpoon")
			harpoon:list():prev()
		end },
		{ "<C-l>", function()
			local harpoon = require("harpoon")
			harpoon:list():next()
		end },
	},
}
--[[
return {
  'theprimeagen/harpoon',
  config = function ()
    require("harpoon").setup {}
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    vim.keymap.set("n", "<leader>a", mark.add_file)
    vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

    vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
    vim.keymap.set("n", "<C-9>", function() ui.nav_file(2) end)
    vim.keymap.set("n", "<C-0>", function() ui.nav_file(3) end)
    vim.keymap.set("n", "<C-p>", function() ui.nav_file(4) end)
  end
}
--]]

--[[
return {
	"ThePrimeagen/harpoon",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = true,
	keys = {
		{ "<leader>hm", "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "Mark file with harpoon" },
		{ "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<cr>", desc = "Go to next harpoon mark" },
		{ "<leader>hp", "<cmd>lua require('harpoon.ui').nav_prev()<cr>", desc = "Go to previous harpoon mark" },
		{ "<leader>ha", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Show harpoon marks" },
	},
}
--]]
