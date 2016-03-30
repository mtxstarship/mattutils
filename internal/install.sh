#!/bin/bash

# This script symlinks all relevant scripts from this repository into ~/bin and
# configuration settings into your home directory.

# Make a failure terminate the script
set -e

REPO=`dirname $0`
REPO=`readlink -f "${REPO}/.."`

mkdir -p "${HOME}/bin"

# Link useful scripts.
for i in \
         addcert.sh \
         after \
         bashd.sh \
         bitbucket-ls.sh \
         colour-dump \
         defn.sh \
         diff \
         download \
         compresspdf.sh \
         fifi.sh \
         find-broken.sh \
         fuckit-cc \
         fwdmail.py \
         generate-passwd \
         gg \
         git-stree \
         github-ls.sh \
         in \
         has-changed.sh \
         have-lib.sh \
         ifind \
         intray \
         repty \
         rsync \
         timestamp \
         toggle-screensaver \
         term \
         later \
         mediawatch.py \
         mvbs.py \
         notate.py \
         now \
         package.py \
         pdfcrop.sh \
         ppa-install \
         prefix \
         pyman \
         search \
         sendmail.py \
         ssh-proxy \
         tb \
         ubiquity \
         validate.py \
         wh \
         wim ; do
    if [ ! -e "${REPO}/$i" ]; then
        echo "Error: $i not found in working directory." >&2
        exit 1
    fi
    if [ ! -e "${HOME}/bin/$i" ]; then
        ln -s "${REPO}/$i" "${HOME}/bin/$i"
    elif [ ! -L "${HOME}/bin/$i" ]; then
        echo "Warning: Skipping $i that already exists." >&2
    fi
done
if [ ":${PATH}:" != *":${HOME}/bin:"* ]; then
    echo "Warning: ${HOME}/bin, where symlinks are created, is not in your bash \$PATH." >&2
fi

# Link configurations.
for i in .dircolors \
         .emacs \
         .fonts.conf \
         .gdbinit \
         .gnomerc \
         .hgrc \
         .mplayer \
         .reroute-config.py \
         .screenrc \
         .tmux.conf \
         .vimrc \
         .vim \
         .wgetrc \
         .Xdefaults \
         .xmonad \
         .zsh \
         .zshrc; do
    if [ ! -e "${REPO}/config/$i" ]; then
        echo "Error: $i not found in working directory." >&2
        exit 1
    fi
    if [ ! -e "${HOME}/$i" ]; then
        ln -s "${REPO}/config/$i" "${HOME}/$i"
    elif [ ! -L "${HOME}/$i" ]; then
        echo "Warning: Skipping $i that already exists." >&2
    fi
done

# Link SSH config.
if [ ! -e "${HOME}/.ssh/config_mattutils" ]; then
    ln -s "${REPO}/config/.ssh/config" "${HOME}/.ssh/config_mattutils"
elif [ ! -L "${HOME}/.ssh/config_mattutils" ]; then
    echo "Warning: Skipping SSH config_mattutils that already exists." >&2
fi

# Link Git config.
if [ ! -e "${HOME}/.gitconfig_mattutils" ]; then
    ln -s "${REPO}/config/.gitconfig" "${HOME}/.gitconfig_mattutils"
elif [ ! -L "${HOME}/.gitconfig_mattutils" ]; then
    echo "Warning: Skipping gitconfig_mattutils that already exists." >&2
fi

# Build some utils.
if [ ! -e "${HOME}/bin/balloon" ]; then
    cc -W -Wall -Werror -o balloon "${REPO}/misc/balloon.c" $(pkg-config --libs ncurses)
fi
