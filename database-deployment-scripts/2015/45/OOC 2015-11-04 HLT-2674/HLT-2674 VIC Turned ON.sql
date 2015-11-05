-- Updater
UPDATE simples.message_source_availability SET availableFrom='09:30:00', availableTo='20:00:00' WHERE state='VIC';

-- Checker
SELECT * FROM simples.message_source_availability WHERE state='VIC';