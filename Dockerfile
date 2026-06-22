FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV PORT=6080

RUN apt-get update && \
    apt-get install -y \
    tigervnc-standalone-server \
    novnc \
    websockify \
    xterm \
    x11-utils \
    xauth \
    openssl \
    curl \
    wget \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.vnc

RUN cat > /root/.vnc/xstartup << 'EOF'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec xterm
EOF

RUN chmod +x /root/.vnc/xstartup

RUN touch /root/.Xauthority

EXPOSE 6080

CMD bash -c '\
vncserver :1 \
-geometry 1280x720 \
-depth 24 \
-SecurityTypes None \
-localhost no \
--I-KNOW-THIS-IS-INSECURE && \
websockify \
--verbose \
--web=/usr/share/novnc \
0.0.0.0:${PORT:-6080} \
localhost:5901'
