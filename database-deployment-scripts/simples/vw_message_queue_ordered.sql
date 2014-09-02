CREATE OR REPLACE VIEW `simples`.`message_queue_ordered` AS

-- Messages assigned to users
SELECT 0 AS _rule, avail.* FROM simples.message_queue_available avail
WHERE userId > 0

-- All first time postponements (i.e. had one postponement)
UNION
SELECT 1 AS _rule, avail.* FROM simples.message_queue_available avail
WHERE postponeCount = 1

-- Any new messages created, sorted by source priority then last in first out
UNION
(
SELECT 2 AS _rule, avail.* FROM simples.message_queue_available avail
LEFT JOIN simples.message_source src ON src.id = avail.sourceId
WHERE DATE(created) = CURRENT_DATE() AND statusId = 1
ORDER BY src.priority ASC, avail.id DESC
)

-- All other types of messages (other than points 1 & 2 above) created today
-- where there has only been one call attempt made
UNION
SELECT 3 AS _rule, avail.* FROM simples.message_queue_available avail
WHERE DATE(created) = CURRENT_DATE() AND callAttempts = 1
	AND postponeCount <> 1
	AND statusId <> 1

-- All other types of messages (other than points 1, 2 & 3 above) created today
-- where there have been more than 1 call attempts
UNION
SELECT 4 AS _rule, avail.* FROM simples.message_queue_available avail
WHERE DATE(created) = CURRENT_DATE() AND callAttempts > 1
	AND postponeCount <> 1
	AND statusId <> 1

-- All new messages created yesterday or further back that have had no action taken yet
UNION
SELECT 5 AS _rule, avail.* FROM simples.message_queue_available avail
WHERE DATE(created) < CURRENT_DATE() AND statusId = 1

-- All other types of messages (i.e. other than new or postponed)
-- created yesterday and further back where we only had 1 call attempt
UNION
SELECT 6 AS _rule, avail.* FROM simples.message_queue_available avail
WHERE DATE(created) < CURRENT_DATE() AND callAttempts = 1
	AND statusId NOT IN (1, 4)

-- All other types other than point 6 above where we have had more than 1 call attempt
UNION
SELECT 7 AS _rule, avail.* FROM simples.message_queue_available avail
WHERE callAttempts > 1
	AND statusId NOT IN (1, 4)

-- All other postponed messages where there have been more than 1 postponement previously
UNION
SELECT 8 AS _rule, avail.* FROM simples.message_queue_available avail
WHERE postponeCount > 1
