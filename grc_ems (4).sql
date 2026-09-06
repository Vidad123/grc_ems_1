-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 06, 2026 at 10:14 AM
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
(1, 'Enrollment for First Semester is open', 'Submit complete requirements before the published deadline.', 'all', 1, NULL, '2026-09-05 13:34:12', '2026-09-05 05:34:12'),
(2, 'Student orientation', 'New-student orientation will be held at the main auditorium.', 'students', 1, NULL, '2026-09-05 13:34:12', '2026-09-05 05:34:12');

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
(1, 'GRC-APP-26-6BFE65', '5548e7a5-3049-40b4-a0bf-8ed07a5fdf2a', 'siijaayy5@gmail.com', 'Creasan Jade', 'Cacal', 'Vidad', '2026-09-01', '09123456678', 'kaingin', 'bcp', '21312841829', 'ICT', '0000', 'new', 1, 'action_required', 1, 'pakyo', 2, '2026-09-05 13:48:31', '2026-09-06 11:06:24', '2026-09-05 05:48:31', '2026-09-06 03:06:24'),
(2, 'GRC-APP-26-A36779', '667b4bdd-452a-4368-94cd-b55ac5bfc084', 'aibandrosalviolon@gmail.com', 'Aiband', 'Rosal', 'Violon', '2005-06-13', '09055286050', 'weweweweawrawr', 'Arellano Elisa Esguerra Campus', '136839090559', 'HUMSS', '2023', 'new', 1, 'approved', 1, NULL, 2, '2026-09-06 15:14:47', '2026-09-06 15:18:56', '2026-09-06 07:14:47', '2026-09-06 07:18:56');

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
(1, 2, 'birth_certificate', 'b1dc1090f593f0ec6f28371cf7651466.jpg', 'images (4).jpg', 'image/jpeg', 37438, 'pending', NULL, '2026-09-06 07:14:47'),
(2, 2, 'academic_record', '25747656a155762fe20a17eb031e293f.jpg', 'images (4).jpg', 'image/jpeg', 37438, 'pending', NULL, '2026-09-06 07:14:47'),
(3, 2, 'id_photo', '8c844b921e0762a50d8f7bab9b04f7a9.jpg', 'images (4).jpg', 'image/jpeg', 37438, 'pending', NULL, '2026-09-06 07:14:47'),
(4, 2, 'good_moral', '48ba030a475526fa0d53416eb9d3600e.jpg', 'images (4).jpg', 'image/jpeg', 37438, 'pending', NULL, '2026-09-06 07:14:47');

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
(1, 1, 'Tuition and miscellaneous fees', 18500.00, 18000.00, '2026-10-05', '2026-2027', '1st', '2026-09-05 05:49:08', '2026-09-06 05:45:13'),
(2, 2, 'Tuition fee', 15000.00, 0.00, '2026-10-06', '2026-2027', '1st', '2026-09-06 07:18:56', '2026-09-06 07:18:56'),
(3, 2, 'Miscellaneous fees', 3500.00, 0.00, '2026-10-06', '2026-2027', '1st', '2026-09-06 07:18:56', '2026-09-06 07:18:56');

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
(1, NULL, 'account.manual_create', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '{\"role\":\"Super Admin\",\"temporary_setup_page\":true}', '2026-09-05 05:46:42'),
(2, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 05:49:00'),
(3, 2, 'application.approved', 'applications', 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '{\"email_sent\":true}', '2026-09-05 05:49:12'),
(4, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 05:49:31'),
(5, 3, 'auth.login', 'users', 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 05:50:08'),
(6, 3, 'auth.password_changed', 'users', 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 06:07:13'),
(7, 3, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 06:07:16'),
(8, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 09:54:10'),
(9, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 10:19:30'),
(10, 2, 'schedules.delete', 'schedules', 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 10:19:46'),
(11, 2, 'schedules.delete', 'schedules', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 10:19:48'),
(12, 2, 'subjects.delete', 'subjects', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 10:19:53'),
(13, 2, 'subjects.delete', 'subjects', 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 10:19:56'),
(14, 2, 'sections.delete', 'sections', 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 10:19:59'),
(15, 2, 'assessments.save', 'assessments', 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 10:20:25'),
(16, 2, 'assessments.save', 'assessments', 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 10:20:42'),
(17, 2, 'assessments.save', 'assessments', 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 10:20:53'),
(18, 2, 'application.rejected', 'applications', 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '{\"email_sent\":true}', '2026-09-05 10:41:49'),
(19, 2, 'students.save', 'students', 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 03:05:46'),
(20, 2, 'application.action_required', 'applications', 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '{\"email_sent\":true}', '2026-09-06 03:06:29'),
(21, 2, 'sections.save', 'sections', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 03:09:38'),
(22, 2, 'subjects.save', 'subjects', 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 03:10:59'),
(23, 2, 'schedules.save', 'schedules', 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 03:11:47'),
(24, 2, 'students.save', 'students', 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 03:12:09'),
(25, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 03:12:47'),
(26, 3, 'auth.login', 'users', 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 03:12:54'),
(27, 3, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 03:15:53'),
(28, 3, 'auth.login', 'users', 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 03:16:10'),
(29, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 03:44:24'),
(30, 2, 'users.save', 'users', 4, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 03:45:04'),
(31, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 03:45:07'),
(32, 4, 'auth.login', 'users', 4, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 03:45:12'),
(33, 4, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 03:46:02'),
(34, 4, 'auth.login', 'users', 4, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 03:46:09'),
(35, 4, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 03:46:17'),
(36, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 03:46:25'),
(37, 3, 'auth.login', 'users', 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 05:03:06'),
(38, 3, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 05:03:50'),
(39, 4, 'auth.login', 'users', 4, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 05:04:28'),
(40, 4, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 05:06:48'),
(41, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 05:07:09'),
(42, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 05:39:37'),
(43, 3, 'auth.login', 'users', 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 05:39:43'),
(44, 3, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 05:40:33'),
(45, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 05:40:40'),
(46, 2, 'students.save', 'students', 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 05:43:41'),
(47, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 05:43:42'),
(48, 3, 'auth.login', 'users', 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 05:43:53'),
(49, 3, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 05:44:20'),
(50, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 05:44:36'),
(51, 2, 'assessments.save', 'assessments', 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 05:45:03'),
(52, 2, 'assessments.save', 'assessments', 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 05:45:13'),
(53, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 05:45:28'),
(54, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 06:17:46'),
(55, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 06:57:10'),
(56, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 07:11:57'),
(57, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 07:18:34'),
(58, 2, 'application.approved', 'applications', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '{\"email_sent\":true}', '2026-09-06 07:19:01'),
(59, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 07:19:48'),
(60, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 07:32:55'),
(61, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 07:32:59'),
(62, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 07:48:17'),
(63, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 07:49:37'),
(64, 4, 'auth.login', 'users', 4, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 07:49:48'),
(65, 4, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 07:50:06'),
(66, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 07:50:21'),
(67, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 07:51:03'),
(68, 4, 'auth.login', 'users', 4, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 07:51:10'),
(69, 4, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 07:51:14'),
(70, 4, 'auth.login', 'users', 4, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 07:52:25'),
(71, 4, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 07:53:29'),
(72, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 07:53:38'),
(73, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 07:54:34'),
(74, 3, 'auth.login', 'users', 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 07:54:40'),
(75, 3, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 07:55:02'),
(76, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-06 07:55:09'),
(77, 2, 'schedules.save', 'schedules', 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 07:56:13'),
(78, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 07:56:14'),
(79, 3, 'auth.login', 'users', 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 07:56:19'),
(80, 3, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 07:56:34'),
(81, 2, 'auth.login', 'users', 2, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 07:56:40'),
(82, 2, 'sections.save', 'sections', 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 07:57:23'),
(83, 2, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 08:01:02'),
(84, 3, 'auth.login', 'users', 3, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 08:01:09'),
(85, 3, 'auth.logout', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '[]', '2026-09-05 08:02:47');

-- --------------------------------------------------------

--
-- Table structure for table `class_schedules`
--

CREATE TABLE `class_schedules` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `section_id` int(10) UNSIGNED NOT NULL,
  `subject_id` int(10) UNSIGNED NOT NULL,
  `day_of_week` enum('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday') NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `room` varchar(80) DEFAULT NULL,
  `instructor` varchar(190) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `class_schedules`
--

INSERT INTO `class_schedules` (`id`, `section_id`, `subject_id`, `day_of_week`, `start_time`, `end_time`, `room`, `instructor`) VALUES
(3, 2, 3, 'Saturday', '21:00:00', '22:00:00', '306', 'Jose Rizal');

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
(1, 'siijaayy5@gmail.com', 'GRC Application Approved – Your Student Portal Account', '[Credential email redacted] Application GRC-APP-26-6BFE65 approved; account GRC-2026-00003 created.', 'sent', NULL, '2026-09-05 05:49:12'),
(2, 'siijaayy5@gmail.com', 'GRC Application Update – Not Approved', '<h2>GRC application decision</h2><p>Dear Creasan Jade Vidad,</p><p>We regret to inform you that your application was not approved after review.</p><p><b>Application reference:</b> GRC-APP-26-6BFE65</p><p>The submitted application did not meet the current enrollment requirements.</p><p>If you believe information is missing or would like clarification, please call the school at <b>09123456789</b> or visit <b>GRC Building, 454, 1400 Rizal Ave Ext, Grace Park East, Caloocan, Metro Manila, Philippines</b>. Please bring your reference ID and supporting documents.</p><p>Thank you for your interest in Global Reciprocal Colleges.</p>', 'sent', NULL, '2026-09-05 10:41:48'),
(3, 'siijaayy5@gmail.com', 'Action Required for Your GRC Application', '<h2>Action required for your GRC application</h2><p>Dear Creasan Jade Vidad,</p><p>We need additional information or corrected documents before processing your application.</p><p><b>Application reference:</b> GRC-APP-26-6BFE65</p><p>pakyo</p>', 'sent', NULL, '2026-09-06 03:06:29'),
(4, 'aibandrosalviolon@gmail.com', 'GRC Application Approved – Your Student Portal Account', '[Credential email redacted] Application GRC-APP-26-A36779 approved; account GRC-2026-00005 created.', 'sent', NULL, '2026-09-06 07:19:01');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `student_profile_id` bigint(20) UNSIGNED NOT NULL,
  `reference_no` varchar(80) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `payment_date` datetime NOT NULL,
  `status` enum('pending','posted','void') DEFAULT 'posted'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
(5, 'academics.manage', 'Manage programs, sections, subjects, and schedules'),
(6, 'finance.manage', 'Manage tuition and fee assessments'),
(7, 'announcements.manage', 'Publish announcements'),
(8, 'tickets.manage', 'Manage helpdesk tickets'),
(9, 'tickets.create', 'Create helpdesk tickets'),
(10, 'tickets.view', 'View permitted tickets'),
(11, 'reports.view', 'View reports'),
(12, 'portal.view', 'Use student portal'),
(13, 'profile.manage', 'Manage own profile'),
(14, 'users.manage', 'Manage staff and administrator accounts');

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
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(1, 11),
(1, 12),
(1, 13),
(1, 14),
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(2, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 10),
(2, 11),
(2, 14),
(3, 1),
(3, 2),
(3, 3),
(3, 4),
(3, 5),
(3, 7),
(3, 8),
(3, 10),
(3, 11),
(4, 1),
(4, 2),
(4, 3),
(4, 8),
(4, 10),
(5, 9),
(5, 10),
(5, 12),
(5, 13),
(6, 8),
(6, 10);

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
(2, 'BSIT - 123', 1, 1, '2026-2027', '1st', 50),
(3, '1233', 2, 11, '111', '11', 111);

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
(1, 3, 1, 'GRC-2026-00003', 1, 2, 1, '2026-09-05 05:49:08'),
(2, 5, 2, 'GRC-2026-00005', 1, 2, 1, '2026-09-06 07:18:56');

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
(1, 'admin', 'admin@gmail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', 1, 'active', 0, 0, NULL, '2026-09-05 13:34:12', '2026-09-05 05:34:12', '2026-09-05 05:34:12'),
(2, 'ADMINISTRATOR', 'sp@gmail.com', '$2y$10$g3LlbZ3WSNgn21wOnCCtaOrqa5wwrB6.hGHrRrrlY39DP1Xk4.njK', 1, 'active', 0, 0, '2026-09-05 15:56:40', '2026-09-05 13:46:42', '2026-09-05 05:46:42', '2026-09-05 07:56:40'),
(3, 'student2600001', 'siijaayy5@gmail.com', '$2y$10$4pKkBgLdjMmTkbwIYuyYA.R3MSKoGhsqSavbwXnTCrE0wcHGHWobW', 5, 'active', 0, 0, '2026-09-05 16:01:09', '2026-09-05 13:49:08', '2026-09-05 05:49:08', '2026-09-05 08:01:09'),
(4, 'creasan', '1@gmail.com', '$2y$10$FT7EjUinYRwvf0hAQiIuYO3LEWDVEWpA.7TLaK38pp/L5KfSRROr.', 3, 'active', 0, 0, '2026-09-06 15:52:25', '2026-09-06 11:45:04', '2026-09-06 03:45:04', '2026-09-06 07:52:25'),
(5, 'student2600002', 'aibandrosalviolon@gmail.com', '$2y$10$uABtdsQFbp3/ICw808JiPeD.eOKKM42BeXrcQx7HjtC91OMx3jVnS', 5, 'active', 1, 0, NULL, '2026-09-06 15:18:56', '2026-09-06 07:18:56', '2026-09-06 07:18:56');

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
  ADD KEY `student_profile_id` (`student_profile_id`);

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
  ADD KEY `subject_id` (`subject_id`);

--
-- Indexes for table `email_logs`
--
ALTER TABLE `email_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_email_status` (`status`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `reference_no` (`reference_no`),
  ADD KEY `student_profile_id` (`student_profile_id`);

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
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `application_documents`
--
ALTER TABLE `application_documents`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `assessments`
--
ALTER TABLE `assessments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=86;

--
-- AUTO_INCREMENT for table `class_schedules`
--
ALTER TABLE `class_schedules`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `email_logs`
--
ALTER TABLE `email_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `sections`
--
ALTER TABLE `sections`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `student_profiles`
--
ALTER TABLE `student_profiles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `subjects`
--
ALTER TABLE `subjects`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tickets`
--
ALTER TABLE `tickets`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ticket_messages`
--
ALTER TABLE `ticket_messages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `class_schedules`
--
ALTER TABLE `class_schedules`
  ADD CONSTRAINT `class_schedules_ibfk_1` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `class_schedules_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`);

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`student_profile_id`) REFERENCES `student_profiles` (`id`) ON DELETE CASCADE;

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
