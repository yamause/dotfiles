#!/bin/bash
# init-work-journal.sh - Initialize work journal directory if not exists

PROJECT_ROOT="${1:-.}"

# Create work-journal directory if it doesn't exist
if [[ ! -d "$PROJECT_ROOT/work-journal" ]]; then
    mkdir -p "$PROJECT_ROOT/work-journal"
    echo "*" > "$PROJECT_ROOT/work-journal/.gitignore"
    echo "✓ Created work-journal directory with .gitignore"
    exit 0
fi

# Check if there are existing journal files
JOURNAL_COUNT=$(find "$PROJECT_ROOT/work-journal" -name "*.md" -type f 2>/dev/null | wc -l)
if [[ $JOURNAL_COUNT -gt 0 ]]; then
    echo "ℹ️  Found $JOURNAL_COUNT existing journal file(s) in work-journal/"
    echo "   Consider reviewing them for context on previous work."
fi

exit 0
