CREATE
DEFINER = 'events_sp_mgr'@'localhost'
VIEW aggregator.vw_callcentre_sales
AS
SELECT
  `t`.`transaction_id` AS `TransactionID`,
  `t`.`date` AS `TransactionDate`,
  UCASE(`t`.`operator_id`) AS `OperatorID`,
  `u`.`displayName` AS `displayName`,
  IFNULL(UCASE(`d21`.`textValue`), 'ONLINE') AS `QType`,
  `h1`.`styleCodeId` AS `WhiteLabelCode`
FROM ((((`ctm`.`touches` `t`
  LEFT JOIN `simples`.`user` `u`
    ON ((`t`.`operator_id` = `u`.`ldapuid`)))
  JOIN `aggregator`.`transaction_header` `h1`
    ON ((`t`.`transaction_id` = `h1`.`TransactionId`)))
  LEFT JOIN `aggregator`.`transaction_details` `d4`
    ON (((`t`.`transaction_id` = `d4`.`transactionId`)
    AND (`d4`.`xpath` = 'health/application/email')
    AND (`d4`.`textValue` <> ' '))))
  LEFT JOIN `aggregator`.`transaction_details` `d21`
    ON (((`t`.`transaction_id` = `d21`.`transactionId`)
    AND (`d21`.`xpath` = 'health/simples/contactType'))))
WHERE ((`t`.`type` = 'C')
AND (CAST(`t`.`date` AS date) = (CURDATE() - INTERVAL 0 DAY))
AND ((NOT ((`d4`.`textValue` LIKE 'preload.testing%')))
OR ISNULL(`d4`.`textValue`))
AND (UCASE(`h1`.`ProductType`) = 'HEALTH'))
GROUP BY `t`.`transaction_id`,
         `t`.`operator_id`,
         `h1`.`StartDate`,
         `t`.`date`;