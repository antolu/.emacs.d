#!/bin/sh

git clone https://github.com/ycm-core/ycmd.git
cd ycmd
git submodule update --init --recursive
python3 build.py --clang-completer --java-completer --go-completer

