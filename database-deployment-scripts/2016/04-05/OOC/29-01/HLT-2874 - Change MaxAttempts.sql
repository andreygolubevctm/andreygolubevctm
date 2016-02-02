-- Test Should be all set to 4 except for the failed joins
SELECT * FROM simples.message_source;

-- Update to 3
UPDATE simples.message_source SET maxAttempts = 5 WHERE id in (1,2,3,4,6,7,9,10);

-- Test - should all be 5
SELECT * FROM simples.message_source;

-- ROLLBACK Set back to 6
-- UPDATE simples.message_source SET maxAttempts = 4 WHERE id in (1,2,3,4,6,7,9,10);