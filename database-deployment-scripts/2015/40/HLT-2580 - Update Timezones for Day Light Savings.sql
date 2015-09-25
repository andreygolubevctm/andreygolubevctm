-- TEST - 80 Rows with availableFrom = '08:30:00'
SELECT * FROM simples.message_source_availability;

UPDATE simples.message_source_availability SET availableFrom = '09:30:00';

-- TEST - 80 Rows with availableFrom = '09:30:00'
SELECT * FROM simples.message_source_availability;