#!/bin/bash
set -e

export NPP_CACHE="${NPP_CACHE:-FALSE}"

# dentro de docker, por defecto, se instalan dependencias
if [ -f /.dockerenv ]; then
	export INSTALL_DEPENDS="${INSTALL_DEPENDS:-TRUE}"
else
	export INSTALL_DEPENDS="${INSTALL_DEPENDS:-FALSE}"
fi

if [ "$INSTALL_DEPENDS" = "TRUE" ]; then
	# hacerlo si no esto dentro de un contenedor docker que incluye cmaki_depends
	# sería bueno tener una variable para indicar que el entorno tiene las "cmaki_depends"
	curl -s https://raw.githubusercontent.com/makiolo/cmaki_scripts/master/cmaki_depends.sh | bash
fi

env | sort

if [[ -d "bin" ]]; then
	rm -Rf bin
fi

if [[ -d "artifacts" ]]; then
	rm -Rf artifacts
fi

if [[ -d "node_modules" ]]; then
	rm -Rf node_modules
fi

if [ -f "artifacts.json" ]; then
	rm artifacts.json
fi

if [ -f "package.json" ]; then

	# echo [0/3] prepare
	# npm cache clean --force
	# rm -Rf $HOME/.npm

	echo [1/2] compile
	npm install

	echo [2/2] run tests
	npm test
else
	# echo [1/3] prepare
	# curl -s https://raw.githubusercontent.com/makiolo/cmaki_scripts/master/bootstrap.sh | bash

	echo [1/2] compile
	./node_modules/cmaki_scripts/setup.sh && ./node_modules/cmaki_scripts/compile.sh

	echo [2/2] run tests
	./node_modules/cmaki_scripts/test.sh
fi

if [ -f "cmaki.yml" ]; then
	echo [3/3] upload artifact
	if [ -f "package.json" ]; then
		npm run upload
	else
		./node_modules/cmaki_scripts/upload.sh
	fi
fi

