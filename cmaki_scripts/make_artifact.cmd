@echo off

:: IF DEFINED CMAKI_PWD (
::   set CMAKI_PWD=%CMAKI_PWD%
:: ) else (
::   set CMAKI_PWD=%CD%
:: )
:: 
:: IF DEFINED CMAKI_INSTALL (
::   set CMAKI_INSTALL=%CMAKI_INSTALL%
:: ) else (
::   set CMAKI_INSTALL=%CMAKI_PWD%/bin
:: )

IF DEFINED MODE (
  set MODE=%MODE%
) else (
  set MODE=Debug
)

IF DEFINED YMLFILE (
  build --yaml=%YMLFILE% --server=http://artifacts.myftp.biz:8080 -d
) else (
  IF DEFINED PACKAGE (
    build %PACKAGE% --server=http://artifacts.myftp.biz:8080 -d
  ) else (
    echo Error: must define env var YMLFILE or PACKAGE
  )
)
