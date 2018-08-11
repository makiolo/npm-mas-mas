#!/bin/bash

# if [ $# -e 0 ]; then
#     echo $0: [ERROR], usage: ./cmaki_emulator.sh <program>
#     exit 1
# fi

export DIRPROGRAM="$( cd "$( dirname "$1" )" >/dev/null && pwd )"
export BASENAMEPROGRAM=$(basename "$1")
export CMAKI_PWD="${CMAKI_PWD:-$(pwd)}"
export CMAKI_EMULATOR="${CMAKI_EMULATOR:-}"

export LD_LIBRARY_PATH=$(pwd):$LD_LIBRARY_PATH
cd ${DIRPROGRAM}

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

