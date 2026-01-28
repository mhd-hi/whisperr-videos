# Whisper Videos
> Original repo: https://github.com/manzolo/openai-whisper-docker

Transcribe audio files (.m4a) to SRT format using OpenAI Whisper locally in Docker.

## Prerequisites

- Docker installed
- For GPU: NVIDIA GPU with Docker Desktop (tested on NVIDIA RTX 4070)

## Usage

1. Place .m4a files in `audio-files/` directory.
2. Run transcription:

   **GPU (recommended):**
   ```bash
   docker compose --profile gpu up --build
   ```

3. SRT files will appear in `output/` directory.

## Model

Uses `large-v3-turbo` model (cached in `models/`).

