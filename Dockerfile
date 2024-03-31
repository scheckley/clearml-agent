# syntax = docker/dockerfile
FROM nvidia/cuda:12.3.2-runtime-ubuntu22.04

WORKDIR /usr/local/agent
RUN groupadd -g 1001 clearml && useradd -u 1001 -g clearml clearml
COPY . /usr/local/agent

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install -y curl python3-pip git
RUN curl -sSL https://get.docker.com/ | sh
RUN python3 -m pip install -U pip
RUN python3 -m pip install clearml-agent
RUN python3 -m pip install -U "cryptography>=2.9"

ENV CLEARML_DOCKER_SKIP_GPUS_FLAG=1

ENTRYPOINT ["/usr/local/agent/entrypoint.sh"]
