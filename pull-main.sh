#!/usr/bin/env zsh

# Script to pull latest main branch and rebase/merge current branch onto it

# Exit on error
set -e

# Default operation is rebase
operation="rebase"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -m|--merge)
            operation="merge"
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -m, --merge    Use merge instead of rebase"
            echo "  -h, --help     Show this help message"
            echo ""
            echo "Default behavior: rebase current branch onto main"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Save the current branch name
current_branch=$(git branch --show-current)

# Check for uncommitted changes
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "Error: You have uncommitted changes. Please commit or stash them before running this script."
    exit 1
fi

# Check if we're already on main
if [ "$current_branch" = "main" ] || [ "$current_branch" = "master" ]; then
    echo "Already on main/master branch. Just pulling..."
    git pull
    exit 0
fi

echo "Current branch: $current_branch"
echo "Switching to main branch..."

# Checkout main branch (try main first, fall back to master)
if git show-ref --verify --quiet refs/heads/main; then
    main_branch="main"
elif git show-ref --verify --quiet refs/heads/master; then
    main_branch="master"
else
    echo "Error: Neither 'main' nor 'master' branch found"
    exit 1
fi

git checkout "$main_branch"

echo "Pulling latest changes..."
git pull

echo "Switching back to $current_branch..."
git checkout "$current_branch"

if [ "$operation" = "rebase" ]; then
    echo "Rebasing $current_branch onto $main_branch..."
    git rebase "$main_branch"
    echo "✓ Successfully rebased $current_branch onto $main_branch"
else
    echo "Merging $main_branch into $current_branch..."
    git merge "$main_branch"
    echo "✓ Successfully merged $main_branch into $current_branch"
fi
