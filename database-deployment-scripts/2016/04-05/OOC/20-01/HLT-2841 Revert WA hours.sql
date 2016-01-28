-- Test -- All availableTo values should be 13:00:00 before run and 20:00:00 after
SELECT *
FROM simples.message_source_availability
WHERE STATE = "WA";

-- Run
UPDATE simples.message_source_availability
SET availableTo = "20:00:00"
WHERE STATE = "WA";

-- Rollback
/*
UPDATE simples.message_source_availability
SET availableTo = "13:00:00"
WHERE STATE = "WA";
*/