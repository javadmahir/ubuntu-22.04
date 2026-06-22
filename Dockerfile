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
    sudo \
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
    x11-apps \
    software-properties-common && \
    apt-get clean

RUN touch /root/.Xauthority

RUN mkdir -p /root/.vnc && \
    echo '#!/bin/bash' > /root/.vnc/xstartup && \
    echo 'xrdb $HOME/.Xresources' >> /root/.vnc/xstartup && \
    echo 'startxfce4 &' >> /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

EXPOSE 6080

CMD ["/bin/bash","-c", "\
vncserver :1 -localhost no -SecurityTypes None -geometry 1280x720 && \
openssl req -new -x509 -days 365 -nodes \
-subj '/C=US/ST=Render/L=Cloud/O=Desktop/CN=localhost' \
-out /tmp/self.pem \
-keyout /tmp/self.pem && \
echo 'Desktop Ready' && \
websockify --web=/usr/share/novnc/ --cert=/tmp/self.pem ${PORT:-6080} localhost:5901 \
"]
