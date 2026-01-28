-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 24, 2026 at 05:22 AM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `kegiatan_harian`
--

-- --------------------------------------------------------

--
-- Table structure for table `kegiatan`
--

CREATE TABLE `kegiatan` (
  `id_kegiatan` int NOT NULL,
  `tanggal` date NOT NULL,
  `judul_kegiatan` varchar(100) NOT NULL,
  `deskripsi` text NOT NULL,
  `kategori` enum('Akademik','Organisasi','Pribadi','Pekerjaan','Lainnya') NOT NULL,
  `status` enum('Direncanakan','Sedang Berjalan','Selesai') NOT NULL,
  `tanggal_input` date NOT NULL,
  `foto` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `kegiatan`
--

INSERT INTO `kegiatan` (`id_kegiatan`, `tanggal`, `judul_kegiatan`, `deskripsi`, `kategori`, `status`, `tanggal_input`, `foto`) VALUES
(1, '2026-01-10', 'Mengikuti Kuliah Mobile Programming', 'Mempelajari Flutter dan integrasi API', 'Akademik', 'Selesai', '2026-01-10', NULL),
(2, '2026-01-12', 'Rapat Organisasi Himpunan', 'Membahas program kerja semester baru', 'Organisasi', 'Selesai', '2026-01-12', '1769231006_5562.jpeg'),
(3, '2026-01-14', 'Belajar Mandiri Flutter', 'Latihan membuat CRUD aplikasi', 'Pribadi', 'Sedang Berjalan', '2026-01-14', '1769229553_9121.png'),
(4, '2026-01-15', 'Mengerjakan Project UAS Coding', 'Penyelesaian aplikasi mobile', 'Akademik', 'Direncanakan', '2026-01-15', '1769231856_7528.jpeg'),
(6, '2026-01-30', 'PEMBUATAN JEMBATAN', 'jembatan selindung ', 'Organisasi', 'Direncanakan', '2026-01-24', '1769231983_8562.jpg');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `kegiatan`
--
ALTER TABLE `kegiatan`
  ADD PRIMARY KEY (`id_kegiatan`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `kegiatan`
--
ALTER TABLE `kegiatan`
  MODIFY `id_kegiatan` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
