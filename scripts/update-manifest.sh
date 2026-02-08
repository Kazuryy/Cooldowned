#!/bin/bash

# Update manifest.json with new version
# Usage: ./update-manifest.sh <version> <zip-file>

set -e

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <version> <zip-file>"
    echo "Example: $0 1.0.0 NextEpisodeDelay-v1.0.0.zip"
    exit 1
fi

VERSION="$1"
ZIP_FILE="$2"
MANIFEST="manifest.json"

if [ ! -f "$ZIP_FILE" ]; then
    echo "Error: File '$ZIP_FILE' not found"
    exit 1
fi

if [ ! -f "$MANIFEST" ]; then
    echo "Error: manifest.json not found"
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed"
    echo "Install with: sudo apt install jq"
    exit 1
fi

# Generate checksum
CHECKSUM=$(md5sum "$ZIP_FILE" | awk '{print $1}')
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
SOURCE_URL="https://github.com/kazury/Cooldowned/releases/download/v${VERSION}/${ZIP_FILE}"

echo "Updating manifest.json..."
echo "  Version: $VERSION"
echo "  Checksum: $CHECKSUM"
echo "  Timestamp: $TIMESTAMP"
echo "  Source URL: $SOURCE_URL"

# Read changelog from CHANGELOG.md (extract version section)
CHANGELOG="See CHANGELOG.md for details"

# Update manifest.json
# Add new version at the beginning of the versions array
jq --arg version "$VERSION" \
   --arg checksum "$CHECKSUM" \
   --arg timestamp "$TIMESTAMP" \
   --arg url "$SOURCE_URL" \
   --arg changelog "$CHANGELOG" \
   '.[0].versions = [{
      "version": $version,
      "changelog": $changelog,
      "targetAbi": "10.11.0.0",
      "sourceUrl": $url,
      "checksum": $checksum,
      "timestamp": $timestamp
   }] + .[0].versions' \
   "$MANIFEST" > "${MANIFEST}.tmp" && mv "${MANIFEST}.tmp" "$MANIFEST"

echo ""
echo "✓ manifest.json updated successfully!"
echo ""
echo "Next steps:"
echo "  1. Review the changes: git diff manifest.json"
echo "  2. Commit: git add manifest.json && git commit -m 'Release v$VERSION'"
echo "  3. Push: git push origin main"
