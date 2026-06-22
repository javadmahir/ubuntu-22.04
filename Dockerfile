FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV PORT=6080

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    xfce4 \
    xfce4-terminal \
    tigervnc-standalone-server \
    novnc \
    websockify \
    dbus-x11 \
    x11-xserver-utils \
    xterm \
    curl \
    wget \
    ca-certificates \
    openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.vnc

RUN printf '#!/bin/sh\n\
unset SESSION_MANAGER\n\
unset DBUS_SESSION_BUS_ADDRESS\n\
xrdb $HOME/.Xresources\n\
startxfce4 &\n' > /root/.vnc/xstartup && \
chmod +x /root/.vnc/xstartup

RUN touch /root/.Xauthority

RUN openssl req -x509 -nodes -days 365 \
-newkey rsa:2048 \
-keyout /root/key.pem \
-out /root/cert.pem \
-subj "/CN=localhost"

EXPOSE 6080

CMD bash -c '\
dbus-daemon --system --fork && \
vncserver :1 \
-geometry 1280x720 \
-depth 24 \
-SecurityTypes None \
-localhost no && \
echo "Desktop Started" && \
websockify \
--web=/usr/share/novnc \
--cert=/root/cert.pem \
${PORT} \
localhost:5901'
