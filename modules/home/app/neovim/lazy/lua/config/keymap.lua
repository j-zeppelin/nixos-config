local map = vim.keymap.set

local function open_file_picker_in_split(direction)
	require("snacks").picker.files({
		confirm = function(picker, item)
			picker:close()
			if item then
				if direction == "horizontal" then
					vim.cmd("split " .. item.file)
				else
					vim.cmd("vsplit " .. item.file)
				end
			end
		end,
	})
end

map("n", "<leader>w", ":write<CR>")
map("n", "<leader>rs", ":restart<CR>")
map("n", "<leader>o", "<CMD>Oil<CR>")
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })
map("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true })
map("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true })

map("n", "<leader>q", ":copen<CR>")
map("n", "<leader>e", vim.diagnostic.open_float)
map("n", "<leader>q", vim.diagnostic.setloclist)
map("n", "L", ":bnext<CR>", { noremap = true, silent = true })
map("n", "H", ":bprev<CR>", { noremap = true, silent = true })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>mr", ":below Recompile<CR>")
map("n", "<leader>mR", ":below Compile<CR>")
map("n", "gl", "$", { desc = "Go to end of line" })
map("n", "gh", "^", { desc = "Go to start of line" })
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })

map("n", ";", "*``cgn", { noremap = true })
map("n", ",", "#``cgN", { noremap = true })
vim.keymap.set("v", ";", function()
	vim.cmd('noau normal! "sy')
	local selected = vim.fn.getreg("s")
	selected = vim.fn.escape(selected, "\\/.*$^~[]")
	selected = selected:gsub("\n", "\\n")
	vim.cmd("let @/ = '\\V" .. selected .. "'")
	vim.cmd("set hlsearch")
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("cgn", true, false, true), "n", false)
end, { noremap = true })

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("v", "p", '"_dP', { noremap = true, silent = true })

map("n", "<A-h>", require("smart-splits").resize_left)
map("n", "<A-j>", require("smart-splits").resize_down)
map("n", "<A-k>", require("smart-splits").resize_up)
map("n", "<A-l>", require("smart-splits").resize_right)
map("n", "<C-h>", require("smart-splits").move_cursor_left)
map("n", "<C-j>", require("smart-splits").move_cursor_down)
map("n", "<C-k>", require("smart-splits").move_cursor_up)
map("n", "<C-l>", require("smart-splits").move_cursor_right)
map("n", "<C-\\>", require("smart-splits").move_cursor_previous)
-- map("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
-- map("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
-- map("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
-- map("n", "<leader><leader>l", require("smart-splits").swap_buf_right)
map("n", "<leader><space>", function()
	Snacks.picker.smart()
end)
map("n", "<leader>sf", function()
	Snacks.picker.files()
end)
map("n", "<leader>sg", function()
	Snacks.picker.grep()
end)
map("n", "<leader>sb", function()
	Snacks.picker.buffers()
end)
map("n", "<leader>sr", function()
	Snacks.picker.recent()
end)
map("n", "<leader>se", function()
	Snacks.picker.diagnostics()
end)
map("n", "<leader>x", function()
	Snacks.picker.explorer()
end)
map("n", "<leader>scf", function()
	Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end)
map("n", "<leader>scg", function()
	Snacks.picker.grep({ cwd = vim.fn.stdpath("config") })
end)
map("n", "<leader>sp", function()
	Snacks.picker.projects({
		max_depth = 3,
		dev = { "~/coding", "~/.dotfiles" },
		patterns = { "Cargo.toml", ".git", "_darcs", ".hg", ".bzr", ".svn", "package.json", "Makefile" },
	})
end)
map("n", "<leader>gd", function()
	Snacks.picker.lsp_definitions()
end)
map("n", "<leader>gD", function()
	Snacks.picker.lsp_declarations()
end)
map("n", "<leader>gI", function()
	Snacks.picker.lsp_implementations()
end)
map("n", "<leader>gy", function()
	Snacks.picker.lsp_type_definitions()
end)
map("n", "<leader>gr", function()
	Snacks.picker.lsp_references()
end)
map("n", "<leader><BS>", function()
	Snacks.bufdelete()
end)
map("n", "<leader>lg", function()
	Snacks.lazygit()
end)

map("n", "<leader>v", function()
	open_file_picker_in_split("vertical")
end, { desc = "Pick file in vertical split" })

map("n", "<leader>h", function()
	open_file_picker_in_split("horizontal")
end, { desc = "Pick file in horizontal split" })

local diagnostic_goto = function(next, severity)
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		vim.diagnostic.jump({ count = next and 1 or -1, float = true, severity = severity })
	end
end
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

map("n", "<leader>dp", ":DapToggleBreakpoint<CR>", { desc = "Toggle Breakpoint" })
map("n", "<leader>dc", ":DapContinue<CR>", { desc = "Continue" })
map("n", "<leader>dn", ":DapNew<CR>", { desc = "New session" })
map("n", "<leader>do", ":DapStepOver<CR>", { desc = "Step Over" })
map("n", "<leader>di", ":DapStepInto<CR>", { desc = "Step Into" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "dap-view-term",
	callback = function(args)
		vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], {
			buffer = args.buf,
			silent = true,
		})
	end,
})

map("v", "<leader>aa", ":CodeCompanion #buffer ", { desc = "Inline action" })
map("n", "<leader>at", ":CodeCompanionChat Toggle<CR>", { desc = "Toggle CodeCompanion" })
map("v", "ga", ":CodeCompanionChat Add<CR>", { desc = "CodeCompanionChat add lines" })
map("v", "gf", ":CodeCompanion /fix<CR>", { desc = "Fix selected code" })
map("v", "gl", ":CodeCompanion /lsp<CR>", { desc = "Explain lsp diagnostics" })
map("n", "cca", ":CodeCompanionActions<CR>", { desc = "CodeCompanion actions" })
