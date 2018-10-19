SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS `sdbs_ac` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `sdbs_ac`;

DROP TABLE IF EXISTS `server_log`;
CREATE TABLE `server_log` (
  `server` varchar(255) NOT NULL,
  `count_start` bigint(20) NOT NULL,
  `timestamp_start` bigint(20) NOT NULL,
  `count_stop` bigint(20) NOT NULL,
  `timestamp_stop` bigint(20) NOT NULL,
  `count_change_map` bigint(20) NOT NULL,
  `count_connect_player` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `server_log_change_map`;
CREATE TABLE `server_log_change_map` (
  `map` varchar(255) NOT NULL,
  `server` varchar(255) NOT NULL,
  `count_change` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `server_log_visit_player`;
CREATE TABLE `server_log_visit_player` (
  `player` varchar(255) NOT NULL,
  `ip` varchar(1024) NOT NULL,
  `old_ip_1` varchar(1024) NOT NULL,
  `old_ip_2` varchar(1024) NOT NULL,
  `old_ip_3` varchar(1024) NOT NULL,
  `old_ip_4` varchar(1024) NOT NULL,
  `old_ip_5` varchar(1024) NOT NULL,
  `server` varchar(255) NOT NULL,
  `count_visit` bigint(20) NOT NULL,
  `timestamp_connect` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `name` varchar(255) NOT NULL,
  `name_registered` varchar(255) NOT NULL,
  `uuid` varchar(36) NOT NULL,
  `pwd` varchar(255) NOT NULL,
  `email` varchar(512) NOT NULL,
  `access` tinyint(4) NOT NULL DEFAULT '0',
  `use_access` tinyint(4) NOT NULL DEFAULT '0',
  `date_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_login` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_logout` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `active` tinyint(1) NOT NULL DEFAULT '0',
  `server` text NOT NULL,
  `player_name` text NOT NULL,
  `count_login_gema` bigint(20) NOT NULL DEFAULT '0',
  `count_login_ctf` bigint(20) NOT NULL DEFAULT '0',
  `count_login_lss` bigint(20) NOT NULL DEFAULT '0',
  `count_login_vs` bigint(20) NOT NULL DEFAULT '0',
  `ip` text NOT NULL,
  `disable_account` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `user_data_gema`;
CREATE TABLE `user_data_gema` (
  `name` varchar(255) NOT NULL,
  `email` varchar(512) NOT NULL,
  `uuid` varchar(36) NOT NULL,
  `map` varchar(255) NOT NULL,
  `count` int(11) NOT NULL DEFAULT '0',
  `count_score` int(11) NOT NULL DEFAULT '0',
  `time_score` int(11) NOT NULL DEFAULT '0',
  `time_score_old` int(11) NOT NULL DEFAULT '0',
  `time_score_best` int(11) NOT NULL DEFAULT '0',
  `time_score_best_old` int(11) NOT NULL DEFAULT '0',
  `use_map_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


ALTER TABLE `server_log`
  ADD UNIQUE KEY `name` (`server`);

ALTER TABLE `user`
  ADD UNIQUE KEY `name` (`name`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
