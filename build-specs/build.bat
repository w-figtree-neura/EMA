@echo off
:: -- INITIALIZE VARIABLES --

setlocal
set ERRORLEVEL=0
set errorfile="%~dp0CI_Error.txt"
set settingsfile="%~dp0CI_Settings.txt"
set runfile="%~dp0CI_Running.txt"
set logfile="%~dp0logfile.txt"

:: -- CREATE TMP FILES
echo. 2>%runfile%
echo. 2>%settingsfile%
echo. 2>%errorfile%
echo.Error File %errorfile%
echo.Settings File %settingsfile%
echo.Run File %runfile%

echo %BUILD_NUMBER% >> %settingsfile%
:: -- RUN BUILD
echo Launching Build Script
start "" "C:\Program Files (x86)\National Instruments\LabVIEW 2014\LabVIEW.exe" "%~dp0CI Server Build Package.vi"
::start "" "C:\Program Files (x86)\National Instruments\LabVIEW 2013\LabVIEW.exe" "%~dp0CI Server Build Package.vi"
::"C:\Program Files (x86)\National Instruments\LabVIEW 2013\LabVIEW.exe" "%~dp0CI Server Build Package.vi" -- %BUILD_NUMBER% %errorfile% %runfile%
::"CI Server Build Package.exe" -- %BUILD_NUMBER% %errorfile% %runfile%
:: -- MONITOR BUILD, LOOP UNTIL BUILD IS FINISHED, use PING to act as a 'sleep' function for loop
:BUILDRUNNING
type %runfile%
type nul > %runfile%
::type %logfile%
::type nul > %logfile%
:: -- WAIT FOR 5 SECONDS, WINDOWS DOESN'T HAVE A COMMAND LINE WAIT
PING 1.1.1.1 -n 1 -w 50 >NUL
if exist %runfile% goto BUILDRUNNING

echo Build finished

:: -- CHECK FOR BUILD ERRORS
echo Checking for build errors
:: if NOT exist %errorfile% GOTO NOERRORFILE
CALL "%~dp0checkerror.bat" %errorfile%
IF %ERRORLEVEL% GTR 0 GOTO DISPLAYERROR
GOTO RUNEXIT

:DISPLAYERROR
echo ============ LabVIEW Build Error Start ============ 
type %errorfile%
echo.
echo ============= LabVIEW Build Error End =============
GOTO RUNEXIT

:NOERRORFILE
echo LabVIEW error file %errorfile% does not exist
set ERRORLEVEL=2
GOTO RUNEXIT

:RUNEXIT
echo ERRORLEVEL = %ERRORLEVEL%

:: -- UNCOMMENT WHEN RUNNING FROM JENKINS
EXIT %ERRORLEVEL%
