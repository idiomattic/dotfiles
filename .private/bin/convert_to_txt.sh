#!/usr/bin/env bash

input_dir=""
output_dir=""
extension_filter=""
include_all=false
show_help=false

show_usage() {
    echo "Usage: p export-for-claude-project [OPTIONS]"
    echo ""
    echo "Convert files to .txt extension while respecting git ignore rules."
    echo ""
    echo "Options:"
    echo "  -i, --input PATH      Input directory (required)"
    echo "  -o, --output PATH     Output directory (required)"
    echo "  -e, --extension EXT   Filter by file extension (e.g., 'py', '.js')"
    echo "  -a, --all            Include hidden files and files ignored by git"
    echo "  -h, --help           Show this help message"
    echo ""
    echo "Examples:"
    echo "  p export-for-claude-project -i /path/to/source -o /path/to/dest"
    echo "  p export-for-claude-project --input ./src --output ./txt --extension py"
    echo "  p export-for-claude-project -i . -o ../output -e .js -a"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -i|--input)
            if [[ -n "$2" && ! "$2" =~ ^- ]]; then
                input_dir="$2"
                shift 2
            else
                echo "Error: --input requires a path argument"
                exit 1
            fi
            ;;
        -o|--output)
            if [[ -n "$2" && ! "$2" =~ ^- ]]; then
                output_dir="$2"
                shift 2
            else
                echo "Error: --output requires a path argument"
                exit 1
            fi
            ;;
        -e|--extension)
            if [[ -n "$2" && ! "$2" =~ ^- ]]; then
                extension_filter="$2"
                shift 2
            else
                echo "Error: --extension requires an extension argument"
                exit 1
            fi
            ;;
        -a|--all)
            include_all=true
            shift
            ;;
        -h|--help)
            show_help=true
            shift
            ;;
        *)
            echo "Error: Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

if [[ "$show_help" == true ]]; then
    show_usage
    exit 0
fi

if [[ -z "$input_dir" ]]; then
    echo "Error: Input directory is required"
    echo "Use -h or --help for usage information"
    exit 1
fi

if [[ -z "$output_dir" ]]; then
    echo "Error: Output directory is required"
    echo "Use -h or --help for usage information"
    exit 1
fi

if [ ! -d "$input_dir" ]; then
    echo "Error: Input directory '$input_dir' does not exist"
    exit 1
fi

if [ ! -d "$output_dir" ]; then
    mkdir -p "$output_dir"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create output directory '$output_dir'"
        exit 1
    fi
fi

output_dir="$(cd "$output_dir" && pwd)"
if [ $? -ne 0 ]; then
    echo "Error: Failed to resolve output directory to absolute path"
    exit 1
fi

if [ -n "$extension_filter" ]; then
    extension_filter="${extension_filter#.}"
    extension_filter=".$extension_filter"
    echo "Filtering for files with extension: $extension_filter"
fi

if [ "$include_all" = true ]; then
    echo "Including all files (hidden files and git-ignored files)"
fi

matches_extension() {
    local file="$1"
    if [ -z "$extension_filter" ]; then
        return 0
    fi
    [[ "$file" == *"$extension_filter" ]]
}

original_pwd="$(pwd)"
cd "$input_dir" || exit 1

if ! command -v git >/dev/null 2>&1 || ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "Note: Not in a git repository or git not available, processing all files"
    find . -type f | while read -r file; do
        file="${file#./}"

        if ! matches_extension "$file"; then
            continue
        fi

        full_file_path="$(pwd)/$file"
        output_filename_stem_dots="${file//\//.}"
        final_output_filename_txt="${output_filename_stem_dots}.txt"
        target_file_full_path="$output_dir/$final_output_filename_txt"

        cp "$full_file_path" "$target_file_full_path"
        if [ $? -eq 0 ]; then
            echo "Converted: $file -> $target_file_full_path"
        else
            echo "Error: Failed to convert $file"
        fi
    done
else
    # In a git repository
    if [ "$include_all" = true ]; then
        # Include all files, even those ignored by git
        git ls-files --cached --others | while read -r file; do
            if [ -f "$file" ] && matches_extension "$file"; then
                full_file_path="$(pwd)/$file"
                output_filename_stem_dots="${file//\//.}"
                final_output_filename_txt="${output_filename_stem_dots}.txt"
                target_file_full_path="$output_dir/$final_output_filename_txt"

                cp "$full_file_path" "$target_file_full_path"
                if [ $? -eq 0 ]; then
                    echo "Converted: $file -> $target_file_full_path"
                else
                    echo "Error: Failed to convert $file"
                fi
            fi
        done
    else
        # Respect git ignore rules (default behavior)
        git ls-files --cached --others --exclude-standard | while read -r file; do
            if [ -f "$file" ] && matches_extension "$file"; then
                full_file_path="$(pwd)/$file"
                output_filename_stem_dots="${file//\//.}"
                final_output_filename_txt="${output_filename_stem_dots}.txt"
                target_file_full_path="$output_dir/$final_output_filename_txt"

                cp "$full_file_path" "$target_file_full_path"
                if [ $? -eq 0 ]; then
                    echo "Converted: $file -> $target_file_full_path"
                else
                    echo "Error: Failed to convert $file"
                fi
            fi
        done
    fi
fi

cd "$original_pwd"