local modes = {
  ["n"]  = "NORMAL",
  ["no"] = "NORMAL",
  ["v"]  = "VISUAL",
  ["V"]  = "V-LINE",
  [""]   = "V-BLOCK",
  ["s"]  = "SELECT",
  ["S"]  = "S-LINE",
  [""]   = "S-BLOCK",
  ["i"]  = "INSERT",
  ["ic"] = "INSERT",
  ["R"]  = "REPLACE",
  ["Rv"] = "V-REPLACE",
  ["c"]  = "COMMAND",
  ["cv"] = "VIM EX",
  ["ce"] = "EX",
  ["r"]  = "PROMPT",
  ["rm"] = "MOAR",
  ["r?"] = "CONFIRM",
  ["!"]  = "SHELL",
  ["t"]  = "TERMINAL",
}

local function mode()
  local current_mode = vim.api.nvim_get_mode().mode
  return string.format(" %s ", modes[current_mode]):upper()
end

local function filepath()
  local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
  if fpath == "" or fpath == "." then
      return " "
  end

  return string.format(" %%<%s/", fpath)

end

local function filename()
  local fname = vim.fn.expand "%:t"
  if fname == "" then
      return ""
  end
  return fname .. " "
end

local function filetype()
  return string.format(" %s ", vim.bo.filetype):upper()
end

local function lineinfo()
  if vim.bo.filetype == "alpha" then
    return ""
  end
  return " %P %l:%c "
end

local icon_branch = '󰘬'
local icon_clock = ''
local icon_left_sep = ''
local icon_right_sep = ''

local function GetGitBranch()
    return string.format(" %s %s ", icon_branch, vim.fn["fugitive#Head"]())
end

local function time()
    local current_time = os.date("*t")
    return string.format(" %s %02d:%02d ", icon_clock, current_time.hour, current_time.min)
end


local color_text = '#F4E1E0'
local color_first = '#200A08'
local color_second = '#A73D35'
local color_third = '#643632'
local color_free = '#200A08'

local function createHiCommand(group, fg, bg)
    return string.format('hi %s guifg=%s guibg=%s', group, fg, bg)
end

local function createColors()
    vim.cmd(createHiCommand('Status1', color_text, color_first))
    
    vim.cmd(createHiCommand('Status2', color_first, color_second))
    vim.cmd(createHiCommand('Status2T', color_text, color_second))

    vim.cmd(createHiCommand('Status3', color_second, color_third))
    vim.cmd(createHiCommand('Status3T', color_text, color_third))
    vim.cmd(createHiCommand('Status4', color_third, color_free))

    vim.cmd(string.format('hi NonText guifg=%s', color_first))
end

createColors()

Statusline = {}

Statusline.active = function()
  return table.concat {
    "%#Status1#",
    mode(),
    "%#Status2#",
    icon_left_sep,

    "%#Status2T#",
    GetGitBranch(),
    "%#Status3#",
    icon_left_sep,

    "%#Status3T#",
    filepath(),
    filename(),
    "%#Status4#",
    icon_left_sep,


    "%=%#Normal#",


    "%#Status4#",
    icon_right_sep,
    "%#Status3T#",
    filetype(),

    "%#Status3#",
    icon_right_sep,
    "%#Status2T#",
    lineinfo(),

    "%#Status2#",
    icon_right_sep,
    "%#Status1#",
    time()
  }
end

vim.o.laststatus = 3
vim.api.nvim_exec([[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
  augroup END
]], false)

