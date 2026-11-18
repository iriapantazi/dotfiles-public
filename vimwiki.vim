" only wiki comments; `highlight Comment` would change comments in every buffer
highlight VimwikiComment ctermfg=DarkCyan ctermbg=black

syntax match VimwikiKeywordTODO /\<TODO\>/
highlight VimwikiKeywordTODO cterm=bold ctermfg=Red

syntax match VimwikiKeywordEXPER /\<EXPER\>/
highlight VimwikiKeywordEXPER cterm=bold ctermfg=Magenta ctermbg=black

syntax match VimwikiKeywordEXP /\<EXP\>/
highlight VimwikiKeywordEXP cterm=bold ctermfg=Red ctermbg=black

syntax match VimwikiKeywordEXCL /!!!!/
highlight VimwikiKeywordEXCL cterm=bold ctermfg=Magenta ctermbg=black

syntax match VimwikiKeywordDO /\<DO\>/
highlight VimwikiKeywordDO cterm=bold ctermfg=Green ctermbg=black

syntax match VimwikiKeywordREASON /\<REASON\>/
highlight VimwikiKeywordREASON cterm=bold ctermfg=Green ctermbg=black

syntax match VimwikiKeywordPROJ /\<PROJ\>/
highlight VimwikiKeywordPROJ cterm=underline,bold ctermfg=Red ctermbg=black

syntax match VimwikiKeywordOBJ /\<OBJECTIVE\>/
highlight VimwikiKeywordOBJ cterm=underline,bold ctermfg=DarkRed ctermbg=white

syntax match VimwikiKeywordSUMMARY /\<SUMMARY\>/
highlight VimwikiKeywordSUMMARY cterm=underline,bold ctermfg=DarkBlue ctermbg=white

syntax match VimwikiKeywordGOAL /\<GOAL\>/
highlight VimwikiKeywordGOAL cterm=underline,bold ctermfg=White ctermbg=Black

syntax match VimwikiKeywordCASE /\<CASE\>/
highlight VimwikiKeywordCASE cterm=underline,bold ctermfg=LightMagenta ctermbg=black

syntax match VimwikiKeywordPROBLEM /\<PROBLEM\>/
highlight VimwikiKeywordPROBLEM cterm=underline,bold ctermfg=LightMagenta ctermbg=black

syntax match VimwikiKeywordMAYBE /\<MAYBE\>/
highlight VimwikiKeywordMAYBE cterm=underline ctermfg=Magenta ctermbg=black

syntax match VimwikiKeywordDONE /\<DONE\>/
highlight VimwikiKeywordDONE cterm=bold ctermfg=DarkGreen

syntax match VimwikiKeywordNEED /\<NEED\>/
highlight VimwikiKeywordNEED cterm=bold ctermbg=Black

syntax match VimwikiKeywordBUG /\<BUG\>/
highlight VimwikiKeywordBUG cterm=underline,bold ctermfg=Yellow

syntax match VimwikiKeywordINPROGRESS /\<INPROGRESS\>/
highlight VimwikiKeywordINPROGRESS cterm=bold ctermfg=Blue

syntax match VimwikiKeywordQ /\<Q:/
highlight VimwikiKeywordQ cterm=bold ctermfg=DarkCyan

syntax match VimwikiKeywordA /\<A:/
highlight VimwikiKeywordA cterm=bold ctermfg=DarkCyan

syntax match VimwikiKeywordYES /\<YES\>/
highlight VimwikiKeywordYES cterm=underline,bold ctermfg=DarkGreen ctermbg=black

syntax match VimwikiKeywordETA /\<ETA\>/
highlight VimwikiKeywordETA cterm=underline,bold ctermfg=DarkYellow ctermbg=LightMagenta

syntax match VimwikiKeywordFAIL /\<FAIL\>/
highlight VimwikiKeywordFAIL cterm=underline,bold ctermfg=Magenta

syntax match VimwikiKeywordNO /\<NO\>/
highlight VimwikiKeywordNO cterm=underline,bold ctermfg=Red

syntax match VimwikiKeywordERROR /\<ERROR\>/
highlight VimwikiKeywordERROR cterm=bold ctermbg=Yellow ctermfg=DarkRed

syntax match VimwikiKeywordNB /\<NB\>/
highlight VimwikiKeywordNB cterm=bold,underline ctermfg=DarkYellow

syntax match VimwikiKeywordOK /\<OK\>/
highlight VimwikiKeywordOK cterm=bold ctermfg=DarkGreen ctermbg=black

syntax match VimwikiKeywordRESULT /\<RESULT\>/
highlight VimwikiKeywordRESULT cterm=bold ctermfg=DarkCyan ctermbg=black

syntax match VimwikiKeywordNEXT /\<NEXT STEP\>/
highlight VimwikiKeywordNEXT cterm=bold ctermfg=DarkMagenta ctermbg=black

syntax match VimwikiKeywordINOTE /\<NOTE\>/
highlight VimwikiKeywordINOTE cterm=bold ctermfg=Blue ctermbg=black

" highlight the pattern nnnnwwwnn where n is a number and w is a word
syntax match VimwikiDate /\<\d\{4}[a-zA-Z]\{3}\d\{2}\>/
highlight VimwikiDate cterm=underline ctermfg=DarkCyan
" syntax match VimwikiDate /\d{4}\w{3}\d{4}/ "containedin=ALL
" highlight VimwikiDate cterm=bold,underline ctermfg=DarkCyan

" single and triple code background colours
highlight VimwikiCode ctermbg=black ctermfg=magenta
highlight VimwikiCodeBlockBackground cterm=bold ctermbg=25 guibg=#2E2E2E


" Custom highlight for table headers in markdown
highlight MarkdownTableHeader guifg=#FFA500 guibg=#2E2E2E ctermfg=214 ctermbg=235

" Match the header row of tables: a row followed by a |---|---| separator line
syntax match MarkdownTableHeader /^\s*|.*|\ze\s*\n\s*|[ :|-]*-[ :|-]*|\s*$/ containedin=VimwikiTableRow

" syntax match GanttBar /\v\[\#{1,}[-#]*\]/ containedin=ALL
" highlight GanttBar cterm=bold ctermfg=DarkCyan


" Define a bunch of keywords and their highlight colors
let s:keywords = {
      \ 'PLANNING': 'DarkCyan',
      \ 'DATE': 'Blue',
      \ 'NAME': 'Yellow',
      \ 'TASK': 'Magenta',
      \ 'MACHINE': 'Yellow',
      \ 'BRANCH': 'Yellow',
      \ 'COMMENTS': 'Yellow',
      \ 'LOCATION': 'Yellow'
      \ }

for [kw, color] in items(s:keywords)
  execute 'syntax match VimwikiKeyword' . kw . ' /\<' . kw . '\>/'
  execute 'highlight VimwikiKeyword' . kw . ' ctermfg=' . color . ' cterm=bold'
endfor
