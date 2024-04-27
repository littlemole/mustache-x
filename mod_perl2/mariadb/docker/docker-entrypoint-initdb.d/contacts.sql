
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

