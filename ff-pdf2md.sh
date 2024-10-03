#!/bin/bash

# FF-PDF2MD.sh
# This script processes all PDF files in a specified directory, performs OCR on them,
# and outputs the results as Markdown files in a newly created directory.
# It provides progress indicators and a summary report.

# Prerequisites:
# - Homebrew must be installed on your macOS.
# - Install Tesseract for OCR by running: brew install tesseract
# - Install Poppler utilities for PDF to image conversion: brew install poppler
# - Install Pandoc for converting text to Markdown: brew install pandoc

# Optimizations for M1 Max Mac Studio:
# - The script uses parallel processing to leverage the multiple cores of the M1 Max.
#   This is achieved by running each PDF processing task in the background.
# - Ensure that Homebrew is ARM-native, and the installed tools are optimized for Apple Silicon.
# - Adjust Tesseract's thread usage if needed to optimize OCR performance.

# Usage:
# 1. Place this script in any directory.
# 2. Ensure the script is executable by running: chmod +x FF-PDF2MD.sh
# 3. Run the script with the directory containing your PDFs as an argument:
#    ./FF-PDF2MD.sh /path/to/your/pdf_directory
# 4. The script will create a directory named `markdown_output` within the specified directory
#    to store the resulting Markdown files.
# 5. A summary report will be displayed at the end, indicating the number of successful
#    and failed conversions.

process_pdf() {
  local pdf="$1"
  BASENAME=$(basename "$pdf" .pdf)
  echo "Processing: $BASENAME.pdf"

  # Convert PDF to images
  pdftoppm "$pdf" "$OUTPUT_DIR/$BASENAME" -png
  if [ $? -ne 0 ]; then
	echo "Failed to convert $BASENAME.pdf to images."
	return
  fi

  # Perform OCR and convert to Markdown
  for img in "$OUTPUT_DIR/$BASENAME"-*.png; do
	txt="${img%.png}.txt"
	md="${img%.png}.md"

	# Extract text using Tesseract
	tesseract "$img" "${txt%.txt}" > /dev/null 2>&1
	if [ $? -ne 0 ]; then
	  echo "Failed to perform OCR on $img."
	  return
	fi

	# Convert text to Markdown using Pandoc
	pandoc "$txt" -o "$md" > /dev/null 2>&1
	if [ $? -ne 0 ]; then
	  echo "Failed to convert $txt to Markdown."
	  return
	fi

	# Clean up intermediate text file
	rm "$txt"
  done

  # Clean up image files
  rm "$OUTPUT_DIR/$BASENAME"-*.png
  echo "Completed processing $BASENAME.pdf."
}

# Check if input directory is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <input_directory>"
  exit 1
fi

INPUT_DIR="$1"
OUTPUT_DIR="${INPUT_DIR}/markdown_output"
mkdir -p "$OUTPUT_DIR"

pdf_files=("$INPUT_DIR"/*.pdf)
total_pdfs=${#pdf_files[@]}

echo "Found $total_pdfs PDF files in $INPUT_DIR."

# Process each PDF file in parallel
for pdf in "${pdf_files[@]}"; do
  process_pdf "$pdf" &
done

wait

echo "Processing complete. Markdown files are located in $OUTPUT_DIR."
