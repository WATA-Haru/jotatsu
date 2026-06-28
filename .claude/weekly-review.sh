#!/usr/bin/env bash
# jotatsu weekly review agent (layer 2 / ADR-0008, ADR-0009)
# Reads all learn.md and outputs promotion proposals for principles/ as "proposal only".
# Only read tools are allowed, so it can never modify the vault.
set -euo pipefail

# vault ルートをスクリプト自身の位置から解決する（.claude/ の親）。
# これでテンプレートをどこに展開しても動く。
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT="$(dirname "$SCRIPT_DIR")"
CLAUDE="$(command -v claude || echo "$HOME/.local/bin/claude")"
OUT_DIR="$VAULT/reviews"
PROMPT_FILE="$VAULT/.claude/weekly-review-prompt.md"

mkdir -p "$OUT_DIR"
cd "$VAULT"

OUT="$OUT_DIR/review-$(date +%F).md"

{
  echo "# Weekly review — promotion proposals ($(date '+%Y-%m-%d %H:%M'))"
  echo
  "$CLAUDE" -p --allowedTools "Read Glob Grep" "$(cat "$PROMPT_FILE")"
} > "$OUT" 2>&1

echo "wrote: $OUT"
