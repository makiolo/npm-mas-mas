@echo off

setlocal enableextensions

if "%Configuration%" == "Release" (
    set MODE=Release
) else (
    set MODE=Debug
)

if "%Platform%" == "x64" (
    set GENERATOR=Visual Studio 14 2015 Win64
) else (
    set GENERATOR=Visual Studio 14 2015
)

echo running in mode %MODE% ...
if exist %MODE% (rmdir /s /q %MODE%)
md %MODE%

:: setup
cd %MODE%

:: TODO:
:: -DNOCACHE_REMOTE=$NOCACHE_REMOTE -DNOCACHE_LOCAL=$NOCACHE_LOCAL -DCOVERAGE=$COVERAGE -DTESTS_VALGRIND=$TESTS_VALGRIND

IF DEFINED Configuration (
    IF DEFINED Platform (
        cmake .. -DCMAKE_BUILD_TYPE=%MODE% -G"%GENERATOR%" -DCMAKE_INSTALL_PREFIX=%CMAKI_INSTALL%
    ) ELSE (
        cmake .. -DCMAKE_BUILD_TYPE=%MODE% -DCMAKE_INSTALL_PREFIX=%CMAKI_INSTALL%
    )
) ELSE (
    cmake .. -DCMAKE_BUILD_TYPE=%MODE% -DCMAKE_INSTALL_PREFIX=%CMAKI_INSTALL%
)

set lasterror=%errorlevel%
cd ..

if %lasterror% neq 0 exit /b %lasterror%
