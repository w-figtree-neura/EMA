@echo off
REM -- CHECK FOR BUILD ERRORS
set size=%~z1

set ERRORLEVEL=0

REM check if size is set
IF "%size%." == "." goto RUNEXIT

REM check is size is zero
IF %size% EQU 0 goto RUNEXIT

REM size is greater than zero, set error
set ERRORLEVEL=1
echo Build error occurred

:RUNEXIT
REM echo ERRORLEVEL = %ERRORLEVEL%

REM -- UNCOMMENT WHEN RUNNING FROM JENKINS
REM EXIT %ERRORLEVEL%