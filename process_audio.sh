#!/usr/bin/env bash
set -euo pipefail

# Process all supported audio files in audio-files directory and output SRT files to output directory
AUDIO_DIR="/app/audio-files"
OUTPUT_DIR="/app/output"
MODEL="${MODEL:-large-v3-turbo}"

# Supported extensions
SUPPORTED_EXTENSIONS="m4a mp4 mkv wav mp3"

NOW=$(date +"%Y-%m-%d %H:%M")
echo "[$NOW] Starting audio transcription"
echo "Processing files from: $AUDIO_DIR"
echo "Using model: $MODEL"

ext_regex=$(printf '%s|' ${SUPPORTED_EXTENSIONS} | sed 's/|$//')

# Count matching files
file_count=$(find "$AUDIO_DIR" -type f -regextype posix-extended -regex ".*\.($ext_regex)$" | wc -l)
echo "Found $file_count audio files to process"

if [ "$file_count" -eq 0 ]; then
    echo "No audio files found in $AUDIO_DIR"
    exit 0
fi

# Process each audio file
processed_count=0
find "$AUDIO_DIR" -type f -regextype posix-extended -regex ".*\.($ext_regex)$" -print0 |
while IFS= read -r -d '' audio_file; do
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

        processed_count=$((processed_count + 1))
        percent=$((processed_count * 100 / file_count))

        NOW=$(date +"%Y-%m-%d %H:%M")

        echo "[$NOW] ✓ Completed: $filename"
        echo "[$NOW] Progress: $processed_count/$file_count ($percent%)"
        echo ""
    fi
done

NOW=$(date +"%Y-%m-%d %H:%M")
echo "[$NOW] All files processed!"
ls -lh "$OUTPUT_DIR"
