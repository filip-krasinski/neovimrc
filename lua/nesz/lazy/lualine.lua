return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
   init = function()
        require('lualine').setup({
            options = {
                theme = 'horizon',
                component_separators = { left = '', right = ''},
                section_separators = { left = '', right = ''},
            },
        })
    end
}
