# second-brain-live

Situs publik dari vault Obsidian privat (`../second-brain`), dibangun pakai [Quartz 5](https://quartz.jzhao.xyz).

## Cara publish sebuah note

Tambahin ke frontmatter note-nya di vault:

```yaml
---
publish: true
---
```

Lalu:

```bash
./sync.sh          # copy note ber-publish:true ke content/, plus gambar yang dipake
git add -A && git commit -m "publish: <judul note>" && git push
```

Gambar yang di-embed note kepublish (`![[foo.png]]`) ikut kecopy ke `content/assets/`.
Yang kecopy cuma yang beneran dipake — folder attachment vault nggak pernah disalin
bulat-bulat, soalnya isinya campur sama gambar punya note privat.

Push ke `main` men-trigger GitHub Actions → GitHub Pages.

## Kenapa filternya di sync, bukan pas build

Vault-nya privat dan isinya ada password + jurnal pribadi. `sync.sh` menyaring **di lokal**, jadi note yang nggak ditandai nggak pernah masuk git history repo publik ini sama sekali. Plugin `explicit-publish` Quartz nyala juga sebagai lapis kedua.

## Pengaman

`sync.sh` itu gerbangnya; `check_content.sh` jaring pengamannya — nolak tiap note di
`content/` yang nggak ada `publish: true`, buat nutup kasus file kesalin manual atau
sisa note yang flag-nya udah dicabut di vault.

Jalan otomatis di CI sebelum build, jadi note yang nggak ditandai nggak akan pernah
sampai Pages. Biar gagalnya kelihatan lebih cepet, aktifin hook lokalnya sekali per
clone:

```bash
git config core.hooksPath hooks     # pre-push jalanin check_content.sh
```

## Preview lokal

```bash
npx quartz build --serve
```

## Test

```bash
./test_sync.sh     # nguji filter publish + guard-nya sekalian
./check_content.sh # cek content/ yang sekarang
```
