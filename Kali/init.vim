call plug#begin('~/.local/share/nvim/plugged')
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
call plug#end()

colorscheme catppuccin " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha

" basic settings
syntax on
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set termguicolors
