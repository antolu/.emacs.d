#!/bin/sh

git clone https://github.com/ycm-core/ycmd.git ~/.ycmd
cd ~/.ycmd
git submodule update --init --recursive

sudo pacman -Sy --needed go jdk-openjdk
python3 build.py --clang-completer --java-completer --go-completer

pip install jedi flake8 autopep8 black yapf

cd

git clone https://github.com/antolu/.emacs.d.git ~/.emacs.d
