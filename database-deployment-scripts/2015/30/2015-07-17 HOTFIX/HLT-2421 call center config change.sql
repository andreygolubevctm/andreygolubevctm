-- Disable single sources, but keep them same config as the others
UPDATE `simples`.`message_source` SET `active`=0, `maxAttempts`='6', `attemptDelay5`='1380' WHERE `id`='9';
UPDATE `simples`.`message_source` SET `active`=0, `maxAttempts`='6', `attemptDelay5`='1380' WHERE `id`='10';

-- Update other sources to be
-- max attempts=6
-- 24 hours after attempt 4 (so 23 hours after attempt 5)
UPDATE `simples`.`message_source` SET `maxAttempts`='6', `attemptDelay5`='1380' WHERE `id`='7';
UPDATE `simples`.`message_source` SET `maxAttempts`='6', `attemptDelay5`='1380' WHERE `id`='6';
UPDATE `simples`.`message_source` SET `maxAttempts`='6', `attemptDelay5`='1380' WHERE `id`='4';
UPDATE `simples`.`message_source` SET `maxAttempts`='6', `attemptDelay5`='1380' WHERE `id`='3';
UPDATE `simples`.`message_source` SET `maxAttempts`='6', `attemptDelay5`='1380' WHERE `id`='2';
UPDATE `simples`.`message_source` SET `maxAttempts`='6', `attemptDelay5`='1380' WHERE `id`='1';