FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PORT=10000

RUN apt-get update && \
    apt-get install -y nodejs npm

CMD ["bash","-c","python3 -m http.server $PORT"]
