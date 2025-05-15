FROM debian:12-slim

LABEL maintainer="kyle.blue.doidge@gmail.com"

# Install essentials
RUN apt update -y && \
    apt install -y git vim ssh rsync zsh tmux curl wget


# Install oh my zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
COPY zshrc ~/.zshrc

# Install neovim
RUN add-apt-repository ppa:neovim-ppa/unstable && apt update && apt install neovim

# Install python dev tools
RUN apt-get install -y build-essential zlib1g-dev libffi-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev liblzma-dev libncurses-dev tk-dev


# Install pyenv
# Install python 3.12.9
RUN curl -fsSL https://pyenv.run | bash && \
    source ~/.zshrc && \
    pyenv install 3.12.9 && pyenv global 3.12.9

# Install / Upgrade pip & setuptools
RUN pip install -U pip setuptools

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Install CUDA toolkit
RUN wget https://developer.download.nvidia.com/compute/cuda/12.9.0/local_installers/cuda-repo-debian12-12-9-local_12.9.0-575.51.03-1_amd64.deb && \
    dpkg -i cuda-repo-debian12-12-9-local_12.9.0-575.51.03-1_amd64.deb && \
    cp /var/cuda-repo-debian12-12-9-local/cuda-*-keyring.gpg /usr/share/keyrings/ && \
    apt-get -y update && \
    apt-get -y install cuda-toolkit-12-9

# Install huggingface-cli
# Install numpy, matplotlib, pytorch, transformers, datasets, accelerate, tokenizers, peft
# TODO: Make s
RUN pip install -U "huggingface_hub[cli]" numpy matplotlib "torch~=2.7.0" transformers datasets accelerate tokenizers peft

# Install gptqmodel 3.0 from source
RUN pip install "gptqmodel@git+https://github.com/ModelCloud/GPTQModel.git@v3.0.0" --no-build-isolation

# Expose ssh ?

USER admin
EXPOSE 22
WORKDIR /workspace
