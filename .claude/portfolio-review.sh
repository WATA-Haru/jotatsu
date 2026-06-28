#!/usr/bin/env bash
# howWhatWhy portfolio review (operational layer / ADR-0012)
# Deterministically scans projects/*/index.md frontmatter and reports
# WIP-over-limit and stalled (active & untouched) projects. No AI; pure bash.
# This is the push-side nudge for the tracker (the Dataview dashboard is pull).
# Concern is separate from weekly-review.sh (learn -> principles).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT="$(dirname "$SCRIPT_DIR")"
OUT_DIR="$VAULT/reviews"
WIP_LIMIT=5
STALE_DAYS=14

mkdir -p "$OUT_DIR"
OUT="$OUT_DIR/portfolio-$(date +%F).md"
now=$(date +%s)

active=0
active_lines=""
stale_lines=""

shopt -s nullglob
for idx in "$VAULT"/projects/*/index.md; do
  name="$(basename "$(dirname "$idx")")"
  status="$(grep -m1 '^status:' "$idx" | sed 's/^status:[[:space:]]*//; s/[[:space:]]*$//')"
  touched="$(grep -m1 '^last-touched:' "$idx" | sed 's/^last-touched:[[:space:]]*//; s/[[:space:]]*$//')"
  [ "$status" = "active" ] || continue
  active=$((active + 1))
  active_lines+="- $name（last-touched: ${touched:-?}）"$'\n'
  if t=$(date -d "$touched" +%s 2>/dev/null); then
    days=$(( (now - t) / 86400 ))
    if [ "$days" -gt "$STALE_DAYS" ]; then
      stale_lines+="- $name（${days}日ノータッチ）→ 再開 / paused / dropped を決める"$'\n'
    fi
  fi
done

{
  echo "# Portfolio review — $(date '+%Y-%m-%d %H:%M')"
  echo
  echo "## WIP: active ${active} / 上限 ${WIP_LIMIT}"
  if [ "$active" -gt "$WIP_LIMIT" ]; then
    echo
    echo "⚠ **抱えすぎ。** active が上限超過。1つを done / paused / dropped にすること。"
  fi
  echo
  echo "## Active"
  if [ -n "$active_lines" ]; then printf "%s" "$active_lines"; else echo "（なし）"; fi
  echo
  echo "## ⚠ 停滞（active かつ ${STALE_DAYS}日超ノータッチ）"
  if [ -n "$stale_lines" ]; then printf "%s" "$stale_lines"; else echo "（なし）"; fi
} > "$OUT"

echo "wrote: $OUT"

# optional desktop push (if available)
if command -v notify-send >/dev/null 2>&1; then
  msg="active ${active}/${WIP_LIMIT}"
  [ "$active" -gt "$WIP_LIMIT" ] && msg="${msg} ・抱えすぎ⚠"
  notify-send "howWhatWhy portfolio" "$msg" || true
fi
