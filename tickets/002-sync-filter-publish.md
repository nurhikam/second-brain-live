# TICKET-002 — Gerbang sync `publish: true`

**Status:** done
**Priority:** critical
**Blocking:** TICKET-005
**Blocked by:** TICKET-001

## Deskripsi
Cuma note yang ditandai `publish: true` boleh keluar dari vault privat. Filternya jalan di lokal, sebelum apapun ke-push, biar note privat nggak pernah masuk history repo publik.

## Scope
- `sync.sh`: scan vault, copy note yang lolos ke `content/`, pertahanin struktur folder
- `publish: true` cuma dihitung kalau ada di dalam blok frontmatter
- Skip `.git/` dan `.obsidian/`
- Bersihin `content/` tiap sync, kecuali `index.md` yang ditulis tangan
- `test_sync.sh` sebagai pengaman

## Acceptance Criteria
- [x] `publish: true` di frontmatter lolos
- [x] `publish: false` ditolak
- [x] Note tanpa frontmatter ditolak
- [x] `publish: true` di badan note ditolak
- [x] `publish: true` setelah blok frontmatter ditutup ditolak
- [x] Note di subfolder lolos dengan path-nya utuh
- [x] `Passw.md` ditolak
- [x] `./test_sync.sh` lewat

## Notes
Sempat ada bug: `exit 0` di awk ketiban `END{exit 1}`, jadi semua note ditolak diam-diam. Ketahuan gara-gara test-nya. Itu alasan test ini ada.
