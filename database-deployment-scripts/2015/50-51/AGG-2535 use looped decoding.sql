-- Run
INSERT INTO `ctm`.`configuration` (`configCode`, `environmentCode`, `styleCodeId`, `verticalId`, `configValue`) VALUES ('useLoopedTransferringURIDecoding', '0', '0', '0', 'true');

-- Rollback
-- DELETE FROM `ctm`.`configuration` WHERE `configCode`='useLoopedTransferringURIDecoding' and`styleCodeId`='0' and`verticalId`='0' and`environmentCode`='0';