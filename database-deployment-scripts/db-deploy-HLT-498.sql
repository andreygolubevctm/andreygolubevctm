--
-- Add CUA as a new provider
--

-- STAGING
INSERT INTO test.help (id, header, des) VALUES (520, 'Medicare Card', 'To be eligible to take the rebate as a reduction to your premium, all policy holders must hold a valid green Medicare card.' );

-- PRODUCTION
INSERT INTO test.help (id, header, des) VALUES  (520, 'Medicare Card', 'To be eligible to take the rebate as a reduction to your premium, all policy holders must hold a valid green Medicare card.' );


-- rollback
DELETE FROM test.help WHERE id = 520;
