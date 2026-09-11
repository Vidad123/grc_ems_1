-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 11, 2026 at 04:48 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `grc_ems`
--

-- --------------------------------------------------------

--
-- Table structure for table `announcements`
--

CREATE TABLE `announcements` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(190) NOT NULL,
  `body` text NOT NULL,
  `audience` enum('all','students','staff') DEFAULT 'all',
  `is_published` tinyint(1) DEFAULT 1,
  `published_by` bigint(20) UNSIGNED DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `announcements`
--

INSERT INTO `announcements` (`id`, `title`, `body`, `audience`, `is_published`, `published_by`, `published_at`, `created_at`) VALUES
(1, 'Enrollment for First Semester is open', 'Submit complete requirements before the published deadline.', 'all', 1, NULL, '2026-09-05 13:34:12', '2026-09-04 21:34:12'),
(2, 'Student orientation', 'New-student orientation will be held at the main auditorium.', 'students', 1, NULL, '2026-09-05 13:34:12', '2026-09-04 21:34:12');

-- --------------------------------------------------------

--
-- Table structure for table `applications`
--

CREATE TABLE `applications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `reference_id` varchar(40) NOT NULL,
  `submission_token` char(64) DEFAULT NULL,
  `email` varchar(190) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) NOT NULL,
  `birth_date` date DEFAULT NULL,
  `contact_number` varchar(30) DEFAULT NULL,
  `present_address` text DEFAULT NULL,
  `last_school_attended` varchar(190) DEFAULT NULL,
  `lrn` varchar(80) DEFAULT NULL,
  `strand` varchar(150) DEFAULT NULL,
  `year_graduated` year(4) DEFAULT NULL,
  `enrollment_type` enum('new','transferee','returning','continuing') DEFAULT 'new',
  `program_id` int(10) UNSIGNED DEFAULT NULL,
  `status` enum('draft','submitted','under_review','action_required','approved','rejected') DEFAULT 'draft',
  `privacy_consent` tinyint(1) DEFAULT 0,
  `review_notes` text DEFAULT NULL,
  `reviewed_by` bigint(20) UNSIGNED DEFAULT NULL,
  `submitted_at` datetime DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `applications`
--

INSERT INTO `applications` (`id`, `reference_id`, `submission_token`, `email`, `first_name`, `middle_name`, `last_name`, `birth_date`, `contact_number`, `present_address`, `last_school_attended`, `lrn`, `strand`, `year_graduated`, `enrollment_type`, `program_id`, `status`, `privacy_consent`, `review_notes`, `reviewed_by`, `submitted_at`, `reviewed_at`, `created_at`, `updated_at`) VALUES
(1, 'GRC-APP-26-6BFE65', '5548e7a5-3049-40b4-a0bf-8ed07a5fdf2a', 'siijaayy5@gmail.com', 'Creasan Jade', 'Cacal', 'Vidad', '2026-09-01', '09123456678', 'kaingin', 'bcp', '21312841829', 'ICT', NULL, 'new', 1, 'approved', 1, NULL, 2, '2026-09-05 13:48:31', '2026-09-06 11:06:24', '2026-09-04 21:48:31', '2026-09-05 19:06:24'),
(2, 'GRC-APP-26-A36779', '667b4bdd-452a-4368-94cd-b55ac5bfc084', 'aibandrosalviolon@gmail.com', 'Aiband', 'Rosal', 'Violon', '2005-06-13', '09055286050', 'weweweweawrawr', 'Arellano Elisa Esguerra Campus', '136839090559', 'HUMSS', '2023', 'new', 1, 'approved', 1, NULL, 2, '2026-09-06 15:14:47', '2026-09-06 15:18:56', '2026-09-05 23:14:47', '2026-09-05 23:18:56'),
(3, 'GRC-APP-26-C1227F', 'e6d58c96-efc2-4c77-9d34-39244b0e9b17', 'vidadcontessa64@gmail.com', 'Contessa', 'Cacal', 'Vidad', '2007-07-12', '09511282827', 'weweweweawrawr', 'apolsam', '136516130105', 'ICT', '2024', 'new', 1, 'approved', 1, NULL, 2, '2026-09-10 21:28:40', '2026-09-10 21:30:00', '2026-09-10 13:28:40', '2026-09-10 13:30:00');

-- --------------------------------------------------------

--
-- Table structure for table `application_documents`
--

CREATE TABLE `application_documents` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `application_id` bigint(20) UNSIGNED NOT NULL,
  `document_type` varchar(80) NOT NULL,
  `stored_name` varchar(255) NOT NULL,
  `original_name` varchar(255) NOT NULL,
  `mime_type` varchar(100) NOT NULL,
  `file_size` int(10) UNSIGNED NOT NULL,
  `validation_status` enum('pending','valid','invalid') DEFAULT 'pending',
  `validation_note` text DEFAULT NULL,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `application_documents`
--

INSERT INTO `application_documents` (`id`, `application_id`, `document_type`, `stored_name`, `original_name`, `mime_type`, `file_size`, `validation_status`, `validation_note`, `uploaded_at`) VALUES
(1, 2, 'birth_certificate', 'b1dc1090f593f0ec6f28371cf7651466.jpg', 'images (4).jpg', 'image/jpeg', 37438, 'pending', NULL, '2026-09-05 23:14:47'),
(2, 2, 'academic_record', '25747656a155762fe20a17eb031e293f.jpg', 'images (4).jpg', 'image/jpeg', 37438, 'pending', NULL, '2026-09-05 23:14:47'),
(3, 2, 'id_photo', '8c844b921e0762a50d8f7bab9b04f7a9.jpg', 'images (4).jpg', 'image/jpeg', 37438, 'pending', NULL, '2026-09-05 23:14:47'),
(4, 2, 'good_moral', '48ba030a475526fa0d53416eb9d3600e.jpg', 'images (4).jpg', 'image/jpeg', 37438, 'pending', NULL, '2026-09-05 23:14:47');

-- --------------------------------------------------------

--
-- Table structure for table `assessments`
--

CREATE TABLE `assessments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `student_profile_id` bigint(20) UNSIGNED NOT NULL,
  `description` varchar(190) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `amount_paid` decimal(12,2) NOT NULL DEFAULT 0.00,
  `due_date` date DEFAULT NULL,
  `school_year` varchar(20) DEFAULT NULL,
  `semester` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `assessments`
--

INSERT INTO `assessments` (`id`, `student_profile_id`, `description`, `amount`, `amount_paid`, `due_date`, `school_year`, `semester`, `created_at`, `updated_at`) VALUES
(1, 1, 'Tuition and miscellaneous fees', 18500.00, 18500.00, '2026-10-05', '2026-2027', '1st', '2026-09-04 21:49:08', '2026-09-08 18:34:52'),
(2, 2, 'Tuition fee', 15000.00, 0.00, '2026-10-06', '2026-2027', '1st', '2026-09-05 23:18:56', '2026-09-05 23:18:56'),
(3, 2, 'Miscellaneous fees', 3500.00, 0.00, '2026-10-06', '2026-2027', '1st', '2026-09-05 23:18:56', '2026-09-05 23:18:56'),
(4, 3, 'Tuition fee', 15000.00, 15000.00, '2026-10-10', '2026-2027', '1st', '2026-09-10 13:30:01', '2026-09-10 13:33:04'),
(5, 3, 'Miscellaneous fees', 3500.00, 0.00, '2026-10-10', '2026-2027', '1st', '2026-09-10 13:30:01', '2026-09-10 13:30:01'),
(6, 1, 'pang bili ko ng big bike', 1000000.00, 0.00, '2026-09-11', '2026-2027', '1st', '2026-09-10 15:27:23', '2026-09-10 15:27:23'),
(7, 2, 'pang bili ko ng big bike', 1000000.00, 0.00, '2026-09-11', '2026-2027', '1st', '2026-09-10 15:27:23', '2026-09-10 15:27:23'),
(8, 3, 'pang bili ko ng big bike', 1000000.00, 1000000.00, '2026-09-11', '2026-2027', '1st', '2026-09-10 15:27:23', '2026-09-10 15:31:26');

-- --------------------------------------------------------

--
-- Table structure for table `assessment_bills`
--

CREATE TABLE `assessment_bills` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `assessment_id` bigint(20) UNSIGNED NOT NULL,
  `bill_code` varchar(40) NOT NULL,
  `bill_name` varchar(190) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `due_date` date DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `assessment_bills`
--

INSERT INTO `assessment_bills` (`id`, `assessment_id`, `bill_code`, `bill_name`, `amount`, `due_date`, `notes`, `is_active`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 6, '654654', 'pang bili ko ng big bike', 1000000.00, '2026-09-11', 'walang aangal', 1, 2, '2026-09-10 15:27:23', '2026-09-10 15:27:23'),
(2, 7, '654654', 'pang bili ko ng big bike', 1000000.00, '2026-09-11', 'walang aangal', 1, 2, '2026-09-10 15:27:23', '2026-09-10 15:27:23'),
(3, 8, '654654', 'pang bili ko ng big bike', 1000000.00, '2026-09-11', 'walang aangal', 1, 2, '2026-09-10 15:27:23', '2026-09-10 15:27:23');

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `action` varchar(120) NOT NULL,
  `target_table` varchar(80) DEFAULT NULL,
  `target_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `details_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details_json`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `user_id`, `action`, `target_table`, `target_id`, `ip_address`, `user_agent`, `details_json`, `created_at`) VALUES
(1, 2, 'profile.update', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 18:01:07'),
(2, 2, 'auth.password_changed', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 18:13:31'),
(3, 2, 'auth.password_changed', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 18:14:04'),
(4, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 18:15:27'),
(5, 3, 'auth.login', 'users', 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 18:15:36'),
(6, 3, 'payment.submit', 'payment_requests', 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 18:33:32'),
(7, 3, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 18:33:38'),
(8, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 18:33:45'),
(9, 2, 'payment.approved', 'payment_requests', 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 18:34:52'),
(10, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 19:43:16'),
(11, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 19:43:33'),
(12, 2, 'users.save', 'users', 6, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 19:44:24'),
(13, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 19:44:27'),
(14, 6, 'auth.login', 'users', 6, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 19:44:34'),
(15, 6, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 19:48:05'),
(16, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 19:48:13'),
(17, 2, 'schedules.save', 'schedules', 4, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 20:20:51'),
(18, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 20:20:59'),
(19, 6, 'auth.login', 'users', 6, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 20:21:14'),
(20, 6, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 20:29:48'),
(21, 3, 'auth.login', 'users', 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 20:29:56'),
(22, 3, 'ticket.create', 'tickets', 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 20:30:17'),
(23, 3, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 20:30:31'),
(24, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 20:30:58'),
(25, 2, 'ticket.reply', 'tickets', 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 20:31:16'),
(26, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 20:31:20'),
(27, 3, 'auth.login', 'users', 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 20:31:40'),
(28, 3, 'ticket.reply', 'tickets', 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 20:31:50'),
(29, 3, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-08 20:32:14'),
(30, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-09 04:38:50'),
(31, 2, 'users.save', 'users', 7, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-09 04:39:37'),
(32, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-09 04:40:16'),
(33, 7, 'auth.login', 'users', 7, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-09 04:40:23'),
(34, 7, 'ticket.status', 'tickets', 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '{\"status\":\"resolved\"}', '2026-09-09 04:56:07'),
(35, 7, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-09 05:27:59'),
(36, 3, 'auth.login', 'users', 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-09 05:28:25'),
(37, 3, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-09 05:29:12'),
(38, 6, 'auth.login', 'users', 6, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-09 05:29:23'),
(39, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 13:22:07'),
(40, 3, 'auth.login', 'users', 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 13:23:02'),
(41, 3, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 13:23:42'),
(42, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 13:23:51'),
(43, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 13:25:48'),
(44, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 13:25:57'),
(45, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 13:26:25'),
(46, 4, 'auth.login', 'users', 4, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 13:26:33'),
(47, 4, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 13:26:55'),
(48, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 13:27:01'),
(49, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 13:27:20'),
(50, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 13:29:52'),
(51, 2, 'application.approved', 'applications', 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '{\"email_sent\":true}', '2026-09-10 13:30:07'),
(52, 8, 'auth.login', 'users', 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 13:30:56'),
(53, 8, 'auth.password_changed', 'users', 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 13:31:29'),
(54, 8, 'payment.submit', 'payment_requests', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 13:32:16'),
(55, 8, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 13:32:19'),
(56, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 13:32:26'),
(57, 2, 'payment.approved', 'payment_requests', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 13:33:04'),
(58, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 13:33:32'),
(59, 6, 'auth.login', 'users', 6, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 13:33:41'),
(60, 6, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 13:48:22'),
(61, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 13:48:26'),
(62, 2, 'assessment_bill.bulk_create', 'assessment_bills', NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '{\"scope\":\"all\",\"student_count\":3,\"bill_code\":\"654654\"}', '2026-09-10 15:27:23'),
(63, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 15:29:47'),
(64, 8, 'auth.login', 'users', 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 15:29:54'),
(65, 8, 'payment.submit', 'payment_requests', 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 15:30:59'),
(66, 8, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 15:31:06'),
(67, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 15:31:11'),
(68, 2, 'payment.approved', 'payment_requests', 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 15:31:26'),
(69, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 15:31:32'),
(70, 8, 'auth.login', 'users', 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 15:31:40'),
(71, 8, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 17:17:17'),
(72, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-10 17:17:24');

-- --------------------------------------------------------

--
-- Table structure for table `class_schedules`
--

CREATE TABLE `class_schedules` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `section_id` int(10) UNSIGNED NOT NULL,
  `subject_id` int(10) UNSIGNED NOT NULL,
  `teacher_user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `day_of_week` enum('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday') NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `room` varchar(80) DEFAULT NULL,
  `instructor` varchar(190) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `class_schedules`
--

INSERT INTO `class_schedules` (`id`, `section_id`, `subject_id`, `teacher_user_id`, `day_of_week`, `start_time`, `end_time`, `room`, `instructor`) VALUES
(3, 2, 3, NULL, 'Saturday', '21:00:00', '22:00:00', '306', 'Jose Rizal'),
(4, 2, 3, 6, 'Monday', '10:00:00', '22:00:00', '100', 'teacher');

-- --------------------------------------------------------

--
-- Table structure for table `email_logs`
--

CREATE TABLE `email_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `recipient` varchar(190) NOT NULL,
  `subject` varchar(190) NOT NULL,
  `body` mediumtext NOT NULL,
  `status` enum('sent','failed') NOT NULL,
  `error_message` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `email_logs`
--

INSERT INTO `email_logs` (`id`, `recipient`, `subject`, `body`, `status`, `error_message`, `created_at`) VALUES
(1, 'siijaayy5@gmail.com', 'GRC Application Approved – Your Student Portal Account', '[Credential email redacted] Application GRC-APP-26-6BFE65 approved; account GRC-2026-00003 created.', 'sent', NULL, '2026-09-04 21:49:12'),
(4, 'aibandrosalviolon@gmail.com', 'GRC Application Approved – Your Student Portal Account', '[Credential email redacted] Application GRC-APP-26-A36779 approved; account GRC-2026-00005 created.', 'sent', NULL, '2026-09-05 23:19:01'),
(5, 'vidadcontessa64@gmail.com', 'GRC Application Approved – Your Student Portal Account', '[Credential email redacted] Application GRC-APP-26-C1227F approved; account GRC-2026-00008 created.', 'sent', NULL, '2026-09-10 13:30:07');

-- --------------------------------------------------------

--
-- Table structure for table `payment_requests`
--

CREATE TABLE `payment_requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `assessment_id` bigint(20) UNSIGNED NOT NULL,
  `student_profile_id` bigint(20) UNSIGNED NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `payment_method` varchar(80) NOT NULL,
  `payment_reference` varchar(100) NOT NULL,
  `receipt_stored_name` varchar(255) DEFAULT NULL,
  `receipt_original_name` varchar(255) DEFAULT NULL,
  `receipt_mime_type` varchar(100) DEFAULT NULL,
  `receipt_file_size` int(10) UNSIGNED DEFAULT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `processor_notes` text DEFAULT NULL,
  `processed_by` bigint(20) UNSIGNED DEFAULT NULL,
  `processed_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payment_requests`
--

INSERT INTO `payment_requests` (`id`, `assessment_id`, `student_profile_id`, `amount`, `payment_method`, `payment_reference`, `receipt_stored_name`, `receipt_original_name`, `receipt_mime_type`, `receipt_file_size`, `status`, `processor_notes`, `processed_by`, `processed_at`, `created_at`) VALUES
(1, 1, 1, 500.00, 'GCash', '34j24h23g42', 'payment_7d9a5ddb690d452ffb8f2e1aa8aa42ca.jpg', 'Gemini_Generated_Image_jfgp9fjfgp9fjfgp.jpg', 'image/jpeg', 487160, 'approved', 'hggf', 2, '2026-09-09 02:34:52', '2026-09-08 18:33:32'),
(2, 4, 3, 15000.00, 'GCash', '34j24h23g42', 'payment_f5814fbe9289ccc1d7f7510d086d2967.jpg', 'Gemini_Generated_Image_fnp6kxfnp6kxfnp6.jpg', 'image/jpeg', 611935, 'approved', 'mahal kaba?', 2, '2026-09-10 21:33:04', '2026-09-10 13:32:15'),
(3, 8, 3, 1000000.00, 'Over-the-counter', 'gefhsoisf', 'payment_51fc795d6e3a6b8ae4a06a42ade02eee.jpg', 'Gemini_Generated_Image_nsotr8nsotr8nsot.jpg', 'image/jpeg', 621704, 'approved', NULL, 2, '2026-09-10 23:31:26', '2026-09-10 15:30:59');

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` int(10) UNSIGNED NOT NULL,
  `permission_key` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `permission_key`, `description`) VALUES
(1, 'applications.view', 'View submitted applications'),
(2, 'applications.review', 'Process applications'),
(3, 'students.view', 'View student records'),
(4, 'students.manage', 'Manage student records'),
(5, 'users.manage', 'Manage staff and administrator accounts'),
(6, 'academics.manage', 'Manage programs, sections, subjects, and schedules'),
(7, 'finance.manage', 'Manage assessments and verify payments'),
(8, 'payments.create', 'Submit student payment requests'),
(9, 'announcements.manage', 'Publish announcements'),
(10, 'tickets.manage', 'Manage helpdesk tickets'),
(11, 'tickets.create', 'Create helpdesk tickets'),
(12, 'tickets.view', 'View permitted tickets'),
(13, 'reports.view', 'View reports'),
(14, 'portal.view', 'Use student portal'),
(15, 'profile.manage', 'Manage own profile');

-- --------------------------------------------------------

--
-- Table structure for table `programs`
--

CREATE TABLE `programs` (
  `id` int(10) UNSIGNED NOT NULL,
  `program_code` varchar(30) NOT NULL,
  `program_name` varchar(190) NOT NULL,
  `department` varchar(190) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `programs`
--

INSERT INTO `programs` (`id`, `program_code`, `program_name`, `department`, `description`, `is_active`) VALUES
(1, 'BSIT', 'Bachelor of Science in Information Technology', 'Computer Studies', 'Software, networks, data, and information systems.', 1),
(2, 'BSBA', 'Bachelor of Science in Business Administration', 'Business', 'Management, marketing, finance, and enterprise.', 1),
(3, 'BSHM', 'Bachelor of Science in Hospitality Management', 'Hospitality', 'Hospitality operations and service management.', 1),
(4, 'BSEd', 'Bachelor of Secondary Education', 'Education', 'Professional preparation for secondary teaching.', 1),
(5, 'BSA', 'Bachelor of Science in Accountancy', 'Business', 'Accounting, auditing, taxation, and finance.', 1);

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(10) UNSIGNED NOT NULL,
  `role_name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `role_name`, `description`) VALUES
(1, 'Super Admin', 'All permissions'),
(2, 'Admin', 'Enrollment and campus operations'),
(3, 'Registrar', 'Admissions and records'),
(4, 'Staff', 'Limited application and helpdesk processing'),
(5, 'Student', 'Student portal access'),
(6, 'Teacher', 'Teaching staff access');

-- --------------------------------------------------------

--
-- Table structure for table `role_permissions`
--

CREATE TABLE `role_permissions` (
  `role_id` int(10) UNSIGNED NOT NULL,
  `permission_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `role_permissions`
--

INSERT INTO `role_permissions` (`role_id`, `permission_id`) VALUES
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(2, 5),
(2, 6),
(2, 7),
(2, 9),
(2, 10),
(2, 12),
(2, 13),
(2, 15),
(3, 1),
(3, 2),
(3, 3),
(3, 4),
(3, 6),
(3, 7),
(3, 9),
(3, 10),
(3, 12),
(3, 13),
(3, 15),
(4, 1),
(4, 2),
(4, 3),
(4, 7),
(4, 10),
(4, 12),
(4, 15),
(5, 8),
(5, 11),
(5, 12),
(5, 14),
(5, 15),
(6, 10),
(6, 12),
(6, 15);

-- --------------------------------------------------------

--
-- Table structure for table `sections`
--

CREATE TABLE `sections` (
  `id` int(10) UNSIGNED NOT NULL,
  `section_name` varchar(80) NOT NULL,
  `program_id` int(10) UNSIGNED NOT NULL,
  `year_level` tinyint(3) UNSIGNED NOT NULL,
  `school_year` varchar(20) NOT NULL,
  `semester` varchar(20) NOT NULL,
  `capacity` smallint(5) UNSIGNED DEFAULT 40
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sections`
--

INSERT INTO `sections` (`id`, `section_name`, `program_id`, `year_level`, `school_year`, `semester`, `capacity`) VALUES
(2, 'BSIT - 123', 1, 1, '2026-2027', '1st', 50);

-- --------------------------------------------------------

--
-- Table structure for table `student_profiles`
--

CREATE TABLE `student_profiles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `application_id` bigint(20) UNSIGNED NOT NULL,
  `student_number` varchar(40) NOT NULL,
  `program_id` int(10) UNSIGNED NOT NULL,
  `section_id` int(10) UNSIGNED DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `student_profiles`
--

INSERT INTO `student_profiles` (`id`, `user_id`, `application_id`, `student_number`, `program_id`, `section_id`, `is_active`, `created_at`) VALUES
(1, 3, 1, 'GRC-2026-00003', 1, 2, 1, '2026-09-04 21:49:08'),
(2, 5, 2, 'GRC-2026-00005', 1, 2, 1, '2026-09-05 23:18:56'),
(3, 8, 3, 'GRC-2026-00008', 1, 2, 1, '2026-09-10 13:30:01');

-- --------------------------------------------------------

--
-- Table structure for table `subjects`
--

CREATE TABLE `subjects` (
  `id` int(10) UNSIGNED NOT NULL,
  `subject_code` varchar(30) NOT NULL,
  `subject_name` varchar(190) NOT NULL,
  `units` decimal(3,1) DEFAULT 3.0,
  `program_id` int(10) UNSIGNED DEFAULT NULL,
  `year_level` tinyint(3) UNSIGNED DEFAULT NULL,
  `semester` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `subjects`
--

INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `units`, `program_id`, `year_level`, `semester`) VALUES
(3, 'PM', 'Project Management', 8.0, 1, 1, '1st');

-- --------------------------------------------------------

--
-- Table structure for table `teacher_sections`
--

CREATE TABLE `teacher_sections` (
  `teacher_user_id` bigint(20) UNSIGNED NOT NULL,
  `section_id` int(10) UNSIGNED NOT NULL,
  `assigned_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `teacher_sections`
--

INSERT INTO `teacher_sections` (`teacher_user_id`, `section_id`, `assigned_at`) VALUES
(6, 2, '2026-09-08 20:20:51');

-- --------------------------------------------------------

--
-- Table structure for table `tickets`
--

CREATE TABLE `tickets` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `ticket_number` varchar(40) NOT NULL,
  `student_user_id` bigint(20) UNSIGNED NOT NULL,
  `category` varchar(80) NOT NULL,
  `subject` varchar(190) NOT NULL,
  `status` enum('open','in_progress','resolved','closed') DEFAULT 'open',
  `priority` enum('low','normal','high','urgent') DEFAULT 'normal',
  `assigned_to` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tickets`
--

INSERT INTO `tickets` (`id`, `ticket_number`, `student_user_id`, `category`, `subject`, `status`, `priority`, `assigned_to`, `created_at`, `updated_at`) VALUES
(1, 'HD-260908-56897C', 3, 'Technical', 'jih', 'resolved', 'normal', 7, '2026-09-08 20:30:17', '2026-09-09 04:56:07');

-- --------------------------------------------------------

--
-- Table structure for table `ticket_messages`
--

CREATE TABLE `ticket_messages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `ticket_id` bigint(20) UNSIGNED NOT NULL,
  `sender_user_id` bigint(20) UNSIGNED NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ticket_messages`
--

INSERT INTO `ticket_messages` (`id`, `ticket_id`, `sender_user_id`, `message`, `created_at`) VALUES
(1, 1, 3, 'hgchgf', '2026-09-08 20:30:17'),
(2, 1, 2, 'hi', '2026-09-08 20:31:16'),
(3, 1, 3, 'haha', '2026-09-08 20:31:50');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(80) NOT NULL,
  `email` varchar(190) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `status` enum('active','inactive','locked') DEFAULT 'active',
  `must_change_password` tinyint(1) DEFAULT 0,
  `failed_login_attempts` tinyint(3) UNSIGNED DEFAULT 0,
  `last_login_at` datetime DEFAULT NULL,
  `email_verified_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password_hash`, `role_id`, `status`, `must_change_password`, `failed_login_attempts`, `last_login_at`, `email_verified_at`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'admin@gmail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', 1, 'active', 0, 0, NULL, '2026-09-05 13:34:12', '2026-09-04 21:34:12', '2026-09-04 21:34:12'),
(2, 'ADMINISTRATOR', 'sp@gmail.com', '$2y$10$/32kxSE9vEdKszTl/A1dUehf77ra7HxUrqNefwzMdgB1EdXQlc0Uu', 1, 'active', 0, 0, '2026-09-11 01:17:24', '2026-09-05 13:46:42', '2026-09-04 21:46:42', '2026-09-10 17:17:24'),
(3, 'student2600001', 'siijaayy5@gmail.com', '$2y$10$4pKkBgLdjMmTkbwIYuyYA.R3MSKoGhsqSavbwXnTCrE0wcHGHWobW', 5, 'active', 0, 0, '2026-09-10 21:23:02', '2026-09-05 13:49:08', '2026-09-04 21:49:08', '2026-09-10 13:23:02'),
(4, 'creasan', '1@gmail.com', '$2y$10$FT7EjUinYRwvf0hAQiIuYO3LEWDVEWpA.7TLaK38pp/L5KfSRROr.', 3, 'active', 0, 0, '2026-09-10 21:26:33', '2026-09-06 11:45:04', '2026-09-05 19:45:04', '2026-09-10 13:26:33'),
(5, 'student2600002', 'aibandrosalviolon@gmail.com', '$2y$10$uABtdsQFbp3/ICw808JiPeD.eOKKM42BeXrcQx7HjtC91OMx3jVnS', 5, 'active', 1, 0, NULL, '2026-09-06 15:18:56', '2026-09-05 23:18:56', '2026-09-05 23:18:56'),
(6, 'teacher', 'tc@gmail.com', '$2y$10$eyzGfk2y7VH8XwLF8y9qEuySELMRoNlefV2Z7NNi2jig9BnVQtVf.', 6, 'active', 0, 0, '2026-09-10 21:33:41', '2026-09-09 03:44:24', '2026-09-08 19:44:24', '2026-09-10 13:33:41'),
(7, 'staff', 'staff@gmail.com', '$2y$10$hmKU4M.6kcbjNcACZyNRN.5I/v8ayspQbLidJQR62QvMQmwPUCLwK', 4, 'active', 0, 0, '2026-09-09 12:40:23', '2026-09-09 12:39:37', '2026-09-09 04:39:37', '2026-09-09 04:40:23'),
(8, 'student2600003', 'vidadcontessa64@gmail.com', '$2y$10$tYdNNSIIxjSjam/nEn3mb.T2CdmLyniVQPbQhYmR.NIZo6vpFmCwK', 5, 'active', 0, 0, '2026-09-10 23:31:40', '2026-09-10 21:30:01', '2026-09-10 13:30:01', '2026-09-10 15:31:40');

-- --------------------------------------------------------

--
-- Table structure for table `user_profiles`
--

CREATE TABLE `user_profiles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) NOT NULL,
  `birth_date` date DEFAULT NULL,
  `contact_number` varchar(30) DEFAULT NULL,
  `present_address` text DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_profiles`
--

INSERT INTO `user_profiles` (`id`, `user_id`, `first_name`, `middle_name`, `last_name`, `birth_date`, `contact_number`, `present_address`, `updated_at`) VALUES
(1, 2, 'Creasan Jade', 'Cacal', 'Vidad', '2026-09-10', '89787897987', 'kaingin', '2026-09-08 18:01:07');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `announcements`
--
ALTER TABLE `announcements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `published_by` (`published_by`);

--
-- Indexes for table `applications`
--
ALTER TABLE `applications`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `reference_id` (`reference_id`),
  ADD UNIQUE KEY `submission_token` (`submission_token`),
  ADD KEY `program_id` (`program_id`),
  ADD KEY `reviewed_by` (`reviewed_by`),
  ADD KEY `idx_app_status` (`status`),
  ADD KEY `idx_app_email` (`email`);

--
-- Indexes for table `application_documents`
--
ALTER TABLE `application_documents`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_app_doc` (`application_id`,`document_type`);

--
-- Indexes for table `assessments`
--
ALTER TABLE `assessments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_assessment_student` (`student_profile_id`);

--
-- Indexes for table `assessment_bills`
--
ALTER TABLE `assessment_bills`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_assessment_bill_code` (`assessment_id`,`bill_code`),
  ADD KEY `fk_assessment_bills_creator` (`created_by`),
  ADD KEY `idx_bill_assessment` (`assessment_id`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_audit_created` (`created_at`);

--
-- Indexes for table `class_schedules`
--
ALTER TABLE `class_schedules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `section_id` (`section_id`),
  ADD KEY `subject_id` (`subject_id`),
  ADD KEY `idx_schedule_teacher` (`teacher_user_id`);

--
-- Indexes for table `email_logs`
--
ALTER TABLE `email_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_email_status` (`status`);

--
-- Indexes for table `payment_requests`
--
ALTER TABLE `payment_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `assessment_id` (`assessment_id`),
  ADD KEY `student_profile_id` (`student_profile_id`),
  ADD KEY `processed_by` (`processed_by`),
  ADD KEY `idx_payment_status` (`status`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permission_key` (`permission_key`);

--
-- Indexes for table `programs`
--
ALTER TABLE `programs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `program_code` (`program_code`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `role_name` (`role_name`);

--
-- Indexes for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD PRIMARY KEY (`role_id`,`permission_id`),
  ADD KEY `permission_id` (`permission_id`);

--
-- Indexes for table `sections`
--
ALTER TABLE `sections`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `section_name` (`section_name`),
  ADD KEY `program_id` (`program_id`);

--
-- Indexes for table `student_profiles`
--
ALTER TABLE `student_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD UNIQUE KEY `application_id` (`application_id`),
  ADD UNIQUE KEY `student_number` (`student_number`),
  ADD KEY `program_id` (`program_id`),
  ADD KEY `section_id` (`section_id`);

--
-- Indexes for table `subjects`
--
ALTER TABLE `subjects`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `subject_code` (`subject_code`),
  ADD KEY `program_id` (`program_id`);

--
-- Indexes for table `teacher_sections`
--
ALTER TABLE `teacher_sections`
  ADD PRIMARY KEY (`teacher_user_id`,`section_id`),
  ADD KEY `section_id` (`section_id`);

--
-- Indexes for table `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ticket_number` (`ticket_number`),
  ADD KEY `student_user_id` (`student_user_id`),
  ADD KEY `assigned_to` (`assigned_to`),
  ADD KEY `idx_ticket_status` (`status`);

--
-- Indexes for table `ticket_messages`
--
ALTER TABLE `ticket_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ticket_id` (`ticket_id`),
  ADD KEY `sender_user_id` (`sender_user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `role_id` (`role_id`),
  ADD KEY `idx_users_email` (`email`);

--
-- Indexes for table `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `announcements`
--
ALTER TABLE `announcements`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `applications`
--
ALTER TABLE `applications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `application_documents`
--
ALTER TABLE `application_documents`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `assessments`
--
ALTER TABLE `assessments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `assessment_bills`
--
ALTER TABLE `assessment_bills`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT for table `class_schedules`
--
ALTER TABLE `class_schedules`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `email_logs`
--
ALTER TABLE `email_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `payment_requests`
--
ALTER TABLE `payment_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `programs`
--
ALTER TABLE `programs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `sections`
--
ALTER TABLE `sections`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `student_profiles`
--
ALTER TABLE `student_profiles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `subjects`
--
ALTER TABLE `subjects`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tickets`
--
ALTER TABLE `tickets`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `ticket_messages`
--
ALTER TABLE `ticket_messages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `user_profiles`
--
ALTER TABLE `user_profiles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `announcements`
--
ALTER TABLE `announcements`
  ADD CONSTRAINT `announcements_ibfk_1` FOREIGN KEY (`published_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `applications`
--
ALTER TABLE `applications`
  ADD CONSTRAINT `applications_ibfk_1` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`),
  ADD CONSTRAINT `applications_ibfk_2` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `application_documents`
--
ALTER TABLE `application_documents`
  ADD CONSTRAINT `application_documents_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `assessments`
--
ALTER TABLE `assessments`
  ADD CONSTRAINT `assessments_ibfk_1` FOREIGN KEY (`student_profile_id`) REFERENCES `student_profiles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `assessment_bills`
--
ALTER TABLE `assessment_bills`
  ADD CONSTRAINT `fk_assessment_bills_assessment` FOREIGN KEY (`assessment_id`) REFERENCES `assessments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_assessment_bills_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `class_schedules`
--
ALTER TABLE `class_schedules`
  ADD CONSTRAINT `class_schedules_ibfk_1` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `class_schedules_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`),
  ADD CONSTRAINT `fk_schedule_teacher` FOREIGN KEY (`teacher_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `payment_requests`
--
ALTER TABLE `payment_requests`
  ADD CONSTRAINT `payment_requests_ibfk_1` FOREIGN KEY (`assessment_id`) REFERENCES `assessments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `payment_requests_ibfk_2` FOREIGN KEY (`student_profile_id`) REFERENCES `student_profiles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `payment_requests_ibfk_3` FOREIGN KEY (`processed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD CONSTRAINT `role_permissions_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_permissions_ibfk_2` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sections`
--
ALTER TABLE `sections`
  ADD CONSTRAINT `sections_ibfk_1` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`);

--
-- Constraints for table `student_profiles`
--
ALTER TABLE `student_profiles`
  ADD CONSTRAINT `student_profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_profiles_ibfk_2` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`),
  ADD CONSTRAINT `student_profiles_ibfk_3` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`),
  ADD CONSTRAINT `student_profiles_ibfk_4` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `subjects`
--
ALTER TABLE `subjects`
  ADD CONSTRAINT `subjects_ibfk_1` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`);

--
-- Constraints for table `teacher_sections`
--
ALTER TABLE `teacher_sections`
  ADD CONSTRAINT `teacher_sections_ibfk_1` FOREIGN KEY (`teacher_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `teacher_sections_ibfk_2` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `tickets`
--
ALTER TABLE `tickets`
  ADD CONSTRAINT `tickets_ibfk_1` FOREIGN KEY (`student_user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `tickets_ibfk_2` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `ticket_messages`
--
ALTER TABLE `ticket_messages`
  ADD CONSTRAINT `ticket_messages_ibfk_1` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ticket_messages_ibfk_2` FOREIGN KEY (`sender_user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

--
-- Constraints for table `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD CONSTRAINT `user_profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
