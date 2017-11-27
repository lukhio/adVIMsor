" A simple plugin improve your writing quality and productivity
" Copyright 2017 Julien Gamba <julien@jgamba.eu>

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
" improve writing quality and productivity.
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

" Count the sentences in the text
function s:CountSentences()
    let result = 0
    let l:save = winsaveview()
    normal gg0
    while search('[\.!?]', 'W')
        let result += 1
    endwhile
    call winrestview(l:save)
    return result
endfunc

" Count the number of words
" This function excludes words that starts with a blackslash to avoid counting
" LaTeX commands, as well as macro arguments and keywords. It will still count
" some, such as TikZ commands.
function s:CountWords()
    " Hacky fix: for some reason I am always missing a word in the total count,
    " and I am too lazy to debug the regex at the moment.
    let result = 1
    let l:save = winsaveview()
    normal gg0
    while search('\(^\|[^\\#\k]\)\zs\<\w\+\>', 'W')
        let result += 1
    endwhile
    call winrestview(l:save)
    return result
endfunc

" Count the syllables of a word
" TODO: fix this, there are too many cases where this function gives a
" incorrect result, such as double vowels ('cool') and words that end in 'es',
" 'ed' or 'e'.
function! s:CountSyllables(word)
    let i = 0
    let result = 0

    while i < strlen(a:word)
        if strpart(a:word, i, 1) =~? '[aeiouy]'
            let result += 1
        endif
        let i += 1
    endwhile

    return result
endfunc

" Count syllables in the current file
" TODO: make an efficient version of this.
function! s:CountAllSyllables()
    let result = 0
    let file = readfile(expand("%:p")) " read current file
    for line in file
        for word in split(line)
            if word !~? '\\\w' && word !~? '#'
                let result += s:CountSyllables(word)
            endif
        endfor
    endfor
    return result
endfunc

" Compute Flesch reading ease score
function! s:FleschReadingEase()
    " We multiply by 1.0 to cast the results as floats
    let nbSentences = s:CountSentences() * 1.0
    let nbWords = s:CountWords() * 1.0
    let nbSyllables = s:CountAllSyllables() * 1.0
    let score = 206.835 - 1.015 * (nbWords / nbSentences) - 84.6 * (nbSyllables / nbWords)

    if score >= 90.0
        echom 'Score: ' . string(score) . '. Very easy to read.'
    elseif score >= 80.0
        echom 'Score: ' . string(score) . '. Easy to read.'
    elseif score >= 70.0
        echom 'Score: ' . string(score) . '. Fairly easy to read.'
    elseif score >= 60.0
        echom 'Score: ' . string(score) . '. Plain English. Easily understood.'
    elseif score >= 50.0
        echom 'Score: ' . string(score) . '. Fairly difficult to read.'
    elseif score >= 30.0
        echom 'Score: ' . string(score) . '. Difficult to read.'
    else
        echom 'Score: ' . string(score) . '. Very difficult to read.'
    endif
endfunc

" Compute Flesch-Kincaid grade level
function! s:FleschKincaidGradeLevel()
    " We multiply by 1.0 to cast the results as floats
    let nbSentences = s:CountSentences() * 1.0
    let nbWords = s:CountWords() * 1.0
    let nbSyllables = s:CountAllSyllables() * 1.0
    let score = 0.39 * (nbWords / nbSentences) + 11.8 * (nbSyllables / nbWords) - 15.59

    echom 'Flesch-Kincaid grade level: ' . string(score)
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
command! AdVIMsorFleschScore call s:FleschReadingEase()
command! AdVIMsorFleschKincaidScore call s:FleschKincaidGradeLevel()
