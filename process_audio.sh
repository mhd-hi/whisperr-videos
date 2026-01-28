#!/bin/bash

# Process all m4a files in audio-files directory and output SRT files to output directory
AUDIO_DIR="/app/audio-files"
OUTPUT_DIR="/app/output"

echo "Starting audio transcription..."
echo "Processing m4a files from: $AUDIO_DIR"

# Count files
file_count=$(find "$AUDIO_DIR" -name "*.m4a" | wc -l)
echo "Found $file_count m4a files to process"

if [ $file_count -eq 0 ]; then
    echo "No m4a files found in $AUDIO_DIR"
    exit 0
fi

# Process each m4a file
for audio_file in "$AUDIO_DIR"/*.m4a; do
    if [ -f "$audio_file" ]; then
        filename=$(basename "$audio_file")
        echo "Processing: $filename"
        
        whisper "$audio_file" \
            --device cuda \
            --model large-v3-turbo \
            --output_dir "$OUTPUT_DIR" \
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
