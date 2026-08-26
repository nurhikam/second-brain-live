#!/usr/bin/env bash
# Copy only notes marked `publish: true` from the private vault into content/.
# The filter runs HERE, locally — private notes never enter this public repo.
set -euo pipefail

VAULT="${VAULT:-$(cd "$(dirname "$0")/../second-brain" && pwd)}"
DEST="$(cd "$(dirname "$0")" && pwd)/content"
# never leaves the machine, whatever its frontmatter says
PRIVATE_DIR="Private"

[ -d "$VAULT" ] || { echo "vault not found: $VAULT (set VAULT=...)" >&2; exit 1; }

# wipe copied notes, keep hand-written index
find "$DEST" -name '*.md' ! -name 'index.md' -delete 2>/dev/null || true

n=0
while IFS= read -r -d '' f; do
  # publish: true must be inside the frontmatter block (between the first two ---)
  awk 'NR==1 && $0!="---"{exit 1} NR>1 && $0=="---"{exit !ok} /^publish:[[:space:]]*true[[:space:]]*$/{ok=1} END{exit !ok}' "$f" || continue
  rel="${f#"$VAULT"/}"
  mkdir -p "$DEST/$(dirname "$rel")"
  cp "$f" "$DEST/$rel"
  echo "  + $rel"
  n=$((n+1))
done < <(find "$VAULT" -name '*.md' \
  -not -path '*/.git/*' -not -path '*/.obsidian/*' \
  -not -path "$VAULT/$PRIVATE_DIR/*" -print0)

echo "synced $n note(s) -> content/"
