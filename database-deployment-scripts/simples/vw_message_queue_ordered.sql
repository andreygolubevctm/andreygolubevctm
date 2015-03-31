CREATE OR REPLACE VIEW `simples`.`message_queue_ordered` AS

-- Messages assigned to users, (InProgress, Postponed, Assigned, Unsuccessful), deal with your current message
SELECT 0 AS _rule, avail.* FROM simples.message_queue_available avail
WHERE userId > 0 AND statusId IN (3, 4, 5, 6)

-- CTM fail joins, last in first out
UNION
(
SELECT 1 AS _rule, avail.* FROM simples.message_queue_available avail
WHERE avail.sourceId = 5
ORDER BY avail.id DESC
LIMIT 1
)

-- WHITELABLE fail joins, last in first out
UNION
(
SELECT 2 AS _rule, avail.* FROM simples.message_queue_available avail
WHERE avail.sourceId IN (8)
ORDER BY avail.id DESC
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
LEFT JOIN simples.message_source src ON src.id = avail.sourceId
WHERE statusId = 1
ORDER BY src.priority ASC, avail.id DESC
LIMIT 1
)

-- All first time postponements and call attempt, last in first out
UNION
(
SELECT 5 AS _rule, avail.* FROM simples.message_queue_available avail
WHERE postponeCount <= 1 AND callAttempts <= 1
AND userId = 0
ORDER BY avail.id DESC
LIMIT 1
)

-- All second time postponements and call attempt, last in first out
UNION
(
SELECT 6 AS _rule, avail.* FROM simples.message_queue_available avail
WHERE postponeCount <= 2 AND callAttempts <= 2
AND userId = 0
ORDER BY avail.id DESC
LIMIT 1
)

-- All other postponed or unseccussful messages
UNION
(
SELECT 7 AS _rule, avail.* FROM simples.message_queue_available avail
WHERE postponeCount > 2 OR callAttempts > 2
AND userId = 0
ORDER BY avail.id DESC
LIMIT 1
)