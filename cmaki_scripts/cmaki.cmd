@ECHO OFF
SET DIRWORK=%~dp0

IF NOT EXIST "%NODE%" (
 IF DEFINED NODEHOME (
  IF EXIST "%NODEHOME%\node.exe" (
   SET NODE="%NODEHOME%\node.exe"
  ) ELSE (
   ECHO Error: Missing node.exe from node home: "%NODEHOME%"
   EXIT /B 2
  )
 ) ELSE (
  IF EXIST "C:\Program Files\nodejs\node.exe" (
   ECHO WARNING: Defaulting NODE configuration
   SET NODE=C:\Program Files\nodejs\node.exe
   SET NODEHOME=C:\Program Files\nodejs
  ) ELSE (
   ECHO ERROR: NODE configuration unavailable!
   EXIT /B 3
  )
 )
)

"%NODE%" %DIRWORK%\cmaki.js %*
exit /b %ERRORLEVEL%
