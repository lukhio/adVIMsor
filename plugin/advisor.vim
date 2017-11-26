" A simple plugin to look for key mapping conflicts in Vim
" Copyright 2016-2017 Julien Gamba <julien@jgamba.eu>

" Permission is hereby granted, free of charge, to any person obtaining a copy of
" this software and associated documentation files (the 'Software'), to deal in
" the Software without restriction, including without limitation the rights to
" use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
" of the Software, and to permit persons to whom the Software is furnished to do
" so, subject to the following conditions:

" The above copyright notice and this permission notice shall be included in all
" copies or substantial portions of the Software.

" THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
" SOFTWARE.

"==============================================================================
" Plugin: adVIMsor
" Maintainer: Julien Gamba <julien@jgamba.eu>
" URL: https://git.jgamba.eu/cgit.cgi/advimsor/
" Version: 0.1
"
" A plugin to help you write better. Inspired by Matt Might's scripts to
" improve writing productivity.
"
" http://matt.might.net/articles/shell-scripts-for-passive-voice-weasel-words-duplicates/
"==============================================================================

if exists('g:loaded_advimsor')
  finish
endif
let g:loaded_advimsor= 1

""" Utilities
" Load a list of words from a file
" returns: list
function! s:LoadListFromFile(filename)
    let outlist = join(readfile(a:filename), '|')

    return outlist
endfunc

" Count the syllables of a word
function! s:CountSyllables(word)
endfunc

""" Data
" Get absolute path to the script
let s:path = expand('<sfile>:p:h') . '/'

" Load all words to match
let s:weasels = s:LoadListFromFile(s:path . 'lib/weasel_words.txt')
let s:passive_verbs = s:LoadListFromFile(s:path . 'lib/passive_verbs.txt')
let s:passive_auxiliaries = s:LoadListFromFile(s:path . 'lib/passive_auxiliaries.txt')

""" Detection functions
" Detect weasel words
function! s:WeaselWords()
    let to_match = '\c\v' . s:weasels
    let s:m_weasels = matchadd('QuickFixLine', to_match)
endfunc

" Detect passive voice
function! s:PassiveVoice()
    let to_match = '\c\v(' . s:passive_auxiliaries . ')\v([ \t\n]+)\c\v(\w+ed|' . s:passive_verbs . ')'
    let s:m_passive_voices = matchadd('QuickFixLine', to_match)
endfunc

" Detect word duplicates
function! s:DetectDuplicates()
    let s:m_duplicates=matchadd('QuickFixLine', '\v(<\w+>)\_s*<\1>')
endfunction

" Enable AdVIMsor
function! s:Enable()
    call s:WeaselWords()
    call s:PassiveVoice()
    call s:DetectDuplicates()
endfunc

" Disable AdVIMsor
function! s:Disable()
    call matchdelete(s:m_weasels)
    call matchdelete(s:m_passive_voices)
    call matchdelete(s:m_duplicates)
endfunc

""" Commands
" User interface
command! AdVIMsorEnable call s:Enable()
command! AdVIMsorDisable call s:Disable()
