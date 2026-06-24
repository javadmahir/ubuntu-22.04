FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PORT=10000

RUN apt-get update && \
    apt-get install -y curl wget git nano ca-certificates nodejs npm && \
    npm install -g freebuff && \
    apt-get clean

CMD ["bash", "-c", "while true; do sleep 3600; done"]
