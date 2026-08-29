---
created: 2026-08-27
modified: 2026-08-27
publish: true
---

# Day 2 - API Mastery (OpenAI & Groq)

## 1. Struktur Chat (Roles)
Dalam API modern (`chat.completions`), percakapan disusun sebagai *List of Dictionaries* dengan 3 peran utama:

* **`system`** (The Instruction):
    * Instruksi mutlak/inisialisasi karakter model.
    * User tidak melihat ini, tapi ini yang menyetir perilaku model.
    * *Contoh:* "Kamu adalah asisten coding yang galak."
* **`user`** (The Input):
    * Pesan atau pertanyaan dari pengguna akhir.
* **`assistant`** (The Output):
    * Jawaban dari model.
    * Bisa direkayasa untuk memberikan contoh jawaban (Few-Shot) atau menyuntikkan history percakapan.

## 2. Parameter Penting (The Knobs)
* **`temperature` (0.0 - 2.0)**: Mengatur tingkat "kreativitas" atau keacakan.
    * **0.0 (Strict):** Stabil, deterministik. Wajib untuk tugas ekstraksi data (KTP/Invoice) atau coding.
    * **0.7 - 1.0 (Balanced):** Kreatif standar. Cocok untuk chat umum/menulis.
    * **> 1.0 (Random):** Berisiko halusinasi tinggi.
* **`max_tokens`**: Membatasi panjang output jawaban (menghemat biaya & waktu).

## 3. Standar Coding (Python)
Gunakan library `openai` atau `groq`.

**Standard Method (Wajib Pakai):**
`client.chat.completions.create(...)`
* **Kenapa?** Mendukung struktur `messages` (roles), bisa diset karakternya, dan merupakan standar universal (OpenAI, Anthropic, Mistral).

**Non-Standard/Legacy:**
`client.responses.create(...)` atau `client.completions.create(...)`
* Fitur eksperimental atau jadul. Kurang kontrol terhadap persona (`system`) dan history chat.

## 4. Tools Setup
* **Google Colab:** Untuk prototyping cepat (Free GPU).
* **VS Code + Python 3.10+:** Untuk development project serius (nanti).
