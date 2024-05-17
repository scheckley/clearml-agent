# Use the official NVIDIA CUDA base image for Ubuntu 22.04
FROM nvidia/cuda:11.8.0-runtime-ubuntu22.04

# Set environment variables for CUDA
ENV CUDA_VERSION 11.8.0
ENV CUDA_PKG_VERSION 11-8

# Install required dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    gnupg2 \
    software-properties-common \
    python3 \
    python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Add NVIDIA package repositories
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin \
    && mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600 \
    && wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda-repo-ubuntu2204-11-8-local_11.8.0-520.61.05-1_amd64.deb \
    && dpkg -i cuda-repo-ubuntu2204-11-8-local_11.8.0-520.61.05-1_amd64.deb \
    && apt-key add /var/cuda-repo-ubuntu2204-11-8-local/7fa2af80.pub \
    && apt-get update

# Install CUDA and cuDNN
RUN apt-get install -y --no-install-recommends \
    cuda \
    libcudnn8 \
    libcudnn8-dev && \
    rm -rf /var/lib/apt/lists/*

# Install NVIDIA Container Toolkit
RUN wget https://nvidia.github.io/nvidia-docker/gpgkey \
    && apt-key add gpgkey \
    && distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
    && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list \
    && apt-get update \
    && apt-get install -y nvidia-container-toolkit && \
    rm -rf /var/lib/apt/lists/*

# Set up the NVIDIA runtime as the default runtime
RUN nvidia-ctk runtime configure --runtime=docker

# Install ClearML
RUN pip3 install clearml-agent

# Verify CUDA installation
RUN nvidia-smi

# Run ClearML agent
CMD ["clearml-agent", "daemon", "--queue", "default"]