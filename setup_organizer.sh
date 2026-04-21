#!/bin/bash
# Downloads Organizer Setup Script
# Located in ~/Projects/downloads-organizer/

echo "========================================="
echo "  DOWNLOADS FOLDER ORGANIZER SETUP"
echo "========================================="
echo "Project location: ~/Projects/downloads-organizer/"
echo ""

# Check if Python is available
PYTHON_PATH=$(which python3)
if [ -z "$PYTHON_PATH" ]; then
    echo "ERROR: Python3 is not installed or not in PATH"
    exit 1
fi

PROJECT_PATH="$HOME/Projects/downloads-organizer"
ORGANIZER_SCRIPT="$PROJECT_PATH/organize_downloads_cron.py"

echo "Python found: $PYTHON_PATH"
echo "Project path: $PROJECT_PATH"
echo ""

# Check if organizer scripts exist
if [ ! -f "$ORGANIZER_SCRIPT" ]; then
    echo "ERROR: Organizer script not found at $ORGANIZER_SCRIPT"
    exit 1
fi

echo "Available organization methods:"
echo "1. Real-time watcher (runs whenever new files are added)"
echo "2. Daily cron job (runs at 6:00 PM daily)"
echo "3. Hourly cron job (runs every hour)"
echo "4. Weekly cron job (runs every Sunday at 9:00 AM)"
echo "5. Manual setup (I'll show you the commands)"
echo ""

read -p "Choose an option (1-5): " choice
echo ""

case $choice in
    1)
        echo "Setting up real-time watcher..."
        echo ""
        
        # Check if inotifywait is installed
        if ! command -v inotifywait &> /dev/null; then
            echo "Installing inotify-tools..."
            sudo apt-get update && sudo apt-get install -y inotify-tools
        fi
        
        # Make sure watcher script exists
        WATCHER_SCRIPT="$PROJECT_PATH/watch_downloads.sh"
        if [ ! -f "$WATCHER_SCRIPT" ]; then
            echo "ERROR: Watcher script not found at $WATCHER_SCRIPT"
            exit 1
        fi
        
        echo "Starting watcher in the background..."
        nohup "$WATCHER_SCRIPT" > /tmp/downloads_watcher.log 2>&1 &
        
        echo ""
        echo "Watcher started! It will run in the background."
        echo "To check logs: tail -f /tmp/downloads_watcher.log"
        echo "To stop: pkill -f watch_downloads.sh"
        echo ""
        echo "To run automatically on startup, add this to your ~/.bashrc:"
        echo "  nohup $PROJECT_PATH/watch_downloads.sh > /tmp/downloads_watcher.log 2>&1 &"
        ;;
    
    2)
        echo "Setting up daily cron job (6:00 PM)..."
        echo ""
        
        CRON_JOB="0 18 * * * $PYTHON_PATH $ORGANIZER_SCRIPT"
        (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
        
        echo "Cron job added: $CRON_JOB"
        echo ""
        echo "To view cron jobs: crontab -l"
        echo "To edit: crontab -e"
        echo "Logs: ~/.hermes/downloads_organizer.log"
        ;;
    
    3)
        echo "Setting up hourly cron job..."
        echo ""
        
        CRON_JOB="0 * * * * $PYTHON_PATH $ORGANIZER_SCRIPT"
        (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
        
        echo "Cron job added: $CRON_JOB"
        echo ""
        echo "To view cron jobs: crontab -l"
        echo "To edit: crontab -e"
        echo "Logs: ~/.hermes/downloads_organizer.log"
        ;;
    
    4)
        echo "Setting up weekly cron job (Sunday 9:00 AM)..."
        echo ""
        
        CRON_JOB="0 9 * * 0 $PYTHON_PATH $ORGANIZER_SCRIPT"
        (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
        
        echo "Cron job added: $CRON_JOB"
        echo ""
        echo "To view cron jobs: crontab -l"
        echo "To edit: crontab -e"
        echo "Logs: ~/.hermes/downloads_organizer.log"
        ;;
    
    5)
        echo "MANUAL SETUP INSTRUCTIONS"
        echo "========================="
        echo "Project location: ~/Projects/downloads-organizer/"
        echo ""
        echo "1. Test the organizer script:"
        echo "   python3 ~/Projects/downloads-organizer/organize_downloads_cron.py"
        echo ""
        echo "2. To run manually anytime (interactive):"
        echo "   python3 ~/Projects/downloads-organizer/organize_downloads.py"
        echo ""
        echo "3. To add a cron job (edit schedule as needed):"
        echo "   crontab -e"
        echo "   Add this line for daily at 6 PM:"
        echo "   0 18 * * * $(which python3) $HOME/Projects/downloads-organizer/organize_downloads_cron.py"
        echo ""
        echo "4. To run real-time watcher:"
        echo "   ~/Projects/downloads-organizer/watch_downloads.sh"
        echo "   (Run in background: nohup ~/Projects/downloads-organizer/watch_downloads.sh &)"
        echo ""
        echo "5. Log files:"
        echo "   - Organizer logs: ~/.hermes/downloads_organizer.log"
        echo "   - Watcher logs: /tmp/downloads_watcher.log"
        echo ""
        echo "6. Quick commands from anywhere:"
        echo "   alias organize-downloads='python3 ~/Projects/downloads-organizer/organize_downloads.py'"
        echo "   alias watch-downloads='nohup ~/Projects/downloads-organizer/watch_downloads.sh &'"
        ;;
    
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo ""
echo "========================================="
echo "           SETUP COMPLETE!"
echo "========================================="
echo ""
echo "Your Downloads folder will now be automatically organized."
echo "Project files are in: ~/Projects/downloads-organizer/"
echo ""
echo "You can always run the organizer manually with:"
echo "  python3 ~/Projects/downloads-organizer/organize_downloads.py"
echo ""
echo "Or use the interactive version:"
echo "  python3 ~/Projects/downloads-organizer/organize_downloads.py"
echo ""