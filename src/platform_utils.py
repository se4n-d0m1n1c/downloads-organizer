#!/usr/bin/env python3
"""
Platform detection and path utilities for cross-platform compatibility.
"""

import os
import sys
import platform
from pathlib import Path


def get_platform():
    """Get the current operating system platform."""
    system = platform.system().lower()
    
    if system == 'windows':
        return 'windows'
    elif system == 'darwin':
        return 'macos'
    elif system == 'linux':
        return 'linux'
    else:
        return 'unknown'


def get_downloads_path():
    """Get the Downloads folder path for the current platform."""
    home = Path.home()
    platform_name = get_platform()
    
    if platform_name == 'windows':
        # Windows Downloads folder
        downloads = home / 'Downloads'
        # Also check OneDrive Downloads if it exists
        onedrive_downloads = home / 'OneDrive' / 'Downloads'
        if onedrive_downloads.exists():
            return onedrive_downloads
        return downloads
    elif platform_name == 'macos':
        # macOS Downloads folder
        return home / 'Downloads'
    else:
        # Linux and other Unix-like systems
        return home / 'Downloads'


def get_config_path():
    """Get the configuration/log file path for the current platform."""
    home = Path.home()
    platform_name = get_platform()
    
    if platform_name == 'windows':
        # Windows: Use AppData/Local
        appdata = os.environ.get('LOCALAPPDATA', home / 'AppData' / 'Local')
        config_dir = Path(appdata) / 'DownloadsOrganizer'
    elif platform_name == 'macos':
        # macOS: Use Library/Application Support
        config_dir = home / 'Library' / 'Application Support' / 'DownloadsOrganizer'
    else:
        # Linux and other Unix-like systems: Use ~/.config
        config_dir = home / '.config' / 'downloads-organizer'
    
    # Create directory if it doesn't exist
    config_dir.mkdir(parents=True, exist_ok=True)
    return config_dir


def get_log_file():
    """Get the log file path."""
    config_dir = get_config_path()
    return config_dir / 'downloads_organizer.log'


def is_windows():
    """Check if running on Windows."""
    return get_platform() == 'windows'


def is_linux():
    """Check if running on Linux."""
    return get_platform() == 'linux'


def is_macos():
    """Check if running on macOS."""
    return get_platform() == 'macos'


if __name__ == "__main__":
    # Test the functions
    print(f"Platform: {get_platform()}")
    print(f"Downloads path: {get_downloads_path()}")
    print(f"Config path: {get_config_path()}")
    print(f"Log file: {get_log_file()}")
    print(f"Is Windows: {is_windows()}")
    print(f"Is Linux: {is_linux()}")
    print(f"Is macOS: {is_macos()}")