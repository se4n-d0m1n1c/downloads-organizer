# Downloads Folder Organizer - Windows PowerShell Script
# Run this script to organize your Downloads folder

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  DOWNLOADS FOLDER ORGANIZER - WINDOWS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Python is installed
$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    Write-Host "ERROR: Python is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Python from https://python.org" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Get the script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectDir = Split-Path -Parent $scriptDir
$organizerScript = Join-Path $projectDir "src" "organize_downloads_crossplatform.py"

# Run the cross-platform organizer
Write-Host "Running Downloads organizer..." -ForegroundColor Green
Write-Host ""
python $organizerScript

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "            ORGANIZATION COMPLETE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Log file: $env:LOCALAPPDATA\DownloadsOrganizer\downloads_organizer.log" -ForegroundColor Yellow
Write-Host ""
Read-Host "Press Enter to exit"