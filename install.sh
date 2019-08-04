#!/bin/sh

function installPackages() {
    source /etc/os-release
    
    case $ID in
        arch)
	    PKGINSTALL=sudo pacman -Sy --noconfirm --needed 
	    ;;
	ubuntu|debian)
	    PKGINSTALL=sudo apt install -y
	    ;;
    esac

    if [ $PYTHON ] || [ $C ] || [ $JAVA ] || [ $GO ]; then
	if [ -z `which python3` ]; then
	    PKGINSTALL+=" python3 python3-pip"
	fi
	PKGINSTALL+=" cmake"
    fi

    if [ $JAVA ]; then
	case $ID in
	    arch)
		PKGINSTALL+=" jdk-openjdk"
		;;
	    ubuntu|debian)
		PKGINSTALL+=" default-jdk"
		;;
	esac
    fi

    if [ $C ]; then
	PKGINSTALL+=" gcc"
    fi

    if [ $GO ]; then
	case $ID in
	    arch)
		PKGINSTALL+=" go"
		;;
	    *)
		curl -L -o go.tar.gz https://dl.google.com/go/go1.12.7.linux-amd64.tar.gz
		sudo tar -xf go.tar.gz /usr/local/
		sudo echo "PATH=$PATH:/usr/local/go/bin" >> /etc/environment
		;;
	esac
    fi

    eval $PKGINSTALL

}


function parseArguments() {
if [ -z $@ ]; then
    PYTHON=True
    C=True
    GO=True
    JAVA=True
    return
fi    
for key in $@; do
    case $key in
        python)
            PYTHON=True
            ;;
        c|c++)
            C=True
	    ;;
        go)
            GO=True
	    ;;
        java)
            JAVA=True
	    ;;
        *)
	    echo "Option ${key} unknown or not supported."
	    ;;
    esac
done
}

echo $@

parseArguments $@  

git clone https://github.com/antolu/.emacs.d.git ~/.emacs.d

cd ~/.emacs.d
git checkout modular-install

git submodule update --init --recursive

installPackages

if [ $PYTHON ]; then 
    sudo pip install jedi flake8 autopep8 black yapf wakatime
    sed -i '/(custom-set-variables/i(load-user-file "modules/python.el")' init.el
fi

if [ $C ]; then
    YCMDOPTIONS+=" --clang-completer"
    sed -i '/(custom-set-variables/i(load-user-file "modules/C.el")' init.el
fi
if [ $JAVA ]; then YCMDOPTIONS+="  --java-completer"; fi
if [ $GO ]; then YCMDOPTIONS+=" --go-completer"; fi

if [ $C ] || [ $JAVA ] || [ $GO ]; then
    cd ycmd
    python3 build.py $YCMDOPTIONS
    cd ..
    sed -i '/(custom-set-variables/i(load-user-file "modules/ycmd.el")' init.el
fi

WAKATIME_CLI=`sudo find / -name cli.py | grep wakatime`

sed -i "s@WAKATIME_CLI@$WAKATIME_CLI@" ~/.emacs.d/init.el
sed -i "s@USER_HOME@$HOME@g" ~/.emacs.d/init.el

