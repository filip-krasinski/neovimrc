return {
    {
        "williamboman/mason.nvim",
        opts = {
            --overrides.mason,
            registries = {
                "github:nvim-java/mason-registry",
                "github:mason-org/mason-registry",
            }
        }
    },
    --{
    --    "neovim/nvim-lspconfig",
    --    opts = {
    --        setup = {
    --            -- disable jdtls config from lspconfig
    --            jdtls = function()
    --                return true
    --            end,
    --        },
    --    },
    --},
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
        config = function()
            local on_attach = function(client, bufnr)
            require("plugins.configs.lspconfig").on_attach(client, bufnr)
        end
    
        --local capabilities = require("plugins.configs.lspconfig").capabilities
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
        -- calculate workspace dir
        local workspace_dir = vim.fn.stdpath "data" .. "/site/java/workspace-root/" .. project_name
        -- get the mason install path
        local install_path = require("mason-registry").get_package("jdtls"):get_install_path()
        --
        local lombok_path = require("mason-registry").get_package("lombok-nightly"):get_install_path() .. "/lombok.jar"
        -- get the debug adapter install path
        local debug_install_path = require("mason-registry").get_package("java-debug-adapter"):get_install_path()
        local bundles = {
            vim.fn.glob(debug_install_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", 1),
        }
    
        -- Comment out these lines if you have 'java-test' installed
        -- local java_test_path = require("mason-registry").get_package("java-test"):get_install_path()
        -- vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar", 1), "\n"))
    
        local config = {
            cmd = {
                install_path .. "/bin/jdtls",
                "--jvm-arg=-javaagent:" .. lombok_path,
                "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                "-Dosgi.bundles.defaultStartLevel=4",
                "-Declipse.product=org.eclipse.jdt.ls.core.product",
                "-Dlog.protocol=true",
                "-Dlog.level=ALL",
                "-Xms1g",
                "--add-modules=ALL-SYSTEM",
                "--add-opens",
                "java.base/java.util=ALL-UNNAMED",
                "--add-opens",
                "java.base/java.lang=ALL-UNNAMED",
                "-data",
                workspace_dir,
            },
            on_attach = on_attach,
            --capabilities = capabilities,
            root_dir = vim.fs.dirname(
                vim.fs.find({ ".gradlew", ".git", "mvnw", "pom.xml", "build.gradle" }, { upward = true })[1]
            ),
    
            settings = {
                java = {
                    signatureHelp = { enabled = true },
                },
            },
    
            init_options = {
                bundles = bundles,
            },
           
            vim.keymap.set("n", "<leader>ca", "<Cmd>lua vim.lsp.buf.code_action()<CR>");
            vim.keymap.set("n", "<leader>gd", "<Cmd>lua vim.lsp.buf.definition()<CR>");
            vim.keymap.set("n", "<leader>gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>");

            vim.keymap.set("n", "<leader>oi", "<Cmd>lua require'jdtls'.organize_imports()<CR>");
            vim.keymap.set("n", "<leader>ev", "<Cmd>lua require('jdtls').extract_variable()<CR>");
            vim.keymap.set("n", "<leader>ec", "<Cmd>lua require('jdtls').extract_constant()<CR>");

            vim.keymap.set("v", "<leader>ca", "<Cmd>lua vim.lsp.buf.range_code_action()<CR>");
            vim.keymap.set("v", "<leader>ev", "<Cmd>lua require('jdtls').extract_variable(true)<CR>");
            vim.keymap.set("v", "<leader>ec", "<Cmd>lua require('jdtls').extract_constant(true)<CR>");
            vim.keymap.set("v", "<leader>em", "<Cmd>lua require('jdtls').extract_method(true)<CR>");

        }
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function()
                require("jdtls").start_or_attach(config)
            end,
        })
        end,
    },
}
