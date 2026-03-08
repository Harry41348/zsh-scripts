#!/usr/bin/env zsh
# backup.sh
# Create a compressed, timestamped archive of a source directory.
#
# Usage: ./backup.sh <source_dir> [destination_dir]
#
# If destination_dir is omitted, the archive is placed in the current directory.

set -euo pipefail

usage() {
    echo "Usage: $0 <source_dir> [destination_dir]"
    exit 1
}

# ── Argument validation ───────────────────────────────────────────────────────
[[ $# -lt 1 ]] && usage

SOURCE_DIR="${1%/}"          # strip trailing slash
DEST_DIR="${2:-$PWD}"

[[ ! -d "$SOURCE_DIR" ]] && { echo "Error: '$SOURCE_DIR' is not a directory."; exit 1; }
[[ ! -d "$DEST_DIR"   ]] && { echo "Error: '$DEST_DIR' is not a directory.";   exit 1; }

# ── Build archive name ────────────────────────────────────────────────────────
BASENAME=$(basename "$SOURCE_DIR")
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE="${DEST_DIR}/${BASENAME}_${TIMESTAMP}.tar.gz"

# ── Create archive ────────────────────────────────────────────────────────────
echo "Backing up '${SOURCE_DIR}' → '${ARCHIVE}' ..."
tar -czf "$ARCHIVE" -C "$(dirname "$SOURCE_DIR")" "$BASENAME"

SIZE=$(du -sh "$ARCHIVE" | cut -f1)
echo "Done. Archive size: ${SIZE}"
echo "Saved to: ${ARCHIVE}"
