FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PORT=10000

RUN apt-get update && \
    apt-get install -y curl wget nodejs npm && \
    npm install -g freebuff && \
    wget -O /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd

# CMD bash -c "ttyd --writable -p $PORT bash"
CMD bash -c "ttyd -c mj:mj@123 --writable -p $PORT bash"
