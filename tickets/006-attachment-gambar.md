# TICKET-006 — Attachment dan gambar ikut kesync

**Status:** done
**Priority:** high
**Blocking:** -
**Blocked by:** TICKET-005

## Deskripsi
`sync.sh` cuma nyalin `*.md`. Note yang nge-embed gambar (`![[foo.png]]`) bakal kepublish dengan gambar rusak.

## Scope
- Parse embed dari note yang lolos filter
- Copy cuma attachment yang beneran dipake note kepublish, jangan seluruh folder attachment
- Tambahin kasusnya ke `test_sync.sh`

## Acceptance Criteria
- [x] Gambar di note kepublish kerender di situs
- [x] Attachment yang cuma dipake note privat nggak ikut kecopy
- [x] Test nutup kasus "attachment note privat nggak boleh bocor"

## Notes
Ini lubang keamanan juga, bukan cuma bug tampilan: nyalin folder attachment bulat-bulat bakal ngepublish gambar dari note privat.

## Hasil
Kekhawatiran di Notes itu kejadian beneran: 5 gambar yang dibutuhin ada di
`Archive/Resources-Legacy/Attachment/` **bareng 63 file lain** punya note privat dan
arsip. Nyalin foldernya = ngepublish 68 file. Jadi resolusinya per-embed, bukan per-folder.

Cara kerjanya:
- Baca embed (`![[x.png]]` dan `![](x.png)`) cuma dari note yang **udah lolos filter
  publish** — bukan dari seluruh vault.
- Resolve per basename, dan `find`-nya **nggak pernah masuk `Private/`**. Jadi embed yang
  cuma ketemu di note privat balik kosong, bukan kecopy.
- Semua mendarat flat di `content/assets/`, bukan ngikutin path vault. Dua alasan:
  `markdownLinkResolution: shortest` emang nyari by basename, dan kalau path vault
  ditiru, nama folder vault (`Archive/Resources-Legacy/...`) jadi URL publik.
- `assets/` dibongkar tiap run, biar attachment nggak nyangkut setelah note-nya berhenti
  nge-embed.

Emitter `Assets()` ternyata **built-in dan selalu nyala** (`config-loader.ts:498`), jadi
nggak perlu nambah plugin di `quartz.config.yaml`.

Diverifikasi lewat build beneran: 5 embed jadi `<img>` yang nunjuk file yang emang ada,
0 broken.

**Belum kecakup:** link attachment non-embed (`[baca](file.pdf)` tanpa `!`) masih nggak
ikut kecopy. Belum ada kasusnya di vault.
