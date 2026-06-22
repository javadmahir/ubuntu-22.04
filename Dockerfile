FROM node:22-bookworm-slim

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g freebuff

WORKDIR /app

CMD ["bash"]
