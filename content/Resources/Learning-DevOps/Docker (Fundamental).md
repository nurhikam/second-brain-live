---
created: 2025-11-27
modified: 2026-08-27
tags:
  - docker
  - devops
  - learning
  - cheat-sheet
status: completed
date: 2025-11-27
link_ref:
publish: true
---

# 🐳 Docker: Belajar Kilat (1 Jam)

## 1. Konsep Dasar: Mengapa Docker?

**Masalah:** "Di laptopku jalan, tapi di server error." (Inkosiistensi Environment).
**Solusi:** Membungkus aplikasi + *dependencies*-nya ke dalam satu paket standar.

### Analogi: VM vs Container

| Fitur | Virtual Machine (VM) 🏠 | Docker Container 🏢 |
| :--- | :--- | :--- |
| **Analogi** | **Rumah Tapak:** Punya fondasi sendiri-sendiri. | **Apartemen:** Berbagi fondasi gedung yang sama. |
| **Teknis** | Membawa OS & Kernel sendiri (Berat). | **Sharing Kernel** Host/Laptop (Ringan). |
| **Booting** | Menit (harus boot OS). | Detik (langsung jalan). |
| **Isolasi** | Hardware Level. | OS Level. |

> [!NOTE] Inti Efisiensi
> Docker tidak perlu menginstall OS baru untuk setiap aplikasi. Semua container "meminjam" **Kernel** (otak penggerak hardware) dari host-nya.

---

## 2. Empat Pilar Docker (Terminologi)

Menggunakan **Analogi Masak-Memasak**:

1.  📜 **Dockerfile (Resep):** File teks berisi instruksi cara membuat aplikasi.
2.  🍱 **Image (Cetakan / Makanan Beku):**
    * Paket aplikasi yang sudah jadi (hasil build).
    * Sifat: **Immutable** (Abadi/Tidak bisa diedit langsung).
3.  🍲 **Container (Makanan Siap Saji):**
    * Image yang sedang dijalankan (*Running instance*).
    * Sifat: Sementara (*Ephemeral*). Bisa dihapus dan dibuat lagi dengan mudah.
4.  🏪 **Registry (Supermarket):**
    * Tempat menyimpan dan membagikan Image (Contoh: Docker Hub).

---

## 3. Cheat Sheet Perintah Dasar (Mantra)

```bash
# 1. Mengambil Image dari Registry
docker pull nginx

# 2. Melihat Image yang ada di laptop
docker images

# 3. Menjalankan Container (Mantra Utama)
# -d: Detached (jalan di background)
# -p: Port Mapping (PortLaptop:PortContainer)
docker run -d -p 8080:80 nginx

# 4. Cek Container yang sedang jalan (Process Status)
docker ps

# 5. Mematikan Container
docker stop <CONTAINER_ID>

# 6. Membuat Image dari Dockerfile sendiri
# -t: Tag (memberi nama)
# . : Lokasi Dockerfile (titik = folder ini)
docker build -t nama-aplikasiku .

# 7. Bersih-bersih cache/sampah
docker system prune
```

## 4. Struktur Dockerfile

Contoh membuat aplikasi Python sederhana:
``` Dockerfile
# 1. Bahan Dasar (Base Image)
FROM python:3.9-slim

# 2. Persiapan Dapur (Working Directory)
WORKDIR /app

# 3. Masukkan Bahan (Copy file dari laptop ke container)
COPY . .

# 4. Memasak / Persiapan (Build Time)
# Dijalankan SEKALI saat pembuatan Image.
RUN pip install flask

# 5. Menyajikan / Eksekusi (Runtime)
# Dijalankan SETIAP KALI Container di-start.
CMD ["python", "app.py"]
```

> [!WARNING] Perbedaan RUN vs CMD
> 
> - **RUN:** "Tolong pasang ini **sekarang** (saat bikin image)." -> Contoh: Install Library.
>     
> - **CMD:** "Tolong jalankan ini **nanti** (saat container dinyalakan)." -> Contoh: Start Web Server.
>     

---

## 5. Konsep Penting Lainnya

### Layer Caching (Efisiensi Update)

Saat kita melakukan `docker build` ulang:

- Docker **tidak** membangun ulang dari nol.
    
- Docker mengecek baris per baris. Jika baris tersebut (dan sebelumnya) tidak berubah, Docker mengambil dari **Cache**.
    
- _Hasil:_ Proses update sangat cepat, hanya memproses layer yang berubah (kodingan kita).
    

### Workflow Distribusi

Code snippet

```graph LR
    A[Laptop Dev] -- docker build --> B(Image Lokal)
    B -- docker push --> C{Registry / Docker Hub}
    C -- docker pull --> D[Server / Teman]
    D -- docker run --> E(Container Jalan)
```

---

## 6. Next Steps to Learn

- [ ] **Docker Volume:** Agar data database tidak hilang saat container dihapus.
    
- [ ] **Docker Network:** Menghubungkan container Frontend dengan Backend.
    
- [ ] **Docker Compose:** Menjalankan banyak container sekaligus (orchestration sederhana).
