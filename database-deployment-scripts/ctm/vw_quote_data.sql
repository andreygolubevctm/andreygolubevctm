CREATE
DEFINER = 'events_sp_mgr'@'localhost'
VIEW aggregator.vw_quote_data
AS
SELECT DISTINCT
  `th`.`rootId` AS `rootId`,
  `tch`.`operator_id` AS `operator_id`,
  `u`.`displayName` AS `displayName`,
  `td`.`dateValue` AS `dateValue`,
  `td`.`textValue` AS `textValue`,
  `th`.`styleCodeId` AS `styleCodeId`
FROM (((`aggregator`.`transaction_details` `td`
  JOIN `aggregator`.`transaction_header` `th`
    ON ((`th`.`TransactionId` = `td`.`transactionId`)))
  JOIN `ctm`.`touches` `tch`
    ON ((`tch`.`transaction_id` = `td`.`transactionId`)))
  LEFT JOIN `simples`.`user` `u`
    ON ((`tch`.`operator_id` = `u`.`ldapuid`)))
WHERE ((`tch`.`type` = 'R')
AND (`th`.`ProductType` = 'Health')
AND (`td`.`xpath` = 'health/simples/contactType')
AND (CAST(`tch`.`date` AS date) = (CURDATE() - INTERVAL 0 DAY)));