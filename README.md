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
./sync.sh          # copy note ber-publish:true ke content/
git add -A && git commit -m "publish: <judul note>" && git push
```

Push ke `main` men-trigger GitHub Actions → GitHub Pages.

## Kenapa filternya di sync, bukan pas build

Vault-nya privat dan isinya ada password + jurnal pribadi. `sync.sh` menyaring **di lokal**, jadi note yang nggak ditandai nggak pernah masuk git history repo publik ini sama sekali. Plugin `explicit-publish` Quartz nyala juga sebagai lapis kedua.

## Preview lokal

```bash
npx quartz build --serve
```

## Test

```bash
./test_sync.sh     # memastikan filter publish nggak bocor
```
