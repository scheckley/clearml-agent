# syntax = docker/dockerfile
FROM nvidia/cuda:12.3.2-runtime-ubuntu22.04

WORKDIR /usr/local/agent

# Add clearml user
RUN useradd -rm -d /home/clearml -s /bin/bash -g root -G sudo -u 1001 clearml

# Add permissions
RUN chown -R clearml:root /home/clearml && \
    chgrp -R 0 /home/clearml && \
    chmod -R 775 /home/clearml 
##Specify the user with UID
USER 1001

RUN chown -R clearml:clearml /usr/local/agent
RUN chgrp -R 0 /usr/local/agent && \
    chmod -R g=u /usr/local/agent


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
