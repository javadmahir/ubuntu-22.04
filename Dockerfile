FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PORT=10000

RUN apt-get update && apt-get install -y curl wget git sudo nano vim nodejs npm python3 python3-pip && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://code-server.dev/install.sh | sh

EXPOSE 10000

CMD ["code-server","--bind-addr","0.0.0.0:10000","--auth","password","/root"]
