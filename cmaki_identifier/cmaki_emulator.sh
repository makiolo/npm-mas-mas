#!/bin/bash

# if [ $# -e 0 ]; then
#     echo $0: [ERROR], usage: ./cmaki_emulator.sh <program>
#     exit 1
# fi

export _DIRNAMEPROGRAM=$(dirname "$1")
export DIRPROGRAM="$( cd "$_DIRNAMEPROGRAM" && pwd )"
export BASENAMEPROGRAM=$(basename "$1")
export CMAKI_PWD="${CMAKI_PWD:-$(pwd)}"
export CMAKI_INSTALL="${CMAKI_INSTALL:-$CMAKI_PWD/bin}"
export CMAKI_EMULATOR="${CMAKI_EMULATOR:-}"

# 
# echo "DIRPROGRAM = $DIRPROGRAM"
# echo "CMAKI_PWD = $CMAKI_PWD"
# echo "CMAKI_INSTALL = $CMAKI_INSTALL"
# echo "CMAKI_EMULATOR = $CMAKI_EMULATOR"
# echo "BASENAMEPROGRAM = $BASENAMEPROGRAM"
# 

# TODO: dont use identification based in docker image
# avoid acoplation with docker here

cd $DIRPROGRAM
if [[ "$DEFAULT_DOCKCROSS_IMAGE" = "makiolo/windows-x86" ]]; then
	wine ./$BASENAMEPROGRAM "${@:2}"
elif [[ "$DEFAULT_DOCKCROSS_IMAGE" = "makiolo/windows-x64" ]]; then
	wine ./$BASENAMEPROGRAM "${@:2}"
elif [[ "$DEFAULT_DOCKCROSS_IMAGE" = "makiolo/android-arm" ]]; then
	unset LD_LIBRARY_PATH
	qemu-arm -L /usr/arm-linux-gnueabi ./$BASENAMEPROGRAM "${@:2}"
elif [[ "$DEFAULT_DOCKCROSS_IMAGE" = "makiolo/linux-armv6" ]]; then
	qemu-arm ./$BASENAMEPROGRAM "${@:2}"
elif [[ "$DEFAULT_DOCKCROSS_IMAGE" = "makiolo/linux-armv7" ]]; then
	qemu-arm ./$BASENAMEPROGRAM "${@:2}"
elif [[ "$DEFAULT_DOCKCROSS_IMAGE" = "makiolo/browser-asmjs" ]]; then
	nodejs ./$BASENAMEPROGRAM "${@:2}"
else
	$CMAKI_EMULATOR ./$BASENAMEPROGRAM "${@:2}"
fi
