# syntax = docker/dockerfile
FROM nvidia/cuda:12.3.2-runtime-ubuntu22.04

WORKDIR /usr/local/agent

# Add clearml user
RUN groupadd -g 1001 clearml && useradd -u 1001 -g clearml clearml

#Add permissions
RUN chown -R clearml:clearml /usr/local/agent && \
    chgrp -R 0 /usr/local/agent && \
    chmod -R 775 /usr/local/agent
##Specify the user with UID as OpenShift assigns random

USER 1001

COPY . /usr/local/agent

USER ROOT 

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install -y curl python3-pip git
RUN curl -sSL https://get.docker.com/ | sh
RUN python3 -m pip install -U pip
RUN python3 -m pip install clearml-agent
RUN python3 -m pip install -U "cryptography>=2.9"

ENV CLEARML_DOCKER_SKIP_GPUS_FLAG=1

ENTRYPOINT ["/usr/local/agent/entrypoint.sh"]
