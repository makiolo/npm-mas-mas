@echo off

setlocal enableextensions

if "%Configuration%" == "Release" (
    set MODE=Release
) else (
    set MODE=Debug
)

if "%Platform%" == "x64" (
    set GENERATOR=Visual Studio 16 2019 Win64
) else (
    set GENERATOR=Visual Studio 16 2019
)

echo running in mode %MODE% ...
if exist %MODE% (rmdir /s /q %MODE%)
md %MODE%

:: setup
cd %MODE%

conan install %CMAKI_PWD% --build missing -s build_type=%MODE%
:: conan install %CMAKI_PWD% --build never -s build_type=%MODE%

IF DEFINED Configuration (
    IF DEFINED Platform (
        cmake .. -DCMAKE_MODULE_PATH=%CMAKI_PWD%\\node_modules\\npm-mas-mas\\cmaki -DCMAKE_BUILD_TYPE=%MODE% -G"%GENERATOR%" -DCMAKE_INSTALL_PREFIX=%CMAKI_INSTALL%
    ) ELSE (
        cmake .. -DCMAKE_MODULE_PATH=%CMAKI_PWD%\\node_modules\\npm-mas-mas\\cmaki -DCMAKE_BUILD_TYPE=%MODE% -DCMAKE_INSTALL_PREFIX=%CMAKI_INSTALL%
    )
) ELSE (
    cmake .. -DCMAKE_MODULE_PATH=%CMAKI_PWD%\\node_modules\\npm-mas-mas\\cmaki -DCMAKE_BUILD_TYPE=%MODE% -DCMAKE_INSTALL_PREFIX=%CMAKI_INSTALL%
)

set lasterror=%errorlevel%
cd ..

exit /b %lasterror%
