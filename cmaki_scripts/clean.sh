#!/bin/bash
export NOCACHE_LOCAL="${NOCACHE_LOCAL:-FALSE}"
export CC="${CC:-gcc}"
export MODE="${MODE:-Debug}"
export COMPILER_BASENAME=$(basename ${CC})

if [ -d $COMPILER_BASENAME/$MODE ]; then
	rm -Rf $COMPILER_BASENAME/$MODE
fi
if [ "$NOCACHE_LOCAL" == "TRUE" ]; then
	rm -Rf artifacts 2> /dev/null
fi
rm -Rf coverage 2> /dev/null
rm -Rf gcc 2> /dev/null
rm -Rf clang 2> /dev/null

