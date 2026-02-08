#!/bin/bash

# Generate MD5 checksum for release package
# Usage: ./generate-checksum.sh NextEpisodeDelay-v1.0.0.zip

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <plugin-zip-file>"
    echo "Example: $0 NextEpisodeDelay-v1.0.0.zip"
    exit 1
fi

FILE="$1"

if [ ! -f "$FILE" ]; then
    echo "Error: File '$FILE' not found"
    exit 1
fi

echo "Generating MD5 checksum for $FILE..."
MD5SUM=$(md5sum "$FILE" | awk '{print $1}')

echo ""
echo "✓ MD5 Checksum: $MD5SUM"
echo ""
echo "Update manifest.json with this checksum:"
echo "  \"checksum\": \"$MD5SUM\""
