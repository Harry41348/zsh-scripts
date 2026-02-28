#!/usr/bin/env bash
# find-large-files.sh
# Find the largest files under a given directory, sorted by size (descending).
#
# Usage: ./find-large-files.sh [directory] [top_n] [min_size]
#
# Defaults:
#   directory  = current directory (.)
#   top_n      = 20
#   min_size   = 1M

set -euo pipefail

DIR="${1:-.}"
TOP_N="${2:-20}"
MIN_SIZE="${3:-1M}"

[[ ! -d "$DIR" ]] && { echo "Error: '$DIR' is not a directory."; exit 1; }

echo "Top ${TOP_N} files >= ${MIN_SIZE} under '${DIR}':"
echo "------------------------------------------------------------"

results=$(find "$DIR" -type f -size +"${MIN_SIZE}" -printf '%s\t%p\n' 2>/dev/null \
    | sort -rn \
    | head -n "$TOP_N" \
    | awk '{
        size = $1
        path = $2
        if (size >= 1073741824)
            printf "%.2f GB\t%s\n", size/1073741824, path
        else if (size >= 1048576)
            printf "%.2f MB\t%s\n", size/1048576, path
        else if (size >= 1024)
            printf "%.2f KB\t%s\n", size/1024, path
        else
            printf "%d B\t%s\n", size, path
    }' || true)

if [[ -z "$results" ]]; then
    echo "No files found matching the criteria."
else
    echo "$results"
fi
