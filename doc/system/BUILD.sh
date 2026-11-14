#!/usr/bin/env bash
set -euo pipefail

# Assembles the eval-cal-node compiled system reference (designation ecn).
# Fail-closed: missing _index.md, designation/output mismatch, no chapters,
# or snapshot validation failure aborts the build with BUILD_FAILED on stderr.

PARTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$PARTS_DIR/../.." && pwd)"
DESIGNATION="ecn"
OUTPUT="${OUTPUT:-doc/${DESIGNATION}SYSTEM.md}"
VALIDATOR="$PARTS_DIR/validate_snapshots.sh"

fail() { echo "BUILD_FAILED: $1" >&2; exit 1; }

case "$OUTPUT" in
  *"${DESIGNATION}SYSTEM.md") ;;
  *) fail "output path '$OUTPUT' does not match designation ${DESIGNATION}" ;;
esac

[ -f "$PARTS_DIR/_index.md" ] || fail "missing $PARTS_DIR/_index.md"

mkdir -p "$(dirname "$ROOT_DIR/$OUTPUT")"
TMP_OUTPUT="$(mktemp)"
trap 'rm -f "$TMP_OUTPUT"' EXIT
cat "$PARTS_DIR/_index.md" > "$TMP_OUTPUT"

PART_COUNT=0
while IFS= read -r part; do
  { echo ""; echo "---"; echo ""; cat "$part"; } >> "$TMP_OUTPUT"
  PART_COUNT=$((PART_COUNT + 1))
done < <(find "$PARTS_DIR" -mindepth 1 -maxdepth 1 -type f -name '[0-9][0-9]-*.md' | sort)

[ "$PART_COUNT" -ge 1 ] || fail "no numbered chapters found directly under doc/system/"

if [ -f "$VALIDATOR" ]; then bash "$VALIDATOR" "$TMP_OUTPUT" || fail "snapshot validation failed"; else fail "missing validator $VALIDATOR"; fi

cp "$TMP_OUTPUT" "$ROOT_DIR/$OUTPUT"
chmod 664 "$ROOT_DIR/$OUTPUT"
LINE_COUNT=$(wc -l < "$ROOT_DIR/$OUTPUT")
echo "BUILD_OK designation=${DESIGNATION} output=${OUTPUT} parts=${PART_COUNT} lines=${LINE_COUNT}"
