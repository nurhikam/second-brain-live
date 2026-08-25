# TICKET-003 — Tema, tipografi, warna

**Status:** done
**Priority:** medium
**Blocking:** -
**Blocked by:** TICKET-001

## Deskripsi
Bikin situsnya nggak kelihatan kayak Quartz default, tanpa nyentuh layout.

## Scope
- Font: Geist (header + body), Geist Mono (code), di `theme.typography` dan di opsi plugin `quartz-fonts`
- Palet: aksen hijau forest, netral off-white / off-black, satu aksen dikunci di dua mode
- Verifikasi kontras WCAG AA secara angka, bukan kira-kira
- Graph dan backlinks `display: all` biar muncul di mobile
- Matiin plugin `cname` (ini project page, bukan custom domain)

## Acceptance Criteria
- [x] Body 9.4:1 light, 11.8:1 dark
- [x] Link 5.9:1 light, 7.5:1 dark
- [x] Teks muted 4.9:1 light, 5.6:1 dark
- [x] Nggak ada `public/CNAME` di hasil build
- [x] Nol em-dash di teks yang kelihatan

## Notes
Plugin `quartz-fonts` punya default sendiri, kepisah dari `theme.typography`. Kalau cuma set salah satu, situsnya narik dua stylesheet font yang beda.
