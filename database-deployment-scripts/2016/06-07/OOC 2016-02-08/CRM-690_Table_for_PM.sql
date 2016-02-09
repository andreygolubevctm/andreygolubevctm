CREATE TABLE `simples`.`personal_messages` (
  `personalMessageId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `rootId` INT(11) UNSIGNED NOT NULL,
  `userId` INT(11) NOT NULL DEFAULT 0,
  `whenToAction` DATETIME NULL,
  `contactName` VARCHAR(255) NULL DEFAULT NULL,
  `isDeleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`personalMessageId`),
  UNIQUE INDEX `rootId_UNIQUE` (`rootId` ASC));
