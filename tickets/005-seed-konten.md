# TICKET-005 — Isi konten pertama

**Status:** todo
**Priority:** high
**Blocking:** TICKET-006
**Blocked by:** TICKET-002, TICKET-004

## Deskripsi
Situsnya udah live tapi isinya baru homepage. Perlu note asli biar graph dan backlink ada gunanya.

## Scope
- Pilih note dari `30_Resources` dan `10_Projects` yang layak publik
- Tambahin `publish: true` di frontmatter-nya
- `./sync.sh` lalu push
- Cek link antar note nyambung, bukan jadi link putus

## Acceptance Criteria
- [ ] Minimal 5 note kepublish
- [ ] Graph nunjukin koneksi, bukan titik-titik terpisah
- [ ] Nggak ada wikilink putus ke note yang nggak kepublish

## Notes
Wikilink ke note yang nggak kepublish bakal jadi link putus. Pas milih note, ikutin juga tetangganya, atau edit link-nya.
