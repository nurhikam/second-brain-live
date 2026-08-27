---
publish: true
---

Betul sekali.

Jika tujuan Anda adalah agar IP VPS Anda bisa **dibuka di browser** (seperti Chrome/Firefox) dan menampilkan halaman web, Anda harus menginstal **Web Server** terlebih dahulu. Nginx adalah salah satu pilihan web server yang paling populer.

---

### 🏛️ Kenapa Perlu Nginx?

Sederhananya, VPS Anda saat ini tidak tahu harus berbuat apa ketika ada _browser_ yang "mengunjungi" IP Anda di jalur web (Port 80/443).

- **SSH (Port 22)** adalah "pintu belakang" untuk Anda sebagai admin.
    
- **Web Server (Port 80/443)** adalah "pintu depan" untuk pengunjung web.
    

Tugas Nginx adalah menjadi "pelayan" yang berdiri di pintu depan (port 80). Ketika browser pengunjung datang, Nginx-lah yang akan menjawab dan menyajikan halaman web Anda.

![Image of a diagram showing how a web server works](https://encrypted-tbn0.gstatic.com/licensed-image?q=tbn:ANd9GcRgCNYw1Xks6ZN0BZ5CKkgnZCEwNoXOeAKsFOcNIp_zzS5QqxAad3Ife1FZydvWSUy3epPOxN-iXXsxKMwZR7g6CIzArFpmlKgdki1mdGlnPmZSdX8)


---

### 🛠️ Cara Install Nginx (Contoh di Ubuntu/Debian)

Jika VPS Anda menggunakan Linux Ubuntu atau Debian (yang paling umum), cara instalnya sangat mudah:

1. Login ke VPS Anda
    
    (Gunakan cara SSH yang sudah kita bahas sebelumnya).
    
    Bash
    
    ```
    ssh root@IP_VPS_ANDA
    ```
    
2. Update Daftar Aplikasi
    
    Selalu update dulu agar mendapat versi terbaru.
    
    Bash
    
    ```
    apt update
    ```
    
3. **Install Nginx**
    
    Bash
    
    ```
    apt install nginx
    ```
    
4. Izinkan Nginx di Firewall (PENTING)
    
    Seringkali VPS memiliki firewall (UFW) yang aktif. Perintah ini akan membuka "pintu depan" (port 80) untuk Nginx.
    
    Bash
    
    ```
    ufw allow 'Nginx HTTP'
    ```
    

---

### ✅ Tes Hasilnya

Setelah langkah 1-4 selesai, **sekarang** Anda bisa membuka browser di komputer Anda dan mengetik:

`http://IP_VPS_ANDA`

Jika berhasil, Anda akan melihat halaman _default_ "Welcome to Nginx!"

Apakah Anda ingin mencoba menginstalnya sekarang?