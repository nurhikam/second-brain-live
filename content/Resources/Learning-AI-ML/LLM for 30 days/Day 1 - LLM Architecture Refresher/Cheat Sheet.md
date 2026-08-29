---
created: 2026-08-27
modified: 2026-08-27
publish: true
---

# Day 1 - LLM Architecture Refresher

## 1. Transformer Basics: Encoder vs Decoder

**Encoder (The Understander)**
* **Sifat:** Bidirectional (Melihat konteks kiri dan kanan sekaligus).
* **Fokus:** Memahami makna kalimat secara utuh.
* **Contoh Model:** BERT.
* **Kegunaan:** Klasifikasi teks, Named Entity Recognition (NER).
* **Analogi:** Seperti melihat sebuah **foto** secara utuh.

**Decoder (The Generator)**
* **Sifat:** Unidirectional / Causal (Hanya melihat ke belakang/masa lalu).
* **Mekanisme Kunci:** Masked Self-Attention (Mencegah model "mengintip" kata masa depan saat training agar tidak curang).
* **Fokus:** Next Token Prediction (Generative).
* **Contoh Model:** GPT.
* **Analogi:** Seperti membaca **buku** kata demi kata dari awal.

## 2. Tokenisasi & Context Window

**Tokenisasi (The Currency)**
* **Fungsi:** Mengubah teks menjadi representasi angka (ID).
* **Metode:** Sub-word Tokenization (BPE - Byte Pair Encoding).
  * Kata umum = 1 token.
  * Kata kompleks/asing = dipecah jadi beberapa token.
* **Tools:** `tiktoken` (Library OpenAI).
* **Biaya:** Bahasa Inggris biasanya lebih efisien (murah) tokennya dibanding Bahasa Indonesia.

**Context Window (The Limit)**
* **Definisi:** "Memori jangka pendek" atau kapasitas input maksimal model.
* **Prinsip:**
  * Jika penuh, token paling lama (awal) akan **dibuang (truncated)** agar muat token baru.
  * Jika dipaksa masuk sekaligus melebihi batas, API akan error.
