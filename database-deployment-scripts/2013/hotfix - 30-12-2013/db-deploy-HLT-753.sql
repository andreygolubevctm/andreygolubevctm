-- Hotfix Monday 30/12/2013

-- Monday 30th December - Usual opening hours (8.30am -8.00pm)
-- Tuesday 31st December - Reduced opening hours 8.30am - 1.00pm
-- Wednesday 1st January - Closed, New Years Day PH
-- Thursday 2nd January - Usual opening hours (8.30am-8.00pm)
UPDATE test.general
SET description = '08:30,20:00'
WHERE type = 'healthCallCentreHours'
AND code = 'Thurs';
-- Friday 3rd January - Usual opening hours (8.30am-8.00pm)
UPDATE test.general
SET description = '08:30,13:00'
WHERE type = 'healthCallCentreHours'
AND code = 'Fri';
-- Saturday 4th -  Usual hours (closed)
-- Sunday 5th - Usual hours (closed)