# TICKET-007 — Pengaman sebelum push

**Status:** todo
**Priority:** medium
**Blocking:** -
**Blocked by:** -

## Deskripsi
Sekarang keamanan bergantung pada lo inget jalanin `sync.sh` dan nggak pernah nyalin file ke `content/` manual. Perlu sesuatu yang gagal sendiri kalau itu kejadian.

## Scope
- Cek: tiap `*.md` di `content/` (selain `index.md`) harus punya `publish: true`
- Pasang sebagai pre-push hook atau step di workflow yang bikin build gagal

## Acceptance Criteria
- [ ] File tanpa `publish: true` di `content/` bikin push atau build gagal
- [ ] Pesan errornya nyebut file mana yang salah

## Notes
Murah, dan nutup satu-satunya jalan bocor yang tersisa: kesalahan manusia, bukan bug.
