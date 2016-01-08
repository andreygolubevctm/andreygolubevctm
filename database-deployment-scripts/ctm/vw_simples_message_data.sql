USE aggregator;

CREATE
DEFINER = 'events_sp_mgr'@'localhost'
VIEW aggregator.vw_simples_message_data
AS
SELECT
  `m`.`transactionId` AS `transactionId`,
  `th`.`styleCodeId` AS `styleCodeId`,
  UCASE(`u`.`ldapuid`) AS `UPPER(u.ldapuid)`,
  `u`.`displayName` AS `displayName`,
  `ma`.`statusId` AS `statusId`,
  `ma`.`reasonStatusId` AS `reasonStatusId`,
  CAST(`ma`.`created` AS time) AS `Call_Time`,
  CAST(`ma`.`created` AS date) AS `Call_Date`,
  CAST(`m`.`created` AS time) AS `Created_Time`,
  CAST(`m`.`created` AS date) AS `Created_Date`,
  `ms`.`status` AS `Call_Result`,
  `ms1`.`status` AS `Call_Result_Reason`
FROM (((((`simples`.`message_audit` `ma`
  JOIN `simples`.`user` `u`
    ON ((`ma`.`userId` = `u`.`id`)))
  LEFT JOIN `simples`.`message` `m`
    ON ((`m`.`id` = `ma`.`messageId`)))
  JOIN `aggregator`.`transaction_header` `th`
    ON ((`th`.`TransactionId` = `m`.`transactionId`)))
  LEFT JOIN `simples`.`message_status` `ms`
    ON ((`ma`.`statusId` = `ms`.`id`)))
  LEFT JOIN `simples`.`message_status` `ms1`
    ON ((`ma`.`reasonStatusId` = `ms1`.`id`)))
WHERE (`m`.`created` BETWEEN (CURDATE() - INTERVAL 4 WEEK) AND CURDATE())
UNION
SELECT
  `m`.`transactionId` AS `transactionId`,
  `th`.`styleCodeId` AS `styleCodeId`,
  UCASE(`u`.`ldapuid`) AS `UPPER(u.ldapuid)`,
  `u`.`displayName` AS `displayName`,
  `ma`.`statusId` AS `statusId`,
  `ma`.`reasonStatusId` AS `reasonStatusId`,
  CAST(`ma`.`created` AS time) AS `Call_Time`,
  CAST(`ma`.`created` AS date) AS `Call_Date`,
  CAST(`m`.`created` AS time) AS `Created_Time`,
  CAST(`m`.`created` AS date) AS `Created_Date`,
  `ms`.`status` AS `Call_Result`,
  `ms1`.`status` AS `Call_Result_Reason`
FROM (((((`simples`.`message_audit` `ma`
  JOIN `simples`.`user` `u`
    ON ((`ma`.`userId` = `u`.`id`)))
  LEFT JOIN `simples`.`message` `m`
    ON ((`m`.`id` = `ma`.`messageId`)))
  JOIN `aggregator`.`transaction_header2_cold` `th`
    ON ((`th`.`transactionId` = `m`.`transactionId`)))
  LEFT JOIN `simples`.`message_status` `ms`
    ON ((`ma`.`statusId` = `ms`.`id`)))
  LEFT JOIN `simples`.`message_status` `ms1`
    ON ((`ma`.`reasonStatusId` = `ms1`.`id`)))
WHERE (`m`.`created` BETWEEN (CURDATE() - INTERVAL 4 WEEK) AND CURDATE())
UNION
SELECT
  `m`.`transactionId` AS `transactionId`,
  `th`.`styleCodeId` AS `styleCodeId`,
  UCASE(`u`.`ldapuid`) AS `UPPER(u.ldapuid)`,
  `u`.`displayName` AS `displayName`,
  `ma`.`statusId` AS `statusId`,
  `ma`.`reasonStatusId` AS `reasonStatusId`,
  CAST(`ma`.`created` AS time) AS `Call_Time`,
  CAST(`ma`.`created` AS date) AS `Call_Date`,
  CAST(`m`.`created` AS time) AS `Created_Time`,
  CAST(`m`.`created` AS date) AS `Created_Date`,
  `ms`.`status` AS `Call_Result`,
  `ms1`.`status` AS `Call_Result_Reason`
FROM (((((`simples`.`message_audit` `ma`
  JOIN `simples`.`user` `u`
    ON ((`ma`.`userId` = `u`.`id`)))
  LEFT JOIN `simples`.`message_archived` `m`
    ON ((`m`.`id` = `ma`.`messageId`)))
  JOIN `aggregator`.`transaction_header` `th`
    ON ((`th`.`TransactionId` = `m`.`transactionId`)))
  LEFT JOIN `simples`.`message_status` `ms`
    ON ((`ma`.`statusId` = `ms`.`id`)))
  LEFT JOIN `simples`.`message_status` `ms1`
    ON ((`ma`.`reasonStatusId` = `ms1`.`id`)))
WHERE (`m`.`created` BETWEEN (CURDATE() - INTERVAL 4 WEEK) AND CURDATE())
UNION
SELECT
  `m`.`transactionId` AS `transactionId`,
  `th`.`styleCodeId` AS `styleCodeId`,
  UCASE(`u`.`ldapuid`) AS `UPPER(u.ldapuid)`,
  `u`.`displayName` AS `displayName`,
  `ma`.`statusId` AS `statusId`,
  `ma`.`reasonStatusId` AS `reasonStatusId`,
  CAST(`ma`.`created` AS time) AS `Call_Time`,
  CAST(`ma`.`created` AS date) AS `Call_Date`,
  CAST(`m`.`created` AS time) AS `Created_Time`,
  CAST(`m`.`created` AS date) AS `Created_Date`,
  `ms`.`status` AS `Call_Result`,
  `ms1`.`status` AS `Call_Result_Reason`
FROM (((((`simples`.`message_audit` `ma`
  JOIN `simples`.`user` `u`
    ON ((`ma`.`userId` = `u`.`id`)))
  LEFT JOIN `simples`.`message_archived` `m`
    ON ((`m`.`id` = `ma`.`messageId`)))
  JOIN `aggregator`.`transaction_header2_cold` `th`
    ON ((`th`.`transactionId` = `m`.`transactionId`)))
  LEFT JOIN `simples`.`message_status` `ms`
    ON ((`ma`.`statusId` = `ms`.`id`)))
  LEFT JOIN `simples`.`message_status` `ms1`
    ON ((`ma`.`reasonStatusId` = `ms1`.`id`)))
WHERE (`m`.`created` BETWEEN (CURDATE() - INTERVAL 4 WEEK) AND CURDATE());