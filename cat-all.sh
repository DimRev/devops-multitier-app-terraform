#!/bin/bash
MODULES_DIR="modules"

# Recursively iterate over each directory within the modules folder (sorted)
find "$MODULES_DIR" -type d | sort | while read -r dir; do
  echo "===== Directory: $dir ====="

  # Loop through each file in the current directory
  for file in "$dir"/*; do
    if [ -f "$file" ]; then
      echo "----- File: $file -----"
      cat "$file"
      echo "----- End of $file -----"
      echo ""
    fi
  done

  echo "===== End of Directory: $dir ====="
  echo ""
done
