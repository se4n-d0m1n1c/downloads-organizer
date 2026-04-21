#!/bin/bash
# Test script for Downloads Organizer

echo "Testing Downloads Organizer..."
echo "Project: ~/Projects/downloads-organizer/"
echo ""

# Create test files in Downloads
echo "Creating test files..."
cd ~/Downloads
echo "Test PDF document" > test_file.pdf
echo "Test Python script" > test_script.py
echo "Test image content" > test_picture.jpg
echo "Test archive" > test_archive.zip
echo "Test document" > test_doc.txt

echo "Test files created:"
ls -la test_* 2>/dev/null || echo "No test files found (they may have been organized already)"

echo ""
echo "Running organizer..."
python3 ~/Projects/downloads-organizer/organize_downloads_cron.py

echo ""
echo "Checking where files were moved..."
echo ""

# Check each category
for category in Documents Code Images Archives; do
    if [ -f ~/Downloads/$category/test_* 2>/dev/null ]; then
        echo "Files in $category/:"
        ls -la ~/Downloads/$category/test_* 2>/dev/null
    fi
done

echo ""
echo "Cleaning up test files..."
rm -f ~/Downloads/Documents/test_* 2>/dev/null
rm -f ~/Downloads/Code/test_* 2>/dev/null
rm -f ~/Downloads/Images/test_* 2>/dev/null
rm -f ~/Downloads/Archives/test_* 2>/dev/null

echo ""
echo "Test complete!"