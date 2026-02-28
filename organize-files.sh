#!/usr/bin/env bash
# organize-files.sh
# Move files in a target directory into sub-directories named after their extension.
# Files without an extension are placed in an 'other/' sub-directory.
# Directories inside the target are left untouched.
#
# Usage: ./organize-files.sh [target_dir]
#
# Default target_dir: current directory (.)
#
# Pass --dry-run as the second argument to preview without moving files.

set -euo pipefail

TARGET="${1:-.}"
DRY_RUN=false
[[ "${2:-}" == "--dry-run" ]] && DRY_RUN=true

[[ ! -d "$TARGET" ]] && { echo "Error: '$TARGET' is not a directory."; exit 1; }

moved=0
skipped=0

while IFS= read -r -d '' file; do
    filename=$(basename "$file")
    ext="${filename##*.}"

    # Treat files with no real extension (hidden files, no dot, or name == ext) as 'other'
    if [[ "$ext" == "$filename" || "$filename" == .* && "$ext" == "${filename#.}" ]]; then
        ext="other"
    fi
    ext=$(echo "$ext" | tr '[:upper:]' '[:lower:]')

    dest_dir="${TARGET}/${ext}"
    dest_file="${dest_dir}/${filename}"

    # Skip if file would overwrite an existing file with the same name
    if [[ -e "$dest_file" ]]; then
        echo "SKIP (exists): $file → ${dest_file}"
        ((skipped++)) || true
        continue
    fi

    if $DRY_RUN; then
        echo "MOVE (dry-run): $file → ${dest_dir}/"
    else
        mkdir -p "$dest_dir"
        mv "$file" "$dest_dir/"
        echo "MOVE: $file → ${dest_dir}/"
    fi
    ((moved++)) || true

done < <(find "$TARGET" -maxdepth 1 -type f -print0)

echo "-----------------------------"
if $DRY_RUN; then
    echo "Dry run complete. ${moved} file(s) would be moved, ${skipped} skipped."
else
    echo "Done. ${moved} file(s) moved, ${skipped} skipped."
fi
