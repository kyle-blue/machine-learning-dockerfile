FROM ubuntu:22.04

LABEL maintainer="kyle.blue.doidge@gmail.com"

ARG DEBIAN_FRONTEND=noninteractive

# Install essentials
RUN apt update -y && \
    apt install -y git vim ssh rsync zsh tmux curl wget

# Install basic utilities
RUN apt install --yes --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    file \
    git \
    inotify-tools \
    jq \
    libgl1 \
    lsof \
    vim \
    nano \
    tmux \
    nginx \
    openssh-server \
    procps \
    rsync \
    sudo \
    software-properties-common \
    unzip \
    wget \
    zip

# Install Oh my ZSH
RUN echo y | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && chsh -s /bin/zsh root

# Install python dev tools
RUN apt-get install -y -qq build-essential zlib1g-dev libffi-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev liblzma-dev libncurses-dev tk-dev

COPY zshrc /root/.zshrc



# Install pyenv
# Install python 3.12.9
RUN curl -fsSL https://pyenv.run | bash && cat ~/.zshrc && cd ~ && pwd && \
    zsh -c ". ~/.zshrc && pyenv install 3.12.9 && pyenv global 3.12.9"

# Use zsh from here on out to use zshrc with python version
SHELL ["/bin/zsh", "-c"]

# Install CUDA toolkit
RUN wget https://developer.download.nvidia.com/compute/cuda/12.9.0/local_installers/cuda-repo-debian12-12-9-local_12.9.0-575.51.03-1_amd64.deb && \
    dpkg -i cuda-repo-debian12-12-9-local_12.9.0-575.51.03-1_amd64.deb && \
    cp /var/cuda-repo-debian12-12-9-local/cuda-*-keyring.gpg /usr/share/keyrings/ && \
    apt-get -y update && \
    apt-get -y install cuda-toolkit-12-9 && \
    rm cuda-repo-debian12-12-9-local_12.9.0-575.51.03-1_amd64.deb

# Install / Upgrade pip & setuptools
RUN . ~/.zshrc && pip install -U pip setuptools && \
    # Install uv
    curl -LsSf https://astral.sh/uv/install.sh | sh && . ~/.zshrc && \
    # Install huggingface-cli, numpy, matplotlib, pytorch, transformers, datasets, accelerate, tokenizers, peft
    uv pip install --system -U "huggingface_hub[cli]" numpy matplotlib "torch~=2.7.0" transformers datasets accelerate tokenizers peft && \
    # Install gptqmodel 3.0 from source
    uv pip install --system "gptqmodel@git+https://github.com/ModelCloud/GPTQModel.git@v3.0.0" --no-build-isolation

# Expose ssh ?
# TODO: Add jupyter notebook?
# Add non root user (admin) and secure ssh
# Set firewall rules

USER root
EXPOSE 22
WORKDIR /workspace

COPY ./start.sh /start.sh

CMD ["/start.sh"]
