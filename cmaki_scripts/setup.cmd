@echo off

setlocal enableextensions

if DEFINED GENERATOR (
    echo Using Visual Studio generator: %GENERATOR%
) else (
    set GENERATOR=Visual Studio 16 2019
    echo Env var GENERATOR is not defined. Using by default: %GENERATOR%
)

if "%Configuration%" == "Release" (
    set MODE=Release
) else (
    set MODE=Debug
)

if "%Platform%" == "x64" (
    set GENERATOR=%GENERATOR% Win64
    set ARCH=x86_64
) else (
    set ARCH=x86
)

echo running in mode %MODE% ...
if exist %MODE% (rmdir /s /q %MODE%)
md %MODE%

:: setup
cd %MODE%

conan install %CMAKI_PWD% --build missing -s build_type=%MODE% -s arch=%ARCH% -s arch_build=%ARCH% -s compiler="Visual Studio"

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
