FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PORT=6080

RUN apt-get update && \
    apt-get install -y \
    xfce4 \
    xfce4-goodies \
    xfce4-session \
    xfwm4 \
    xfdesktop4 \
    xfce4-terminal \
    tigervnc-standalone-server \
    novnc \
    websockify \
    dbus-x11 \
    x11-xserver-utils \
    x11-apps \
    xterm \
    curl \
    wget \
    git \
    vim \
    net-tools \
    openssl \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN touch /root/.Xauthority

RUN mkdir -p /root/.vnc

RUN cat > /root/.vnc/xstartup << 'EOF'
#!/bin/bash
xrdb $HOME/.Xresources
export XKL_XMODMAP_DISABLE=1
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4
EOF

RUN chmod +x /root/.vnc/xstartup

EXPOSE 6080

CMD ["/bin/bash", "-c", "\
dbus-daemon --system --fork && \
vncserver :1 \
-localhost no \
-SecurityTypes None \
-geometry 1280x720 \
--I-KNOW-THIS-IS-INSECURE && \
openssl req -new -x509 -days 365 -nodes \
-subj '/CN=localhost' \
-out /tmp/self.pem \
-keyout /tmp/self.pem && \
echo 'Desktop Ready on Port ${PORT:-6080}' && \
websockify --web=/usr/share/novnc/ \
--cert=/tmp/self.pem \
${PORT:-6080} \
localhost:5901 \
"]
