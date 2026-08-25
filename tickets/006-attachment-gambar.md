# TICKET-006 — Attachment dan gambar ikut kesync

**Status:** todo
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
- [ ] Gambar di note kepublish kerender di situs
- [ ] Attachment yang cuma dipake note privat nggak ikut kecopy
- [ ] Test nutup kasus "attachment note privat nggak boleh bocor"

## Notes
Ini lubang keamanan juga, bukan cuma bug tampilan: nyalin folder attachment bulat-bulat bakal ngepublish gambar dari note privat.
