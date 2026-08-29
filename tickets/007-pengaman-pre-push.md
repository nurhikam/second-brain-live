# TICKET-007 — Pengaman sebelum push

**Status:** done
**Priority:** medium
**Blocking:** -
**Blocked by:** -

## Deskripsi
Sekarang keamanan bergantung pada lo inget jalanin `sync.sh` dan nggak pernah nyalin file ke `content/` manual. Perlu sesuatu yang gagal sendiri kalau itu kejadian.

## Scope
- Cek: tiap `*.md` di `content/` (selain `index.md`) harus punya `publish: true`
- Pasang sebagai pre-push hook atau step di workflow yang bikin build gagal

## Acceptance Criteria
- [x] File tanpa `publish: true` di `content/` bikin push atau build gagal
- [x] Pesan errornya nyebut file mana yang salah

## Notes
Murah, dan nutup satu-satunya jalan bocor yang tersisa: kesalahan manusia, bukan bug.

## Hasil
`check_content.sh` — nolak tiap `*.md` di `content/` (kecuali `index.md`) yang
frontmatter-nya nggak ada `publish: true`. Dipasang di dua tempat:

- **CI**: step `./check_content.sh` di `deploy.yml`, **sebelum** `npx quartz build`.
  Ini yang otoritatif — build gagal, nggak ada yang naik ke Pages.
- **Lokal**: `hooks/pre-push`, aktifin sekali per clone dengan
  `git config core.hooksPath hooks`. Cuma biar gagalnya lebih cepet; CI tetap
  yang nentuin.

Predikat frontmatter-nya **disalin persis dari `sync.sh`**, dan `test_sync.sh`
sekarang nguji dua-duanya sekaligus: output `sync.sh` harus lolos guard (kalau
nggak, berarti dua-duanya udah beda arah), guard harus nolak file tanpa
`publish: true`, dan `index.md` harus dikecualiin.
