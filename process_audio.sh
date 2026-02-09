#!/bin/bash

# Process all supported audio files in audio-files directory and output SRT files to output directory
AUDIO_DIR="/app/audio-files"
OUTPUT_DIR="/app/output"
MODEL="${MODEL:-large-v3-turbo}"
SUPPORTED_EXTENSIONS=("*.m4a" "*.mp4")

echo "Starting audio transcription..."
echo "Processing files from: $AUDIO_DIR"
echo "Using model: $MODEL"

# Build find command for supported extensions
find_args=(-type f)
for ext in "${SUPPORTED_EXTENSIONS[@]}"; do
    find_args+=(-o -name "$ext")
done
# Remove the first -o (which is invalid)
find_args=("${find_args[@]:1}")

# Count files
file_count=$(find "$AUDIO_DIR" "${find_args[@]}" | wc -l)
echo "Found $file_count audio files to process"

if [ $file_count -eq 0 ]; then
    echo "No audio files found in $AUDIO_DIR"
    exit 0
fi

# Process each audio file
find "$AUDIO_DIR" "${find_args[@]}" | while read audio_file; do
    if [ -f "$audio_file" ]; then
        filename=$(basename "$audio_file")
        echo "Processing: $filename"
        
        # Calculate relative path from AUDIO_DIR
        relative_path=$(realpath --relative-to="$AUDIO_DIR" "$audio_file")
        output_subdir="$OUTPUT_DIR/$(dirname "$relative_path")"
        
        # Create output subdirectory if it doesn't exist
        mkdir -p "$output_subdir"
        
        whisper "$audio_file" \
            --device cuda \
            --model "$MODEL" \
            --output_dir "$output_subdir" \
            --output_format srt \
            --verbose False
        
        if [ $? -eq 0 ]; then
            echo "✓ Completed: $filename"
        else
            echo "✗ Failed: $filename"
        fi
        echo ""
    fi
done

echo "All files processed!"
ls -lh "$OUTPUT_DIR"
