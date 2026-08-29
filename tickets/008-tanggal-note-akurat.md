# TICKET-008 — Tanggal note akurat

**Status:** done
**Priority:** low
**Blocking:** -
**Blocked by:** TICKET-005

## Deskripsi
Plugin `created-modified-date` baca dari git repo situs, jadi semua note kelihatan dibuat di tanggal sync, bukan tanggal aslinya.

## Scope
- Pilih salah satu: `created` / `modified` di frontmatter vault, atau `sync.sh` yang mertahanin mtime file

## Acceptance Criteria
- [x] Tanggal di situs sesuai tanggal note di vault

## Notes
Prioritas rendah, kelihatan jelek doang. Naik prioritas kalau nanti bikin halaman "catatan terbaru".

## Hasil
`sync.sh` sekarang nulis `created:`/`modified:` ke frontmatter note yang dicopy
(bukan ke note vault-nya). Plugin `created-modified-date` udah nyusun
prioritasnya `frontmatter` → `git` → `filesystem`, jadi begitu frontmatter-nya
keisi, git repo publik ini nggak dipake lagi buat nentuin tanggal.

Sumber tanggalnya, urut:
1. `created:`/`modified:` yang emang udah ditulis penulisnya — **nggak pernah ditimpa**
2. `date:` (ejaan lama di vault) → dipromosiin jadi `created`
3. git **vault** (`--follow`, commit pertama = created, terakhir = modified)
4. mtime file di vault

`defaultDateType` diganti `modified` → `created`. Aman sekarang, soalnya
frontmatter yang nentuin, bukan git — dan buat situs catatan, yang relevan itu
kapan notenya ditulis, bukan kapan kepublish.

**Batas yang jujur:** cuma 1 dari 16 note (`Docker (Fundamental)`, `date: 2025-11-27`)
yang punya tanggal asli. Sisanya nggak punya tanggal di frontmatter, dan git vault
nyatetnya **semua di 2026-08-27** — bukan karena ditulis hari itu, tapi karena baru
masuk git vault waktu itu (dicek pake `--follow`, jadi bukan efek rename folder).
mtime juga nggak kepake, ke-reset waktu clone. Jadi tanggal aslinya emang **nggak
bisa dipulihin** buat 15 note itu, dan sengaja nggak dikarang. Yang berubah: tanggal
situs sekarang properti vault, bukan tanggal sync — dan note baru yang nulis
`created:` (konvensi vault yang sekarang) bakal langsung akurat.

**Efek samping:** file yang nggak diakhiri newline sekarang jadi diakhiri newline,
gara-gara file-nya di-rewrite pas nyisipin frontmatter. Nggak ngefek ke render.
