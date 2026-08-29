---
created: 2026-08-27
modified: 2026-08-27
publish: true
---

# Roadmap Persiapan Junior LLM Engineer (5 Minggu)

**Target Start Date:** 5 Januari 2026 **Fokus:** LLM Application Development, RAG, & Deployment

## Minggu 1: Foundation & The "New" Stack

**Goal:** Memahami cara kerja LLM di level API dan Prompt Engineering tingkat lanjut. Bukan sekadar chat di ChatGPT.

- **Day 1: LLM Architecture Refresher**
    
    - _Pelajari:_ Transformer basics (Encoder vs Decoder), Context Window, Tokenization (tiktoken).
        
    - _Target:_ Bisa menjelaskan bedanya GPT (Decoder-only) dan BERT (Encoder-only) dalam 2 menit.
        
- **Day 2: API Mastery (OpenAI/Anthropic)**
    
    - _Pelajari:_ Request structure, Parameters (`temperature`, `top_p`), Roles (`system`, `user`, `assistant`).
        
    - _Praktek:_ Buat script Python sederhana untuk memanggil API dan print responsnya.
        
- **Day 3: Advanced Prompt Engineering**
    
    - _Pelajari:_ Chain-of-Thought (CoT), Few-Shot Prompting, ReAct logic.
        
    - _Target:_ Ubah prompt yang "buruk" menjadi prompt yang terstruktur dan konsisten.
        
- **Day 4: Structured Output (Crucial!)**
    
    - _Pelajari:_ Cara memaksa LLM mengeluarkan output JSON (JSON Mode / Pydantic). Ini skill wajib engineer.
        
    - _Praktek:_ Ekstrak data nama & tanggal dari teks acak menjadi format JSON valid.
        
- **Day 5: Mini Project 1 - "The Wrapper"**
    
    - _Tugas:_ Buat CLI Chatbot sederhana (Python) yang memiliki "persona" tertentu (misal: Asisten Masak) dan mengingat history chat (memory buffer).
        

## Minggu 2: The Bread & Butter - RAG

**Goal:** Menguasai Retrieval-Augmented Generation. 80% tugas junior saat ini ada di area ini.

- **Day 1: Vector Database 101**
    
    - _Pelajari:_ Embeddings, Cosine Similarity, Vector DB (Pilih satu: ChromaDB, Pinecone, atau Weaviate).
        
    - _Praktek:_ Ubah kalimat jadi vector, simpan di DB, lalu cari kalimat paling mirip.
        
- **Day 2: Orchestration Frameworks**
    
    - _Pelajari:_ LangChain atau LlamaIndex (Pilih satu saja dulu agar tidak pusing). Pahami konsep "Chains" dan "Loaders".
        
    - _Target:_ Load file `.txt` atau `.pdf` ke dalam script Python.
        
- **Day 3: Splitting & Ingestion**
    
    - _Pelajari:_ Text Splitters (RecursiveCharacterTextSplitter). Mengapa chunk size itu penting?
        
    - _Praktek:_ Eksperimen dengan chunk size berbeda (misal: 500 vs 2000 tokens) dan lihat efeknya pada pencarian.
        
- **Day 4: Retrieval Techniques**
    
    - _Pelajari:_ Naive retrieval vs Hybrid Search (Keyword + Vector).
        
    - _Target:_ Implementasi pencarian dokumen sederhana.
        
- **Day 5: Mini Project 2 - "Chat with Data"**
    
    - _Tugas:_ Buat aplikasi RAG sederhana. User upload PDF, lalu bisa tanya jawab tentang isi PDF tersebut.
        

## Minggu 3: Agents & Tools

**Goal:** Membuat LLM bisa "bertindak" (memanggil fungsi, browsing, hitung matematika), bukan hanya "ngomong".

- **Day 1: Function Calling / Tool Use**
    
    - _Pelajari:_ Bagaimana cara LLM mengenali kapan harus memanggil fungsi Python (misal: `get_weather()`).
        
    - _Praktek:_ Definisikan dummy function di Python dan biarkan LLM memilih argumennya.
        
- **Day 2: Agentic Workflows**
    
    - _Pelajari:_ Konsep Agents (Model yang melakukan loop: Thought -> Action -> Observation -> Result).
        
    - _Target:_ Pahami bedanya "Chain" (linear) dengan "Agent" (looping/dinamis).
        
- **Day 3: Local LLMs (Hemat Biaya)**
    
    - _Pelajari:_ Ollama, LM Studio, HuggingFace GGUF models.
        
    - _Praktek:_ Jalankan Llama-3 atau Mistral di laptop sendiri secara lokal.
        
- **Day 4: Debugging LLMs**
    
    - _Pelajari:_ Tracing (menggunakan LangSmith atau Arize Phoenix).
        
    - _Target:_ Bisa melihat log "apa yang sebenarnya dikirim ke LLM" dan "berapa token yang dipakai".
        
- **Day 5: Mini Project 3 - "Smart Assistant"**
    
    - _Tugas:_ Buat bot yang bisa menjawab pertanyaan umum TAPI jika ditanya soal matematika, dia memanggil fungsi kalkulator Python (bukan hitung manual).
        

## Minggu 4: Evaluation & Production

**Goal:** Menjawab pertanyaan "Apakah model kita bagus?" dan mempersiapkan deployment.

- **Day 1: RAG Evaluation**
    
    - _Pelajari:_ Ragas (Retrieval Augmented Generation Assessment) atau TruLens. Konsep: Faithfulness & Answer Relevance.
        
    - _Target:_ Evaluasi Project Minggu 2 dengan skor Ragas.
        
- **Day 2: Fine-Tuning Concepts (High Level)**
    
    - _Pelajari:_ Kapan pakai RAG vs Fine-tuning? Konsep PEFT/LoRA (agar tahu saja, mungkin belum tentu langsung praktek berat).
        
- **Day 3: Backend API (FastAPI)**
    
    - _Pelajari:_ Membuat endpoint REST API untuk model AI mu.
        
    - _Praktek:_ Wrap kode RAG Minggu 2 menjadi API yang bisa di-hit via Postman.
        
- **Day 4: Frontend UI (Streamlit/Gradio)**
    
    - _Pelajari:_ Cara cepat bikin UI untuk demo ke atasan/klien.
        
    - _Praktek:_ Bikin UI sederhana untuk API hari Rabu.
        
- **Day 5: Review & Refactor**
    
    - _Tugas:_ Rapikan kode Project Minggu 2 & 3. Tambahkan komentar, type hinting, dan struktur folder yang rapi.
        

## Minggu 5: The Final Polish

**Goal:** Kesiapan Mental & Environment Kerja.

- **Day 1: Git & Version Control for AI**
    
    - _Fokus:_ Jangan commit API Key ke GitHub! Pelajari `.gitignore` dan `.env`.
        
- **Day 2: Docker Basics**
    
    - _Fokus:_ Containerize aplikasi Python-mu. Ini standar industri agar "jalan di laptop saya, jalan juga di server".
        
- **Day 3: Reading Strategy**
    
    - _Fokus:_ Belajar cara skimming paper AI di Arxiv atau blog engineering perusahaan besar (Uber, Netflix, OpenAI blog).
        
- **Day 4: Setup "Day 1"**
    
    - _Fokus:_ Install VS Code extensions (Python, Pylance, Jupyter), setup Github SSH, rapikan LinkedIn/CV (untuk arsip).
        
- **Day 5: ISTIRAHAT TOTAL**
    
    - _Fokus:_ Tidur cukup. Siapkan mental. Jangan coding hari ini.
        

## Resources Rekomendasi

1. **Dokumentasi Resmi:** LangChain Docs / LlamaIndex Docs (Baca ini, jangan cuma tutorial YouTube lama).
    
2. **Course Gratis:** "DeepLearning.AI" (Andrew Ng) - Short courses tentang LLM & RAG.
    
3. **YouTube:** Harrison Chase (LangChain), AI Jason, James Briggs (Vector DB).
    

**Tips Tambahan untuk Junior:**

- Simpan semua kode latihan di GitHub pribadimu. Ini bukti portofolio instan.
    
- Jangan terjebak "Tutorial Hell". Setelah nonton/baca, **langsung tulis kode** walau error.
    
- Gunakan ChatGPT/Claude untuk menjadi "Senior Buddy" kamu saat error ("Jelaskan error ini dan cara fix-nya").
