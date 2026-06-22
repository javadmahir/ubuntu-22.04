FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
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
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.vnc

RUN cat > /root/.vnc/xstartup << 'EOF'
#!/bin/sh
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
sleep 3 && \
echo "========== VNC LOG ==========" && \
cat /root/.vnc/*.log && \
echo "=============================" && \
websockify \
--verbose \
--web=/usr/share/novnc \
${PORT:-6080} \
localhost:5901'
