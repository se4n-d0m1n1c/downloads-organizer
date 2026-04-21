# Downloads Organizer - Windows Task Scheduler Setup
# PowerShell script to create a scheduled task for automatic organization

param(
    [string]$Schedule = "Daily",  # Daily, Hourly, Weekly, Startup
    [switch]$Force
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  WINDOWS TASK SCHEDULER SETUP" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Host "ERROR: This script requires Administrator privileges" -ForegroundColor Red
    Write-Host "Please run PowerShell as Administrator" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

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
$pythonPath = $python.Source

# Task configuration
$taskName = "DownloadsFolderOrganizer"
$taskDescription = "Automatically organizes files in the Downloads folder"
$taskAction = New-ScheduledTaskAction -Execute $pythonPath -Argument "`"$organizerScript`""

# Set trigger based on schedule
switch ($Schedule.ToLower()) {
    "daily" {
        $taskTrigger = New-ScheduledTaskTrigger -Daily -At "6:00PM"
        Write-Host "Setting up DAILY schedule (6:00 PM)" -ForegroundColor Green
    }
    "hourly" {
        $taskTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours 1)
        Write-Host "Setting up HOURLY schedule" -ForegroundColor Green
    }
    "weekly" {
        $taskTrigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At "9:00AM"
        Write-Host "Setting up WEEKLY schedule (Sunday 9:00 AM)" -ForegroundColor Green
    }
    "startup" {
        $taskTrigger = New-ScheduledTaskTrigger -AtStartup
        Write-Host "Setting up STARTUP schedule" -ForegroundColor Green
    }
    default {
        Write-Host "ERROR: Invalid schedule. Use: Daily, Hourly, Weekly, Startup" -ForegroundColor Red
        exit 1
    }
}

# Task settings
$taskSettings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RunOnlyIfNetworkAvailable `
    -WakeToRun

# Register the task
try {
    Write-Host "Creating scheduled task..." -ForegroundColor Yellow
    
    # Check if task already exists
    $existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
    if ($existingTask -and -not $Force) {
        Write-Host "Task '$taskName' already exists!" -ForegroundColor Red
        $response = Read-Host "Overwrite? (y/n)"
        if ($response -notmatch '^[yY]') {
            Write-Host "Setup cancelled." -ForegroundColor Yellow
            exit 0
        }
    }
    
    # Register or update the task
    Register-ScheduledTask `
        -TaskName $taskName `
        -Action $taskAction `
        -Trigger $taskTrigger `
        -Settings $taskSettings `
        -Description $taskDescription `
        -Force:$Force | Out-Null
    
    Write-Host "Task created successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Task Name: $taskName" -ForegroundColor Yellow
    Write-Host "Schedule: $Schedule" -ForegroundColor Yellow
    Write-Host "Python Script: $organizerScript" -ForegroundColor Yellow
    Write-Host "Log File: $env:LOCALAPPDATA\DownloadsOrganizer\downloads_organizer.log" -ForegroundColor Yellow
    
} catch {
    Write-Host "ERROR: Failed to create scheduled task" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "            SETUP COMPLETE!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To manage the task:" -ForegroundColor Yellow
Write-Host "1. Open Task Scheduler (taskschd.msc)" -ForegroundColor White
Write-Host "2. Find task under: Task Scheduler Library\$taskName" -ForegroundColor White
Write-Host ""
Write-Host "To run manually:" -ForegroundColor Yellow
Write-Host "  python `"$organizerScript`"" -ForegroundColor White
Write-Host ""
Read-Host "Press Enter to exit"