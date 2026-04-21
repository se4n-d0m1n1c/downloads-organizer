#!/bin/bash
# Setup script for Downloads folder organizer cron job
# Located in ~/Projects/downloads-organizer/

echo "Setting up automatic Downloads folder organizer..."
echo "Project location: ~/Projects/downloads-organizer/"
echo ""

# Get the full path to the organizer script
PROJECT_PATH="$HOME/Projects/downloads-organizer"
ORGANIZER_SCRIPT="$PROJECT_PATH/organize_downloads_cron.py"
PYTHON_PATH=$(which python3)

if [ ! -f "$ORGANIZER_SCRIPT" ]; then
    echo "Error: Organizer script not found at $ORGANIZER_SCRIPT"
    exit 1
fi

if [ -z "$PYTHON_PATH" ]; then
    echo "Error: python3 not found in PATH"
    exit 1
fi

echo "Python path: $PYTHON_PATH"
echo "Project path: $PROJECT_PATH"
echo "Organizer script: $ORGANIZER_SCRIPT"
echo ""

# Create the cron job entry
CRON_JOB="0 18 * * * $PYTHON_PATH $ORGANIZER_SCRIPT"

echo "The following cron job will be added:"
echo "$CRON_JOB"
echo ""

read -p "Do you want to proceed? (y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Add to crontab
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    
    if [ $? -eq 0 ]; then
        echo "Cron job added successfully!"
        echo ""
        echo "The organizer will run daily at 6:00 PM."
        echo "Logs are saved to: $HOME/.hermes/downloads_organizer.log"
        echo ""
        echo "To view your cron jobs: crontab -l"
        echo "To edit your cron jobs: crontab -e"
        echo "To remove this cron job: crontab -e (then delete the line)"
    else
        echo "Failed to add cron job."
        exit 1
    fi
else
    echo "Setup cancelled."
fi