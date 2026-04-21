# Downloads Folder Organizer - Windows Edition

A cross-platform Python tool that automatically organizes your Downloads folder by file type. This Windows edition includes PowerShell scripts, batch files, and Task Scheduler integration.

## Features
- **Cross-platform Python core** - Works on Windows, macOS, and Linux
- **Multiple organization methods**:
  - Real-time file watcher
  - Scheduled tasks (daily, hourly, weekly, startup)
  - Manual organization
- **Smart categorization** - 10+ file categories
- **Duplicate handling** - Automatically renames duplicates
- **Comprehensive logging** - All actions logged for review

## Quick Start

### 1. Prerequisites
- **Python 3.6+** installed and in PATH
- **PowerShell 5.1+** (included with Windows 10/11)

### 2. Installation
1. Download or clone this repository
2. Open PowerShell in the project folder
3. Run the setup script:
   ```powershell
   PowerShell -ExecutionPolicy Bypass -File .\windows\setup_windows.ps1
   ```

### 3. Choose Your Setup Method
The setup script offers 6 options:
1. **Real-time watcher** - Monitors Downloads folder continuously
2. **Daily task** - Runs at 6:00 PM daily
3. **Hourly task** - Runs every hour
4. **Weekly task** - Runs every Sunday at 9:00 AM
5. **Startup task** - Runs when Windows starts
6. **Manual setup** - Shows you all commands

## File Categories

The organizer sorts files into these categories:

| Category | File Extensions |
|----------|-----------------|
| Documents | .pdf, .doc, .docx, .txt, .rtf, .odt, .xls, .xlsx, .ppt, .pptx, .md, .csv |
| Images | .jpg, .jpeg, .png, .gif, .bmp, .svg, .webp, .tiff, .ico |
| Videos | .mp4, .avi, .mov, .wmv, .flv, .mkv, .webm, .m4v |
| Archives | .zip, .rar, .7z, .tar, .gz, .bz2, .xz, .tgz |
| Code | .py, .js, .html, .css, .java, .cpp, .c, .h, .php, .rb, .go, .rs, .ts, .json, .xml, .yml, .yaml, .toml, .ini, .sh, .bash, .ps1, .bat, .cmd |
| Software | .exe, .msi, .dmg, .pkg, .deb, .rpm, .apk, .appimage |
| Fonts | .ttf, .otf, .woff, .woff2, .eot |
| Audio | .mp3, .wav, .flac, .aac, .ogg, .m4a, .wma |
| Ebooks | .epub, .mobi, .azw3 |
| Miscellaneous | All other files |

## Windows-Specific Files

### Scripts in `windows/` folder:
- **`organize_downloads.bat`** - Batch file for manual organization
- **`organize_downloads.ps1`** - PowerShell script for manual organization
- **`watch_downloads.ps1`** - Real-time file watcher
- **`setup_task_scheduler.ps1`** - Creates Windows scheduled tasks
- **`setup_windows.ps1`** - Main setup menu script

### Core Python files in `src/` folder:
- **`organize_downloads_crossplatform.py`** - Main organizer script
- **`platform_utils.py`** - Platform detection utilities

## Usage Examples

### Manual Organization
```powershell
# Using PowerShell
python .\src\organize_downloads_crossplatform.py

# Using batch file (double-click)
.\windows\organize_downloads.bat
```

### Real-time Watcher
```powershell
# Start watcher in foreground
PowerShell -ExecutionPolicy Bypass -File .\windows\watch_downloads.ps1

# Start watcher in background (hidden)
Start-Process PowerShell -ArgumentList "-ExecutionPolicy Bypass -File `".\windows\watch_downloads.ps1`"" -WindowStyle Hidden
```

### Scheduled Task (Run as Administrator)
```powershell
# Daily at 6:00 PM
PowerShell -ExecutionPolicy Bypass -File .\windows\setup_task_scheduler.ps1 -Schedule Daily

# Hourly
PowerShell -ExecutionPolicy Bypass -File .\windows\setup_task_scheduler.ps1 -Schedule Hourly

# Weekly (Sunday 9:00 AM)
PowerShell -ExecutionPolicy Bypass -File .\windows\setup_task_scheduler.ps1 -Schedule Weekly

# Startup
PowerShell -ExecutionPolicy Bypass -File .\windows\setup_task_scheduler.ps1 -Schedule Startup
```

## Log Files

- **Organizer logs**: `%LOCALAPPDATA%\DownloadsOrganizer\downloads_organizer.log`
- **Watcher logs**: `%LOCALAPPDATA%\DownloadsOrganizer\downloads_watcher.log`

View logs with:
```powershell
Get-Content "$env:LOCALAPPDATA\DownloadsOrganizer\downloads_organizer.log" -Tail 20
```

## Managing Scheduled Tasks

1. Open **Task Scheduler** (`taskschd.msc`)
2. Find task: **Task Scheduler Library** → **DownloadsFolderOrganizer**
3. Right-click to: Enable/Disable, Run, Delete, or Properties

## Troubleshooting

### "Python is not recognized"
- Install Python from [python.org](https://python.org)
- Check "Add Python to PATH" during installation
- Restart PowerShell/Command Prompt after installation

### "Execution Policy" error
Run PowerShell as Administrator and set execution policy:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Task Scheduler fails
- Run PowerShell **as Administrator**
- Ensure Python is in system PATH
- Check Windows Event Viewer for detailed errors

### Watcher doesn't detect files
- Check if watcher is running: `Get-Process powershell`
- Verify log file for errors
- Increase poll interval in watcher script (default: 5 seconds)

## Customization

### Modify Categories
Edit `src/organize_downloads_crossplatform.py` and update the `CATEGORIES` dictionary.

### Change Schedule
Edit the scheduled task in Task Scheduler or rerun setup with different parameters.

### Adjust Poll Interval
Edit `windows/watch_downloads.ps1` and change `$PollInterval` value (in seconds).

## Uninstallation

1. Delete scheduled task:
   ```powershell
   Unregister-ScheduledTask -TaskName "DownloadsFolderOrganizer" -Confirm:$false
   ```

2. Stop watcher (if running):
   ```powershell
   Get-Process powershell | Where-Object {$_.CommandLine -like "*watch_downloads*"} | Stop-Process
   ```

3. Delete log files:
   ```powershell
   Remove-Item "$env:LOCALAPPDATA\DownloadsOrganizer" -Recurse -Force
   ```

## License

MIT License - See [LICENSE](../LICENSE) file.

## Support

For issues or questions:
1. Check the log files for errors
2. Review troubleshooting section
3. Open an issue on GitHub repository