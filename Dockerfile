FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PORT=6080

RUN apt-get update && \
    apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tigervnc-standalone-server \
    novnc \
    websockify \
    xterm \
    vim \
    net-tools \
    curl \
    wget \
    git \
    tzdata \
    openssl \
    dbus-x11 \
    x11-utils \
    x11-xserver-utils \
    x11-apps && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN touch /root/.Xauthority

RUN mkdir -p /root/.vnc

RUN printf '#!/bin/sh\nstartxfce4 &\n' > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

EXPOSE 6080

CMD ["/bin/bash","-c", "\
vncserver :1 \
-localhost no \
-SecurityTypes None \
-geometry 1280x720 \
--I-KNOW-THIS-IS-INSECURE && \
openssl req -new -x509 -days 365 -nodes \
-subj '/C=US/ST=Cloud/L=Render/O=Desktop/CN=localhost' \
-out /tmp/self.pem \
-keyout /tmp/self.pem && \
echo 'Desktop started' && \
websockify --web=/usr/share/novnc/ --cert=/tmp/self.pem ${PORT:-6080} localhost:5901 \
"]
