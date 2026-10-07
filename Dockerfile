FROM ghcr.io/engigu/baihu:latest

ENV REMOTE_FOLDER="huggingface:/baihu"

RUN apt-get update && apt-get install -y \
    jq \
    xvfb \
    curl \
    unzip \
    sshpass \
    openssh-client \
    libglib2.0-0 \
    libnspr4 \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libdbus-1-3 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libgtk-3-0 \
    libasound2 \
    && curl -fsSL https://rclone.org/install.sh | bash \
    && rclone version \
    && ssh -V \
    && sshpass -V \
    && rm -rf /var/lib/apt/lists/*

RUN rclone config -h

COPY ./restore.sh /

RUN sed -i '/^exec baihu server$/d' /app/docker-entrypoint.sh
RUN cat /restore.sh >> /app/docker-entrypoint.sh

RUN mise exec python@3.13.12 -- pip install requests
RUN mise use -g python@3.13.12
RUN mise use -g node@23.11.1
