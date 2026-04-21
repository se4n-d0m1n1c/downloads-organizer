#!/usr/bin/env python3
"""
Downloads Folder Organizer - Cron Version
Located in ~/Projects/downloads-organizer/
Automatically organizes files in the Downloads folder by file type
Run this with cron for automatic organization
"""

import os
import shutil
import logging
from pathlib import Path

# Configure logging
log_file = Path.home() / '.hermes' / 'downloads_organizer.log'
log_file.parent.mkdir(exist_ok=True, parents=True)

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(str(log_file)),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

# Define file categories and their extensions
CATEGORIES = {
    'Documents': ['.pdf', '.doc', '.docx', '.txt', '.rtf', '.odt', '.xls', '.xlsx', '.ppt', '.pptx', '.md', '.csv'],
    'Images': ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.svg', '.webp', '.tiff', '.ico'],
    'Videos': ['.mp4', '.avi', '.mov', '.wmv', '.flv', '.mkv', '.webm', '.m4v'],
    'Archives': ['.zip', '.rar', '.7z', '.tar', '.gz', '.bz2', '.xz', '.tgz'],
    'Code': ['.py', '.js', '.html', '.css', '.java', '.cpp', '.c', '.h', '.php', '.rb', '.go', '.rs', '.ts', '.json', '.xml', '.yml', '.yaml', '.toml', '.ini', '.sh', '.bash'],
    'Software': ['.exe', '.msi', '.dmg', '.pkg', '.deb', '.rpm', '.apk', '.appimage'],
    'Fonts': ['.ttf', '.otf', '.woff', '.woff2', '.eot'],
    'Audio': ['.mp3', '.wav', '.flac', '.aac', '.ogg', '.m4a', '.wma'],
    'Ebooks': ['.epub', '.mobi', '.azw3'],
    'Miscellaneous': []  # For files that don't match any category
}

def get_category(file_extension):
    """Determine the category for a file based on its extension"""
    for category, extensions in CATEGORIES.items():
        if file_extension.lower() in extensions:
            return category
    return 'Miscellaneous'

def organize_downloads():
    """Main function to organize the Downloads folder"""
    downloads_path = Path.home() / 'Downloads'
    
    if not downloads_path.exists():
        logger.error(f"Downloads folder not found at {downloads_path}")
        return False
    
    logger.info(f"Starting automatic organization of {downloads_path}")
    
    # Create category folders if they don't exist
    for category in CATEGORIES.keys():
        category_path = downloads_path / category
        category_path.mkdir(exist_ok=True)
    
    # Track statistics
    stats = {category: 0 for category in CATEGORIES.keys()}
    stats['total_files'] = 0
    stats['moved_files'] = 0
    stats['skipped_files'] = 0
    
    # Process files in Downloads root (excluding category folders)
    for item in downloads_path.iterdir():
        if item.is_file():
            stats['total_files'] += 1
            file_extension = item.suffix
            
            category = get_category(file_extension)
            target_folder = downloads_path / category
            
            # Handle duplicate filenames
            target_path = target_folder / item.name
            counter = 1
            while target_path.exists():
                name_parts = item.stem, item.suffix
                new_name = f"{name_parts[0]}_{counter}{name_parts[1]}"
                target_path = target_folder / new_name
                counter += 1
            
            try:
                shutil.move(str(item), str(target_path))
                stats[category] += 1
                stats['moved_files'] += 1
                logger.info(f"Moved: {item.name} -> {category}/{target_path.name}")
            except Exception as e:
                stats['skipped_files'] += 1
                logger.error(f"Failed to move {item.name}: {e}")
    
    # Log summary
    logger.info("=" * 50)
    logger.info("AUTOMATIC ORGANIZATION SUMMARY")
    logger.info("=" * 50)
    logger.info(f"Total files found: {stats['total_files']}")
    logger.info(f"Files moved: {stats['moved_files']}")
    logger.info(f"Files skipped: {stats['skipped_files']}")
    logger.info("-" * 50)
    
    moved_any = False
    for category in sorted(CATEGORIES.keys()):
        if stats[category] > 0:
            logger.info(f"{category}: {stats[category]} files")
            moved_any = True
    
    if not moved_any and stats['total_files'] == 0:
        logger.info("No files to organize - Downloads folder is already clean!")
    
    logger.info("=" * 50)
    
    return moved_any

def main():
    """Main entry point for the cron/watcher organizer"""
    # Run organization automatically (no user input for cron)
    success = organize_downloads()
    
    if success:
        print(f"Organization completed successfully. Log saved to {log_file}")
    else:
        print(f"No files needed organization. Log saved to {log_file}")


if __name__ == "__main__":
    main()