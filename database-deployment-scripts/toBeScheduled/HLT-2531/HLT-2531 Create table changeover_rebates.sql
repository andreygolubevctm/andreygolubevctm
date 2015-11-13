CREATE TABLE `ctm`.`health_changeover_rebates` (
  `id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `effectiveStart` TIMESTAMP NOT NULL,
  `multiplier` DECIMAL(20,10) NOT NULL,
  PRIMARY KEY (`id`)
);

INSERT INTO `ctm`.`health_changeover_rebates`(`effectiveStart`, `multiplier`) VALUES
('2013-04-01 00:00:00', 1),
('2014-04-01 00:00:00', 0.968),
('2015-04-01 00:00:00', 0.927344),
('2016-04-01 00:00:00', 0.927344);