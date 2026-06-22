FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PORT=6080

RUN apt-get update && \
    apt-get install -y \
    tigervnc-standalone-server \
    novnc \
    websockify \
    xterm \
    openssl

RUN mkdir -p /root/.vnc

RUN echo '#!/bin/sh' > /root/.vnc/xstartup && \
    echo 'exec xterm' >> /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

RUN touch /root/.Xauthority

RUN openssl req -x509 -nodes -days 365 \
-newkey rsa:2048 \
-keyout /root/key.pem \
-out /root/cert.pem \
-subj "/CN=localhost"

EXPOSE 6080

CMD bash -c '\
vncserver :1 \
-geometry 1024x768 \
-depth 24 \
-SecurityTypes None \
-localhost no \
--I-KNOW-THIS-IS-INSECURE && \
sleep 5 && \
cat /root/.vnc/*.log && \
websockify \
--web=/usr/share/novnc \
--cert=/root/cert.pem \
${PORT:-6080} \
localhost:5901'
