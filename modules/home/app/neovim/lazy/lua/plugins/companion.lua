return {
	{
		"olimorris/codecompanion.nvim",
		event = "BufReadPost *.*",
		version = "^19.0.0",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			display = {
				chat = {
					fold_reasoning = false,
					show_reasoning = false,
				},
			},
			interactions = {
				chat = {
					adapter = {
						name = "copilot",
						model = "auto",
					},
					opts = {
						---@param ctx CodeCompanion.SystemPrompt.Context
						---@return string
						system_prompt = function(ctx)
							return ctx.default_system_prompt
								.. [[Additional context: All code blocks must end with four ` (````)]]
						end,
					},
				},
				inline = {
					adapter = {
						name = "copilot",
						model = "auto",
					},
				},
			},
		},
	},
}
