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
