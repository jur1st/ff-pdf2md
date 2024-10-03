#!/bin/bash

# FF-DocConcat.sh
# This script concatenates document-level Markdown files into a single text file.
# Each document is wrapped with XML tags for clear delineation.
# It calculates the total number of tokens using tiktoken CLI for precision.

# Usage:
# 1. Place this script in the directory containing the consolidated documents.
# 2. Ensure the script is executable by running: chmod +x FF-DocConcat.sh
# 3. Run the script with the path to the consolidated documents directory as an argument:
#    ./FF-DocConcat.sh /path/to/consolidated_documents

# Check if input directory is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <consolidated_documents_directory>"
  exit 1
fi

INPUT_DIR="$1"
OUTPUT_FILE="${INPUT_DIR}/concatenated_documents.txt"

# Initialize the output file
echo "Creating concatenated document: $OUTPUT_FILE"
echo "" > "$OUTPUT_FILE"

# Process each Markdown file in the directory
for doc_file in "$INPUT_DIR"/*.md; do
  if [ -f "$doc_file" ]; then
	# Extract the base name for labeling
	base_name=$(basename "$doc_file" .md)
	
	# Add XML-style delimiters and content to the output file
	echo "<document id=\"$base_name\">" >> "$OUTPUT_FILE"
	cat "$doc_file" >> "$OUTPUT_FILE"
	echo -e "\n</document>\n" >> "$OUTPUT_FILE"
  fi
done

echo "Concatenation complete. The document is saved as $OUTPUT_FILE."

# Calculate the total number of tokens using tiktoken CLI
total_tokens=$(tiktoken -f "$OUTPUT_FILE" -m "gpt-4")
echo "Total tokens in the concatenated file: $total_tokens"
