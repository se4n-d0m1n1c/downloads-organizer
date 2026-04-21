# Downloads Organizer - Windows Setup Script
# Provides a menu for setting up different organization methods on Windows

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  DOWNLOADS ORGANIZER - WINDOWS SETUP" -ForegroundColor Cyan
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

# Get paths
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectDir = Split-Path -Parent $scriptDir
$organizerScript = Join-Path $projectDir "src" "organize_downloads_crossplatform.py"

Write-Host "Python found: $($python.Source)" -ForegroundColor Green
Write-Host "Project path: $projectDir" -ForegroundColor Green
Write-Host ""

Write-Host "Available organization methods:" -ForegroundColor Yellow
Write-Host "1. Real-time watcher (runs whenever new files are added)" -ForegroundColor White
Write-Host "2. Daily scheduled task (runs at 6:00 PM daily)" -ForegroundColor White
Write-Host "3. Hourly scheduled task (runs every hour)" -ForegroundColor White
Write-Host "4. Weekly scheduled task (runs every Sunday at 9:00 AM)" -ForegroundColor White
Write-Host "5. Startup scheduled task (runs when Windows starts)" -ForegroundColor White
Write-Host "6. Manual setup (I'll show you the commands)" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Choose an option (1-6)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "Setting up real-time watcher..." -ForegroundColor Green
        Write-Host ""
        
        $watcherScript = Join-Path $scriptDir "watch_downloads.ps1"
        
        Write-Host "To start the watcher, run:" -ForegroundColor Yellow
        Write-Host "  PowerShell -ExecutionPolicy Bypass -File `"$watcherScript`"" -ForegroundColor White
        Write-Host ""
        Write-Host "To run in background (hidden window):" -ForegroundColor Yellow
        Write-Host "  Start-Process PowerShell -ArgumentList `"-ExecutionPolicy Bypass -File `"`"$watcherScript`"`"`" -WindowStyle Hidden" -ForegroundColor White
        Write-Host ""
        Write-Host "To stop: Close the PowerShell window or press Ctrl+C" -ForegroundColor Yellow
    }
    
    "2" {
        Write-Host ""
        Write-Host "Setting up daily scheduled task (6:00 PM)..." -ForegroundColor Green
        Write-Host ""
        
        $taskScript = Join-Path $scriptDir "setup_task_scheduler.ps1"
        
        Write-Host "Running Task Scheduler setup..." -ForegroundColor Yellow
        PowerShell -ExecutionPolicy Bypass -File "$taskScript" -Schedule Daily
    }
    
    "3" {
        Write-Host ""
        Write-Host "Setting up hourly scheduled task..." -ForegroundColor Green
        Write-Host ""
        
        $taskScript = Join-Path $scriptDir "setup_task_scheduler.ps1"
        
        Write-Host "Running Task Scheduler setup..." -ForegroundColor Yellow
        PowerShell -ExecutionPolicy Bypass -File "$taskScript" -Schedule Hourly
    }
    
    "4" {
        Write-Host ""
        Write-Host "Setting up weekly scheduled task (Sunday 9:00 AM)..." -ForegroundColor Green
        Write-Host ""
        
        $taskScript = Join-Path $scriptDir "setup_task_scheduler.ps1"
        
        Write-Host "Running Task Scheduler setup..." -ForegroundColor Yellow
        PowerShell -ExecutionPolicy Bypass -File "$taskScript" -Schedule Weekly
    }
    
    "5" {
        Write-Host ""
        Write-Host "Setting up startup scheduled task..." -ForegroundColor Green
        Write-Host ""
        
        $taskScript = Join-Path $scriptDir "setup_task_scheduler.ps1"
        
        Write-Host "Running Task Scheduler setup..." -ForegroundColor Yellow
        PowerShell -ExecutionPolicy Bypass -File "$taskScript" -Schedule Startup
    }
    
    "6" {
        Write-Host ""
        Write-Host "MANUAL SETUP INSTRUCTIONS" -ForegroundColor Cyan
        Write-Host "=========================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Project location: $projectDir" -ForegroundColor Yellow
        Write-Host ""
        
        Write-Host "1. Test the organizer script:" -ForegroundColor Green
        Write-Host "   python `"$organizerScript`"" -ForegroundColor White
        Write-Host ""
        
        Write-Host "2. To run manually anytime:" -ForegroundColor Green
        Write-Host "   python `"$organizerScript`"" -ForegroundColor White
        Write-Host "   Or double-click: $scriptDir\organize_downloads.bat" -ForegroundColor White
        Write-Host ""
        
        Write-Host "3. To create a scheduled task (run as Administrator):" -ForegroundColor Green
        Write-Host "   PowerShell -ExecutionPolicy Bypass -File `"$scriptDir\setup_task_scheduler.ps1`" -Schedule Daily" -ForegroundColor White
        Write-Host ""
        
        Write-Host "4. To run real-time watcher:" -ForegroundColor Green
        Write-Host "   PowerShell -ExecutionPolicy Bypass -File `"$scriptDir\watch_downloads.ps1`"" -ForegroundColor White
        Write-Host ""
        
        Write-Host "5. Log files:" -ForegroundColor Green
        Write-Host "   - Organizer logs: $env:LOCALAPPDATA\DownloadsOrganizer\downloads_organizer.log" -ForegroundColor White
        Write-Host "   - Watcher logs: $env:LOCALAPPDATA\DownloadsOrganizer\downloads_watcher.log" -ForegroundColor White
        Write-Host ""
        
        Write-Host "6. Quick commands (add to your PowerShell profile):" -ForegroundColor Green
        Write-Host "   function organize-downloads { python `"$organizerScript`" }" -ForegroundColor White
        Write-Host "   function watch-downloads { PowerShell -ExecutionPolicy Bypass -File `"$scriptDir\watch_downloads.ps1`" }" -ForegroundColor White
    }
    
    default {
        Write-Host "Invalid choice. Exiting." -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "           SETUP COMPLETE!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Your Downloads folder will now be automatically organized." -ForegroundColor Green
Write-Host "Project files are in: $projectDir" -ForegroundColor Yellow
Write-Host ""
Write-Host "You can always run the organizer manually with:" -ForegroundColor Green
Write-Host "  python `"$organizerScript`"" -ForegroundColor White
Write-Host "  or double-click organize_downloads.bat" -ForegroundColor White
Write-Host ""
Read-Host "Press Enter to exit"