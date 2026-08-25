# TICKET-004 — Deploy ke GitHub Pages

**Status:** done
**Priority:** high
**Blocking:** TICKET-005
**Blocked by:** TICKET-001

## Deskripsi
Push ke `main` langsung jadi situs, tanpa langkah manual.

## Scope
- Workflow `deploy.yml`: build lalu deploy, `fetch-depth: 0` biar tanggal dari git akurat
- Repo publik `nurhikam/second-brain-live`
- Pages dengan `build_type: workflow`

## Acceptance Criteria
- [x] Actions run hijau
- [x] https://nurhikam.github.io/second-brain-live/ balas HTTP 200
- [x] `<title>` sesuai konfigurasi

## Notes
Ada annotation deprecation Node 20 dari actions upstream. Nggak bikin gagal, tapi bakal jadi TICKET sendiri kalau nanti mulai error.
