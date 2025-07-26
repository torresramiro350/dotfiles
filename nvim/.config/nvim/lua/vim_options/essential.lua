local opt = vim.opt
local wo = vim.wo

-- Basic settings
opt.viewoptions = { "cursor", "folds" } -- keep the viewoption in cursot's last location
opt.number = true
opt.cursorline = true -- highlight current line
opt.relativenumber = true -- relative numbers
opt.scrolloff = 10 -- keep 10 lines above/below cursor
opt.sidescrolloff = 8 -- keep 8 columns left/right of cursor
opt.ruler = false -- Disable the default ruler
-- TODO: find what this oes
opt.list = true
opt.laststatus = 3 -- draw the status line over the whole window
opt.textwidth = 80 -- set the maximum text width to be 80 characters

-- Indentation
opt.tabstop = 2 -- tab width
opt.shiftwidth = 2 -- indent width
opt.softtabstop = 2 -- soft tab stop
opt.expandtab = true -- use spaces instead of tabs
opt.smartindent = true -- smart auto-indenting
opt.autoindent = true -- copy indent from current line
opt.breakindent = true -- Enable break indent

-- Search settings
opt.ignorecase = true -- Case insensitive search
opt.smartcase = true -- Case sensitive if uppercase search
opt.hlsearch = false -- Don't highlight search results
opt.incsearch = true -- Show matches as you type

-- Visual settings
opt.termguicolors = true -- Enable 24-bit colors
opt.signcolumn = "yes" -- Always show sign column
opt.colorcolumn = "90" -- Show column at 90 characters
opt.showmatch = true -- Highlight matching parenthesis
opt.matchtime = 2 -- How long to show matching bracket
opt.cmdheight = 1 -- Command line height
opt.completeopt = "menuone,noinsert,noselect" -- Completion options
opt.showmode = false -- Don't show mode in command line
opt.pumheight = 10 -- Pop-up menu height
opt.pumblend = 10 -- Popup menu transparency
opt.winblend = 0 -- Floating window transparency
opt.conceallevel = 2 -- Don't hide markup
opt.concealcursor = "" -- Don't hide curser line markup
opt.lazyredraw = false -- Don't redraw during macros (false to work with noice)
opt.synmaxcol = 300 -- Syntax highlight limit
-- TODO: find what this oes
opt.jumpoptions = "view"
opt.inccommand = "nosplit" -- preview incremental substitute

-- File handling
opt.backup = false -- Don't create backup files
opt.writebackup = false -- Don't create backup before writing
opt.swapfile = false -- Don't create swap files
opt.undofile = true -- Persistent undo
opt.undodir = vim.fn.expand("~/.vim/undodir") -- Undo directory
opt.updatetime = 300 -- Faster compeltion
opt.timeoutlen = 500 -- Key timeout duration
opt.ttimeoutlen = 0 -- Key code timeout
opt.autoread = true -- Auto relaod files changed outside vim
opt.autowrite = false -- Don't autosave

-- Behavior settings
opt.hidden = true -- Allow hidden buffers
opt.errorbells = false -- No error bells
opt.backspace = "indent,eol,start" -- Better backspace behavior
opt.autochdir = false -- Don't auto change directory
opt.iskeyword:append("-") -- Treat dash as part of word
opt.path:append("**") -- include subdirectories in search
opt.selection = "exclusive" -- selection behavior
opt.mouse = "a" -- Enable mouse support
opt.mousemoveevent = true
opt.clipboard:append("unnamedplus") -- Use system clipboard
opt.modifiable = true -- Allow buffer modifications
opt.encoding = "UTF-8" -- Set encoding

-- Folding settings
opt.foldmethod = "expr" -- Use expression for folding
opt.foldexpr = "nvim_treesitter#foldexpr()" -- use treesitter for folding
opt.foldlevel = 99 -- Start with all folds open
vim.opt.foldenable = true
vim.opt.foldcolumn = "0"

-- Split behavior
opt.splitbelow = true -- Horizontal splits go below
opt.splitright = true -- Vertical splits go right
vim.opt.splitkeep = "screen" -- Better splitting

-- Key mappings
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- nerd fonts
vim.g.have_nerd_font = true

-- ai settings
vim.g.ai_cmp = true
vim.g.copilot_no_tab_map = false

-- Place all the general Neovim options
vim.g.gitblame_display_virtual_text = 1
vim.o.background = "dark"

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
