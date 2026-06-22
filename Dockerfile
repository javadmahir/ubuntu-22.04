FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PORT=6080

RUN apt update -y && \
    apt install --no-install-recommends -y \
    xfce4 \
    xfce4-goodies \
    tigervnc-standalone-server \
    novnc \
    websockify \
    sudo \
    xterm \
    init \
    systemd \
    snapd \
    vim \
    net-tools \
    curl \
    wget \
    git \
    tzdata \
    dbus-x11 \
    x11-utils \
    x11-xserver-utils \
    x11-apps \
    software-properties-common \
    openssl

RUN add-apt-repository ppa:mozillateam/ppa -y

RUN echo 'Package: *' > /etc/apt/preferences.d/mozilla-firefox && \
    echo 'Pin: release o=LP-PPA-mozillateam' >> /etc/apt/preferences.d/mozilla-firefox && \
    echo 'Pin-Priority: 1001' >> /etc/apt/preferences.d/mozilla-firefox

RUN apt update -y && \
    apt install -y firefox xubuntu-icon-theme

RUN touch /root/.Xauthority

EXPOSE 6080

CMD ["/bin/bash", "-c", "\
mkdir -p /root/.vnc && \
vncserver :1 -localhost no -SecurityTypes None -geometry 1280x720 && \
openssl req -new -x509 -days 365 -nodes \
-subj '/C=JP/ST=Tokyo/L=Tokyo/O=Docker/CN=localhost' \
-out /tmp/self.pem \
-keyout /tmp/self.pem && \
echo 'Starting noVNC on port '${PORT:-6080} && \
websockify --web=/usr/share/novnc/ --cert=/tmp/self.pem ${PORT:-6080} localhost:5901 \
"]
