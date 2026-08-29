#!/usr/bin/env bash
# Guard the publish filter: only real frontmatter `publish: true` may pass.
set -euo pipefail
T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
V="$T/vault"; mkdir -p "$V/sub"

printf -- '---\ntitle: a\npublish: true\n---\nbody\n'            > "$V/yes.md"
printf -- '---\npublish: false\n---\nbody\n'                     > "$V/no-false.md"
printf -- '---\ntitle: b\n---\nbody\n'                           > "$V/no-none.md"
printf -- 'no frontmatter\npublish: true\n'                      > "$V/no-body.md"
printf -- '---\ntitle: c\n---\ntext\npublish: true\n'            > "$V/no-afterblock.md"
printf -- '---\npublish: true\n---\nsecret\n'                    > "$V/sub/yes-nested.md"
printf -- 'PASSWORDS\n'                                          > "$V/Passw.md"
mkdir -p "$V/Private"
# marked for publish, but sits in the private dir: must still be refused
printf -- '---\npublish: true\n---\nghp_realtoken\n'              > "$V/Private/token.md"

# --- attachments: one shared folder holding public and private images alike,
# which is the arrangement that makes "just copy the folder" a data leak
mkdir -p "$V/Attachment"
printf 'PUBLIC-PNG\n'   > "$V/Attachment/used.png"
printf 'PRIVATE-PNG\n'  > "$V/Attachment/private-only.png"
printf 'UNUSED-PNG\n'   > "$V/Attachment/never-referenced.png"
# embedded by a published note -> must be copied
printf -- '---\npublish: true\n---\n![[used.png]]\n![alt](https://ex.com/x.png)\n' > "$V/has-embed.md"
# embedded only by notes that never publish -> must NOT be copied
printf -- '---\npublish: false\n---\n![[private-only.png]]\n'     > "$V/no-embed-unpub.md"
printf -- '---\npublish: true\n---\n![[private-only.png]]\n'      > "$V/Private/embed-private.md"

O="$T/out"; mkdir -p "$O"
VAULT="$V" DEST="$O" ./sync.sh >/dev/null

got=$(cd "$O" && find . -name '*.md' ! -name 'index.md' | sed 's|^\./||' | sort | tr '\n' ' ')
want="has-embed.md sub/yes-nested.md yes.md "
[ "$got" = "$want" ] && echo "PASS sync" || { echo "FAIL sync: got [$got] want [$want]"; exit 1; }

# --- attachments: only what a published note actually embeds ---

gota=$(cd "$O" && find . -type f ! -name '*.md' | sed 's|^\./||' | sort | tr '\n' ' ')
wanta="assets/used.png "
[ "$gota" = "$wanta" ] || { echo "FAIL assets: got [$gota] want [$wanta]"; exit 1; }

# the leak this ticket exists to prevent: an image reachable only from notes
# that never publish must not be sitting in the output
[ ! -e "$O/assets/private-only.png" ] \
  || { echo "FAIL assets: image embedded only by private/unpublished notes was copied"; exit 1; }
# and copying the folder wholesale would have dragged this one along too
[ ! -e "$O/assets/never-referenced.png" ] \
  || { echo "FAIL assets: unreferenced image was copied"; exit 1; }

# a dropped embed must not leave its attachment behind on the next run
printf -- '---\npublish: true\n---\nno more embed\n' > "$V/has-embed.md"
VAULT="$V" DEST="$O" ./sync.sh >/dev/null 2>&1
[ ! -e "$O/assets/used.png" ] \
  || { echo "FAIL assets: attachment survived its note dropping the embed"; exit 1; }

echo "PASS assets"

# --- check_content.sh: the tripwire for when sync.sh gets bypassed ---

# sync.sh's own output must satisfy the guard, or the two have drifted apart
DEST="$O" ./check_content.sh >/dev/null \
  || { echo "FAIL guard: rejected sync.sh's own output"; exit 1; }

# and it must actually trip — a guard that never fails is not a guard
printf -- '---\npublish: false\n---\nleak\n' > "$O/leak.md"
if DEST="$O" ./check_content.sh >/dev/null 2>&1; then
  echo "FAIL guard: passed a file without publish: true"; exit 1
fi
rm "$O/leak.md"

# index.md is hand-written and has no frontmatter: it must be exempt
printf -- 'homepage\n' > "$O/index.md"
DEST="$O" ./check_content.sh >/dev/null \
  || { echo "FAIL guard: index.md must be exempt"; exit 1; }

echo "PASS guard"
