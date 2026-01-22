FROM registry.gitlab.com/islandoftex/images/texlive:latest

USER root

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    openssh-server \
    curl \
    bash \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 设置 texlive 用户密码和 shell
RUN echo "texlive:your_passwd" | chpasswd
RUN chsh -s /bin/bash texlive

# 配置 SSH
RUN mkdir -p /var/run/sshd
RUN sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# 为 texlive 安装 NVM + Node.js
RUN su - texlive -c " \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && \
    export NVM_DIR='/home/texlive/.nvm' && \
    [ -s \"\$NVM_DIR/nvm.sh\" ] && \\. \"\$NVM_DIR/nvm.sh\" && \
    nvm install lts/* && \
    nvm alias default lts/* && \
    nvm use default \
  "

# 配置 .bashrc 加载 NVM
RUN echo '\n\
export NVM_DIR="$HOME/.nvm"\n\
[ -s "$NVM_DIR/nvm.sh" ] && \\. "$NVM_DIR/nvm.sh"\n\
[ -s "$NVM_DIR/bash_completion" ] && \\. "$NVM_DIR/bash_completion"\n\
' >> /home/texlive/.bashrc

# 安装 Codex（带完整环境和错误检查）
RUN su - texlive -c " \
    set -e; \
    export NVM_DIR='/home/texlive/.nvm'; \
    [ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"; \
    nvm use default; \
    node -v; npm -v; \
    curl -s https://vibe.aiok.me/setup-codex.sh | bash -s -- \
      --url https://your_base_url \
      --key your_api_key \
  "

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]