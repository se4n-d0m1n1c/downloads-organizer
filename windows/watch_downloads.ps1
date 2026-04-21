# Downloads Folder Watcher - Windows PowerShell
# Monitors the Downloads folder and organizes files in real-time

param(
    [string]$WatchPath = "$env:USERPROFILE\Downloads",
    [int]$PollInterval = 5  # Seconds between checks
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  DOWNLOADS FOLDER WATCHER - WINDOWS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Watching: $WatchPath" -ForegroundColor Yellow
Write-Host "Poll interval: $PollInterval seconds" -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
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
$pythonPath = $python.Source

# Log file
$logDir = "$env:LOCALAPPDATA\DownloadsOrganizer"
$null = New-Item -ItemType Directory -Path $logDir -Force
$logFile = Join-Path $logDir "downloads_watcher.log"

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $Message"
    Add-Content -Path $logFile -Value $logMessage
    Write-Host $logMessage
}

# Initial setup
Write-Log "Starting Downloads folder watcher"
Write-Log "Watch path: $WatchPath"
Write-Log "Poll interval: $PollInterval seconds"
Write-Log "Organizer script: $organizerScript"

# Track previously seen files to avoid re-processing
$previousFiles = @{}

try {
    while ($true) {
        # Get current files in the Downloads folder
        $currentFiles = @{}
        if (Test-Path $WatchPath) {
            Get-ChildItem -Path $WatchPath -File | ForEach-Object {
                $currentFiles[$_.FullName] = $_.LastWriteTime
            }
        }
        
        # Find new files (in current but not in previous)
        $newFiles = $currentFiles.Keys | Where-Object { -not $previousFiles.ContainsKey($_) }
        
        if ($newFiles.Count -gt 0) {
            Write-Log "Found $($newFiles.Count) new file(s)"
            
            # Run the organizer for new files
            $result = & $pythonPath $organizerScript 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Log "Organizer ran successfully"
            } else {
                Write-Log "ERROR: Organizer failed - $result"
            }
        }
        
        # Update previous files
        $previousFiles = $currentFiles
        
        # Wait for next poll
        Start-Sleep -Seconds $PollInterval
    }
} catch {
    if ($_.Exception.GetType().Name -eq "PipelineStoppedException") {
        # Ctrl+C was pressed
        Write-Log "Watcher stopped by user"
    } else {
        Write-Log "ERROR: $($_.Exception.Message)"
    }
} finally {
    Write-Log "Watcher stopped"
    Write-Host ""
    Write-Host "Log file: $logFile" -ForegroundColor Yellow
}