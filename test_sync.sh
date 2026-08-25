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

VAULT="$V" ./sync.sh >/dev/null

got=$(cd content && find . -name '*.md' ! -name 'index.md' | sed 's|^\./||' | sort | tr '\n' ' ')
want="sub/yes-nested.md yes.md "
[ "$got" = "$want" ] && echo "PASS" || { echo "FAIL: got [$got] want [$want]"; exit 1; }
