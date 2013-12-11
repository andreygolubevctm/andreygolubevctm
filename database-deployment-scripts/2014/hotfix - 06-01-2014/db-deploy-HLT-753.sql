-- Hotfix 06/01/2014 change back to Usual opening hours

-- Monday
-- Tuesday
UPDATE test.general
SET description = '08:30,20:00'
WHERE type = 'healthCallCentreHours'
AND code = 'Tues';
-- Wednesday
UPDATE test.general
SET description = '08:30,20:00'
WHERE type = 'healthCallCentreHours'
AND code = 'Wed';
-- Thursday
-- Friday
-- Saturday Usual hours (closed)
-- Sunday Usual hours (closed)