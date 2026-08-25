# TICKET-001 — Scaffold Quartz

**Status:** done
**Priority:** high
**Blocking:** TICKET-003, TICKET-004
**Blocked by:** -

## Deskripsi
Siapin Quartz 5 sebagai mesin situs, bersihin bawaan repo upstream yang nggak kepake.

## Scope
- Clone Quartz 5, buang `.git`-nya, init repo baru
- `quartz.config.yaml` dari `quartz.config.default.yaml`
- Hapus cruft upstream: CODE_OF_CONDUCT, Dockerfile, issue template, workflow upstream
- `.gitignore` buat `node_modules/`, `public/`

## Acceptance Criteria
- [x] `npx quartz build` sukses
- [x] Cuma workflow kita yang ada di `.github/workflows/`
