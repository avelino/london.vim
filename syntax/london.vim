" Vim syntax file
" Language:	London template
" Maintainer:	Thiago Avelino
" Last Change:	2012 May 30
" Version:      0.2

" .vimrc variable to disable html highlighting
if !exists('g:london_syntax_html')
   let g:london_syntax_html=1
endif

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
  finish
endif
  let main_syntax = 'london'
endif

" Pull in the HTML syntax.
if g:london_syntax_html
  if version < 600
    so <sfile>:p:h/html.vim
  else
    runtime! syntax/html.vim
    unlet b:current_syntax
  endif
endif

syntax case match

" London template built-in tags and parameters (without filter, macro, is and raw, they
" have special threatment)
syn keyword londonStatement containedin=londonVarBlock,londonTagBlock,londonNested contained and if else in not or recursive as import piece base style_tags body_scripts

syn keyword londonStatement containedin=londonVarBlock,londonTagBlock,londonNested contained is filter skipwhite nextgroup=londonFilter
syn keyword londonStatement containedin=londonTagBlock contained macro skipwhite nextgroup=londonFunction
syn keyword londonStatement containedin=londonTagBlock contained block skipwhite nextgroup=londonBlockName

" Variable Names
syn match londonVariable containedin=londonVarBlock,londonTagBlock,londonNested contained skipwhite /[a-zA-Z_][a-zA-Z0-9_]*/
syn keyword londonSpecial containedin=londonVarBlock,londonTagBlock,londonNested contained false true none False True None loop super caller varargs kwargs

" Filters
syn match londonOperator "|" containedin=londonVarBlock,londonTagBlock,londonNested contained nextgroup=londonFilter
syn match londonFilter contained skipwhite /[a-zA-Z_][a-zA-Z0-9_]*/
syn match londonFunction contained skipwhite /[a-zA-Z_][a-zA-Z0-9_]*/
syn match londonBlockName contained skipwhite /[a-zA-Z_][a-zA-Z0-9_]*/

" London template constants
syn region londonString containedin=londonVarBlock,londonTagBlock,londonNested contained start=/"/ skip=/\\"/ end=/"/
syn region londonString containedin=londonVarBlock,londonTagBlock,londonNested contained start=/'/ skip=/\\'/ end=/'/
syn match londonNumber containedin=londonVarBlock,londonTagBlock,londonNested contained /[0-9]\+\(\.[0-9]\+\)\?/

" Operators
syn match londonOperator containedin=londonVarBlock,londonTagBlock,londonNested contained /[+\-*\/<>=!,:]/
syn match londonPunctuation containedin=londonVarBlock,londonTagBlock,londonNested contained /[()\[\]]/
syn match londonOperator containedin=londonVarBlock,londonTagBlock,londonNested contained /\./ nextgroup=londonAttribute
syn match londonAttribute contained /[a-zA-Z_][a-zA-Z0-9_]*/

" London template tag and variable blocks
syn region londonNested matchgroup=londonOperator start="(" end=")" transparent display containedin=londonVarBlock,londonTagBlock,londonNested contained
syn region londonNested matchgroup=londonOperator start="\[" end="\]" transparent display containedin=londonVarBlock,londonTagBlock,londonNested contained
syn region londonNested matchgroup=londonOperator start="{" end="}" transparent display containedin=londonVarBlock,londonTagBlock,londonNested contained
syn region londonTagBlock matchgroup=londonTagDelim start=/{%-\?/ end=/-\?%}/ skipwhite containedin=ALLBUT,londonTagBlock,londonVarBlock,londonRaw,londonString,londonNested,londonComment

syn region londonVarBlock matchgroup=londonVarDelim start=/{{-\?/ end=/-\?}}/ containedin=ALLBUT,londonTagBlock,londonVarBlock,londonRaw,londonString,londonNested,londonComment

" London template 'raw' tag
syn region londonRaw matchgroup=londonRawDelim start="{%\s*raw\s*%}" end="{%\s*endraw\s*%}" containedin=ALLBUT,londonTagBlock,londonVarBlock,londonString,londonComment

" London comments
syn region londonComment matchgroup=londonCommentDelim start="{#" end="#}" containedin=ALLBUT,londonTagBlock,londonVarBlock,londonString

" Block start keywords.  A bit tricker.  We only highlight at the start of a
" tag block and only if the name is not followed by a comma or equals sign
" which usually means that we have to deal with an assignment.
syn match londonStatement containedin=londonTagBlock contained skipwhite /\({%-\?\s*\)\@<=\<[a-zA-Z_][a-zA-Z0-9_]*\>\(\s*[,=]\)\@!/

" and context modifiers
syn match londonStatement containedin=londonTagBlock contained /\<with\(out\)\?\s\+context\>/ skipwhite


" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_london_syn_inits")
  if version < 508
    let did_london_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink londonPunctuation londonOperator
  HiLink londonAttribute londonVariable
  HiLink londonFunction londonFilter

  HiLink londonTagDelim londonTagBlock
  HiLink londonVarDelim londonVarBlock
  HiLink londonCommentDelim londonComment
  HiLink londonRawDelim london

  HiLink londonSpecial Special
  HiLink londonOperator Normal
  HiLink londonRaw Normal
  HiLink londonTagBlock PreProc
  HiLink londonVarBlock PreProc
  HiLink londonStatement Statement
  HiLink londonFilter Function
  HiLink londonBlockName Function
  HiLink londonVariable Identifier
  HiLink londonString Constant
  HiLink londonNumber Constant
  HiLink londonComment Comment

  delcommand HiLink
endif

let b:current_syntax = "london"

if main_syntax == 'london'
  unlet main_syntax
endif
