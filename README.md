# Whisper Videos
> Original repo: https://github.com/manzolo/openai-whisper-docker

Transcribe audio files (.m4a) to SRT format using OpenAI Whisper locally in Docker.

## Prerequisites

- Docker installed
- For GPU: NVIDIA GPU with Docker Desktop (tested on NVIDIA RTX 4070)

## Configuration

Copy `.env.example` to `.env` and modify the variables as needed:

- `MODEL`: Whisper model to use (default: `large-v3-turbo`)

## Usage

1. Place .m4a or .mp4 files in `audio-files/` directory.
2. Run transcription:

   **First time or after Dockerfile changes:**
   ```bash
   DOCKER_BUILDKIT=1 docker compose up --build
   ```

   **Subsequent runs:**
   ```bash
   docker compose up
   ```

3. SRT files will appear in `output/` directory.

## Model

Uses `large-v3-turbo` model (cached in `models/`).

