# TICKET-005 — Isi konten pertama

**Status:** done
**Priority:** high
**Blocking:** TICKET-006
**Blocked by:** TICKET-002, TICKET-004

## Deskripsi
Situsnya udah live tapi isinya baru homepage. Perlu note asli biar graph dan backlink ada gunanya.

## Scope
- Pilih note dari `Resources` dan `Projects` yang layak publik
- Tambahin `publish: true` di frontmatter-nya
- `./sync.sh` lalu push
- Cek link antar note nyambung, bukan jadi link putus

## Acceptance Criteria
- [x] Minimal 5 note kepublish
- [x] Graph nunjukin koneksi, bukan titik-titik terpisah
- [x] Nggak ada wikilink putus ke note yang nggak kepublish

## Hasil
16 note kepublish (commit `37595d5`), semuanya dari `Resources/`:
`Learning-AI-ML/` (9, termasuk seri "LLM for 30 days"), `Ops-Guides/` (6),
`Learning-DevOps/` (1). Belum ada dari `Projects/`.

## Notes
Wikilink ke note yang nggak kepublish bakal jadi link putus. Pas milih note, ikutin juga tetangganya, atau edit link-nya.
