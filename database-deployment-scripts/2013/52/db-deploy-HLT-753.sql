-- Hotfix Monday 23/12/2013

-- Monday 23rd December - Usual opening hours (8.30am - 8.00pm)
-- Tuesday 24th December - Reduced opening hours 8.30am - 1.00pm
UPDATE test.general
SET description = '08:30,13:00'
WHERE type = 'healthCallCentreHours'
AND code = 'Tues';
-- Wednesday 25th December - Closed, Christmas Day PH
UPDATE test.general
SET description = ''
WHERE type = 'healthCallCentreHours'
AND code = 'Wed';
-- Thursday 26th December - Closed, Boxing Day PH
UPDATE test.general
SET description = ''
WHERE type = 'healthCallCentreHours'
AND code = 'Thurs';
-- Friday 27th December - Reduced opening hours 8.30am - 1.00pm
UPDATE test.general
SET description = '08:30,13:00'
WHERE type = 'healthCallCentreHours'
AND code = 'Fri';
-- Saturday 28th December -  Usual hours (closed)
-- Sunday 29th December - Usual hours (closed)