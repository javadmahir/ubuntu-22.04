FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PORT=6080

RUN apt-get update && \
    apt-get install -y \
    tigervnc-standalone-server \
    novnc \
    websockify \
    xterm \
    openssl && \
    apt-get clean

RUN mkdir -p /root/.vnc

RUN printf '#!/bin/sh\nexec xterm\n' > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /root/key.pem \
    -out /root/cert.pem \
    -subj "/CN=localhost"

EXPOSE 6080

CMD bash -c '\
vncserver :1 \
-geometry 1280x720 \
-depth 24 \
-SecurityTypes None \
-localhost no \
--I-KNOW-THIS-IS-INSECURE && \
websockify \
--web=/usr/share/novnc \
--cert=/root/cert.pem \
${PORT:-6080} \
localhost:5901'
