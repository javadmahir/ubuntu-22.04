FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PORT=10000

RUN apt-get update && \
    apt-get install -y curl wget git sudo && \
    curl -fsSL https://code-server.dev/install.sh | sh

# CMD code-server \
#     --bind-addr 0.0.0.0:$PORT \
#     --auth none \
#     /root

CMD code-server \
    --bind-addr 0.0.0.0:$PORT \
    --auth password \
    /root
