return {
    {
        "nvim-lua/plenary.nvim",
        name = "plenary"
    },


    "github/copilot.vim",
    {
        "eandrju/cellular-automaton.nvim",
        config = function()
            vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>")
        end
    }
    --"gpanders/editorconfig.nvim",
}
