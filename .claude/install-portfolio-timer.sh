#!/usr/bin/env bash
# jotatsu: install the portfolio review (WIP / stalled check) as a systemd
# user timer. Runs every Monday 09:00 (Persistent=true catches missed runs).
# Re-runnable. Uninstall: systemctl --user disable --now jotatsu-portfolio.timer
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REVIEW_SH="$SCRIPT_DIR/portfolio-review.sh"
UNIT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"

if [ ! -f "$REVIEW_SH" ]; then
  echo "error: not found: $REVIEW_SH" >&2
  exit 1
fi

chmod +x "$REVIEW_SH"
mkdir -p "$UNIT_DIR"

cat > "$UNIT_DIR/jotatsu-portfolio.service" <<EOF
[Unit]
Description=jotatsu portfolio review (WIP / stalled check)

[Service]
Type=oneshot
ExecStart=$REVIEW_SH
EOF

cat > "$UNIT_DIR/jotatsu-portfolio.timer" <<'EOF'
[Unit]
Description=Run jotatsu portfolio review every Monday 09:00

[Timer]
OnCalendar=Mon *-*-* 09:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl --user daemon-reload
systemctl --user enable --now jotatsu-portfolio.timer

echo "installed. next scheduled run:"
systemctl --user list-timers jotatsu-portfolio.timer --no-pager || true
echo "uninstall: systemctl --user disable --now jotatsu-portfolio.timer"
