# Downloads Folder Organizer

A Python-based automation tool that organizes your Downloads folder by file type in real-time or on a schedule.

## Features
- **Real-time organization** - Watches Downloads folder and organizes files as they arrive
- **Smart categorization** - 10+ file categories with customizable extensions
- **Multiple scheduling options** - Cron jobs, systemd service, or manual runs
- **Duplicate handling** - Automatically renames duplicate files
- **Comprehensive logging** - Detailed logs for troubleshooting
- **Easy setup** - Interactive setup script with menu options

## Project Structure
```
downloads-organizer/
├── src/                    # Python source code
│   ├── organize_downloads.py      # Interactive organizer
│   └── organize_downloads_cron.py # Automatic organizer (for cron/watcher)
├── scripts/                # Shell scripts
│   ├── watch_downloads.sh         # Real-time folder watcher
│   ├── setup_organizer.sh         # Interactive setup menu
│   ├── setup_cron.sh              # Cron job setup
│   └── test_organizer.sh          # Test script
├── config/                # Configuration files
│   └── downloads-organizer.service # Systemd service file
├── docs/                  # Documentation
│   └── README.md                 # Detailed documentation
├── tests/                 # Test files (future)
├── .gitignore            # Git ignore rules
└── requirements.txt      # Python dependencies (minimal)
```

## Quick Start

### 1. Clone and navigate
```bash
git clone https://github.com/se4n-d0m1n1c/downloads-organizer.git
cd downloads-organizer
```

### 2. Easy setup (recommended)
```bash
./scripts/setup_organizer.sh
```

### 3. Manual organization
```bash
python3 src/organize_downloads.py
```

### 4. Real-time watcher
```bash
./scripts/watch_downloads.sh
```

## File Categories
Files are automatically sorted into these folders:
- **Documents** - PDF, Word, Excel, PowerPoint, Text files
- **Images** - JPG, PNG, GIF, SVG, etc.
- **Videos** - MP4, AVI, MOV, MKV, etc.
- **Archives** - ZIP, RAR, 7Z, TAR, etc.
- **Code** - Python, JavaScript, HTML, CSS, Shell scripts, etc.
- **Software** - EXE, MSI, DMG, DEB, etc.
- **Fonts** - TTF, OTF, WOFF, etc.
- **Audio** - MP3, WAV, FLAC, etc.
- **Ebooks** - EPUB, MOBI, AZW3
- **Miscellaneous** - Files that don't match any category

## Installation Methods

### Method 1: Real-time Watcher (Recommended)
```bash
./scripts/watch_downloads.sh
# Run in background: nohup ./scripts/watch_downloads.sh &
```

### Method 2: Cron Job (Scheduled)
```bash
./scripts/setup_cron.sh
# Or manually: 0 18 * * * /usr/bin/python3 /path/to/src/organize_downloads_cron.py
```

### Method 3: Systemd Service
```bash
sudo cp config/downloads-organizer.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable downloads-organizer
sudo systemctl start downloads-organizer
```

## Customization

Edit `src/organize_downloads_cron.py` to:
- Add new file extensions to categories
- Change category names or folder structure
- Modify logging settings
- Adjust duplicate file handling

## Logs
- Organizer logs: `~/.hermes/downloads_organizer.log`
- Watcher logs: `/tmp/downloads_watcher.log`

## Platform Support

This project now supports **Windows, macOS, and Linux**!

### Windows Users
See the [Windows Edition README](windows/README_WINDOWS.md) for complete setup instructions including:
- PowerShell scripts for real-time monitoring
- Windows Task Scheduler integration  
- Batch files for easy manual execution
- Windows-specific setup wizard

### Linux/macOS Users
Use the standard setup scripts in the `scripts/` folder for:
- Real-time watcher with inotify (Linux) or fswatch (macOS)
- Cron job scheduling
- Systemd service setup (Linux)

## Requirements
- **Python 3.6+** (required for all platforms)
- **Linux**: inotify-tools for real-time watcher
- **Windows**: PowerShell 5.1+ for scripts
- **macOS**: fswatch for real-time watcher (optional)

## License
MIT License - Feel free to use and modify for your needs.

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.