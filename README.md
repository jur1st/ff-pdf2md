# FF-PDF2MD Suite

This suite of shell scripts is designed to process PDF documents, perform OCR, and convert them into Markdown format. The scripts then consolidate page-level Markdown files into document-level files and finally concatenate all documents into a single text file with XML delimiters for use with language models like GPT-4.

## Prerequisites

Before using these scripts, ensure you have the following installed on your system:

-   **Homebrew**: Package manager for macOS. Install it from [brew.sh](https://brew.sh/).
-   **Python**: Install via Homebrew if not already available:
  ```bash
  brew install python
  ```
-   **Tesseract**: OCR engine for extracting text from images.
  ```bash
  brew install tesseract
  ```
-   **Poppler**: Utilities for converting PDF files to images.
  ```bash
  brew install poppler
  ```
-   **Pandoc**: Universal document converter for converting text to Markdown.
  ```bash
  brew install pandoc
  ```
-   **tiktoken**: Tokenizer for calculating tokens for language models.
  ```bash
  pip install tiktoken
  ```

## Script Overview

### 1. FF-PDF2MD.sh

This script converts PDF files into page-level Markdown files using OCR.

-   **Usage**:
  ```bash
  ./FF-PDF2MD.sh /path/to/pdf_directory
  ```
-   **Output**: Generates a `markdown_output` directory with Markdown files for each page of each PDF.

### 2. FF-MDConsolidate.sh

This script consolidates page-level Markdown files into document-level Markdown files.

-   **Usage**:
  ```bash
  ./FF-MDConsolidate.sh /path/to/markdown_output
  ```
-   **Output**: Creates a `consolidated_documents` directory with a single Markdown file for each document.

### 3. FF-DocConcat.sh

This script concatenates all document-level Markdown files into a single text file with XML delimiters and calculates the total number of tokens.

-   **Usage**:
  ```bash
  ./FF-DocConcat.sh /path/to/consolidated_documents
  ```
-   **Output**: Produces a `concatenated_documents.txt` file and prints the total token count.

## Future Improvements

-   **Directory Handling**: Improve the handling of nested directories to streamline the process and reduce complexity.
-   **Error Handling**: Enhance error handling to provide more informative feedback and ensure robustness.
-   **Configuration**: Introduce configuration options for easier customization and flexibility.

## Credits

Built by accident by John Benson. Another fine Darko Labs release. 

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue to discuss improvements or report bugs.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
