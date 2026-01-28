# Use the NVIDIA NGC base image with CUDA
FROM nvcr.io/nvidia/cuda:12.4.0-runtime-ubuntu22.04

# Update the system and install required dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    sudo \
    python3.9 \
    python3-distutils \
    python3-pip \
    ffmpeg

# Upgrade pip
RUN pip install --upgrade pip

# Install openai-whisper
RUN --mount=type=cache,target=/root/.cache/pip pip install openai-whisper==20240930

# Set the working directory inside the container
WORKDIR /app

# Copy the processing script
COPY process_audio.sh /app/process_audio.sh
RUN chmod +x /app/process_audio.sh

# Default command when the container starts
CMD ["/app/process_audio.sh"]
