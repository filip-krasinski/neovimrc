return {
    'nvim-java/nvim-java',
    dependencies = {
        'nvim-java/lua-async-await',
        'nvim-java/nvim-java-core',
        'nvim-java/nvim-java-test',
        'nvim-java/nvim-java-dap',
        'MunifTanjim/nui.nvim',
        'neovim/nvim-lspconfig',
        {
            'mfussenegger/nvim-jdtls',
            config = function()
                vim.api.nvim_create_autocmd("LspAttach", {
                    callback = function(args)
                        local client = vim.lsp.get_client_by_id(args.data.client_id)
                        if client and client.name == "jdtls" then
                            vim.keymap.set('v', '<leader>ca', function()
                                print("<leader>ca")
                                require("jdtls").code_action()
                            end)
                            
                            vim.keymap.set('v', '<leader>gi', function()
                                print("<leader>gi")
                                vim.lsp.buf.implementation()
                            end)

                            vim.keymap.set('v', '<leader>gd', function()
                                print("<leader>gd")
                                vim.lsp.buf.definition()
                            end)
                        end
                    end
                })
            end
        },
        {
            'rcarriga/nvim-dap-ui',
            opts = {},
            keys = {
                { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
            },
            config = function(_, opts)
                local dap = require("dap")
                local dapui = require("dapui")
                dapui.setup(opts)
                dap.listeners.after.event_initialized["dapui_config"] = function()
                    dapui.open({})
                end
                dap.listeners.before.event_terminated["dapui_config"] = function()
                    dapui.close({})
                end
                dap.listeners.before.event_exited["dapui_config"] = function()
                    dapui.close({})
                end
            end,
        },
        {
            'mfussenegger/nvim-dap',
            keys = {
                { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
                { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
                { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
                { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
            },
        },
        {
            'williamboman/mason.nvim',
            opts = {
                registries = {
                    'github:nvim-java/mason-registry',
                    'github:mason-org/mason-registry',
                },
            },
        },
        {
            "williamboman/mason-lspconfig.nvim",
            opts = {
                handlers = {
                    ["jdtls"] = function()
                        require("java").setup()
                    end,
                },
            },
        },
    },
}
