return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        cmdline = {
            enabled = false
        },
        messages = {
            enabled = false
        },
        popupmenu = {
            enabled = false
        },
    },
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    init = function()
         require("notify").setup({
            background_colour = "#000000",
        })
    end
}
