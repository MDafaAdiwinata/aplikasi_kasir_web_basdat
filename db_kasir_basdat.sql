-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Waktu pembuatan: 06 Okt 2026 pada 05.25
-- Versi server: 10.4.28-MariaDB
-- Versi PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_kasir_basdat`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `detail_pesanan`
--

CREATE TABLE `detail_pesanan` (
  `id` int(11) NOT NULL,
  `pesanan_id` int(11) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `varian_id` int(11) DEFAULT NULL,
  `jumlah` int(11) NOT NULL,
  `harga_satuan` decimal(10,2) NOT NULL,
  `subtotal_item` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `detail_pesanan`
--

INSERT INTO `detail_pesanan` (`id`, `pesanan_id`, `menu_id`, `varian_id`, `jumlah`, `harga_satuan`, `subtotal_item`) VALUES
(1, 1, 2, 2, 1, 20000.00, 20000.00),
(2, 1, 4, NULL, 1, 15000.00, 15000.00);

-- --------------------------------------------------------

--
-- Struktur dari tabel `jam_operasional`
--

CREATE TABLE `jam_operasional` (
  `id` int(11) NOT NULL,
  `hari` varchar(20) NOT NULL,
  `jam_buka` time NOT NULL,
  `jam_tutup` time NOT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `jam_operasional`
--

INSERT INTO `jam_operasional` (`id`, `hari`, `jam_buka`, `jam_tutup`, `is_active`) VALUES
(1, 'Senin', '08:00:00', '22:00:00', 1),
(2, 'Selasa', '08:00:00', '22:00:00', 1),
(3, 'Rabu', '08:00:00', '22:00:00', 1),
(4, 'Kamis', '08:00:00', '22:00:00', 1),
(5, 'Jumat', '13:00:00', '23:00:00', 1),
(6, 'Sabtu', '08:00:00', '23:00:00', 1),
(7, 'Minggu', '08:00:00', '22:00:00', 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `kategori_menu`
--

CREATE TABLE `kategori_menu` (
  `id` int(11) NOT NULL,
  `nama_kategori` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `kategori_menu`
--

INSERT INTO `kategori_menu` (`id`, `nama_kategori`) VALUES
(1, 'Kopi'),
(2, 'Non-Kopi'),
(3, 'Makanan Ringan');

-- --------------------------------------------------------

--
-- Struktur dari tabel `meja`
--

CREATE TABLE `meja` (
  `id` int(11) NOT NULL,
  `nomor_meja` varchar(10) NOT NULL,
  `qr_code_token` varchar(255) NOT NULL,
  `status` enum('kosong','terisi') DEFAULT 'kosong'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `meja`
--

INSERT INTO `meja` (`id`, `nomor_meja`, `qr_code_token`, `status`) VALUES
(1, 'M01', 'QR_MEJA_01_TOKEN123', 'terisi'),
(2, 'M02', 'QR_MEJA_02_TOKEN456', 'kosong'),
(3, 'M03', 'QR_MEJA_03_TOKEN789', 'kosong');

-- --------------------------------------------------------

--
-- Struktur dari tabel `menu`
--

CREATE TABLE `menu` (
  `id` int(11) NOT NULL,
  `kategori_id` int(11) NOT NULL,
  `nama_menu` varchar(100) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `harga_dasar` decimal(10,2) NOT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `is_available` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `menu`
--

INSERT INTO `menu` (`id`, `kategori_id`, `nama_menu`, `deskripsi`, `harga_dasar`, `foto`, `is_available`) VALUES
(1, 1, 'Kopi Tubruk Mbah Buyut', 'Kopi hitam tradisional khas kedai', 12000.00, NULL, 1),
(2, 1, 'Es Kopi Susu Gula Aren', 'Espresso dipadu susu segar dan gula aren asli', 18000.00, NULL, 1),
(3, 2, 'Matcha Latte', 'Minuman teh hijau Jepang dipadu susu hangat/dingin', 20000.00, NULL, 1),
(4, 3, 'Cireng Bumbu Rujak', 'Cireng renyah disajikan dengan bumbu pedas manis', 15000.00, NULL, 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `pesanan`
--

CREATE TABLE `pesanan` (
  `id` int(11) NOT NULL,
  `kode_pesanan` varchar(50) NOT NULL,
  `pelanggan_id` int(11) DEFAULT NULL,
  `meja_id` int(11) DEFAULT NULL,
  `jenis_pesanan` enum('dine_in','take_away') NOT NULL DEFAULT 'dine_in',
  `status_pesanan` enum('menunggu_konfirmasi','diproses','selesai','dibatalkan') DEFAULT 'menunggu_konfirmasi',
  `catatan` text DEFAULT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `potongan_coin` decimal(10,2) DEFAULT 0.00,
  `total_bayar` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pesanan`
--

INSERT INTO `pesanan` (`id`, `kode_pesanan`, `pelanggan_id`, `meja_id`, `jenis_pesanan`, `status_pesanan`, `catatan`, `subtotal`, `potongan_coin`, `total_bayar`, `created_at`) VALUES
(1, 'ORD-20261006-001', 3, 1, 'dine_in', 'selesai', 'Less ice ya', 35000.00, 5000.00, 30000.00, '2026-10-06 03:07:53');

-- --------------------------------------------------------

--
-- Struktur dari tabel `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `roles`
--

INSERT INTO `roles` (`id`, `name`) VALUES
(1, 'admin'),
(2, 'kasir'),
(3, 'pelanggan');

-- --------------------------------------------------------

--
-- Struktur dari tabel `transaksi`
--

CREATE TABLE `transaksi` (
  `id` int(11) NOT NULL,
  `pesanan_id` int(11) NOT NULL,
  `kasir_id` int(11) DEFAULT NULL,
  `metode_pembayaran` enum('tunai','qris','transfer_bank') NOT NULL,
  `total_bayar` decimal(10,2) NOT NULL,
  `uang_diterima` decimal(10,2) DEFAULT 0.00,
  `kembalian` decimal(10,2) DEFAULT 0.00,
  `status_pembayaran` enum('pending','lunas','gagal') DEFAULT 'pending',
  `coin_diperoleh` int(11) DEFAULT 0,
  `waktu_transaksi` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `transaksi`
--

INSERT INTO `transaksi` (`id`, `pesanan_id`, `kasir_id`, `metode_pembayaran`, `total_bayar`, `uang_diterima`, `kembalian`, `status_pembayaran`, `coin_diperoleh`, `waktu_transaksi`) VALUES
(1, 1, 2, 'qris', 30000.00, 30000.00, 0.00, 'lunas', 300, '2026-10-06 03:08:00');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `coin_balance` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `role_id`, `nama`, `email`, `password`, `no_hp`, `coin_balance`, `created_at`, `updated_at`) VALUES
(1, 1, 'Admin Mbah Buyut', 'admin@mbahbuyut.com', '$2y$10$e8T...', '081234567890', 0, '2026-10-06 03:07:29', '2026-10-06 03:07:29'),
(2, 2, 'Siti Kasir', 'kasir1@mbahbuyut.com', '$2y$10$e8T...', '081298765432', 0, '2026-10-06 03:07:29', '2026-10-06 03:07:29'),
(3, 3, 'Budi Santoso', 'budi@gmail.com', '$2y$10$e8T...', '085678901234', 5000, '2026-10-06 03:07:29', '2026-10-06 03:07:29');

-- --------------------------------------------------------

--
-- Struktur dari tabel `varian`
--

CREATE TABLE `varian` (
  `id` int(11) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `nama_varian` varchar(50) NOT NULL,
  `tambahan_harga` decimal(10,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `varian`
--

INSERT INTO `varian` (`id`, `menu_id`, `nama_varian`, `tambahan_harga`) VALUES
(1, 2, 'Hot', 0.00),
(2, 2, 'Ice', 2000.00),
(3, 3, 'Hot', 0.00),
(4, 3, 'Ice', 2000.00);

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pesanan_id` (`pesanan_id`),
  ADD KEY `menu_id` (`menu_id`),
  ADD KEY `varian_id` (`varian_id`);

--
-- Indeks untuk tabel `jam_operasional`
--
ALTER TABLE `jam_operasional`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `kategori_menu`
--
ALTER TABLE `kategori_menu`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `meja`
--
ALTER TABLE `meja`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nomor_meja` (`nomor_meja`);

--
-- Indeks untuk tabel `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`id`),
  ADD KEY `kategori_id` (`kategori_id`);

--
-- Indeks untuk tabel `pesanan`
--
ALTER TABLE `pesanan`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kode_pesanan` (`kode_pesanan`),
  ADD KEY `pelanggan_id` (`pelanggan_id`),
  ADD KEY `meja_id` (`meja_id`);

--
-- Indeks untuk tabel `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indeks untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `pesanan_id` (`pesanan_id`),
  ADD KEY `kasir_id` (`kasir_id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `role_id` (`role_id`);

--
-- Indeks untuk tabel `varian`
--
ALTER TABLE `varian`
  ADD PRIMARY KEY (`id`),
  ADD KEY `menu_id` (`menu_id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `jam_operasional`
--
ALTER TABLE `jam_operasional`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `kategori_menu`
--
ALTER TABLE `kategori_menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `meja`
--
ALTER TABLE `meja`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `menu`
--
ALTER TABLE `menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `pesanan`
--
ALTER TABLE `pesanan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `varian`
--
ALTER TABLE `varian`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  ADD CONSTRAINT `detail_pesanan_ibfk_1` FOREIGN KEY (`pesanan_id`) REFERENCES `pesanan` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `detail_pesanan_ibfk_2` FOREIGN KEY (`menu_id`) REFERENCES `menu` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `detail_pesanan_ibfk_3` FOREIGN KEY (`varian_id`) REFERENCES `varian` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `menu`
--
ALTER TABLE `menu`
  ADD CONSTRAINT `menu_ibfk_1` FOREIGN KEY (`kategori_id`) REFERENCES `kategori_menu` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `pesanan`
--
ALTER TABLE `pesanan`
  ADD CONSTRAINT `pesanan_ibfk_1` FOREIGN KEY (`pelanggan_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `pesanan_ibfk_2` FOREIGN KEY (`meja_id`) REFERENCES `meja` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_1` FOREIGN KEY (`pesanan_id`) REFERENCES `pesanan` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `transaksi_ibfk_2` FOREIGN KEY (`kasir_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `varian`
--
ALTER TABLE `varian`
  ADD CONSTRAINT `varian_ibfk_1` FOREIGN KEY (`menu_id`) REFERENCES `menu` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
