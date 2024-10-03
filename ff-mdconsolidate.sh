#!/bin/bash

# FF-MDConsolidate.sh
# This script consolidates page-level Markdown files into document-level Markdown files.
# Each document-level file corresponds to an original PDF file.

# Usage:
# 1. Place this script in the directory containing the `markdown_output` directory.
# 2. Ensure the script is executable by running: chmod +x FF-MDConsolidate.sh
# 3. Run the script with the path to the `markdown_output` directory as an argument:
#    ./FF-MDConsolidate.sh /path/to/markdown_output

# Check if input directory is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <markdown_output_directory>"
  exit 1
fi

INPUT_DIR="$1"
OUTPUT_DIR="${INPUT_DIR}/consolidated_documents"
mkdir -p "$OUTPUT_DIR"

# Find all unique document bases by stripping the page number and extension
document_bases=($(ls "$INPUT_DIR" | sed -E 's/-[0-9]+\.md$//' | sort -u))

total_pages=0
total_documents=0

echo "Found ${#document_bases[@]} unique documents to consolidate."

# Consolidate each document
for base in "${document_bases[@]}"; do
  echo "Consolidating document: $base"

  # Create a consolidated Markdown file
  consolidated_file="$OUTPUT_DIR/$base.md"
  touch "$consolidated_file"

  # Append each page's content to the consolidated file
  page_count=0
  for page_file in "$INPUT_DIR/$base"-*.md; do
	if [ -f "$page_file" ]; then
	  cat "$page_file" >> "$consolidated_file"
	  echo -e "\n\n---\n\n" >> "$consolidated_file"  # Add a separator between pages
	  ((page_count++))
	else
	  echo "Warning: No files found for base $base"
	fi
  done

  echo "Created consolidated document: $consolidated_file with $page_count pages."
  total_pages=$((total_pages + page_count))
  ((total_documents++))
done

echo "Consolidation complete. Document-level Markdown files are located in $OUTPUT_DIR."
echo "Statistics: Consolidated $total_pages pages into $total_documents documents."
