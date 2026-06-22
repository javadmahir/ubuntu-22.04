#!/bin/bash

mkdir -p /run/dbus

dbus-daemon --system --fork || true

vncserver :1 -geometry 1280x720 -depth 24

websockify \
  --web=/usr/share/novnc \
  0.0.0.0:10000 \
  localhost:5901
