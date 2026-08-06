FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    openjdk-21-jdk \
    maven \
    git \
    vim \
    curl \
    wget \
    unzip \
    sudo \
    docker.io \
    python3 \
    python3-pip \
    && apt clean

RUN useradd -m -s /bin/bash developer && \
    echo "developer:developer" | chpasswd && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN useradd -m -s /bin/bash ansible && \
    echo "ansible:ansible" | chpasswd && \
    echo "ansible ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER developer

WORKDIR /home/developer

CMD ["/bin/bash"]
