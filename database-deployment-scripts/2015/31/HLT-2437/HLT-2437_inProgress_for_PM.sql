-- New status for personal message
INSERT INTO `simples`.`message_status` (`id`, `status`, `active`) VALUES ('35', 'In Progress for PM', 1);

-- Add new status to rule1
UPDATE `simples`.`rule` SET `value`='SELECT id, transactionId, userId, sourceId, statusId, status, contactName, phoneNumber1, phoneNumber2, state, canPostpone, whenToAction, created FROM simples.message_queue_available avail WHERE userId = ? AND statusId IN (1, 3, 4, 5, 6, 35) ORDER BY whenToAction ASC LIMIT 1' WHERE `id`='1';
UPDATE `simples`.`rule` SET `value`='SELECT id, transactionId, userId, sourceId, statusId, status, contactName, phoneNumber1, phoneNumber2, state, canPostpone, whenToAction, created FROM simples.message_queue_expired expired WHERE userId = ? AND statusId IN (1, 3, 4, 5, 6, 35) ORDER BY whenToAction ASC LIMIT 1' WHERE `id`='5';

-- Removing all Hawking audits because new statusIds have been used by new purposes
DELETE FROM simples.message_audit
WHERE reasonStatusId IN (34,35)
AND created <= '2015-07-09';

/* Test, should return 0 row
SELECT * FROM simples.message_audit
WHERE reasonStatusId IN (34,35)
AND created <= '2015-07-09'
ORDER BY id desc
LIMIT 99999