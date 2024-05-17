# syntax = docker/dockerfile
FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.0"

WORKDIR /usr/local/agent

# Add clearml user
RUN groupadd -g 1001 clearml && useradd -u 1001 -g clearml clearml
RUN mkdir /home/clearml
RUN mkdir /.clearml

#Add permissions
RUN chown -R clearml:clearml /usr/local/agent && \
    chgrp -R 0 /usr/local/agent && \
    chmod -R 775 /usr/local/agent && \
    chmod -R 775 /home/clearml && \
    chmod -R 775 /.clearml
#Specify the user with UID as OpenShift assigns random

USER 1001

COPY ./entrypoint.sh /usr/local/agent/entrypoint.sh
COPY ./clearml.conf /home/clearml/clearml.conf

USER root 

RUN chmod +x /usr/local/agent/entrypoint.sh

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install -y curl python3-pip git
RUN curl -sSL https://get.docker.com/ | sh
RUN python3 -m pip install -U pip
RUN python3 -m pip install clearml-agent
RUN python3 -m pip install -U "cryptography>=2.9"

ENTRYPOINT ["/usr/local/agent/entrypoint.sh"]
