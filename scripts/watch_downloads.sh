#!/bin/bash
# Downloads folder watcher - runs organizer whenever new files are added
# Located in ~/Projects/downloads-organizer/

DOWNLOAD_PATH="$HOME/Downloads"
PROJECT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ORGANIZER_SCRIPT="$PROJECT_PATH/src/organize_downloads_cron.py"
LOG_FILE="$HOME/.hermes/downloads_watcher.log"
PYTHON_PATH=$(which python3)

# Check if organizer script exists
if [ ! -f "$ORGANIZER_SCRIPT" ]; then
    echo "Error: Organizer script not found at $ORGANIZER_SCRIPT" | tee -a "$LOG_FILE"
    exit 1
fi

if [ -z "$PYTHON_PATH" ]; then
    echo "Error: python3 not found in PATH" | tee -a "$LOG_FILE"
    exit 1
fi

echo "Starting Downloads folder watcher..." | tee -a "$LOG_FILE"
echo "Project location: $PROJECT_PATH" | tee -a "$LOG_FILE"
echo "Watching: $DOWNLOAD_PATH" | tee -a "$LOG_FILE"
echo "Organizer: $ORGANIZER_SCRIPT" | tee -a "$LOG_FILE"
echo "Log file: $LOG_FILE" | tee -a "$LOG_FILE"
echo "Started at: $(date)" | tee -a "$LOG_FILE"
echo "----------------------------------------" | tee -a "$LOG_FILE"

# Function to run organizer
run_organizer() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] File change detected, running organizer..." | tee -a "$LOG_FILE"
    
    # Run organizer and capture output
    output=$($PYTHON_PATH "$ORGANIZER_SCRIPT" 2>&1)
    exit_code=$?
    
    echo "$output" | tee -a "$LOG_FILE"
    
    if [ $exit_code -eq 0 ]; then
        echo "[$timestamp] Organizer completed successfully" | tee -a "$LOG_FILE"
    else
        echo "[$timestamp] Organizer failed with exit code: $exit_code" | tee -a "$LOG_FILE"
    fi
    echo "----------------------------------------" | tee -a "$LOG_FILE"
}

# Initial organization run
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Running initial organization..." | tee -a "$LOG_FILE"
initial_output=$($PYTHON_PATH "$ORGANIZER_SCRIPT" 2>&1)
echo "$initial_output" | tee -a "$LOG_FILE"
echo "----------------------------------------" | tee -a "$LOG_FILE"

# Watch for file creation, modification, and movement
inotifywait -m -r -e create -e moved_to -e close_write "$DOWNLOAD_PATH" |
while read -r directory events filename; do
    # Skip if it's a directory or one of our script files
    if [[ -d "$directory/$filename" ]]; then
        continue
    fi
    
    # Skip files in category folders (already organized)
    if [[ "$directory" == */Archives/* ]] || \
       [[ "$directory" == */Code/* ]] || \
       [[ "$directory" == */Documents/* ]] || \
       [[ "$directory" == */Fonts/* ]] || \
       [[ "$directory" == */Games/* ]] || \
       [[ "$directory" == */Images/* ]] || \
       [[ "$directory" == */Miscellaneous/* ]] || \
       [[ "$directory" == */Moot\ Court/* ]] || \
       [[ "$directory" == */Projects/* ]] || \
       [[ "$directory" == */Software/* ]] || \
       [[ "$directory" == */Videos/* ]] || \
       [[ "$directory" == */Audio/* ]] || \
       [[ "$directory" == */Ebooks/* ]]; then
        continue
    fi
    
    # Run organizer
    run_organizer
done