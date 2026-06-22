FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-terminal \
    tigervnc-standalone-server \
    novnc \
    websockify \
    curl \
    wget \
    git \
    nodejs \
    npm \
    dbus-x11 \
    xauth \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g freebuff

RUN mkdir -p /root/.vnc

RUN printf '#!/bin/sh\n\
unset SESSION_MANAGER\n\
unset DBUS_SESSION_BUS_ADDRESS\n\
startxfce4\n' > /root/.vnc/xstartup \
&& chmod +x /root/.vnc/xstartup

RUN echo "password" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 10000

CMD ["/start.sh"]
