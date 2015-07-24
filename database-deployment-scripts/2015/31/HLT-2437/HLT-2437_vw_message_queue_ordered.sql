CREATE OR REPLACE VIEW `simples`.`message_queue_ordered` AS

-- Messages assigned to users, (InProgress, Postponed, Assigned, Unsuccessful), deal with your current message
SELECT 0 AS _rule, avail.* FROM simples.message_queue_available avail
WHERE userId > 0 AND statusId IN (1, 3, 4, 5, 6, 35)

-- CTM fail joins, last in first out
UNION
(
SELECT 1 AS _rule, avail.* FROM simples.message_queue_available avail
WHERE avail.sourceId = 5
AND userId = 0
ORDER BY avail.created DESC, avail.id DESC
LIMIT 1
)

-- WHITELABLE fail joins, last in first out
UNION
(
SELECT 2 AS _rule, avail.* FROM simples.message_queue_available avail
WHERE avail.sourceId IN (8)
AND userId = 0
ORDER BY avail.created DESC, avail.id DESC
LIMIT 1
)

-- Messages assigned to users, (Personal Messages)
UNION
SELECT 3 AS _rule, avail.* FROM simples.message_queue_available avail
WHERE userId > 0 AND statusId IN (31, 32)

-- Any new messages created, sorted by source priority then last in first out
UNION
(
SELECT 4 AS _rule, avail.* FROM simples.message_queue_available avail
WHERE userId = 0
ORDER BY date(created) DESC,
TotalCalls ASC,
callAttempts ASC,
postponeCount ASC,
created DESC,
id DESC
LIMIT 1
)