FROM debian:9-slim

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Set up non-root user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
COPY scripts/*.sh /tmp/
RUN bash /tmp/non-root-user.sh "${USERNAME}" "${USER_UID}" "${USER_GID}" && rm /tmp/non-root-user.sh 

# Terraform version
ARG TERRAFORM_VERSION=1.1.8

RUN mkdir -p /home/$USERNAME/.vscode-server/extensions \
    /home/$USERNAME/.vscode-server-insiders/extensions \
    && chown -R $USERNAME \
    /home/$USERNAME/.vscode-server \
    /home/$USERNAME/.vscode-server-insiders

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog icu-devtools 2>&1 \
    && apt-get install -y \
    git \
    less \
    curl \
    groff \
    libc6 \
    unzip \
    bash-completion \
    sudo \
    python3 \
    python3-pip \
    software-properties-common \
# Install the Azure CLI and PowerShell
    && /tmp/install-az-pwsh.sh && rm /tmp/install-az-pwsh.sh \
    && /tmp/install-pwsh-modules.sh && rm /tmp/install-pwsh-modules.sh 

# Install AWS cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && sudo ./aws/install \
    && rm -rf ./aws/ \
    && rm ./awscliv2.zip

# Install Kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" \
    && echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check \
    && sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh

# Install Terraform
RUN mkdir -p /tmp/dc-downloads \
     && curl -sSL -o /tmp/dc-downloads/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
     && unzip /tmp/dc-downloads/terraform.zip \
     && mv terraform /usr/local/bin \
     && terraform -install-autocomplete \
     && apt-get autoremove -y \
     && apt-get clean -y \
     && rm -rf /var/lib/apt/lists/* \
     && cd ~ \ 
     && rm -rf /tmp/dc-downloads

# Install Packer 
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - \
    && sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && sudo apt-get update && sudo apt-get install packer

# Save command line history 
RUN echo "export HISTFILE=/home/$USERNAME/commandhistory/.bash_history" >> "/home/$USERNAME/.bashrc" \
     && echo "export PROMPT_COMMAND='history -a'" >> "/home/$USERNAME/.bashrc" \
     && mkdir -p /home/$USERNAME/commandhistory \
     && touch /home/$USERNAME/commandhistory/.bash_history \
     && chown -R $USERNAME /home/$USERNAME/commandhistory
     
# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog 
