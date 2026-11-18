" to override vim's initializations
set nocompatible

" filetype plugin indent on (needed by vimwiki) is done by plug#end()
syntax enable
" syntax on

" colorscheme desert default
" colorscheme koehler

set mouse=a
set autoread
"
set encoding=utf-8
set backspace=2 " make backspace work like most other programs

" Number lines and cursor line
set number relativenumber
set ruler
set cursorline
set signcolumn=yes

" when opening new buffer, (??)
set hidden

" Bracket matching
set showmatch
set matchtime=5

" Indent by 2 spaces (no tabs) by default
set expandtab
set softtabstop=2
set shiftwidth=2
set autoindent
" only for sh scripts use what the repo uses
au FileType sh setlocal noexpandtab shiftwidth=8 softtabstop=0

" Copy/paste to system clipboard
" vnoremap <C-c> "*y
" vnoremap <C-x> "*d
" vnoremap <C-v> "*p

" Search settings
set hlsearch
set incsearch
set ignorecase
set fileignorecase
set foldopen-=search " Don't open folds when searching
" hi Search cterm=NONE ctermfg=DarkMagenta ctermbg=LightYellow


" Search settings
set wildmenu
set wildmode=longest:full,full
set wildignorecase " requireds to set ignorecase to fully work
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set wildignore+=*.class,*.pyc,*/node_modules/*,*.o
set showcmd

" Allow some space either side (vertically) of the cursor when scrolling
set scrolloff=2

" title NB it'll be overwritten by in tmux
set title
set titlestring=VIM:\ %-25.55F\ %a%r%m titlelen=70

" Always show the status line
set laststatus=2

" Sensible split directions
set splitbelow
set splitright

" Make Y behave like C and D
nnoremap Y y$

" S to join (free J up)
nnoremap S J

" % is awkward
nnoremap <Tab> %
onoremap <Tab> %
vnoremap <Tab> %

" Backspace to go to the first character of the line above
nnoremap <BS> -

" Nice invisibles
set listchars=tab:▸\ ,eol:¬

" F1 for buffer list
nnoremap <F1> :ls<CR>

" Disable swap file creation
set noswapfile

" C-s to save in insert mode
inoremap <C-s> <esc>:w<CR>gi

" Scroll around in insert mode
inoremap <C-e> <C-x><C-e>
inoremap <C-y> <C-x><C-y>

" Default K is annoying
vnoremap K <Nop>

" Autocomplete (only search current buffer)
set complete=.

" Make folds easier to see
" set foldcolumn=1

" gitgutter signcolumn
" highlight! link SignColumn LineNr
" highlight SignColumn guibg=Red ctermbg=Red

" Tabs and spaces
" au FileType c setl et sw=4 sts=4
" au FileType cpp setl et sw=2 sts=2
" au FileType make setl noet sw=4 ts=4 sts=4
" au FileType java setl et sw=4 sts=4
au FileType python setlocal expandtab shiftwidth=4 softtabstop=4 commentstring=#%s formatoptions+=cro
au FileType rust setlocal expandtab shiftwidth=4 softtabstop=4

" Don't interpret "vim: ..." commit messages as modelines
autocmd FileType gitrebase setlocal nomodeline
autocmd FileType gitcommit setlocal nomodeline

" y/p use the system clipboard (needs +clipboard: vim-full from nix)
set clipboard=unnamedplus
" without a display (e.g. over ssh) use tmux's paste buffer as the clipboard instead:
" shared by all panes, and `load-buffer -w` also sends it on to the local terminal (OSC 52).
" Outside tmux, fall back to OSC 52 directly (copy only, most terminals don't allow pasting)
if exists('+clipmethod')
  function! s:TmuxCopy(reg, type, lines) abort
    call system('tmux load-buffer -w -', join(a:lines, "\n") . (a:type ==# 'V' ? "\n" : ''))
  endfunction
  function! s:TmuxPaste(reg) abort
    let l:text = system('tmux save-buffer -')
    let l:type = l:text =~# "\n$" ? 'V' : 'v'
    let l:lines = split(l:text, "\n", 1)
    return [l:type, l:type ==# 'V' ? l:lines[:-2] : l:lines]
  endfunction
  let v:clipproviders['tmux'] = {
        \ 'available': {-> !empty($TMUX)},
        \ 'copy': {'+': function('s:TmuxCopy'), '*': function('s:TmuxCopy')},
        \ 'paste': {'+': function('s:TmuxPaste'), '*': function('s:TmuxPaste')},
        \ }
  packadd osc52
  let g:osc52_force_avail = 1
  let g:osc52_disable_paste = 1
  set clipmethod=wayland,x11,tmux,osc52
endif

let mapleader=","

" Section: browse oldfiles
set viminfo='10,<50,s10,h " remember 10 files; the rest are vim's defaults
nnoremap <leader>a :browse oldfiles<CR>
" NB use q to stop.
" map vs nnoremap
" map is recursive
" nnoremap is non-recursive, so it won't call other mappings
" ,o opens the last file vim was closed in (mark '0 from viminfo)
nnoremap <leader>o '0

" trailing whitespace is removed on save by the ALE fixers (keeps the cursor in place)

if empty(glob('~/.vim/autoload/plug.vim'))
silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
  \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'https://github.com/altercation/vim-colors-solarized.git'
Plug 'morhetz/gruvbox'
Plug 'jmcantrell/vim-virtualenv'
Plug 'LnL7/vim-nix'
Plug 'https://github.com/scrooloose/nerdtree.git'
" base fzf plugin from the fzf that nix installs (home.nix), so there's one fzf binary
Plug '~/.nix-profile/share/vim-plugins/fzf'
Plug 'https://github.com/junegunn/fzf.vim.git'
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'https://github.com/tpope/vim-eunuch.git'
Plug 'https://github.com/tpope/vim-commentary.git'
Plug 'https://github.com/airblade/vim-gitgutter.git'
Plug 'Eliot00/git-lens.vim'
Plug 'wellle/context.vim'
Plug 'github/copilot.vim'
" Plug 'https://github.com/DanBradbury/copilot-chat.vim.git'
Plug 'dense-analysis/ale'
Plug 'prabirshrestha/vim-lsp'
Plug 'vimwiki/vimwiki'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'nanotee/zoxide.vim'
call plug#end()


" Section: solarized or gruvbox colorscheme
set background=dark " 'dark' or 'light'
let g:gruvbox_contrast_light = 'hard' " 'soft' 'medium' 'hard'
let g:gruvbox_termcolors = 256 " 16, 256, or 24bit
colorscheme gruvbox
highlight Comment ctermfg=DarkCyan
" solarized
" set background=light
" colorscheme solarized

" Section: fzf_vim
" :Files lists what $FZF_DEFAULT_COMMAND prints. fd skips .gitignored files and doesn't go into
" symlinked dirs (like nix's result links), unlike fzf's own walker. A real result/ dir is still listed.
" Set here as well, so vim doesn't depend on the shell having exported it.
if executable('fd')
  let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --exclude .git'
endif
" because no more ctrl-p plugin
nnoremap <C-p> :Files<CR>
nnoremap <leader>P :Files<CR>
nnoremap <leader>B :Buffers<CR>
" use Ag silversearch to fuzzy search within folder files
nnoremap <leader>g :Ag<CR>
nnoremap <leader>r :Rg<CR>
nnoremap <leader>f :RG<CR>
" When inside tmux, use a tmux popup sized to the whole client
if exists('$TMUX')
let g:fzf_layout = { 'tmux': '-p90%,90%' }
else
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.85 } }
endif
" " make it bigger
" let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8} }
" " for narrow screen
" let g:fzf_preview_window = 'down:60%:wrap'

" Section: ALE configuration

" ALE implemented linters + fixers, not LSP

" ruff: linter + formatter
" pyright: static type checker

" markdownlint: linter (has the default 80 chars/line)
" markdown tables are aligned by vimwiki (g:vimwiki_table_auto_fmt), not a fixer


" Make codespell available linter in ALE (it isn't built in for these filetypes)
for s:ft in ['python', 'text', 'markdown']
  call ale#linter#Define(s:ft, {
  \   'name': 'codespell',
  \   'executable': 'codespell',
  \   'command': 'codespell %t',
  \   'callback': 'ale#handlers#unix#HandleAsWarning',
  \})
endfor

" markdownlint-cli2 as a fixer. ALE's built-in 'markdownlint' fixer runs
" `markdownlint --fix` with no file (needs markdownlint-cli, not installed), so
" run cli2 on ALE's temp copy of the buffer and read the fixed file back.
function! s:MarkdownlintCli2Fix(buffer) abort
  return {
  \ 'command': 'markdownlint-cli2 --fix --config ~/.markdownlint.json %t',
  \ 'read_temporary_file': 1,
  \}
endfunction
call ale#fix#registry#Add('markdownlint_cli2', expand('<SID>') . 'MarkdownlintCli2Fix',
  \ ['markdown'], 'markdownlint-cli2 --fix (blank lines around headings, lists, ...)')


let g:ale_linters={
"\ 'python': ['pyright', 'ruff', 'flake8', 'cspell', 'codespell'],
"\ pyright and ruff run through vim-lsp instead (see Section: vim-lsp)
"\ 'python': ['flake8', 'codespell'],
"\ flake8 not needed: ruff covers its checks
\ 'python': ['codespell'],
\ 'sh': ['shellcheck'],
\ 'markdown': ['markdownlint', 'codespell'],
\ 'text': ['codespell'],
\ 'nix': ['statix', 'deadnix'],
\}
" NB if name resolution fails for the fixers, then vim will fall back to the
" previously used environment. Also fixers run on save.
let g:ale_fixers={
\ '*': ['remove_trailing_lines', 'trim_whitespace',],
\ 'python': ['ruff', 'ruff_format'],
\ 'sh': ['shfmt'],
\ 'markdown': ['markdownlint_cli2'],
\ 'nix': ['nixfmt'],
\}
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1 " will change things automatically
let g:ale_completion_enabled = 0  " Disable ALE completion to avoid conflicts
let g:ale_hover_cursor = 0 " use hover from vim-lsp
let g:ale_markdown_markdownlint_executable = 'markdownlint-cli2'
let g:ale_markdown_markdownlint_options = '--config ~/.markdownlint.json'
let g:ale_python_auto_pipenv = 1
let g:ale_python_auto_uv = 1
" let g:ale_python_pyright_auto_uv = 1
" let g:ale_python_pyright_auto_pipenv = 1
" let g:ale_python_pyright_executable = 'pyright-langserver'
" let g:ale_python_flake8_auto_pipenv = 1
" " NB this allows for 92 char length
" let g:ale_python_flake8_options = '--extend-ignore=E203,F722 --max-line-length=92'
let g:ale_python_ruff_auto_pipenv = 1
" let g:ale_python_ruff_options = '--select F401'
let g:ale_python_ruff_format_auto_pipenv = 1
let g:ale_virtualtext_cursor = 0 " 'current'
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'
let g:ale_sign_info = 'ℹ'


" On the ALE and vim-lsp note, the language server works with the
" pyrightconfig.json file in the root of the project.

" Section: vim-lsp
"
" the language server is pyright-langserver
"
" the followign  enable GD and GR for pyright
" NB have to be in path under which are the project directories
" I changed the venv = .venv to ~/.virtualenv/dev
" default venvpath is '.'
" did not see massive changes.
" NB that install packges w/ --no-deps
" alternative to investigate is a uv environment and `uv config`
if executable('pyright-langserver')
  au User lsp_setup call lsp#register_server({
      \ 'name': 'pyright',
      \ 'cmd': ['pyright-langserver', '--stdio'],
      \ 'root_uri_patterns': ['pyrightconfig.json', 'pyproject.toml'],
      \ 'allowlist': ['python'],
      \ 'initialization_options': {
      \     'python': {
      \         'analysis': {
      \             'typeCheckingMode': 'basic',
      \             'reportUnboundVariable': 'none'
      \         }
      \     }
      \ }
      \ })
endif

" NB that this does not affect character length, the flake8 above does.
if executable('ruff')
  au User lsp_setup call lsp#register_server({
      \ 'name': 'ruff',
      \ 'cmd': {server_info->['ruff', 'server']},
      \ 'allowlist': ['python'],
      \ })
endif

if executable('nil')
autocmd User lsp_setup call lsp#register_server({
  \ 'name': 'nil',
  \ 'cmd': {server_info->['nil']},
  \ 'whitelist': ['nix'],
  \ })
endif

if executable('bash-language-server')
autocmd User lsp_setup call lsp#register_server({
  \ 'name': 'bash-language-server',
  \ 'cmd': {server_info->['bash-language-server', 'start']},
  \ 'whitelist': ['sh'],
  \ })
endif

" if executable('uv')
"   autocmd User lsp_setup call lsp#register_server({
"     \ 'name': 'uv',
"     \ 'cmd': {server_info->['uv', 'language-server']},
"     \ 'whitelist': ['sh'],
"     \ 'allowlist': ['python'],
"     \ })
" endif

" can make <leader>gd instead.
nnoremap <silent>K :LspHover<CR>
nnoremap <silent>gd :LspDefinition<CR>
nnoremap <silent>gr :LspReferences<CR>
" because ,d is reserved anf c as well
" nnoremap <leader>dn :LspNextError<CR>
" nnoremap <leader>dp :LspPreviousError<CR>
" nnoremap <silent>ca :LspCodeAction<CR>

" autocmd CursorHold * silent! LspHover " disable auto hover
let g:lsp_diagnostics_virtual_text_enabled = 1 "
let g:lsp_diagnostics_echo_cursor = 1  " Show diagnostics in the command area when cursor is on an error
let g:lsp_diagnostics_virtual_text_position = 'top'
let g:lsp_diagnostics_float_cursor = 0 " Disable floating windows for diagnostics
let g:lsp_preview_float = 1

" Section: vimwiki
let g:vimwiki_list = [{'syntax': 'markdown', 'ext': '.md', 'auto_toc': 1, 'auto_tags': 0,
  \ 'nested_syntaxes': {'python': 'python', 'sh': 'sh', 'bash': 'sh'}}]
let g:vimwiki_filetypes = ['markdown']
let g:vimwiki_hl_headers = 1 " diff header colours
let g:vimwiki_listing_hl = 1
let g:vimwiki_hl_cb_checked = 1
let g:vimwiki_conceallevel = 2 " default, to conceal urls
let g:vimwiki_table_auto_fmt = 1 " default, to format tables
let g:vimwiki_folding = '' " options: 'syntax' 'expr' 'syntax' 'indent'
let g:vimwiki_rx_todo = '\C\<\%(XXX\)\>'
" Don't auto-continue table rows / list bullets when pressing <CR>
let g:vimwiki_key_mappings =
  \ {
  \   'lists_return': 0,
  \ }
" vimwiki headers colors:
hi VimwikiHeader1 cterm=bold ctermfg=yellow
hi VimwikiHeader2 cterm=bold ctermfg=brown
hi VimwikiHeader3 cterm=bold ctermfg=blue
hi VimwikiHeader4 cterm=bold ctermfg=lightgreen
hi VimwikiHeader5 cterm=bold ctermfg=brown
hi VimwikiHeader6 cterm=bold ctermfg=green

" Section: NERDTree
nnoremap <leader>t :NERDTreeToggle<CR>
" nnoremap <leader>g :NERDTreeFocus<CR>
" nmap <Leader>r :NERDTreeFocus<cr>R<c-w><c-p> " to refresh NERDTree
let NERDChristmasTree = 1
let NERDTreeHighlightCursorline = 1
" let NERDTreeShowHidden = 1
let NERDTreeIgnore=['\.git','\.DS_Store','\.pdf', '.beam']



" " Section: Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'
let g:airline#extensions#virtualenv#enabled = 1
let g:airline#extensions#virtualenv#ft = ['python', 'markdown', 'vim']
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]' " skip utf-8[unix] in encoding
let g:airline_powerline_fonts = 1
let g:airline_section_c = '%F'
let g:airline_section_z = '%p%% line: %l/%L col: %c'
let g:airline_section_error = ''
let g:airline_section_warning = ''
let g:airline#extensions#branch#enabled = 1 " show git branch
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline_left_sep=' '
let g:airline_right_sep=' '
let g:airline_detect_spell=1
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>0 <Plug>AirlineSelectTab0


" Section: git-lens
let g:GIT_LENS_ENABLED = 1

" Section: gitline
" not tested yet. adds git info in vim airline iiuc

" Section: Airline Theme
let g:airline_theme = 'light'
" few alternatives: 'jellybeans' 'laederon' 'durant' 'papercolor' 'base16_gruvbox_dark_hard'


" Section: vim-virtualenv
" NB not working
" let g:virtualenv_path = expand('~/.virtualenvs')
" let g:virtualenv_directory = expand('~/$WORKON_HOME')
" let g:virtualenv#prompt = '(%s)'


" Section: Markdown Preview
let g:mkdp_auto_close = 0
let g:mkdp_auto_start = 0
let g:mkdp_command_for_global = 1
let g:mkdp_open_to_the_world = 0
let g:mkdp_echo_preview_url = 1
let g:mkdp_open_ip = '127.0.0.1'
let g:mkdp_theme = 'dark'


" Section: copilot
let g:copilot_filetypes = {
  \ 'gitcommit': v:true,
  \ 'markdown': v:true,
  \ 'yaml': v:true,
  \ 'perl': v:true
  \ }

" Replace tab w/ C-j  CR is regular carriage return fallback is used
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true
" accept 1 word of current suggestion
imap <C-L> <Plug>(copilot-accept-word)
imap <C-K> <Plug>(copilot-next)

" Section: copilot chat
" use <leader> cc to open chat
" NB that ctrl+w does not work

" Section: Buffer switching w/ <leader>
map <leader>n :bnext<cr>
map <leader>m :bprevious<cr>
map <leader>d :bdelete<cr>
map <leader>l :buffers<cr>

" Section: vim-fugitive
" Gw
" Git
" Gdiffsplit
" Gblame
" Gcommit
let g:fugitive_diff_command = 'Gdiffsplit!'

" Section: vim-commentary
" comment w/ gcc in normal mode
" comment w/ gc in visual mode
" comment 3 extra lines bealow gc3j


" Section: vim-eunuch



" Section: Gitgutter
" git changes colour the line numbers, so the sign column is left to ALE and vim-lsp
let g:gitgutter_signs = 0
let g:gitgutter_highlight_linenrs = 1
highlight GitGutterAddLineNr          ctermfg=2 cterm=bold
highlight GitGutterChangeLineNr       ctermfg=3 cterm=bold
highlight GitGutterDeleteLineNr       ctermfg=1 cterm=bold
highlight GitGutterChangeDeleteLineNr ctermfg=3 cterm=bold
set updatetime=100
" TODO what are hunks p
" TODO gitgutter grep
" the hunk summary (+ ~ -) is shown by airline


" Section: set spell
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>
set spelllang=en_gb
" words added with zg are kept in the dotfiles repo (~/.vimrc is a symlink to it)
" if adding by hand run :mkspell! % with the .add file open
let &spellfile = fnamemodify(resolve(expand('<sfile>:p')), ':h') . '/spell/en.utf-8.add'
hi clear SpellBad
hi SpellBad cterm=underline,bold ctermfg=DarkGray ctermbg=lightmagenta

" Section: custom commands
"
" Define a command :Today that inserts the current date
command! Today execute "normal! i" . strftime("%Y%b%d")

" Write starters of task experiment
command! Task call InsertTaskTemplate()

function! InsertTaskTemplate()
  " Move to insert mode and insert the formatted text
  execute "normal! oDATE " . strftime("%Y%b%d")
  execute "normal! oNAME    MACHINE    BRANCH"
  execute "normal! oTASK"
  execute "normal! oRESULT"
endfunction

" useful commands
" :verbose map <leader>n
" :verbose nmap <C-l>
" :verbose map gd
" :map to see all mappings
" :verbose command RG
" :help RG
" :echo mapleader
" :scriptnames to see all loaded scripts
"
