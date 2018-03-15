#!/bin/bash -e

export CC="${CC:-gcc}"
export CXX="${CXX:-g++}"
export MODE="${MODE:-Debug}"
export CMAKI_INSTALL="${CMAKI_INSTALL:-$CMAKI_PWD/bin}"
export YMLFILE=$CMAKI_PWD/cmaki.yml

# warning, TODO: detectar si hay cambios locales y avisar
git diff $CMAKI_PWD

cd $CMAKI_PWD/node_modules/cmaki_generator
curl -s https://raw.githubusercontent.com/makiolo/cmaki_scripts/master/make_artifact.sh | bash
