# Sistem Informasi Pemesanan Digital & Kasir Web - Kedai Kopi Mbah Buyut

Sistem informasi ini dirancang untuk melakukan transformasi digital pada operasional Kedai Kopi Mbah Buyut. Sistem mengintegrasikan pemesanan mandiri berbasis QR Code, pengelolaan kasir (POS), fitur loyalitas koin pelanggan, pengaturan jam operasional, serta pelaporan transaksi secara terpusat.

---

## 1. Peran Pengguna & Hak Akses

Sistem ini mendukung 3 peran pengguna utama:

* **Admin**
  * Mengelola data menu, kategori, varian, dan harga.
  * Mengelola data pengguna dan pembagian peran (role).
  * Mengatur jam operasional kedai.
  * Mengelola poin/koin loyalitas pelanggan.
  * Memantau statistik transaksi dan mengunduh laporan penjualan (PDF/Excel).

* **Kasir**
  * Memproses transaksi pemesanan secara langsung (input manual) maupun mengonfirmasi pesanan masuk dari QR Code.
  * Mengelola status pesanan (konfirmasi, proses, tolak).
  * Mengirimkan dan mencetak nota pembayaran.
  * Melihat riwayat transaksi harian.

* **Pelanggan**
  * Memindai QR Code di meja untuk melihat menu digital.
  * Melakukan checkout pesanan (opsi dine-in/takeaway, varian menu, catatan pesanan).
  * Memilih metode pembayaran (Tunai/Non-Tunai).
  * Menukarkan koin loyalitas sebagai potongan harga.
  * Memantau status pesanan dan mengunduh nota transaksi.

---

## 2. Struktur Basis Data (Database Schema)

Database menggunakan nama `db_mbah_buyut` dengan struktur tabel sebagai berikut:

* **`roles`**: Menyimpan daftar peran pengguna (Admin, Kasir, Pelanggan).
* **`users`**: Data pengguna sistem beserta saldo koin loyalitas.
* **`jam_operasional`**: Pengaturan jadwal operasional kedai per hari.
* **`meja`**: Data nomor meja beserta token QR Code uniknya.
* **`kategori_menu`**: Kategori produk (Kopi, Non-Kopi, Makanan, dll).
* **`menu`**: Daftar menu utama, deskripsi, dan harga dasar.
* **`varian`**: Variasi produk (Hot/Ice, level gula, ukuran) beserta opsi tambahan harga.
* **`pesanan`**: Data utama transaksi pemesanan, jenis pesanan, status, dan penggunaan koin.
* **`detail_pesanan`**: Rincian item menu dan varian yang dipesan dalam satu pesanan.
* **`transaksi`**: Pencatatan pembayaran kasir, metode pembayaran, nominal uang, dan perolehan koin.

---

## 3. Eksekusi Script SQL

Jalankan perintah SQL berikut pada DBMS (MySQL/MariaDB) untuk membuat database, tabel, dan mengisi data sampel awal.

```sql
-- ==========================================
-- 1. PEMBUATAN DATABASE
-- ==========================================
CREATE DATABASE IF NOT EXISTS db_kasir_basdat;
USE db_kasir_basdat;

-- ==========================================
-- 2. PEMBUATAN TABEL
-- ==========================================

CREATE TABLE roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role_id INT NOT NULL,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    no_hp VARCHAR(20),
    coin_balance INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);

CREATE TABLE jam_operasional (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hari VARCHAR(20) NOT NULL,
    jam_buka TIME NOT NULL,
    jam_tutup TIME NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE meja (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nomor_meja VARCHAR(10) NOT NULL UNIQUE,
    qr_code_token VARCHAR(255) NOT NULL,
    status ENUM('kosong', 'terisi') DEFAULT 'kosong'
);

CREATE TABLE kategori_menu (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_kategori VARCHAR(50) NOT NULL
);

CREATE TABLE menu (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kategori_id INT NOT NULL,
    nama_menu VARCHAR(100) NOT NULL,
    deskripsi TEXT,
    harga_dasar DECIMAL(10, 2) NOT NULL,
    foto VARCHAR(255),
    is_available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (kategori_id) REFERENCES kategori_menu(id) ON DELETE CASCADE
);

CREATE TABLE varian (
    id INT AUTO_INCREMENT PRIMARY KEY,
    menu_id INT NOT NULL,
    nama_varian VARCHAR(50) NOT NULL,
    tambahan_harga DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (menu_id) REFERENCES menu(id) ON DELETE CASCADE
);

CREATE TABLE pesanan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kode_pesanan VARCHAR(50) NOT NULL UNIQUE,
    pelanggan_id INT NULL,
    meja_id INT NULL,
    jenis_pesanan ENUM('dine_in', 'take_away') NOT NULL DEFAULT 'dine_in',
    status_pesanan ENUM('menunggu_konfirmasi', 'diproses', 'selesai', 'dibatalkan') DEFAULT 'menunggu_konfirmasi',
    catatan TEXT,
    subtotal DECIMAL(10, 2) NOT NULL,
    potongan_coin DECIMAL(10, 2) DEFAULT 0.00,
    total_bayar DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pelanggan_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (meja_id) REFERENCES meja(id) ON DELETE SET NULL
);

CREATE TABLE detail_pesanan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pesanan_id INT NOT NULL,
    menu_id INT NOT NULL,
    varian_id INT NULL,
    jumlah INT NOT NULL,
    harga_satuan DECIMAL(10, 2) NOT NULL,
    subtotal_item DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (pesanan_id) REFERENCES pesanan(id) ON DELETE CASCADE,
    FOREIGN KEY (menu_id) REFERENCES menu(id) ON DELETE CASCADE,
    FOREIGN KEY (varian_id) REFERENCES varian(id) ON DELETE SET NULL
);

CREATE TABLE transaksi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pesanan_id INT NOT NULL UNIQUE,
    kasir_id INT NULL,
    metode_pembayaran ENUM('tunai', 'qris', 'transfer_bank') NOT NULL,
    total_bayar DECIMAL(10, 2) NOT NULL,
    uang_diterima DECIMAL(10, 2) DEFAULT 0.00,
    kembalian DECIMAL(10, 2) DEFAULT 0.00,
    status_pembayaran ENUM('pending', 'lunas', 'gagal') DEFAULT 'pending',
    coin_diperoleh INT DEFAULT 0,
    waktu_transaksi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pesanan_id) REFERENCES pesanan(id) ON DELETE CASCADE,
    FOREIGN KEY (kasir_id) REFERENCES users(id) ON DELETE SET NULL
);

-- ==========================================
-- 3. INSERT DATA SAMPEL (DUMMY DATA)
-- ==========================================

INSERT INTO roles (id, name) VALUES 
(1, 'admin'),
(2, 'kasir'),
(3, 'pelanggan');

INSERT INTO users (role_id, nama, email, password, no_hp, coin_balance) VALUES 
(1, 'Admin Mbah Buyut', 'admin@mbahbuyut.com', '$2y$10$e8T...', '081234567890', 0),
(2, 'Siti Kasir', 'kasir1@mbahbuyut.com', '$2y$10$e8T...', '081298765432', 0),
(3, 'Budi Santoso', 'budi@gmail.com', '$2y$10$e8T...', '085678901234', 5000);

INSERT INTO jam_operasional (hari, jam_buka, jam_tutup, is_active) VALUES 
('Senin', '08:00:00', '22:00:00', TRUE),
('Selasa', '08:00:00', '22:00:00', TRUE),
('Rabu', '08:00:00', '22:00:00', TRUE),
('Kamis', '08:00:00', '22:00:00', TRUE),
('Jumat', '13:00:00', '23:00:00', TRUE),
('Sabtu', '08:00:00', '23:00:00', TRUE),
('Minggu', '08:00:00', '22:00:00', TRUE);

INSERT INTO meja (nomor_meja, qr_code_token, status) VALUES 
('M01', 'QR_MEJA_01_TOKEN123', 'terisi'),
('M02', 'QR_MEJA_02_TOKEN456', 'kosong'),
('M03', 'QR_MEJA_03_TOKEN789', 'kosong');

INSERT INTO kategori_menu (nama_kategori) VALUES 
('Kopi'),
('Non-Kopi'),
('Makanan Ringan');

INSERT INTO menu (kategori_id, nama_menu, deskripsi, harga_dasar, is_available) VALUES 
(1, 'Kopi Tubruk Mbah Buyut', 'Kopi hitam tradisional khas kedai', 12000.00, TRUE),
(1, 'Es Kopi Susu Gula Aren', 'Espresso dipadu susu segar dan gula aren asli', 18000.00, TRUE),
(2, 'Matcha Latte', 'Minuman teh hijau Jepang dipadu susu hangat/dingin', 20000.00, TRUE),
(3, 'Cireng Bumbu Rujak', 'Cireng renyah disajikan dengan bumbu pedas manis', 15000.00, TRUE);

INSERT INTO varian (menu_id, nama_varian, tambahan_harga) VALUES 
(2, 'Hot', 0.00),
(2, 'Ice', 2000.00),
(3, 'Hot', 0.00),
(3, 'Ice', 2000.00);

INSERT INTO pesanan (kode_pesanan, pelanggan_id, meja_id, jenis_pesanan, status_pesanan, catatan, subtotal, potongan_coin, total_bayar) VALUES 
('ORD-20261006-001', 3, 1, 'dine_in', 'selesai', 'Less ice ya', 35000.00, 5000.00, 30000.00);

INSERT INTO detail_pesanan (pesanan_id, menu_id, varian_id, jumlah, harga_satuan, subtotal_item) VALUES 
(1, 2, 2, 1, 20000.00, 20000.00),
(1, 4, NULL, 1, 15000.00, 15000.00);

INSERT INTO transaksi (pesanan_id, kasir_id, metode_pembayaran, total_bayar, uang_diterima, kembalian, status_pembayaran, coin_diperoleh) VALUES 
(1, 2, 'qris', 30000.00, 30000.00, 0.00, 'lunas', 300);