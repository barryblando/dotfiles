return {
	ansible = {
		ansible = {
			path = "ansible",
		},
		ansiblelint = {
			enabled = false, -- will be handled by null-ls
			path = "ansible-lint",
		},
		executionEnvironment = {
			enable = false,
		},
		python = {
			interpreterPath = "python3",
		},
	},
}
