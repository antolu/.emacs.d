#!/bin/sh

git clone https://github.com/antolu/.emacs.d.git ~/.emacs.d

git clone https://github.com/ycm-core/ycmd.git ~/.emacs.d/ycmd
cd ~/.emacs.d/ycmd
git submodule update --init --recursive

sudo pacman -Sy --needed --noconfirm go jdk-openjdk
python3 build.py --clang-completer --java-completer --go-completer

pip install jedi flake8 autopep8 black yapf wakatime

WAKATIME_CLI=`sudo find / -name cli.py | grep wakatime`

sed -i "s@WAKATIME_CLI@$WAKATIME_CLI@" ~/.emacs.d/init.el
sed -i "s@USER_HOME@$HOME@g" ~/.emacs.d/init.el

