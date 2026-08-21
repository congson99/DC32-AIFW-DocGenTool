#!/bin/bash
# Blocks edits to framework files when edit_framework is not YES.

INPUT=$(cat)

FILE_PATH=$(printf '%s' "$INPUT" | sed -nE 's/.*"file_path"[[:space:]]*:[[:space:]]*"((\\.|[^"\\])*)".*/\1/p')

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Normalize JSON-escaped backslashes (Windows paths, e.g. C:\\Users\\...) to
# forward slashes so the patterns below match regardless of which OS emitted
# the path.
FILE_PATH="${FILE_PATH//\\\\//}"

PROTECTED=("framework/" ".claude/" "CLAUDE.md" "README.md" ".gitignore")

IS_PROTECTED=false
for pattern in "${PROTECTED[@]}"; do
  if [[ "$FILE_PATH" == *"$pattern"* ]]; then
    IS_PROTECTED=true
    break
  fi
done

if [ "$IS_PROTECTED" = false ]; then
  exit 0
fi

CONFIG="framework/framework_config.md"
if [ ! -f "$CONFIG" ]; then
  exit 0
fi

if grep -qi "edit_framework.*yes" "$CONFIG"; then
  exit 0
fi

echo "You do not have permission to edit framework files."
exit 2
