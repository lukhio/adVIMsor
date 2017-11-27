# adVIMsor
A plugin to help you write better. Inspired by Matt Might's scripts to improve
writing quality.

### Requirements
None. This plugin is written in vimscript, nothing more but Vim is needed.

### Installation
You can install it as any other plugin. For Vundle, add this line:

    Plugin 'lukhio/adVIMsor'

to your vimrc file. For pathogen:

    $ cd $HOME/.vim/bundle
    $ git clone git@github.com:lukhio/adVIMsor.git

For other plugin managers please refer to their documentation.

### Usage
This plugin provides three functionalities:

  - Matt Might scripts, to detect weasel words, the use of passive voice and
    word duplicates: just type `:AdVIMsorEnable`. The matched words will be
    highlighted. To disable this functionnality type `:AdVIMsorDisable`.
  - Flesch reading ease test: type `:AdVIMsorFleschScore` to get the score of
    the current buffer.
  - Flesch-Kincaid grade level test: type `:AdVIMsorFleschKincaidScore` to get
    the corresponding grade level of the current buffer.

### Contributing
You can send me patches at julien AT jgamba DOT eu. You can also try to submit
a pull request on Github, but I do not check it often. You can also email me if
you are having issues, or want to give feedback.

### License
See the `LICENSE` file.

### Credits
The original scripts were written by Matt Might, and can be found
[here](http://matt.might.net/articles/shell-scripts-for-passive-voice-weasel-words-duplicates/).
