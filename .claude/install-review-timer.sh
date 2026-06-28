#!/usr/bin/env bash
# howWhatWhy: install the layer-2 weekly review as a systemd user timer.
# Generates and enables a systemd --user service + timer that runs the weekly
# review every Monday 10:00 (Persistent=true catches runs missed while the
# machine was off). Re-runnable (idempotent).
# Uninstall: systemctl --user disable --now howwhatwhy-review.timer
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REVIEW_SH="$SCRIPT_DIR/weekly-review.sh"
UNIT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"

if [ ! -f "$REVIEW_SH" ]; then
  echo "error: not found: $REVIEW_SH" >&2
  exit 1
fi

chmod +x "$REVIEW_SH"
mkdir -p "$UNIT_DIR"

# service: the unit is instance-specific, so the absolute path is resolved at
# install time (systemd does not expand env vars in ExecStart).
cat > "$UNIT_DIR/howwhatwhy-review.service" <<EOF
[Unit]
Description=howWhatWhy weekly learn.md review (promotion proposals)

[Service]
Type=oneshot
ExecStart=$REVIEW_SH
EOF

cat > "$UNIT_DIR/howwhatwhy-review.timer" <<'EOF'
[Unit]
Description=Run howWhatWhy weekly review every Monday 10:00

[Timer]
OnCalendar=Mon *-*-* 10:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl --user daemon-reload
systemctl --user enable --now howwhatwhy-review.timer

echo "installed. next scheduled run:"
systemctl --user list-timers howwhatwhy-review.timer --no-pager || true
echo
echo "tip: on a laptop, to let the job run even while logged out:"
echo "       loginctl enable-linger \"\$USER\""
echo "uninstall: systemctl --user disable --now howwhatwhy-review.timer"
