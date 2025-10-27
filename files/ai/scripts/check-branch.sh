#!/bin/bash
# check-branch.sh - Check if committing to main/master branch

# Exit if not in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    exit 0
fi

# Get current branch name
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

# Check if on main or master branch
if [[ "$BRANCH" == "main" || "$BRANCH" == "master" ]]; then
    echo "⚠️  Warning: You are about to commit to the '$BRANCH' branch."
    echo "   Consider creating a feature branch for this work session."
    echo "   To continue anyway, proceed with the commit."
    # Return non-zero to block the commit (user can override if needed)
    exit 1
fi

exit 0
