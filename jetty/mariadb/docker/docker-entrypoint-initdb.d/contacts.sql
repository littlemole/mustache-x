
drop database if exists contacts;
create database contacts;
create user if not exists 'contacts'@'%' identified by 'contact';
grant all privileges on contacts.* to 'contacts'@'%';
flush privileges;

use contacts;


DROP TABLE IF EXISTS `contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contacts` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(200) NOT NULL,
  `first` varchar(264) NOT NULL,
  `last` varchar(264) DEFAULT NULL,
  `phone` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;


LOCK TABLES `contacts` WRITE;
/*!40000 ALTER TABLE `contacts` DISABLE KEYS */;
INSERT INTO `contacts` VALUES (3,'mike@oha7.org','mikelani','himself','1234'),(8,'mole@oha7.org','mole','maulwurf','0001'),(9,'momo','lonely','',''),(10,'momo2','nana','','');
/*!40000 ALTER TABLE `contacts` ENABLE KEYS */;
UNLOCK TABLES;
