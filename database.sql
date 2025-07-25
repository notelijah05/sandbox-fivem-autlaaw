-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.6.12-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for database_ptr
DROP DATABASE IF EXISTS `database_ptr`;
CREATE DATABASE IF NOT EXISTS `database_ptr` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci */;
USE `database_ptr`;

-- Dumping structure for table database_ptr.app_profile_history
DROP TABLE IF EXISTS `app_profile_history`;
CREATE TABLE IF NOT EXISTS `app_profile_history` (
  `sid` bigint(20) unsigned NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `app` varchar(32) NOT NULL,
  `name` varchar(256) DEFAULT NULL,
  `picture` varchar(2048) DEFAULT NULL,
  `meta` longtext DEFAULT NULL,
  KEY `sid` (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.bank_accounts
DROP TABLE IF EXISTS `bank_accounts`;
CREATE TABLE IF NOT EXISTS `bank_accounts` (
  `account` int(10) NOT NULL,
  `type` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `balance` int(10) NOT NULL DEFAULT 0,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`account`) USING BTREE,
  KEY `Owner` (`owner`) USING BTREE,
  KEY `Type` (`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.bank_accounts_permissions
DROP TABLE IF EXISTS `bank_accounts_permissions`;
CREATE TABLE IF NOT EXISTS `bank_accounts_permissions` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `account` int(10) NOT NULL,
  `type` int(10) NOT NULL,
  `jointOwner` varchar(255) DEFAULT NULL,
  `job` varchar(255) DEFAULT NULL,
  `workplace` varchar(255) DEFAULT NULL,
  `jobPermissions` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `job` (`job`) USING BTREE,
  KEY `workplace` (`workplace`) USING BTREE,
  KEY `jointOwner` (`jointOwner`) USING BTREE,
  KEY `account` (`account`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.bank_accounts_transactions
DROP TABLE IF EXISTS `bank_accounts_transactions`;
CREATE TABLE IF NOT EXISTS `bank_accounts_transactions` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `account` int(10) NOT NULL,
  `amount` int(10) NOT NULL DEFAULT 0,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `description` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `data` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `account` (`account`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.bench_schematics
DROP TABLE IF EXISTS `bench_schematics`;
CREATE TABLE IF NOT EXISTS `bench_schematics` (
  `bench` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `schematic` char(255) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  KEY `bench` (`bench`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.blueline_race_history
DROP TABLE IF EXISTS `blueline_race_history`;
CREATE TABLE IF NOT EXISTS `blueline_race_history` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `state` int(11) NOT NULL DEFAULT 0,
  `name` varchar(32) NOT NULL,
  `host` varchar(32) NOT NULL,
  `track` int(11) unsigned NOT NULL,
  `class` varchar(4) NOT NULL,
  `racers` longtext NOT NULL DEFAULT '[]',
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pd_race_history_track` (`track`) USING BTREE,
  KEY `host` (`host`),
  CONSTRAINT `pd_race_history_track` FOREIGN KEY (`track`) REFERENCES `blueline_tracks` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=879 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.blueline_tracks
DROP TABLE IF EXISTS `blueline_tracks`;
CREATE TABLE IF NOT EXISTS `blueline_tracks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `distance` varchar(256) NOT NULL,
  `type` varchar(16) NOT NULL,
  `checkpoints` longtext NOT NULL,
  `created_by` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.blueline_track_history
DROP TABLE IF EXISTS `blueline_track_history`;
CREATE TABLE IF NOT EXISTS `blueline_track_history` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `track` int(11) unsigned NOT NULL,
  `race` int(11) unsigned NOT NULL,
  `callsign` varchar(32) NOT NULL,
  `lap_start` int(11) NOT NULL,
  `lap_end` int(11) NOT NULL,
  `laptime` int(11) NOT NULL,
  `car` varchar(256) NOT NULL,
  `owned` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pd_track_history_track` (`track`) USING BTREE,
  KEY `pd_track_history_race` (`race`) USING BTREE,
  KEY `callsign` (`callsign`),
  CONSTRAINT `pd_track_history_race` FOREIGN KEY (`race`) REFERENCES `blueline_race_history` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `pd_track_history_track` FOREIGN KEY (`track`) REFERENCES `blueline_tracks` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1156 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.business_phones
DROP TABLE IF EXISTS `business_phones`;
CREATE TABLE IF NOT EXISTS `business_phones` (
  `id` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `number` varchar(12) NOT NULL,
  `muted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.character_app_profiles
DROP TABLE IF EXISTS `character_app_profiles`;
CREATE TABLE IF NOT EXISTS `character_app_profiles` (
  `sid` bigint(20) unsigned NOT NULL,
  `app` varchar(32) NOT NULL,
  `name` varchar(64) NOT NULL,
  `picture` varchar(512) DEFAULT NULL,
  `meta` longtext NOT NULL DEFAULT '{}',
  PRIMARY KEY (`sid`,`app`),
  UNIQUE KEY `app` (`app`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.character_calls
DROP TABLE IF EXISTS `character_calls`;
CREATE TABLE IF NOT EXISTS `character_calls` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `owner` varchar(12) NOT NULL,
  `number` varchar(12) NOT NULL,
  `time` datetime NOT NULL DEFAULT current_timestamp(),
  `method` bit(1) NOT NULL DEFAULT b'0',
  `duration` int(11) NOT NULL DEFAULT -1,
  `anonymous` bit(1) NOT NULL DEFAULT b'0',
  `decryptable` bit(1) NOT NULL DEFAULT b'0',
  `limited` bit(1) NOT NULL DEFAULT b'0',
  `unread` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`),
  KEY `number` (`number`),
  KEY `owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.character_chatter_groups
DROP TABLE IF EXISTS `character_chatter_groups`;
CREATE TABLE IF NOT EXISTS `character_chatter_groups` (
  `sid` bigint(20) unsigned NOT NULL,
  `chatty_group` bigint(20) unsigned NOT NULL,
  `joined_date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`sid`,`chatty_group`) USING BTREE,
  KEY `chatter_char_group` (`chatty_group`),
  CONSTRAINT `chatter_char_group` FOREIGN KEY (`chatty_group`) REFERENCES `chatter_groups` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.character_contacts
DROP TABLE IF EXISTS `character_contacts`;
CREATE TABLE IF NOT EXISTS `character_contacts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `sid` bigint(20) NOT NULL,
  `number` varchar(12) NOT NULL,
  `name` varchar(64) NOT NULL,
  `avatar` varchar(256) DEFAULT NULL,
  `color` varchar(10) DEFAULT NULL,
  `favorite` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`),
  KEY `sid` (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.character_documents
DROP TABLE IF EXISTS `character_documents`;
CREATE TABLE IF NOT EXISTS `character_documents` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `sid` int(11) unsigned NOT NULL,
  `time` datetime NOT NULL DEFAULT current_timestamp(),
  `title` varchar(100) NOT NULL,
  `content` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `owner` (`sid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10794 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.character_documents_shared
DROP TABLE IF EXISTS `character_documents_shared`;
CREATE TABLE IF NOT EXISTS `character_documents_shared` (
  `doc_id` int(10) unsigned NOT NULL,
  `sid` int(10) unsigned NOT NULL,
  `sharer` int(10) unsigned NOT NULL,
  `sharer_name` varchar(256) DEFAULT NULL,
  `shared_date` datetime NOT NULL DEFAULT current_timestamp(),
  `signature_required` tinyint(1) NOT NULL DEFAULT 0,
  `signed` datetime DEFAULT NULL,
  `signed_name` varchar(256) DEFAULT NULL,
  UNIQUE KEY `doc_id_sid` (`doc_id`,`sid`),
  KEY `sid` (`sid`),
  KEY `sharer` (`sharer`),
  KEY `doc_sid` (`doc_id`) USING BTREE,
  CONSTRAINT `doc_shared` FOREIGN KEY (`doc_id`) REFERENCES `character_documents` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.character_emails
DROP TABLE IF EXISTS `character_emails`;
CREATE TABLE IF NOT EXISTS `character_emails` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sid` int(10) unsigned NOT NULL,
  `sender` varchar(256) NOT NULL,
  `subject` varchar(256) NOT NULL,
  `body` longtext NOT NULL,
  `timestamp` datetime NOT NULL DEFAULT current_timestamp(),
  `unread` bit(1) NOT NULL DEFAULT b'1',
  `flags` longtext DEFAULT NULL,
  `expires` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sid` (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.character_messages
DROP TABLE IF EXISTS `character_messages`;
CREATE TABLE IF NOT EXISTS `character_messages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `owner` varchar(12) NOT NULL,
  `number` varchar(12) NOT NULL,
  `method` tinyint(1) NOT NULL DEFAULT 0,
  `unread` bit(1) NOT NULL DEFAULT b'1',
  `time` datetime NOT NULL DEFAULT current_timestamp(),
  `message` varchar(256) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `owner` (`owner`),
  KEY `number` (`number`),
  KEY `ownu` (`owner`,`number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.character_parole
DROP TABLE IF EXISTS `character_parole`;
CREATE TABLE IF NOT EXISTS `character_parole` (
  `SID` int(11) NOT NULL,
  `end` datetime NOT NULL,
  `total` int(11) NOT NULL DEFAULT 0,
  `parole` int(11) NOT NULL DEFAULT 0,
  `sentence` int(11) NOT NULL DEFAULT 0,
  `fine` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.character_photos
DROP TABLE IF EXISTS `character_photos`;
CREATE TABLE IF NOT EXISTS `character_photos` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `sid` int(11) unsigned NOT NULL,
  `time` datetime NOT NULL DEFAULT current_timestamp(),
  `image_url` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `owner` (`sid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.character_schematics
DROP TABLE IF EXISTS `character_schematics`;
CREATE TABLE IF NOT EXISTS `character_schematics` (
  `sid` int(11) DEFAULT NULL,
  `bench` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `schematic` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  KEY `sid` (`sid`,`bench`),
  KEY `schematic` (`schematic`,`bench`,`sid`),
  KEY `sid_schem` (`sid`,`schematic`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.chatter_groups
DROP TABLE IF EXISTS `chatter_groups`;
CREATE TABLE IF NOT EXISTS `chatter_groups` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `label` varchar(64) NOT NULL DEFAULT 'Chatter Group',
  `icon` varchar(1024) DEFAULT NULL,
  `owner` bigint(20) NOT NULL,
  `create_date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=747 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.chatter_messages
DROP TABLE IF EXISTS `chatter_messages`;
CREATE TABLE IF NOT EXISTS `chatter_messages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `group` bigint(20) unsigned NOT NULL,
  `author` bigint(20) unsigned NOT NULL,
  `message` varchar(256) NOT NULL,
  `timestamp` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `chatter_msg_group` (`group`),
  KEY `chatter_msg_author` (`author`),
  CONSTRAINT `chatter_msg_group` FOREIGN KEY (`group`) REFERENCES `chatter_groups` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.crafting_cooldowns
DROP TABLE IF EXISTS `crafting_cooldowns`;
CREATE TABLE IF NOT EXISTS `crafting_cooldowns` (
  `bench` varchar(64) NOT NULL,
  `id` varchar(64) NOT NULL,
  `expires` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.donator_items
DROP TABLE IF EXISTS `donator_items`;
CREATE TABLE IF NOT EXISTS `donator_items` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `player` char(128) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `player_id` int(10) unsigned DEFAULT NULL,
  `redeemed` tinyint(1) NOT NULL DEFAULT 0,
  `data` longtext DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `player` (`player`) USING BTREE,
  KEY `id_player` (`id`,`player`) USING BTREE,
  KEY `player_redeemed` (`player`,`redeemed`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.donor_created_item
DROP TABLE IF EXISTS `donor_created_item`;
CREATE TABLE IF NOT EXISTS `donor_created_item` (
  `sid` int(11) NOT NULL,
  `item_id` char(50) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  KEY `sid` (`sid`) USING BTREE,
  KEY `item_id` (`item_id`) USING BTREE,
  KEY `siditem` (`sid`,`item_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.firearms
DROP TABLE IF EXISTS `firearms`;
CREATE TABLE IF NOT EXISTS `firearms` (
  `police_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `serial` char(128) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `scratched` tinyint(1) NOT NULL DEFAULT 0,
  `purchased` datetime NOT NULL DEFAULT current_timestamp(),
  `model` varchar(128) NOT NULL,
  `item` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `owner_sid` int(11) unsigned DEFAULT NULL,
  `owner_name` varchar(512) DEFAULT NULL,
  `police_filed` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`police_id`),
  KEY `owner_sid` (`owner_sid`) USING BTREE,
  KEY `police_filed` (`police_filed`) USING BTREE,
  KEY `serial` (`serial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.firearms_flags
DROP TABLE IF EXISTS `firearms_flags`;
CREATE TABLE IF NOT EXISTS `firearms_flags` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `serial` char(128) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `type` char(32) NOT NULL DEFAULT 'seized',
  `title` varchar(64) DEFAULT NULL,
  `description` longtext NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `author_sid` int(11) unsigned NOT NULL,
  `author_first` varchar(128) NOT NULL,
  `author_last` varchar(128) NOT NULL,
  `author_callsign` varchar(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `serial` (`serial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.inventory
DROP TABLE IF EXISTS `inventory`;
CREATE TABLE IF NOT EXISTS `inventory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `type` int(11) unsigned NOT NULL DEFAULT 0,
  `slot` int(11) NOT NULL,
  `item_id` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `quality` int(11) NOT NULL DEFAULT 0,
  `information` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci NOT NULL,
  `creationDate` bigint(20) NOT NULL DEFAULT 0,
  `expiryDate` bigint(20) NOT NULL DEFAULT -1,
  `price` int(11) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `item_id_only` (`item_id`),
  KEY `expiryDate` (`expiryDate`),
  KEY `owner` (`owner`,`type`) USING BTREE,
  KEY `type` (`type`) USING BTREE,
  KEY `owner_type_itemid` (`owner`,`type`,`item_id`) USING BTREE,
  KEY `itemidslotname` (`owner`,`type`,`slot`,`item_id`) USING BTREE,
  KEY `owner_type_slot` (`owner`,`type`,`slot`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping structure for table database_ptr.redline_tracks
DROP TABLE IF EXISTS `redline_tracks`;
CREATE TABLE IF NOT EXISTS `redline_tracks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `distance` varchar(256) NOT NULL,
  `type` varchar(16) NOT NULL,
  `checkpoints` longtext NOT NULL,
  `created_by` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.redline_race_history
DROP TABLE IF EXISTS `redline_race_history`;
CREATE TABLE IF NOT EXISTS `redline_race_history` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `state` int(11) NOT NULL DEFAULT 0,
  `name` varchar(32) NOT NULL,
  `host` varchar(32) NOT NULL,
  `track` int(11) unsigned NOT NULL,
  `class` varchar(4) NOT NULL,
  `racers` longtext NOT NULL DEFAULT '[]',
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  KEY `redline_race_history_track` (`track`) USING BTREE,
  KEY `host` (`host`),
  CONSTRAINT `redline_race_history_track` FOREIGN KEY (`track`) REFERENCES `redline_tracks` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.redline_track_history
DROP TABLE IF EXISTS `redline_track_history`;
CREATE TABLE IF NOT EXISTS `redline_track_history` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `track` int(11) unsigned NOT NULL,
  `race` int(11) unsigned NOT NULL,
  `callsign` varchar(32) NOT NULL,
  `lap_start` int(11) NOT NULL,
  `lap_end` int(11) NOT NULL,
  `laptime` int(11) NOT NULL,
  `car` varchar(256) NOT NULL,
  `owned` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `redline_track_history_track` (`track`) USING BTREE,
  KEY `redline_track_history_race` (`race`) USING BTREE,
  KEY `callsign` (`callsign`),
  CONSTRAINT `redline_track_history_race` FOREIGN KEY (`race`) REFERENCES `redline_race_history` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `redline_track_history_track` FOREIGN KEY (`track`) REFERENCES `redline_tracks` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.mdt_warrants
DROP TABLE IF EXISTS `mdt_warrants`;
CREATE TABLE IF NOT EXISTS `mdt_warrants` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `state` enum('active','expired','served') NOT NULL DEFAULT 'active',
  `report` int(11) unsigned DEFAULT NULL,
  `suspect` varchar(64) NOT NULL,
  `title` varchar(255) NOT NULL,
  `creatorSID` varchar(64) NOT NULL,
  `creatorName` varchar(128) NOT NULL,
  `creatorCallsign` varchar(8) DEFAULT NULL,
  `issued` datetime NOT NULL DEFAULT current_timestamp(),
  `expires` datetime DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `officer` varchar(64) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `state` (`state`),
  KEY `suspect` (`suspect`),
  KEY `expires` (`expires`),
  KEY `report` (`report`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.mdt_reports
DROP TABLE IF EXISTS `mdt_reports`;
CREATE TABLE IF NOT EXISTS `mdt_reports` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL DEFAULT 0,
  `title` varchar(255) NOT NULL,
  `content` longtext NOT NULL,
  `officer` varchar(64) NOT NULL,
  `creatorSID` varchar(64) NOT NULL,
  `creatorName` varchar(128) NOT NULL,
  `creatorCallsign` varchar(8) DEFAULT NULL,
  `suspects` longtext DEFAULT NULL,
  `evidence` longtext DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `type` (`type`),
  KEY `officer` (`officer`),
  KEY `created` (`created`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.mdt_vehicles
DROP TABLE IF EXISTS `mdt_vehicles`;
CREATE TABLE IF NOT EXISTS `mdt_vehicles` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `plate` varchar(8) NOT NULL,
  `model` varchar(64) NOT NULL,
  `owner` varchar(64) DEFAULT NULL,
  `stolen` tinyint(1) NOT NULL DEFAULT 0,
  `flags` longtext DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate` (`plate`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.mdt_people
DROP TABLE IF EXISTS `mdt_people`;
CREATE TABLE IF NOT EXISTS `mdt_people` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(64) NOT NULL,
  `first_name` varchar(64) NOT NULL,
  `last_name` varchar(64) NOT NULL,
  `dob` date DEFAULT NULL,
  `gender` enum('male','female','other') DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `flags` longtext DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.mdt_notices
DROP TABLE IF EXISTS `mdt_notices`;
CREATE TABLE IF NOT EXISTS `mdt_notices` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `content` longtext DEFAULT NULL,
  `description` text DEFAULT NULL,
  `author` varchar(64) DEFAULT NULL,
  `creator` varchar(64) NOT NULL,
  `author_name` varchar(128) DEFAULT NULL,
  `restricted` enum('public','private','department','police') NOT NULL DEFAULT 'public',
  `department` varchar(64) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `restricted` (`restricted`),
  KEY `department` (`department`),
  KEY `created` (`created`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.mdt_evidence
DROP TABLE IF EXISTS `mdt_evidence`;
CREATE TABLE IF NOT EXISTS `mdt_evidence` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `report_id` int(11) unsigned DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `type` varchar(64) NOT NULL,
  `file_path` varchar(512) DEFAULT NULL,
  `officer` varchar(64) NOT NULL,
  `officer_name` varchar(128) NOT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `report_id` (`report_id`),
  KEY `type` (`type`),
  CONSTRAINT `mdt_evidence_report` FOREIGN KEY (`report_id`) REFERENCES `mdt_reports` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.mdt_arrests
DROP TABLE IF EXISTS `mdt_arrests`;
CREATE TABLE IF NOT EXISTS `mdt_arrests` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `suspect` varchar(64) NOT NULL,
  `officer` varchar(64) NOT NULL,
  `officer_name` varchar(128) NOT NULL,
  `charges` longtext NOT NULL,
  `fine` int(11) NOT NULL DEFAULT 0,
  `jail_time` int(11) NOT NULL DEFAULT 0,
  `arrested_at` datetime NOT NULL DEFAULT current_timestamp(),
  `released_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `suspect` (`suspect`),
  KEY `officer` (`officer`),
  KEY `arrested_at` (`arrested_at`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.mdt_library
DROP TABLE IF EXISTS `mdt_library`;
CREATE TABLE IF NOT EXISTS `mdt_library` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `label` varchar(255) NOT NULL,
  `link` varchar(512) NOT NULL,
  `job` varchar(64) NOT NULL,
  `workplace` varchar(64) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `job` (`job`),
  KEY `workplace` (`workplace`),
  KEY `label` (`label`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.mdt_bolos
DROP TABLE IF EXISTS `mdt_bolos`;
CREATE TABLE IF NOT EXISTS `mdt_bolos` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `plate` varchar(8) DEFAULT NULL,
  `model` varchar(64) DEFAULT NULL,
  `officer` varchar(64) NOT NULL,
  `officer_name` varchar(128) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `plate` (`plate`),
  KEY `officer` (`officer`),
  KEY `active` (`active`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.mdt_incidents
DROP TABLE IF EXISTS `mdt_incidents`;
CREATE TABLE IF NOT EXISTS `mdt_incidents` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `officer` varchar(64) NOT NULL,
  `officer_name` varchar(128) NOT NULL,
  `suspects` longtext DEFAULT NULL,
  `witnesses` longtext DEFAULT NULL,
  `evidence` longtext DEFAULT NULL,
  `status` enum('open','closed','pending') NOT NULL DEFAULT 'open',
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `officer` (`officer`),
  KEY `status` (`status`),
  KEY `created` (`created`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.placed_meth_tables
DROP TABLE IF EXISTS `placed_meth_tables`;
CREATE TABLE IF NOT EXISTS `placed_meth_tables` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `owner` varchar(64) NOT NULL,
  `coords` varchar(128) NOT NULL,
  `expires` bigint(20) NOT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `owner` (`owner`),
  KEY `expires` (`expires`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.placed_moonshine_stills
DROP TABLE IF EXISTS `placed_moonshine_stills`;
CREATE TABLE IF NOT EXISTS `placed_moonshine_stills` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `owner` varchar(64) NOT NULL,
  `coords` varchar(128) NOT NULL,
  `expires` bigint(20) NOT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `owner` (`owner`),
  KEY `expires` (`expires`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.placed_weed_plants
DROP TABLE IF EXISTS `placed_weed_plants`;
CREATE TABLE IF NOT EXISTS `placed_weed_plants` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `owner` varchar(64) NOT NULL,
  `coords` varchar(128) NOT NULL,
  `stage` int(11) NOT NULL DEFAULT 0,
  `water` int(11) NOT NULL DEFAULT 100,
  `fertilizer` int(11) NOT NULL DEFAULT 0,
  `planted` datetime NOT NULL DEFAULT current_timestamp(),
  `last_watered` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `owner` (`owner`),
  KEY `planted` (`planted`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.placed_cocaine_plants
DROP TABLE IF EXISTS `placed_cocaine_plants`;
CREATE TABLE IF NOT EXISTS `placed_cocaine_plants` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `owner` varchar(64) NOT NULL,
  `coords` varchar(128) NOT NULL,
  `stage` int(11) NOT NULL DEFAULT 0,
  `water` int(11) NOT NULL DEFAULT 100,
  `fertilizer` int(11) NOT NULL DEFAULT 0,
  `planted` datetime NOT NULL DEFAULT current_timestamp(),
  `last_watered` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `owner` (`owner`),
  KEY `planted` (`planted`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.item_template
DROP TABLE IF EXISTS `item_template`;
CREATE TABLE IF NOT EXISTS `item_template` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `label` varchar(128) NOT NULL,
  `description` text DEFAULT NULL,
  `weight` decimal(10,2) NOT NULL DEFAULT 0.00,
  `type` varchar(32) NOT NULL DEFAULT 'item',
  `image` varchar(256) DEFAULT NULL,
  `usable` tinyint(1) NOT NULL DEFAULT 0,
  `stackable` tinyint(1) NOT NULL DEFAULT 1,
  `close_when_used` tinyint(1) NOT NULL DEFAULT 0,
  `combinable` longtext DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.inventory_shop_logs
DROP TABLE IF EXISTS `inventory_shop_logs`;
CREATE TABLE IF NOT EXISTS `inventory_shop_logs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `inventory` varchar(64) NOT NULL,
  `item` varchar(64) NOT NULL,
  `count` int(11) NOT NULL DEFAULT 1,
  `buyer` varchar(64) NOT NULL,
  `metadata` longtext DEFAULT NULL,
  `itemId` int(11) NOT NULL DEFAULT 0,
  `price` int(11) DEFAULT NULL,
  `timestamp` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `inventory` (`inventory`),
  KEY `item` (`item`),
  KEY `buyer` (`buyer`),
  KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.inventory_transactions
DROP TABLE IF EXISTS `inventory_transactions`;
CREATE TABLE IF NOT EXISTS `inventory_transactions` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `from_inventory` varchar(64) DEFAULT NULL,
  `to_inventory` varchar(64) DEFAULT NULL,
  `item` varchar(64) NOT NULL,
  `count` int(11) NOT NULL DEFAULT 1,
  `player` varchar(64) NOT NULL,
  `type` varchar(32) NOT NULL,
  `metadata` longtext DEFAULT NULL,
  `timestamp` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `from_inventory` (`from_inventory`),
  KEY `to_inventory` (`to_inventory`),
  KEY `item` (`item`),
  KEY `player` (`player`),
  KEY `type` (`type`),
  KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

-- Dumping structure for table database_ptr.placed_props
DROP TABLE IF EXISTS `placed_props`;
CREATE TABLE IF NOT EXISTS `placed_props` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `prop` varchar(128) NOT NULL,
  `coords` varchar(128) NOT NULL,
  `heading` float NOT NULL DEFAULT 0,
  `owner` varchar(64) DEFAULT NULL,
  `is_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `owner` (`owner`),
  KEY `is_enabled` (`is_enabled`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.phone_music
DROP TABLE IF EXISTS `phone_music`;
CREATE TABLE IF NOT EXISTS `phone_music` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `owner` varchar(64) NOT NULL,
  `title` varchar(128) NOT NULL,
  `artist` varchar(128) NOT NULL,
  `url` varchar(512) NOT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `owner` (`owner`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.phone_playlists
DROP TABLE IF EXISTS `phone_playlists`;
CREATE TABLE IF NOT EXISTS `phone_playlists` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `owner` varchar(64) NOT NULL,
  `name` varchar(128) NOT NULL,
  `songs` longtext NOT NULL DEFAULT '[]',
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `owner` (`owner`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.vehicles
DROP TABLE IF EXISTS `vehicles`;
CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `owner` varchar(64) NOT NULL,
  `plate` varchar(8) NOT NULL,
  `model` varchar(64) NOT NULL,
  `coords` varchar(128) DEFAULT NULL,
  `heading` float DEFAULT 0,
  `fuel` int(11) NOT NULL DEFAULT 100,
  `engine_health` int(11) NOT NULL DEFAULT 1000,
  `body_health` int(11) NOT NULL DEFAULT 1000,
  `dirt` float NOT NULL DEFAULT 0,
  `mileage` int(11) NOT NULL DEFAULT 0,
  `locked` tinyint(1) NOT NULL DEFAULT 1,
  `stored` tinyint(1) NOT NULL DEFAULT 1,
  `garage` varchar(64) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate` (`plate`),
  KEY `owner` (`owner`),
  KEY `stored` (`stored`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.properties
DROP TABLE IF EXISTS `properties`;
CREATE TABLE IF NOT EXISTS `properties` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `owner` varchar(64) DEFAULT NULL,
  `type` varchar(32) NOT NULL,
  `coords` varchar(128) NOT NULL,
  `price` int(11) NOT NULL DEFAULT 0,
  `furniture` longtext DEFAULT NULL,
  `locked` tinyint(1) NOT NULL DEFAULT 1,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `owner` (`owner`),
  KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.storage_units
DROP TABLE IF EXISTS `storage_units`;
CREATE TABLE IF NOT EXISTS `storage_units` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `owner` varchar(64) NOT NULL,
  `type` varchar(32) NOT NULL,
  `coords` varchar(128) NOT NULL,
  `capacity` int(11) NOT NULL DEFAULT 100,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `owner` (`owner`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.loans
DROP TABLE IF EXISTS `loans`;
CREATE TABLE IF NOT EXISTS `loans` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `borrower` varchar(64) NOT NULL,
  `lender` varchar(64) NOT NULL,
  `amount` int(11) NOT NULL,
  `interest_rate` decimal(5,2) NOT NULL DEFAULT 0.00,
  `term_months` int(11) NOT NULL DEFAULT 12,
  `monthly_payment` int(11) NOT NULL,
  `remaining_balance` int(11) NOT NULL,
  `status` enum('active','paid','defaulted') NOT NULL DEFAULT 'active',
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `next_payment` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `borrower` (`borrower`),
  KEY `lender` (`lender`),
  KEY `status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.business_notices
DROP TABLE IF EXISTS `business_notices`;
CREATE TABLE IF NOT EXISTS `business_notices` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `business` varchar(64) NOT NULL,
  `title` varchar(128) NOT NULL,
  `content` text NOT NULL,
  `author` varchar(64) NOT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `expires` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `business` (`business`),
  KEY `expires` (`expires`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.spawn_locations
DROP TABLE IF EXISTS `spawn_locations`;
CREATE TABLE IF NOT EXISTS `spawn_locations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `coords` varchar(128) NOT NULL,
  `heading` float NOT NULL DEFAULT 0,
  `type` varchar(32) NOT NULL DEFAULT 'default',
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `type` (`type`),
  KEY `enabled` (`enabled`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.placed_moonshine_barrels
DROP TABLE IF EXISTS `placed_moonshine_barrels`;
CREATE TABLE IF NOT EXISTS `placed_moonshine_barrels` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `owner` varchar(64) NOT NULL,
  `coords` varchar(128) NOT NULL,
  `expires` bigint(20) NOT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `owner` (`owner`),
  KEY `expires` (`expires`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.mdt_charges
DROP TABLE IF EXISTS `mdt_charges`;
CREATE TABLE IF NOT EXISTS `mdt_charges` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `description` text DEFAULT NULL,
  `category` varchar(64) DEFAULT NULL,
  `fine` int(11) NOT NULL DEFAULT 0,
  `jail_time` int(11) NOT NULL DEFAULT 0,
  `points` int(11) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.player_shops
DROP TABLE IF EXISTS `player_shops`;
CREATE TABLE IF NOT EXISTS `player_shops` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `position` varchar(128) NOT NULL,
  `ped_model` varchar(64) DEFAULT NULL,
  `owner` varchar(64) DEFAULT NULL,
  `owner_bank` int(11) NOT NULL DEFAULT 0,
  `job` varchar(64) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `owner` (`owner`),
  KEY `job` (`job`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.shop_bank_accounts
DROP TABLE IF EXISTS `shop_bank_accounts`;
CREATE TABLE IF NOT EXISTS `shop_bank_accounts` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `shop` varchar(64) NOT NULL,
  `bank` int(11) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `shop` (`shop`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.shop_items
DROP TABLE IF EXISTS `shop_items`;
CREATE TABLE IF NOT EXISTS `shop_items` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `shop` varchar(64) NOT NULL,
  `item` varchar(64) NOT NULL,
  `price` int(11) NOT NULL DEFAULT 0,
  `stock` int(11) NOT NULL DEFAULT -1,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `shop_item` (`shop`,`item`),
  KEY `shop` (`shop`),
  KEY `item` (`item`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.state_accounts
DROP TABLE IF EXISTS `state_accounts`;
CREATE TABLE IF NOT EXISTS `state_accounts` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `account_number` int(11) NOT NULL,
  `type` varchar(32) NOT NULL,
  `balance` int(11) NOT NULL DEFAULT 0,
  `name` varchar(128) NOT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_number` (`account_number`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.state_account_transactions
DROP TABLE IF EXISTS `state_account_transactions`;
CREATE TABLE IF NOT EXISTS `state_account_transactions` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `account_number` int(11) NOT NULL,
  `type` varchar(32) NOT NULL,
  `amount` int(11) NOT NULL,
  `description` varchar(256) DEFAULT NULL,
  `timestamp` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `account_number` (`account_number`),
  KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Dumping structure for table database_ptr.sequence
DROP TABLE IF EXISTS `sequence`;
CREATE TABLE IF NOT EXISTS `sequence` (
  `id` varchar(64) NOT NULL,
  `sequence` bigint(20) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Data exporting was unselected.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
