# TICKET-009 — Custom domain notes.nurhikam.my.id

**Status:** done
**Priority:** medium
**Blocking:** -
**Blocked by:** TICKET-004

## Deskripsi
Ganti URL dari `nurhikam.github.io/second-brain-live` ke `notes.nurhikam.my.id`.

## Scope
- `baseUrl` di `quartz.config.yaml` -> `notes.nurhikam.my.id`
- Nyalain plugin `cname` biar `public/CNAME` ikut ke-emit
- Record DNS di Jagoan Hosting: `notes` CNAME ke `nurhikam.github.io`
- Set custom domain di setting Pages, lalu paksa HTTPS

## Acceptance Criteria
- [x] `public/CNAME` isinya `notes.nurhikam.my.id`
- [x] `dig notes.nurhikam.my.id CNAME` balas `nurhikam.github.io`
- [x] https://notes.nurhikam.my.id balas 200
- [x] Sertifikat HTTPS terbit dan `Enforce HTTPS` nyala

## Notes
Urutannya penting. Begitu commit yang bawa `CNAME` ke-push, GitHub Pages langsung nganggep situsnya pindah ke domain baru, dan URL `github.io` lama jadi redirect ke sana. Kalau DNS-nya belum ada, situs nggak kebuka di kedua alamat sampai record-nya nongol. Jadi: DNS dulu, baru push.
