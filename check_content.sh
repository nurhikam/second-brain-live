#!/usr/bin/env bash
# Refuse to ship anything in content/ that isn't marked `publish: true`.
# sync.sh is the gate; this is the tripwire for when the gate gets bypassed —
# a hand-copied file, a bad merge, a stale note left behind after the vault
# dropped its publish flag.
set -euo pipefail

DEST="${DEST:-$(cd "$(dirname "$0")" && pwd)/content}"

[ -d "$DEST" ] || { echo "content dir not found: $DEST (set DEST=...)" >&2; exit 1; }

bad=0
while IFS= read -r -d '' f; do
  # same predicate as sync.sh: `publish: true` inside the frontmatter block.
  # keep these two in step — a guard that disagrees with the gate is worse
  # than no guard, because it reads as a pass.
  if ! awk 'NR==1 && $0!="---"{exit 1} NR>1 && $0=="---"{exit !ok} /^publish:[[:space:]]*true[[:space:]]*$/{ok=1} END{exit !ok}' "$f"; then
    echo "  ✗ ${f#"$DEST"/}" >&2
    bad=$((bad+1))
  fi
done < <(find "$DEST" -name '*.md' ! -name 'index.md' -print0)

if [ "$bad" -gt 0 ]; then
  echo >&2
  echo "$bad file(s) in content/ without \`publish: true\` in frontmatter." >&2
  echo "These would go public. Delete them, or re-run ./sync.sh to rebuild content/." >&2
  exit 1
fi

echo "content/ clean: every note carries publish: true"
