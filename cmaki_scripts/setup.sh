#!/bin/bash

export CC="${CC:-gcc}"
export CXX="${CXX:-g++}"
export MODE="${MODE:-Debug}"
export COMPILER="${COMPILER:-gcc}"
export COMPILER_LIBCXX="${COMPILER_LIBCXX:-libstdc++11}"
export COMPILER_VERSION="${COMPILER_VERSION:-7.3}"
export CMAKI_INSTALL="${CMAKI_INSTALL:-$CMAKI_PWD/bin}"
export NPP_CACHE="${NPP_CACHE:-FALSE}"
export CMAKI_GENERATOR="${CMAKI_GENERATOR:-Unix Makefiles}"
export COVERAGE="${COVERAGE:-FALSE}"
export TESTS_VALGRIND="${TESTS_VALGRIND:-FALSE}"
export COMPILER_BASENAME=$(basename ${CC})
export CMAKE_TOOLCHAIN_FILE="${CMAKE_TOOLCHAIN_FILE:-"no cross compile"}"

if [ "$CMAKE_TOOLCHAIN_FILE" == "no cross compile" ]; then
	export CMAKE_TOOLCHAIN_FILE_FILEPATH=""
else
	export CMAKE_TOOLCHAIN_FILE_FILEPATH=" -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
fi

echo "running in mode ${MODE} ... ($COMPILER_BASENAME) (${CC} / ${CXX})"
if [ ! -d ${COMPILER_BASENAME}/${MODE} ]; then
	mkdir -p ${COMPILER_BASENAME}/${MODE}
fi

# setup
cd ${COMPILER_BASENAME}/${MODE}
if [ -f "CMakeCache.txt" ]; then
	rm CMakeCache.txt
fi

export WITH_CONAN=0
if [ -f "../../conanbuildinfo.cmake" ]; then
	if [ -f "../../conanfile.txt" ] || [ -f "../../conanfile.py" ]; then
		echo conan install ../.. --install-folder=$CMAKI_PWD --build missing -s compiler=${COMPILER} -s build_type=${MODE} -s compiler.libcxx=${COMPILER_LIBCXX} -s compiler.version=${COMPILER_VERSION}
		if ! conan install ../.. --install-folder=$CMAKI_PWD --build missing -s compiler=${COMPILER} -s build_type=${MODE} -s compiler.libcxx=${COMPILER_LIBCXX} -s compiler.version=${COMPILER_VERSION}; then
			echo Error conan
			exit 1
		fi
		export WITH_CONAN=1
	fi
else
	if [ -f "../../conanfile.txt" ] || [ -f "../../conanfile.py" ]; then
		echo conan install ../.. --build missing -s compiler=${COMPILER} -s build_type=${MODE} -s compiler.libcxx=${COMPILER_LIBCXX} -s compiler.version=${COMPILER_VERSION}
		if ! conan install ../.. --build missing -s compiler=${COMPILER} -s build_type=${MODE} -s compiler.libcxx=${COMPILER_LIBCXX} -s compiler.version=${COMPILER_VERSION}; then
			echo Error conan
			exit 1
		fi
		export WITH_CONAN=1
	fi
fi

cmake ../.. ${CMAKE_TOOLCHAIN_FILE_FILEPATH} -DCMAKE_MODULE_PATH=${CMAKI_PWD}/node_modules/npm-mas-mas/cmaki -DCMAKE_INSTALL_PREFIX=${CMAKI_INSTALL} -DCMAKE_BUILD_TYPE=${MODE} -DFIRST_ERROR=1 -G"${CMAKI_GENERATOR}" -DCMAKE_C_COMPILER="${CC}" -DCMAKE_CXX_COMPILER="${CXX}" -DNPP_CACHE=${NPP_CACHE} -DCOVERAGE=${COVERAGE} -DTESTS_VALGRIND=${TESTS_VALGRIND} -DWITH_CONAN=${WITH_CONAN}
code=$?
exit ${code}
