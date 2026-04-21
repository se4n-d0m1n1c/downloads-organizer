# Downloads Organizer - Detailed Documentation

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [File Categories](#file-categories)
3. [Installation Methods](#installation-methods)
4. [Configuration](#configuration)
5. [Troubleshooting](#troubleshooting)
6. [Development](#development)
7. [API Reference](#api-reference)

## Architecture Overview

The Downloads Organizer consists of three main components:

### 1. Core Organizer (`src/`)
- `organize_downloads.py`: Interactive version with user prompts
- `organize_downloads_cron.py`: Automated version for scheduling

### 2. Scripts (`scripts/`)
- `watch_downloads.sh`: Real-time folder watcher using inotify
- `setup_organizer.sh`: Interactive setup menu
- `setup_cron.sh`: Cron job configuration
- `test_organizer.sh`: Test script

### 3. Configuration (`config/`)
- `downloads-organizer.service`: Systemd service file

## File Categories

The organizer uses the following category mapping:

| Category | File Extensions | Description |
|----------|----------------|-------------|
| Documents | .pdf, .doc, .docx, .txt, .rtf, .odt, .xls, .xlsx, .ppt, .pptx, .md, .csv | Office documents and text files |
| Images | .jpg, .jpeg, .png, .gif, .bmp, .svg, .webp, .tiff, .ico | Image files |
| Videos | .mp4, .avi, .mov, .wmv, .flv, .mkv, .webm, .m4v | Video files |
| Archives | .zip, .rar, .7z, .tar, .gz, .bz2, .xz, .tgz | Compressed archives |
| Code | .py, .js, .html, .css, .java, .cpp, .c, .h, .php, .rb, .go, .rs, .ts, .json, .xml, .yml, .yaml, .toml, .ini, .sh, .bash | Source code and scripts |
| Software | .exe, .msi, .dmg, .pkg, .deb, .rpm, .apk, .appimage | Executable files |
| Fonts | .ttf, .otf, .woff, .woff2, .eot | Font files |
| Audio | .mp3, .wav, .flac, .aac, .ogg, .m4a, .wma | Audio files |
| Ebooks | .epub, .mobi, .azw3 | Ebook formats |
| Miscellaneous | (all other extensions) | Uncategorized files |

## Installation Methods

### Method 1: Interactive Setup (Recommended)
```bash
./scripts/setup_organizer.sh
```

### Method 2: Real-time Watcher
```bash
./scripts/watch_downloads.sh
```

### Method 3: Cron Job
```bash
# Daily at 6 PM
0 18 * * * /usr/bin/python3 /path/to/src/organize_downloads_cron.py

# Hourly
0 * * * * /usr/bin/python3 /path/to/src/organize_downloads_cron.py
```

### Method 4: Systemd Service
```bash
sudo cp config/downloads-organizer.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable downloads-organizer
sudo systemctl start downloads-organizer
```

## Configuration

### Customizing File Categories
Edit `src/organize_downloads_cron.py` and modify the `CATEGORIES` dictionary:

```python
CATEGORIES = {
    'Documents': ['.pdf', '.doc', '.docx', '.txt', ...],
    'Images': ['.jpg', '.jpeg', '.png', ...],
    # Add or modify categories as needed
}
```

### Logging Configuration
Logs are saved to:
- Organizer: `~/.hermes/downloads_organizer.log`
- Watcher: `/tmp/downloads_watcher.log`

To change log location or level, modify the logging configuration in the Python files.

## Troubleshooting

### Common Issues

#### 1. "Permission denied" errors
```bash
chmod +x scripts/*.sh src/*.py
```

#### 2. inotifywait not found
```bash
sudo apt-get install inotify-tools  # Debian/Ubuntu
sudo yum install inotify-tools      # RHEL/CentOS
```

#### 3. Python not found
```bash
sudo apt-get install python3  # Debian/Ubuntu
```

#### 4. Files not being organized
- Check log files for errors
- Verify the script has execute permissions
- Ensure Python can access the Downloads folder

### Debug Mode
Run with verbose output:
```bash
python3 -c "import logging; logging.basicConfig(level=logging.DEBUG); import sys; sys.path.insert(0, 'src'); from organize_downloads_cron import organize_downloads; organize_downloads()"
```

## Development

### Adding New Features
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Testing
```bash
./scripts/test_organizer.sh
```

### Code Style
- Follow PEP 8 for Python code
- Use meaningful variable names
- Add docstrings to functions
- Include error handling

## API Reference

### `organize_downloads()`
Main organization function.

**Parameters:** None

**Returns:** `bool` - True if files were moved, False otherwise

**Raises:** Various file system exceptions

### `get_category(file_extension)`
Determine category for a file extension.

**Parameters:**
- `file_extension` (str): File extension including dot (e.g., '.pdf')

**Returns:** `str` - Category name

### `cleanup_empty_folders()`
Remove empty category folders (optional).

**Parameters:** None

**Returns:** None

---

## License
MIT License - See LICENSE file for details.

## Support
For issues and questions, please open an issue on GitHub.