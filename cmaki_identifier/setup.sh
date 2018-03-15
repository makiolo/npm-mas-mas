#!/bin/bash

if [ -d "boostorg_predef" ]; then
	rm -Rf boostorg_predef
fi
git clone -q https://github.com/boostorg/predef.git boostorg_predef

curl -s https://raw.githubusercontent.com/makiolo/cmaki_scripts/master/setup.sh | bash

