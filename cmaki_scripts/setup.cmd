@echo off

setlocal enableextensions

if "%Configuration%" == "Release" (
    set MODE=Release
) else (
    set MODE=Debug
)

if "%Platform%" == "x64" (
    :: set GENERATOR=Visual Studio 16 2019 Win64
    set GENERATOR=Visual Studio 14 2015 Win64
    set ARCH=x86_64
) else (
    :: set GENERATOR=Visual Studio 16 2019
    set GENERATOR=Visual Studio 14 2015
    set ARCH=x86
)

echo running in mode %MODE% ...
if exist %MODE% (rmdir /s /q %MODE%)
md %MODE%

:: setup
cd %MODE%

:: -s compiler=${COMPILER} -s build_type=${MODE} -s compiler.libcxx=${COMPILER_LIBCXX} -s compiler.version=${COMPILER_VERSION}
:: compiler=Visual Studio
:: compiler.runtime=MD
:: compiler.version=14

conan install %CMAKI_PWD% --build missing -s build_type=%MODE% -s arch_build=%ARCH% -s compiler=Visual Studio

IF DEFINED Configuration (
    IF DEFINED Platform (
        cmake %CMAKI_PWD% -DWITH_CONAN=1 -DCMAKE_BUILD_TYPE=%MODE% -G"%GENERATOR%" -DCMAKE_INSTALL_PREFIX=%CMAKI_INSTALL%
    ) ELSE (
        cmake %CMAKI_PWD% -DWITH_CONAN=1 -DCMAKE_BUILD_TYPE=%MODE% -DCMAKE_INSTALL_PREFIX=%CMAKI_INSTALL%
    )
) ELSE (
    cmake %CMAKI_PWD% -DWITH_CONAN=1 -DCMAKE_BUILD_TYPE=%MODE% -DCMAKE_INSTALL_PREFIX=%CMAKI_INSTALL%
)

set lasterror=%errorlevel%
cd %CMAKI_PWD%
exit /b %lasterror%
