@echo off
if exist "boostorg_predef" (
	rmdir /s /q boostorg_predef
)
git clone -q https://github.com/boostorg/predef.git boostorg_predef

if exist "__setup.cmd" (
	del __setup.cmd
)

curl -s https://raw.githubusercontent.com/makiolo/cmaki_scripts/master/setup.cmd > __setup.cmd
call __setup.cmd
del __setup.cmd
