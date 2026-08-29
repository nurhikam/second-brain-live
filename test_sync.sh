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

O="$T/out"; mkdir -p "$O"
VAULT="$V" DEST="$O" ./sync.sh >/dev/null

got=$(cd "$O" && find . -name '*.md' ! -name 'index.md' | sed 's|^\./||' | sort | tr '\n' ' ')
want="sub/yes-nested.md yes.md "
[ "$got" = "$want" ] && echo "PASS sync" || { echo "FAIL sync: got [$got] want [$want]"; exit 1; }

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
