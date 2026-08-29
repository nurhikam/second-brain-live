---
created: 2026-08-27
modified: 2026-08-27
link_ref: https://gemini.google.com/share/fbce596355f9
tags:
  - cheatsheet
  - dev
  - vps
publish: true
---

# Guide Lengkap: Deploy Next.js + Bun + Nginx + PM2

Ini adalah panduan end-to-end untuk mendeploy aplikasi Next.js (menggunakan Bun) ke server Ubuntu, menjalankannya 24/7 dengan PM2, dan mengamankannya dengan Nginx (Reverse Proxy) + SSL.

## 🗺️ Arsitektur Final

Alur: `Pengguna` -> `Internet` -> `Nginx (Handle SSL, Port 443)` -> `PM2 (Manajer Proses)` -> `Aplikasi Next.js (Bun, Port 3000)`

## 1. Persiapan Server (Satu Kali Saja)

Lakukan ini jika server Anda masih baru.

### Update Server:

```
sudo apt update && sudo apt upgrade -y
```

### Install Kebutuhan Dasar:

```
sudo apt install -y nginx git curl
```

### Install Bun:

```
curl -fsSL [https://bun.sh/install](https://bun.sh/install) | bash
# Muat ulang terminal
source ~/.bashrc
```

### Install PM2 (Global):

```
bun install -g pm2
```

## 2. Setup Nginx + SSL (Satu Kali Saja)

Kita akan mengarahkan `domainanda.com` ke aplikasi Anda.

### Buat Konfigurasi Nginx Awal:

Ganti `domainanda.com` dengan domain Anda.

```
sudo nano /etc/nginx/sites-available/domainanda.com
```

Tempelkan ini (Hanya untuk verifikasi SSL):

```
server {
    listen 80;
    listen [::]:80;

    server_name domainanda.com [www.domainanda.com](https://www.domainanda.com);
    
    root /var/www/html;
    
    location ~ /.well-known/acme-challenge {
        allow all;
    }
}
```

### Aktifkan Konfigurasi:

```
# Buat symlink
sudo ln -s /etc/nginx/sites-available/domainanda.com /etc/nginx/sites-enabled/

# Hapus default
sudo rm /etc/nginx/sites-enabled/default

# Tes & Restart
sudo nginx -t
sudo systemctl restart nginx
```

### Install SSL (Certbot):

Pastikan domain Anda sudah mengarah ke IP server.

```
sudo apt install -y python3-certbot-nginx

# Jalankan certbot
sudo certbot --nginx -d domainanda.com -d [www.domainanda.com](https://www.domainanda.com)
```

(Pilih **Opsi 2: Redirect** saat ditanya untuk otomatis mengarahkan HTTP ke HTTPS).

### Finalisasi Nginx (Reverse Proxy):

Certbot baru saja mengubah file Anda. Edit lagi:

```
sudo nano /etc/nginx/sites-available/domainanda.com
```

Cari blok `server` yang `listen 443 ssl`. Di dalamnya, temukan `location / { ... }`. Ubah blok `location /` itu menjadi seperti ini:

```
location / {
    # Arahkan ke aplikasi Next.js Anda (yang akan jalan di port 3000)
    proxy_pass http://localhost:3000;

    # Header penting
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

Tes dan Restart Nginx untuk terakhir kalinya:

```
sudo nginx -t
sudo systemctl restart nginx
```

Nginx Anda sekarang SIAP.

## 3. Setup Project (Satu Kali Saja)

Kita akan menghubungkan server ke repo GitHub Anda.

### Di Server: Buat SSH Deploy Key
[[Setup SSH Deploy Key di Server]]

```
# Ganti label dengan nama proyek Anda
ssh-keygen -t ed25519 -C "nama-proyek-key"

# Saat ditanya "Enter file...", KETIK NAMA UNIK:
/home/root/.ssh/nama_proyek_key

# Saat ditanya "Enter passphrase...", JANGAN ISI APAPUN. Tekan Enter 2x.
```

### Di Server: Salin Public Key

```
cat ~/.ssh/nama_proyek_key.pub
```

(Salin seluruh output `ssh-ed25519 ... nama-proyek-key`)

### Di GitHub:

1. Buka Repo -> `Settings` -> `Deploy Keys` -> `Add deploy key`.
2. **Title**: "VPS Proyek" (atau nama deskriptif).
3. **Key**: Paste key dari langkah 2
4. **JANGAN** centang "Allow write access".
5. Klik `Add key`.
### Di Server: Konfigurasi SSH config

Ini memberitahu server untuk pakai key yang benar.

```
nano ~/.ssh/config
```

Tambahkan blok ini (Ganti `IdentityFile` dengan path yang Anda buat tadi):

```
Host github.com
  HostName github.com
  User git
  IdentityFile /home/root/.ssh/nama_proyek_key
```

### Di Server: Clone Project

```
# Buat folder jika belum
sudo mkdir -p /var/www
cd /var/www

# Clone pakai SSH, bukan HTTPS
git clone git@github.com:NAMA_ORGANISASI/NAMA_REPO.git

# Contoh: git clone git@github.com:nexera-id/nexera-website.git
```

## 4. 🚀 Launch Aplikasi (Pertama Kali)

Ini adalah langkah-langkah penting yang sering terlewat dan menyebabkan error.

### Masuk ke Folder Project:

```
cd /var/www/NAMA_REPO
# Contoh: cd /var/www/nexera-website
```

### Install Dependencies (SANGAT PENTING!):

Ini akan menginstal `next` dan semua paket lain dari `package.json`.

```
bun install
```

### Build Project (SANGAT PENTING!):

Ini akan membuat folder `.next` versi produksi.

```
bun run build
```

### Jalankan dengan PM2:

Sekarang jalankan perintah `start` (yaitu `next start` atau `bun start`).

```
pm2 start bun --name "next-app" -- start
```

_Catatan: `--name "next-app"` adalah nama alias untuk PM2. Ganti sesuai keinginan Anda._

### Cek Status:

```
pm2 list
```

Statusnya sekarang seharusnya `online` (hijau) dan CPU/Memory terisi.

### Simpan Proses PM2:

Agar aplikasi otomatis nyala jika server reboot.

```
pm2 save
```

Selamat! Aplikasi Anda sekarang harusnya sudah bisa diakses di `https://domainanda.com`

## 5. 🔄 Alur Kerja Update (Setiap Ada Perubahan)

Ini adalah langkah yang akan Anda lakukan berulang kali setiap ingin rilis update.

### Di Lokal (Komputer Anda):

Selesaikan kode Anda...

```
git add .
git commit -m "Update fitur X"
git push origin main
```

### Di Server (via SSH):

Login dan masuk ke folder project.

```
cd /var/www/NAMA_REPO
# Contoh: cd /var/www/nexera-website
```

#### 1. Ambil kode terbaru

```
git pull origin main
```

#### 2. Install dependensi (jika ada yg baru di `package.json`)

```
bun install
```

#### 3. Build ulang project

```
bun run build
```

#### 4. Restart aplikasi di PM2 (0-downtime)

Gunakan nama alias yang Anda buat di langkah 4.

```
pm2 restart next-app
```

## 6. 📊 Cheat Sheet Perintah PM2

Gunakan ini untuk mengelola aplikasi Anda.

```
# Melihat daftar semua aplikasi
pm2 list

# Melihat log (Paling penting untuk debug)
pm2 logs next-app

# Melihat log error saja
pm2 logs next-app --err

# Merestart aplikasi
pm2 restart next-app

# Menghentikan aplikasi
pm2 stop next-app

# Menghapus aplikasi dari daftar
pm2 delete next-app

# Mengatur agar PM2 jalan saat startup
pm2 startup
# (Salin-tempel perintah yang diberikannya)

# Menyimpan proses saat ini untuk startup
pm2 save
```
