ALTER TABLE `simples`.`message_status` 
ADD COLUMN `active` BIT(1) NOT NULL DEFAULT b'0' AFTER `status`;

UPDATE simples.message_status
SET active = 1
WHERE id <> 13;