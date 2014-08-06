#!/bin/bash

############################  BASIC SETUP TOOLS
msg() {
    printf '%b\n' "$1" >&2
}

success() {
    if [ "$ret" -eq '0' ]; then
    msg "\e[32m[✔]\e[0m ${1}${2}"
    fi
}

error() {
    msg "\e[31m[✘]\e[0m ${1}${2}"
    exit 1
}

############################ SETUP FUNCTIONS
lnif() {
    if [ -e "$1" ]; then
        ln -sf "$1" "$2"
    fi
    ret="$?"
}

do_backup() {
    smsg="$1"
    shift
    today=`date +%Y%m%d_%s`
    while [ $# -gt 0 ]; do
        [ -e "$1" ] && [ ! -L "$1" ] && mv "$1" "$1.$today";
        shift
    done
    ret="$?"
    success "$smsg"
}

create_symlinks() {
    endpath=`pwd`

    lnif "$endpath/dist/ctags_lang"         "$HOME/.ctags"
    lnif "$endpath/.vimrc"                  "$HOME/.vimrc"
    lnif "$endpath/.vimrc.local"            "$HOME/.vimrc.local"
    lnif "$endpath/.vimrc.plugins"          "$HOME/.vimrc.plugins"
    lnif "$endpath/.vimrc.plugins.local"    "$HOME/.vimrc.plugins.local"
    lnif "$endpath/.vimrc.mini"             "$HOME/.vimrc.mini"
    lnif "$endpath/vimfiles"                "$HOME/.vim"

    ret="$?"
    success "$1"
}
############################ MAIN()
do_backup   "Your old vim stuff has a suffix now and looks like .vim.`date +%Y%m%d%S`" \
            "$HOME/.vim" \
            "$HOME/.vimrc" \
            "$HOME/.vimrc.local" \
            "$HOME/.vimrc.plugins" \
            "$HOME/.vimrc.plugins.local" \
            "$HOME/.ctags"

create_symlinks "Setting up vim symlinks"
# cp ./dist/ctags_lang ~/.ctags
# cp .vimrc ~/.vimrc
# cp .vimrc.plugins ~/.vimrc.plugins
# cp .vimrc.local ~/.vimrc.local
# cp .vimrc.plugins.local ~/.vimrc.plugins.local
# rm -rf ~/.vim
# cp -r vimfiles ~/.vim
