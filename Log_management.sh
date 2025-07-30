#!/bin/bash

# Set directory path - by default current directory
DIR_PATH="."

# Create a timestamp file for logging
LOG_FILE="file_maintenance_$(date +%Y%m%d).log"

echo "Starting file maintenance script at $(date)" > "$LOG_FILE"

# Function to check if required commands exist
check_requirements() {
    if ! command -v zip &> /dev/null; then
        echo "Error: zip command not found. Please install zip package." | tee -a "$LOG_FILE"
        exit 1
    fi
}

# Function to delete files older than 60 days
delete_old_files() {
    echo "Deleting files older than 60 days..." | tee -a "$LOG_FILE"
    find "$DIR_PATH" -type f -mtime +60 -exec ls -l {} \; >> "$LOG_FILE" 2>&1
    find "$DIR_PATH" -type f -mtime +60 -exec rm {} \; 2>> "$LOG_FILE"
}

# Function to zip files older than 30 days but younger than 60 days
zip_old_files() {
    echo "Zipping files older than 30 days..." | tee -a "$LOG_FILE"
    
    # Create archive directory if it doesn't exist
    ARCHIVE_DIR="$DIR_PATH/archived_files"
    mkdir -p "$ARCHIVE_DIR"
    
    # Create zip file with timestamp
    ZIP_FILE="$ARCHIVE_DIR/archive_$(date +%Y%m%d).zip"
    
    # Find and zip files
    find "$DIR_PATH" -type f -mtime +30 -not -mtime +60 -print0 | \
    while IFS= read -r -d $'\0' file; do
        if [[ "$file" != *"archived_files"* ]]; then  # Exclude archive directory
            zip -u "$ZIP_FILE" "$file" >> "$LOG_FILE" 2>&1
            echo "Zipped: $file" >> "$LOG_FILE"
        fi
    done
}

# Main execution
echo "File maintenance script started"
check_requirements

# Execute the functions
delete_old_files
zip_old_files

echo "Script completed at $(date)" | tee -a "$LOG_FILE"
#39;\0' file; do
        if [[ "$file" != *"archived_files"* ]]; then  # Exclude archive directory
            zip -u "$ZIP_FILE" "$file" >> "$LOG_FILE" 2>&1
            echo "Zipped: $file" >> "$LOG_FILE"
        fi
    done
}

# Main execution
echo "File maintenance script started"
check_requirements

# Execute the functions
delete_old_files
zip_old_files

echo "Script completed at $(date)" | tee -a "$LOG_FILE"
