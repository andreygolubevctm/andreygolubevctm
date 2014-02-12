UPDATE test.fatal_error_log
SET data = ''
WHERE data like '%health_payment_credit_%'
and id > 0;