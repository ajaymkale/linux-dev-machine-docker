FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openjdk-21-jdk \
        maven \
        git \
        git-lfs \
        vim \
        nano \
        curl \
        wget \
        unzip \
        zip \
        sudo \
        docker.io \
        python3 \
        python3-pip \
        python3-venv \
        openssh-client \
        ca-certificates \
        gnupg \
        lsb-release \
        less \
        jq \
        tree && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create developer user
RUN useradd -m -s /bin/bash developer && \
    usermod -aG sudo developer && \
    usermod -aG docker developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer

# Create ansible user
RUN useradd -m -s /bin/bash ansible && \
    usermod -aG sudo ansible && \
    echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible && \
    chmod 0440 /etc/sudoers.d/ansible

# Install Ansible
RUN python3 -m pip install --break-system-packages \
    ansible \
    ansible-lint

# Set default user
USER developer

WORKDIR /home/developer

# Create useful directories
RUN mkdir -p \
    /home/developer/workspace \
    /home/developer/.ssh \
    /home/developer/.m2 && \
    chmod 700 /home/developer/.ssh

ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV MAVEN_HOME=/usr/share/maven
ENV PATH="${JAVA_HOME}/bin:${MAVEN_HOME}/bin:${PATH}"

CMD ["/bin/bash"]
