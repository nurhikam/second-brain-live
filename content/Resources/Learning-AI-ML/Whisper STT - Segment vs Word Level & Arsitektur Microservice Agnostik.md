---
created: 2026-08-31
modified: 2026-09-11
tags:
  - whisper
  - stt
  - speech-to-text
  - microservice
  - architecture
status: completed
date: 2026-08-31
link_ref: https://huggingface.co/openai/whisper-large-v3-turbo
publish: true
---

# 🎙️ Whisper STT — Segment vs Word Level & Microservice Agnostik

> Dari discuss bareng Eric (CEO Braincore) 30 Aug 2026: format output Whisper, strategi fallback Cloudflare ↔ local, dan visi voice sebagai input utama web app.

---

## 1. Konsep Dasar: Output Whisper Ada 2 Granularitas

**Masalah:** Mau bikin fitur voice-to-text (subtitle, caption, voice input) tapi bingung format timestamp-nya — mau per kalimat atau per kata?
**Solusi:** Whisper bisa ngasih dua level: **segment** (per kalimat) dan **word** (per kata) — pilih sesuai kebutuhan UI.

### Segment Level — Per Kalimat

Cocok buat subtitle/caption baris per baris.

```json
{
  "text": "Halo semuanya, hari ini kita bakal bahas apa itu system design.",
  "segments": [
    {
      "start": 0.0,
      "end": 4.2,
      "text": "Halo semuanya, hari ini kita bakal bahas apa itu system design."
    }
  ],
  "language": "id"
}
```

### Word Level — Per Kata

Cocok buat highlight karaoke-style, word-by-word animation, atau analisis presisi.

```json
{
  "text": "Hari ini kita bakal bahas apa itu system design.",
  "words": [
    { "word": "Hari",   "start": 0.00, "end": 0.36 },
    { "word": "ini",    "start": 0.36, "end": 0.61 },
    { "word": "kita",   "start": 0.61, "end": 0.94 },
    { "word": "bakal",  "start": 0.94, "end": 1.31 },
    { "word": "bahas",  "start": 1.31, "end": 1.70 },
    { "word": "apa",    "start": 1.70, "end": 1.93 },
    { "word": "itu",    "start": 1.93, "end": 2.15 },
    { "word": "system", "start": 2.15, "end": 2.82 },
    { "word": "design", "start": 2.82, "end": 3.52 }
  ]
}
```

> [!NOTE] Kapan Pakai Mana?
> - **Segment** → subtitle video, transcript meeting
> - **Word** → karaoke highlight, animasi per kata (kayak *Remotion* bisa pakai word timestamps buat animasi teks), editor yang butuh presisi

---

## 2. Arsitektur: Fallback Cloudflare ↔ Local

Eric pakai **2-tier fallback** biar hemat + tetap jalan kalau quota habis:

```
Audio Input
    │
    ▼
┌─────────────┐     token habis?     ┌──────────────────┐
│  Cloudflare  │ ──── fallback ────► │  Local Whisper   │
│  (free tier, │                      │  v3 Turbo        │
│   cepat)     │                      │  (self-host)     │
└─────────────┘                      └──────────────────┘
    │                                        │
    └──────────────► JSON ◄──────────────────┘
              (segment / word)
```

- **Primary:** Cloudflare — gratis (free tier), cepat, terdeploy rapi
- **Fallback:** Local model `openai/whisper-large-v3-turbo` ([HuggingFace](https://huggingface.co/openai/whisper-large-v3-turbo)) — jalan kalau token CF habis
- **Kenapa v3 Turbo?** Versi distilled dari Whisper Large v3 — lebih cepat dengan akurasi hampir sama, cocok buat self-host

> [!TIP] Pattern Fallback
> Mirip pattern di *Remotion* atau service lain: coba yang murah/cepat dulu, fallback ke yang mahal/lokal kalau gagal. Hemat cost + resilient.

---

## 3. Visi Lebih Besar: Voice sebagai Input Utama

Eric memprediksi: **web app ke depan gak perlu form input lagi — cukup voice.**

```
Sekarang:  User → ketik form → submit → backend
Masa depan: User → ngomong → STT service → backend (sama aja kayak form)
```

Implikasinya:
- **STT jadi 1 microservice yang dipakai banyak apps** — bukan nempel di 1 app doang
- Contoh yang udah diterapin Eric: **service email yang agnostik** — mau dari Omniflow, Orvix, atau app client mana pun, semua urusan per-email-an nembak ke 1 service yang sama

### Prinsip Microservice Agnostik

```
Omniflow ──┐
Orvix ─────┼──► Email Service (agnostik) ──► kirim email
Client App ┘

App A ──┐
App B ──┼──► STT Service (agnostik) ──► transcript JSON
App C ──┘
```

**Kenapa agnostik lebih efisien:**
- 1 codebase, 1 infra, N consumer — gak duplikat logic di tiap app
- Update model / ganti provider (CF → local) cukup di 1 tempat
- Semua app dapet benefit yang sama tanpa deploy ulang masing-masing

---

## 4. Next Steps to Learn

- [x] Coba `whisper-large-v3-turbo` lokal — bandingin speed vs akurasi sama CF → **udah, lihat Update 2026-09-11 di bawah**
- [ ] Eksperimen word-level timestamps buat animasi teks (konek ke Remotion?)
- [x] Design STT microservice agnostik: API contract (input audio → output segment/word JSON), auth, rate limit → **udah dibangun**, endpoint OpenAI-compatible
- [x] Pelajari Cloudflare Workers AI — free tier limit & pricing setelah habis → **udah, lihat Update 2026-09-11**
- [ ] Pikirin UX voice input: kapan voice lebih enak dari ketik? (mobile, hands-free, accessibility)

---

## Update 2026-09-11 — Arsitektur di atas beneran dibangun

Rencana 2-tier di atas diimplementasi jadi satu gateway STT internal dengan endpoint **OpenAI-compatible** (`POST /v1/audio/transcriptions`), jadi consumer mana pun yang udah support "OpenAI Whisper API" tinggal diarahin ke situ — Hermes (4 profil), bot expense, n8n, semuanya nembak ke service yang sama. Ini persis prinsip microservice agnostik di bagian 3.

### Angka yang terukur

| | Cloudflare Workers AI | Local faster-whisper (CPU) |
|---|---|---|
| Model | `@cf/openai/whisper-large-v3-turbo` | `large-v3-turbo` int8 |
| Waktu (audio 6,4 detik) | **2–9 detik** | **27–40 detik** |
| RAM | nol (di sisi CF) | ~1,1 GB resident saat model ke-load |
| Biaya | $0.00051 / menit audio | gratis |

**Pricing CF:** free tier-nya 10.000 neuron/hari; whisper-large-v3-turbo makan ~237 neuron per menit audio → **±42 menit audio/hari gratis**. Voice note chat harian praktis nggak pernah nyentuh batas bayar.

**Ukuran model Whisper** (yang ke-download on-demand, cache di disk): `base` 150 MB · `medium` 1,5 GB · **`large-v3-turbo` 1,62 GB** · `large-v3` 2,9 GB. Turbo dan large-v3 hampir sama beratnya di disk — bedanya turbo jauh lebih cepat karena decoder-nya dipangkas (32 → 4 layer).

### Yang ternyata salah

- **CF Workers AI nolak `Content-Type: application/octet-stream`.** Kirim audio sebagai raw body dengan header itu → `400 AiError: Invalid input`. Yang diterima cuma `Content-Type: audio/*` (misal `audio/wav`). Multipart form-data juga 400. Ini yang paling lama ke-kejar karena pesan errornya nggak nyebut soal content type sama sekali.
- **Kuantisasi int8 nggak bikin file lebih kecil.** Asumsi umumnya "int8 = file lebih ringan" — ternyata `large-v3-turbo` di format CTranslate2 tetap 1,62 GB, sama kayak safetensors fp16 di HuggingFace. Yang hemat itu RAM + komputasi saat jalan, bukan ukuran di disk.
- **Model lokal per-proses itu jebakan RAM.** Kalau tiap aplikasi load modelnya sendiri, N aplikasi = N salinan di RAM. Di mesin dengan RAM terbatas, dua load bersamaan udah cukup buat bikin OOM killer nendang proses. Gateway terpusat + auto-unload setelah idle menyelesaikan ini.
- **Perbandingan akurasi turbo vs versi lokal belum konklusif.** Tes yang ada pakai audio TTS robotik, dan dua-duanya ngasih hasil mirip. Butuh rekaman suara manusia buat beneran ngukur.
- **Transkrip ngawur bisa jadi salah konfigurasi, bukan salah model.** Kasus nyata: engine-nya udah bener tapi `language` dipaksa `en` sementara audionya Indonesia — hasilnya kalimat Inggris ngawur. Nyalain `language: id` memperbaiki semuanya tanpa ganti model.

### Referensi harga

- [Cloudflare Workers AI — whisper-large-v3-turbo](https://developers.cloudflare.com/workers-ai/models/whisper-large-v3-turbo/) — $0.00051/audio minute
- [Whisper large-v3-turbo with chunking (tutorial CF)](https://developers.cloudflare.com/workers-ai/guides/tutorials/build-a-workers-ai-whisper-with-chunking/)

---

## Referensi

- Model: [openai/whisper-large-v3-turbo](https://huggingface.co/openai/whisper-large-v3-turbo) — HuggingFace
- Discuss: Eric Julianto (CEO Braincore), 30 Aug 2026 — grup chat
- Terkait di vault: *Remotion* (word timestamps → animasi), [[Docker (Fundamental)]] (containerize STT service)

> [!NOTE] Harga & limit Cloudflare Workers AI bisa berubah — cek dashboard CF untuk info terbaru.
