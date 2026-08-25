---
publish: true
---

## 🚀 Cheatsheet: Setup SSH Deploy Key (Server ke GitHub)

### 1. Buat Key di Server

Login ke server Anda, lalu jalankan:

``` Bash
# Ganti 'label' dengan email/nama proyek
ssh-keygen -t ed25519 -C "deploy-key-proyek-saya"
```

- **`Enter file...`**: **WAJIB** ketik nama unik (mis: `~/.ssh/proyek_key`)
- **`Enter passphrase...`**: **WAJIB** tekan ENTER 2x (biarkan kosong)

### 2. Salin Public Key

Tampilkan isi _public key_ untuk disalin ke GitHub.

``` Bash
cat ~/.ssh/proyek_key.pub
```

_(Salin seluruh output `ssh-ed25519 ...`)_

### 3. Tambahkan ke GitHub

- Buka Repo -> **Settings** -> **Deploy Keys** -> **Add deploy key**.
- **Title**: "Server VPS".
- **Key**: Paste key dari langkah 2.
- **JANGAN** centang "Allow write access".
### 4. Konfigurasi SSH di Server

Beri tahu server untuk pakai key yang mana.

``` Bash
nano ~/.ssh/config
```

Tambahkan blok ini (buat file jika belum ada):

```
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/proyek_key
```

_(Sesuaikan path `IdentityFile`)_

### 5. Tes Koneksi

Pergi ke folder repo Anda di server dan jalankan:

``` Bash
git pull origin main
```

_(Seharusnya berhasil tanpa meminta password)._