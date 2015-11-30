# New rules
INSERT INTO `simples`.`rule` (`description`, `value`) VALUES ('15-35days - Messages assigned to users, (InProgress, Postponed, Assigned, Unsuccessful), deal with your current message', 'SELECT id, transactionId, userId, sourceId, statusId, status, contactName, phoneNumber1, phoneNumber2, state, canPostpone, whenToAction, created FROM simples.message_queue_15to35days avail WHERE userId = ? AND statusId IN (1, 3, 4, 5, 6, 35) ORDER BY whenToAction ASC LIMIT 1');
INSERT INTO `simples`.`rule` (`description`, `value`) VALUES ('15-35days - CTM fail joins/WHITELABEL fail joins, last in first out', 'SELECT id, transactionId, userId, sourceId, statusId, status, contactName, phoneNumber1, phoneNumber2, state, canPostpone, whenToAction, created FROM simples.message_queue_15to35days avail WHERE avail.sourceId IN (5,8) AND userId = 0 ORDER BY avail.sourceId ASC, avail.created DESC, avail.id DESC LIMIT 1');
INSERT INTO `simples`.`rule` (`description`, `value`) VALUES ('15-35days - Messages assigned to users, (Personal Messages)', 'SELECT id, transactionId, userId, sourceId, statusId, status, contactName, phoneNumber1, phoneNumber2, state, canPostpone, whenToAction, created FROM simples.message_queue_15to35days avail WHERE userId = ? AND statusId IN (31, 32) ORDER BY whenToAction ASC LIMIT 1');
INSERT INTO `simples`.`rule` (`description`, `value`) VALUES ('15-35days - All other messages, Sort by dates THEN new THEN Postponed THEN Unsuccessful and Last In Last Out', 'SELECT id, transactionId, userId, sourceId, statusId, status, contactName, phoneNumber1, phoneNumber2, state, canPostpone, whenToAction, created FROM simples.message_queue_15to35days avail WHERE userId = 0 ORDER BY date(created) DESC, TotalCalls ASC, callAttempts ASC, postponeCount ASC, created DESC, id DESC LIMIT 1');
INSERT INTO `simples`.`rule` (`description`, `value`) VALUES ('36-90days - Messages assigned to users, (InProgress, Postponed, Assigned, Unsuccessful), deal with your current message', 'SELECT id, transactionId, userId, sourceId, statusId, status, contactName, phoneNumber1, phoneNumber2, state, canPostpone, whenToAction, created FROM simples.message_queue_36to90days avail WHERE userId = ? AND statusId IN (1, 3, 4, 5, 6, 35) ORDER BY whenToAction ASC LIMIT 1');
INSERT INTO `simples`.`rule` (`description`, `value`) VALUES ('36-90days - CTM fail joins/WHITELABEL fail joins, last in first out', 'SELECT id, transactionId, userId, sourceId, statusId, status, contactName, phoneNumber1, phoneNumber2, state, canPostpone, whenToAction, created FROM simples.message_queue_36to90days avail WHERE avail.sourceId IN (5,8) AND userId = 0 ORDER BY avail.sourceId ASC, avail.created DESC, avail.id DESC LIMIT 1');
INSERT INTO `simples`.`rule` (`description`, `value`) VALUES ('36-90days - Messages assigned to users, (Personal Messages)', 'SELECT id, transactionId, userId, sourceId, statusId, status, contactName, phoneNumber1, phoneNumber2, state, canPostpone, whenToAction, created FROM simples.message_queue_36to90days avail WHERE userId = ? AND statusId IN (31, 32) ORDER BY whenToAction ASC LIMIT 1');
INSERT INTO `simples`.`rule` (`description`, `value`) VALUES ('36-90days - All other messages, Sort by dates THEN new THEN Postponed THEN Unsuccessful and Last In Last Out', 'SELECT id, transactionId, userId, sourceId, statusId, status, contactName, phoneNumber1, phoneNumber2, state, canPostpone, whenToAction, created FROM simples.message_queue_36to90days avail WHERE userId = 0 ORDER BY date(created) DESC, TotalCalls ASC, callAttempts ASC, postponeCount ASC, created DESC, id DESC LIMIT 1');

#new rulesets
INSERT INTO `simples`.`rule_set` (`description`) VALUES ('15-35 Days Available');
INSERT INTO `simples`.`rule_set` (`description`) VALUES ('36-90 Days Available');

#assign new rules to new rule sets
INSERT INTO `simples`.`rule_rule_set` (`ruleId`, `ruleSetId`, `priority`, `effectiveStart`, `effectiveEnd`) VALUES ('18', '3', '1', '2015-04-01', '2039-12-31');
INSERT INTO `simples`.`rule_rule_set` (`ruleId`, `ruleSetId`, `priority`, `effectiveStart`, `effectiveEnd`) VALUES ('19', '3', '2', '2015-04-01', '2039-12-31');
INSERT INTO `simples`.`rule_rule_set` (`ruleId`, `ruleSetId`, `priority`, `effectiveStart`, `effectiveEnd`) VALUES ('20', '3', '3', '2015-04-01', '2039-12-31');
INSERT INTO `simples`.`rule_rule_set` (`ruleId`, `ruleSetId`, `priority`, `effectiveStart`, `effectiveEnd`) VALUES ('21', '3', '4', '2015-04-01', '2039-12-31');
INSERT INTO `simples`.`rule_rule_set` (`ruleId`, `ruleSetId`, `priority`, `effectiveStart`, `effectiveEnd`) VALUES ('22', '4', '1', '2015-04-01', '2039-12-31');
INSERT INTO `simples`.`rule_rule_set` (`ruleId`, `ruleSetId`, `priority`, `effectiveStart`, `effectiveEnd`) VALUES ('23', '4', '2', '2015-04-01', '2039-12-31');
INSERT INTO `simples`.`rule_rule_set` (`ruleId`, `ruleSetId`, `priority`, `effectiveStart`, `effectiveEnd`) VALUES ('24', '4', '3', '2015-04-01', '2039-12-31');
INSERT INTO `simples`.`rule_rule_set` (`ruleId`, `ruleSetId`, `priority`, `effectiveStart`, `effectiveEnd`) VALUES ('25', '4', '4', '2015-04-01', '2039-12-31');

#new roles
INSERT INTO `simples`.`role` (`title`, `admin`, `messageQueue`, `developer`) VALUES ('Consultant Outbound (15-35 days)', 0, 1, 0);
INSERT INTO `simples`.`role` (`title`, `admin`, `messageQueue`, `developer`) VALUES ('Consultant Outbound (36-90 days)', 0, 1, 0);

#assign new rulesets to new roles
INSERT INTO `simples`.`role_rule_set` (`roleId`, `ruleSetId`, `priority`) VALUES ('6', '3', '1');
INSERT INTO `simples`.`role_rule_set` (`roleId`, `ruleSetId`, `priority`) VALUES ('7', '4', '1');

#assign queue 36-90days to some users
INSERT INTO simples.user_role
(`userId`, `roleId`, `effectiveStart`, `effectiveEnd`)
VALUES
(267,7,"2014-09-01","2039-12-31"),
(275,7,"2014-09-01","2039-12-31"),
(280,7,"2014-09-01","2039-12-31"),
(291,7,"2014-09-01","2039-12-31"),
(262,7,"2014-09-01","2039-12-31"),
(290,7,"2014-09-01","2039-12-31"),
(47,7,"2014-09-01","2039-12-31"),
(264,7,"2014-09-01","2039-12-31"),
(292,7,"2014-09-01","2039-12-31"),
(269,7,"2014-09-01","2039-12-31"),
(279,7,"2014-09-01","2039-12-31"),
(259,7,"2014-09-01","2039-12-31"),
(260,7,"2014-09-01","2039-12-31"),
(265,7,"2014-09-01","2039-12-31"),
(288,7,"2014-09-01","2039-12-31"),
(294,7,"2014-09-01","2039-12-31"),
(293,7,"2014-09-01","2039-12-31"),
(268,7,"2014-09-01","2039-12-31"),
(277,7,"2014-09-01","2039-12-31"),
(266,7,"2014-09-01","2039-12-31"),
(282,7,"2014-09-01","2039-12-31"),
(257,7,"2014-09-01","2039-12-31"),
(261,7,"2014-09-01","2039-12-31"),
(278,7,"2014-09-01","2039-12-31"),
(287,7,"2014-09-01","2039-12-31"),
(289,7,"2014-09-01","2039-12-31"),
(255,7,"2014-09-01","2039-12-31"),
(296,7,"2014-09-01","2039-12-31"),
(273,7,"2014-09-01","2039-12-31"),
(276,7,"2014-09-01","2039-12-31");