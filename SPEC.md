# SPEC — second-brain-live

## Tujuan
Bikin vault Obsidian pribadi (`../second-brain`, repo privat) bisa dibaca publik lewat web, tanpa mindahin note privat ke tempat publik.

## Non-goal
- Bukan Obsidian Publish replacement penuh (nggak ada canvas interaktif, nggak ada sinkron dua arah).
- Bukan CMS. Nulis tetap di Obsidian, situs cuma output.
- Nggak nyentuh isi vault selain nambah field `publish` di frontmatter.

## Constraint
- Vault privat dan harus tetap privat. Isinya ada `Private/Passw.md` dan 67 note jurnal.
- Akun GitHub Free: Pages cuma jalan dari repo publik. Jadi repo situs harus terpisah dari repo vault.
- Gratis. Nggak nambah layanan berbayar.

## Model keamanan
Gerbangnya `sync.sh`, jalan di mesin lokal sebelum apapun ke-push.

- Note ikut ke `content/` **cuma** kalau ada `publish: true` di dalam blok frontmatter (antara `---` pertama dan kedua).
- `publish: true` di badan note nggak ngaruh. `publish: false` dan note tanpa frontmatter ditolak.
- Note yang nggak lolos nggak pernah jadi file di repo publik, jadi nggak ada di git history-nya juga.
- Plugin Quartz `explicit-publish` nyala sebagai lapis kedua, bukan sebagai gerbang utama.

Alasan filternya di sync dan bukan di build: kalau filter jalan pas build, seluruh vault harus ada di repo publik dulu, dan yang njagain cuma satu baris config.

## Arsitektur
```
second-brain/        repo privat, vault Obsidian
    |
    |  ./sync.sh  (filter publish: true)
    v
second-brain-live/   repo publik
    content/         hasil sync, satu-satunya yang naik
    quartz.config.yaml
    .github/workflows/deploy.yml
    |
    v
GitHub Actions -> GitHub Pages
```
Satu arah. Situs nggak pernah nulis balik ke vault.

## Alur pakai
1. Tandai `publish: true` di frontmatter note yang mau dipublik.
2. `./sync.sh`
3. `git add -A && git commit && git push`
4. Actions build dan deploy sendiri.

## Keputusan desain
| Keputusan | Alasan |
|---|---|
| Quartz 5, bukan Next.js sendiri | wikilink, backlink, graph, search, popover udah jadi. Nulis sendiri berarti kehilangan semua itu. |
| Dua repo, bukan satu | Pages dari repo privat butuh GitHub Pro. Repo publik = seluruh isi kebaca. |
| Filter di sync, bukan di build | Note privat nggak pernah masuk history repo publik. |
| Geist + Geist Mono | Bukan Inter, bukan default Quartz. Cocok buat konteks teknis. |
| Aksen hijau forest, satu warna, dua mode | Bukan AI-purple. Satu aksen dikunci di light dan dark. |
| Plugin `cname` nyala, isi `notes.nurhikam.my.id` | Situs pakai custom domain. Sempat dimatiin waktu masih di project page. |

## Acceptance
- [x] Note tanpa `publish: true` nggak pernah sampai ke `content/`
- [x] `test_sync.sh` lewat, termasuk kasus `Passw.md` dan `publish: true` di badan note
- [x] Wikilink, backlink, dan graph jalan
- [x] Graph dan backlink kelihatan di mobile, bukan cuma desktop
- [x] Kontras teks lolos WCAG AA di light dan dark
- [x] Situs live di https://notes.nurhikam.my.id
- [ ] Ada note asli yang kepublish, bukan cuma homepage
