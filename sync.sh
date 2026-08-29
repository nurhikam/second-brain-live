#!/usr/bin/env bash
# Copy only notes marked `publish: true` from the private vault into content/.
# The filter runs HERE, locally — private notes never enter this public repo.
set -euo pipefail

VAULT="${VAULT:-$(cd "$(dirname "$0")/../second-brain" && pwd)}"
DEST="${DEST:-$(cd "$(dirname "$0")" && pwd)/content}"
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

# --- attachments -------------------------------------------------------------
# Copy ONLY the files that published notes actually embed. Never mirror an
# attachment folder wholesale: those folders mix attachments from private and
# archived notes, so copying one publishes images nobody asked to publish.
#
# Everything lands flat in content/assets/ rather than at its vault path. Two
# reasons: `markdownLinkResolution: shortest` resolves ![[foo.png]] by basename
# regardless of folder, and mirroring the vault path would publish the vault's
# folder names (Archive/Resources-Legacy/...) as public URLs.
ASSETS="$DEST/assets"
rm -rf "$ASSETS"   # rebuild each run, or an attachment stays after its note stops embedding it

refs=$(mktemp); trap 'rm -f "$refs"' EXIT

# collect every embed target from the notes that passed the filter.
# `|| true`: grep exits 1 when a note has no embeds, which is the normal case.
while IFS= read -r -d '' note; do
  grep -ohE '!\[\[[^]|#]+' "$note" | sed 's/^!\[\[//' || true
  grep -ohE '!\[[^]]*\]\([^)]+\)' "$note" | sed 's/.*(\(.*\))/\1/' || true
done < <(find "$DEST" -name '*.md' -print0) >"$refs"

a=0 missing=0
while IFS= read -r target; do
  [ -n "$target" ] || continue
  case "$target" in
    http://*|https://*|data:*) continue ;;   # not ours to copy
    *.md|*.md#*) continue ;;                 # note embed, not an attachment
    *.*) ;;                                  # has an extension: treat as a file
    *) continue ;;                           # no extension: a note embed
  esac
  target=${target%%\#*}                                    # drop #anchor
  base=$(basename "$(printf '%s' "$target" | sed 's/%20/ /g')")
  [ -e "$ASSETS/$base" ] && continue                       # already copied

  # resolve by basename, never looking inside the private dir: an embed that
  # only resolves to a private attachment must come back empty, not copied
  mapfile -t hits < <(find "$VAULT" -type f -name "$base" \
    -not -path '*/.git/*' -not -path '*/.obsidian/*' \
    -not -path "$VAULT/$PRIVATE_DIR/*" -print)

  case ${#hits[@]} in
    1) mkdir -p "$ASSETS"; cp "${hits[0]}" "$ASSETS/$base"
       echo "  + assets/$base"; a=$((a+1)) ;;
    0) echo "  ! embed not found outside $PRIVATE_DIR/: $base" >&2; missing=$((missing+1)) ;;
    *) echo "  ! ambiguous (${#hits[@]} matches), skipped: $base" >&2; missing=$((missing+1)) ;;
  esac
done <"$refs"

echo "synced $a attachment(s) -> content/assets/"
[ "$missing" -eq 0 ] || echo "$missing embed(s) unresolved — see warnings above" >&2
