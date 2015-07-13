-- UPDATER
UPDATE aggregator.help SET des = 'Begin typing your country and select from the available country(ies) where you are travelling to. You can enter more than one destination by repeating the first step until all of your destinations are listed. You are not required to enter stop-over countries if your stop-over is less than 48 hours.' WHERE id = 213;

-- CHECKER - Returns help copy row
SELECT * FROM aggregator.help WHERE id = 213;

-- ROLLBACK
-- UPDATE aggregator.help SET des = 'Select the country(ies) where you are travelling to. You are not required to enter stop-over countries if your stop-over is less than 48 hours.' WHERE id = 213;