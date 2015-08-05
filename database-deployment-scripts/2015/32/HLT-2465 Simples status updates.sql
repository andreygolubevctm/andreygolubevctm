-- new status
INSERT INTO `simples`.`message_status` (`id`, `status`, `active`) VALUES ('36', 'Phone number not connecting', 1);
INSERT INTO `simples`.`message_status` (`id`, `status`, `active`) VALUES ('37', 'Phone number doesn\'t belong to client', 1);
INSERT INTO `simples`.`message_status` (`id`, `status`, `active`) VALUES ('38', 'Incoming call restriction', 1);

-- Disable status
UPDATE `simples`.`message_status` SET `active`= 0 WHERE `id`='19';
UPDATE `simples`.`message_status` SET `active`= 0 WHERE `id`='10';

-- Update mapping
INSERT INTO `simples`.`message_status_mapping` (`statusId`, `parentId`) VALUES ('36', '2');
INSERT INTO `simples`.`message_status_mapping` (`statusId`, `parentId`) VALUES ('37', '2');
INSERT INTO `simples`.`message_status_mapping` (`statusId`, `parentId`) VALUES ('38', '2');