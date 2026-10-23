# NikahTrack – Tabungan Pernikahan Online

Aplikasi web statis (HTML) + Supabase (database dan login) + Netlify (hosting). Bisa dibuka dari HP mana pun dan dipakai bersama pasangan.

## 1. Siapkan Supabase
1. Daftar di supabase.com, klik **New project**, isi nama dan password database, tunggu selesai.
2. Buka **SQL Editor > New query**, tempel isi `supabase.sql`, klik **Run**.
3. Buka **Authentication > Providers > Email**, matikan **Confirm email** agar pendaftaran langsung bisa masuk (opsional, lebih mudah).
4. Buka **Project Settings > API**, salin **Project URL** dan **anon public key**.

## 2. Isi konfigurasi
Buka `index.html`, cari dua baris ini lalu isi dengan nilai dari Supabase:

    const SUPABASE_URL='ISI_DENGAN_PROJECT_URL';
    const SUPABASE_ANON_KEY='ISI_DENGAN_ANON_PUBLIC_KEY';

Pakai kunci **anon public** saja. Jangan pernah memakai kunci **service_role** di file ini. Keamanan data dijaga oleh aturan RLS di `supabase.sql`.

## 3. Unggah ke GitHub
1. Buat repository baru di github.com (misalnya `nikahtrack`).
2. Klik **Add file > Upload files**, unggah `index.html`, `netlify.toml`, `supabase.sql`, `README.md`, lalu **Commit changes**.

## 4. Deploy di Netlify
1. Daftar di netlify.com, pilih **Add new site > Import an existing project > GitHub**.
2. Pilih repository `nikahtrack`. Build command dikosongkan, publish directory `.`, lalu **Deploy**.
3. Anda mendapat alamat seperti `https://nama-anda.netlify.app`. Nama bisa diubah di **Site configuration > Change site name**.
4. Di Supabase, buka **Authentication > URL Configuration**, isi **Site URL** dengan alamat Netlify tadi.

## 5. Cara pakai
1. Buka alamat Netlify di HP, **Daftar** dengan email dan kata sandi, lalu **Masuk**.
2. Pertama kali masuk, **Buat dompet pernikahan** (nama, target, tanggal). Kode dompet muncul di tab **Akun**.
3. Pasangan daftar dengan emailnya sendiri, lalu pilih **Gabung dompet pasangan** dan isi kode tadi. Keduanya melihat dan mengisi data yang sama.
4. Di HP, buka menu browser lalu **Tambahkan ke Layar Utama** agar terpasang seperti aplikasi.

Setiap perubahan di GitHub otomatis ter-deploy ulang oleh Netlify.
