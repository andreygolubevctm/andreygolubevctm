CREATE TABLE `simples`.`message_exclusions` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `event` VARCHAR(45) NOT NULL,
  `date` DATE NOT NULL,
  `state` VARCHAR(3) NOT NULL,
  PRIMARY KEY (`id`));

INSERT INTO `simples`.`message_exclusions` (`event`, `date`, `state`) VALUES ('Labour Day', '2015-10-05', 'QLD');


