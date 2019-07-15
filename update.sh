#!/bin/bash

cd ~/.emacs.d

git reset --hard HEAD
git pull

WAKATIME_CLI=`sudo find / -name cli.py | grep wakatime`

sed -i "s@WAKATIME_CLI@$WAKATIME_CLI@" ~/.emacs.d/init.el
sed -i "s@USER_HOME@$HOME@g" ~/.emacs.d/init.el

