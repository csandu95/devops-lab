#!/bin/bash

set -euo pipefail

# In this project, you will build a tool to archive logs on a set schedule by compressing them and
# storing them in a new directory, this is especially useful for removing old logs and keeping the
# system clean while maintaining the logs in a compressed format for future reference.
# This project will help you practice your programming skills, including working with files and
# directories, and building a simple cli tool.

# The most common location for logs on a unix based system is /var/log.

# Requirements
# The tool should run from the command line, accept the log directory as an argument, compress the
# logs, and store them in a new directory. The user should be able to:

# Provide the log directory as an argument when running the tool.

# bash

# log-archive <log-directory>
# The tool should compress the logs in a tar.gz file and store them in a new directory.

# The tool should log the date and time of the archive to a file.

# bash

# logs_archive_20240816_100648.tar.gz
# You can learn more about the tar command here.

# If you are looking to build a more advanced version of this project, you can consider adding
# functionality to the tool like emailing the user updates on the archive, or sending the archive to
# a remote server or cloud storage.

LOG_DIR="$1"
ARCHIVE_LOG="archive_log.txt"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_NAME="logs_archive_${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="./${ARCHIVE_NAME}"

function usage() {
    echo "Usage: $0 <log-directory>"
    echo "Archives the specified log directory into a tar.gz file."
    echo
    echo "Options:"
    echo "  -h, --help    Show this help message and exit"
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
fi

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run with sudo or as root"
    exit 1
fi

if [ -z "$LOG_DIR" ]; then
    usage
    exit 1
fi

# Create tar.gz preserving relative paths under LOG_DIR
if ! tar -czf "${ARCHIVE_PATH}" -C "${LOG_DIR}" . ; then
    echo "Error: Failed to create archive."
    exit 1
fi

echo "Archiving completed. Archive created at: ${ARCHIVE_PATH}"