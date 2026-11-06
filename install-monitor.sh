#!/bin/sh
# Publishes the monitor page on the GX web server: http://<GX IP>/monitor/
#
# The page itself lives in /data/www/monitor/index.html: the /data partition survives firmware updates.
# Only a link monitor -> /data/www/monitor is created in the GX web root. A firmware update
# overwrites the system partition together with that link, so the script adds itself to /data/rc.local
# (Venus OS runs it on every boot) and restores the link if it is missing.
#
# Safe to run again. To remove: rm <web root>/monitor, delete the line from /data/rc.local,
# rm -r /data/www.

SRC=/data/www/monitor
SELF=/data/www/install-monitor.sh
RC=/data/rc.local

if [ ! -f "$SRC/index.html" ]; then
  echo "No $SRC/index.html: copy the page to the GX first." >&2
  exit 1
fi
chmod 755 /data/www "$SRC"
chmod 644 "$SRC/index.html"

# GX web root: /var/www/venus (gui-v1, gui-v2 and app live there too).
WEBROOT=/var/www/venus
if [ ! -d "$WEBROOT" ]; then
  echo "No $WEBROOT: this firmware uses a different web root. Nothing changed." >&2
  echo "Hint: grep -r root /etc/nginx" >&2
  exit 1
fi
LINK="$WEBROOT/monitor"

if [ "$(readlink "$LINK" 2>/dev/null)" != "$SRC" ]; then
  if [ -e "$LINK" ] && [ ! -L "$LINK" ]; then
    echo "$LINK already exists and is not our link. Nothing changed." >&2
    exit 1
  fi
  # The system partition is usually mounted read-only: open it for writing for a moment
  # and put it back as it was.
  RO=0
  awk '$2=="/"{print $4}' /proc/mounts | grep -q '^ro' && RO=1
  [ $RO = 1 ] && mount -o remount,rw /
  rm -f "$LINK"
  ln -s "$SRC" "$LINK"
  [ $RO = 1 ] && mount -o remount,ro /
fi

# Restore automatically after a firmware update.
if ! grep -qs "$SELF" "$RC"; then
  [ -f "$RC" ] || echo '#!/bin/sh' > "$RC"
  echo "$SELF >/dev/null 2>&1 &" >> "$RC"
  chmod 755 "$RC"
fi

if wget -q -O /dev/null http://127.0.0.1/monitor/ 2>/dev/null; then
  IP=$(ip -4 -o addr show 2>/dev/null | awk '$2!="lo"{sub(/\/.*/,"",$4); print $4; exit}')
  echo "Done: http://${IP:-<GX IP>}/monitor/"
else
  echo "Link created ($LINK), but the web server does not serve /monitor/. Check: ls -l $WEBROOT; grep -r root /etc/nginx" >&2
  exit 1
fi
