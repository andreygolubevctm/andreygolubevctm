CREATE TABLE `simples`.`changeover_rebates` (
  `id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `effectiveStart` TIMESTAMP NOT NULL,
  `effectiveEnd` TIMESTAMP NOT NULL,
  `multiplier` DECIMAL(20,10) NOT NULL,
  PRIMARY KEY (`id`)
);

INSERT INTO `simples`.`changeover_rebates`(`effectiveStart`, `effectiveEnd`, `multiplier`) VALUES
('2013-04-01 00:00:00', '2014-03-31 23:59:59', 1),
('2014-04-01 00:00:00', '2015-03-31 23:59:59', 0.968),
('2015-04-01 00:00:00', '2016-03-31 23:59:59', 0.927344),
('2016-04-01 00:00:00', '2017-03-31 23:59:59', 0.927344);