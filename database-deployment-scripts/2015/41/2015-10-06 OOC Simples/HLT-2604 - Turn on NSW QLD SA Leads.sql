-- TEST
-- Should be 40 Rows with availableFrom = 07:00:00 && availableTo = 07:00:01availableFrom = 09:30:00 && availableTo = 20:00:00
SELECT * FROM simples.message_source_availability where state IN ('QLD', 'NSW', 'SA', 'ACT');

UPDATE simples.message_source_availability SET availableFrom = '09:30:00', availableTo = '20:00:00' where state IN ('QLD', 'NSW', 'SA', 'ACT');

-- Should be 40 Rows with availableFrom = 09:30:00 && availableTo = 20:00:00
SELECT * FROM simples.message_source_availability where state IN ('QLD', 'NSW', 'SA', 'ACT');