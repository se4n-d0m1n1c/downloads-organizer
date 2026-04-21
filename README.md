# Downloads Folder Organizer

A Python-based automation tool that organizes your Downloads folder by file type.

## Project Location
`~/Projects/downloads-organizer/`

## Files

- `organize_downloads.py` - Interactive organizer (asks for confirmation)
- `organize_downloads_cron.py` - Automatic organizer for cron/watcher
- `watch_downloads.sh` - Real-time watcher using inotifywait
- `setup_organizer.sh` - Main setup script with menu options
- `setup_cron.sh` - Cron setup script
- `downloads-organizer.service` - Systemd service file

## How to Use

### Quick Start
```bash
cd ~/Projects/downloads-organizer/
./setup_organizer.sh
```

### Manual Organization
```bash
python3 ~/Projects/downloads-organizer/organize_downloads.py
```

### Real-time Watcher
```bash
~/Projects/downloads-organizer/watch_downloads.sh
# Run in background: nohup ~/Projects/downloads-organizer/watch_downloads.sh &
```

### Cron Job (Daily at 6 PM)
```bash
0 18 * * * /usr/bin/python3 ~/Projects/downloads-organizer/organize_downloads_cron.py
```

## File Categories

Files are organized into these folders:
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

## Logs

- Organizer logs: `~/.hermes/downloads_organizer.log`
- Watcher logs: `/tmp/downloads_watcher.log`

## Add to Startup

To run the watcher automatically on login, add to `~/.bashrc`:
```bash
nohup ~/Projects/downloads-organizer/watch_downloads.sh > /tmp/downloads_watcher.log 2>&1 &
```

## Systemd Service

To run as a system service:
```bash
sudo cp ~/Projects/downloads-organizer/downloads-organizer.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable downloads-organizer
sudo systemctl start downloads-organizer
```

## Customization

Edit `organize_downloads_cron.py` to:
- Add new file extensions
- Change category names
- Modify logging settings
- Adjust duplicate file handling