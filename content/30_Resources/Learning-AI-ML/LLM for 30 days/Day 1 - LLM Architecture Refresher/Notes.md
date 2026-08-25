---
publish: true
---

# Day 1 - LLM Architecture Refresher

## Goals (dari roadmap)
- [ ] Pahami transformer basics: encoder vs decoder
- [ ] Pahami context window & tokenisasi (tiktoken)
- [ ] Bisa jelasin beda GPT (decoder-only) vs BERT (encoder-only) dalam 2 menit


# Unsupervised Pre-Training
![[Pasted image 20251129092811.png]]
# Transformers LM Component
## 1. Feed Forward Neural Network
Kata apa yang akan muncul setelah kata ini
Decoder only. 
![[Pasted image 20251129093122.png]]

## 2. Self-Attention
What does it refer to?![[Pasted image 20251129093717.png]]

# Tokenizer 
![[Pasted image 20251129093901.png]]

### The Big Picture (Gambaran Besar)

misalnya saat Anda menggunakan Google Translate dari "I love AI" ke Indonesia.

1. **Tokenizer:** Memecah "I love AI" menjadi `["I", "love", "AI"]`.    
2. **Embedding:** Mengubah kata-kata itu menjadi angka (vektor) yang punya makna.
3. **Encoder:** Membaca angka-angka itu dan memahami konteks: "Oh, ini kalimat positif tentang menyukai teknologi."
4. **Decoder:** Mengambil pemahaman itu, lalu mulai menulis terjemahan:
    - Menghasilkan angka...
    - **Output Layer** memilih kata terbaik... "Saya"        
    - Ulangi... "suka"
    - Ulangi... "AI"
5. **Tokenizer (lagi):** Menggabungkan potongan-potongan itu menjadi kalimat utuh: "Saya suka AI".

[[Hubungan Fast Forward Neural Network (FFNN) & Self-Attention pada LLM]]
Encoder vs Decoder

## **Transformer Basics: Encoder vs Decoder**. 
Arsitektur ini pertama kali diperkenalkan dalam paper terkenal "Attention is All You Need" (2017).
![[Pasted image 20251202091059.png]]

1. **Encoder (The Understander):** Mengubah token input menjadi **Contextual Embeddings**. "Representasi angka" yang kamu maksud adalah vektor padat (_dense vector_) yang berisi pemahaman makna kata _sesuai konteks kalimatnya_.
    
    - _Sifat:_ **Bidirectional** (Bisa melihat ke kiri dan ke kanan seluruh kalimat sekaligus).
        
2. **Decoder (The Generator):** Mengambil representasi tersebut (sering lewat mekanisme _Cross-Attention_) dan memprediksi **token berikutnya** (_next token prediction_) secara autoregresif.
    
    - _Sifat:_ **Unidirectional** (Hanya boleh melihat ke belakang/masa lalu).
        

Nah, karena **Decoder** tugasnya adalah memprediksi kata selanjutnya, ada satu mekanisme "penutup mata" yang dipasang di Decoder tapi tidak ada di Encoder.

Mekanisme tersebut disebut **Cheating** (mencontek).

Bayangkan kamu sedang ujian "Melengkapi Kalimat".

Soal: "Ibu pergi ke \_\_\_\_\_ untuk membeli sayur."

Jika kamu bisa mengintip jawaban di masa depan (kata "pasar"), kamu tidak akan belajar memahami konteks ("membeli sayur" biasanya di pasar). Kamu hanya akan belajar menyalin kata sebelah kanan. Saat tes beneran (inference) di mana masa depan belum terjadi, modelmu akan bingung karena tidak ada yang bisa dicontek.

Mekanisme ini disebut **Masked Self-Attention**.

Secara teknis, kita memberikan nilai minus tak hingga ($-\infty$) pada *matriks attention* untuk token di masa depan, sehingga probabilitasnya menjadi 0 setelah Softmax.

## Tokenisasi & Context Window

Ini ibarat "mata uang" dan "dompet" di dunia LLM.
### 1. Tokenisasi (The Currency)

Komputer tidak mengerti huruf "A" atau kata "Budi". Mereka cuma mengerti angka. Jadi, tugas **Tokenisasi** adalah memotong-motong teks kita menjadi potongan kecil (_token_) dan memberinya nomor ID.

Tadi kamu sempat menebak dua cara:

1. **Per Kata** (misal: `saya`, `suka`, `koding`).
2. **Per Karakter** (misal: `s`, `a`, `y`, `a`).

Ternyata, GPT menggunakan jalan tengah yang disebut **Sub-word Tokenization** (spesifiknya algoritma BPE - _Byte Pair Encoding_). Library `tiktoken` yang ada di roadmapmu itu alat untuk melakukan ini dengan super cepat.

Prinsip kerjanya:

- Kata yang **sering muncul** dijadikan 1 token (hemat tempat).
- Kata yang **jarang/kompleks** dipecah menjadi beberapa suku kata.

**Fakta Menarik tentang `tiktoken` (Library OpenAI):** Pernah bertanya kenapa biaya API GPT untuk Bahasa Indonesia sering lebih mahal daripada Bahasa Inggris? Karena tokenisasinya dioptimalkan untuk Inggris.

- "Apple" (Inggris) = 1 token.
    
- "Apel" (Indonesa) = mungkin dipecah jadi "Ap" + "el" (2 token). Jadi, kalimat yang sama panjangnya, jumlah tokennya bisa lebih banyak di Bahasa Indonesia.