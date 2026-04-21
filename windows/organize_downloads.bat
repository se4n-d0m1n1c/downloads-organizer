@echo off
REM Downloads Folder Organizer - Windows Batch Script
REM Run this script to organize your Downloads folder

echo ========================================
echo   DOWNLOADS FOLDER ORGANIZER - WINDOWS
echo ========================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python from https://python.org
    pause
    exit /b 1
)

REM Get the script directory
set "SCRIPT_DIR=%~dp0"
set "PROJECT_DIR=%SCRIPT_DIR%.."

REM Run the cross-platform organizer
echo Running Downloads organizer...
echo.
python "%PROJECT_DIR%\src\organize_downloads_crossplatform.py"

echo.
echo ========================================
echo            ORGANIZATION COMPLETE
echo ========================================
echo.
echo Log file: %APPDATA%\DownloadsOrganizer\downloads_organizer.log
echo.
pause