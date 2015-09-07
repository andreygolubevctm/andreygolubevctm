-- UPDATER
UPDATE ctm.scrapes SET html='<ul><li>Trade goods in transit cover up to a maximum of $3,000 per claim</li><li>Trade tools cover up to a maximum of $3,000 per claim</li><li>Trailer cover up to a maximum of $4,000 per claim</li><li>Hire Car cover (up to 14 days or up to $840)</li><li>Windscreen replacement (up to $1000)</li><li>Australia wide Roadside Assistance</li></ul>' WHERE `group`='car' AND path='tech-content/car/ai-01-04/' AND cssSelector='#extras';
UPDATE ctm.scrapes SET html='<ul><li>Trade goods in transit cover up to a maximum of $3,000 per claim</li><li>Trade tools cover up to a maximum of $3,000 per claim</li><li>Trailer cover up to a maximum of $4,000 per claim</li><li>Hire Car cover (up to 14 days or up to $840)</li><li>Windscreen replacement (up to $1000)</li><li>Australia wide Roadside Assistance</li></ul>' WHERE `group`='car' AND path='tech-content/car/ai-01-05/' AND cssSelector='#extras';

-- CHECKER
SELECT * FROM ctm.scrapes WHERE `group` LIKE 'car' AND cssSelector='#extras' AND (path LIKE '%/ai-01-04%' or path LIKE '%/ai-01-05%');

-- ROLLBACK
-- UPDATE ctm.scrapes SET html='<ul><li>Hire Car cover (up to 14 days or up to $840)</li><li>Windscreen replacement (up to $1000)</li><li>Australia wide Roadside Assistance</li></ul>' WHERE `group`='car' AND path='tech-content/car/ai-01-04/' AND cssSelector='#extras';
-- UPDATE ctm.scrapes SET html='<ul><li>Hire Car cover (up to 14 days or up to $840)</li><li>Windscreen replacement (up to $1000)</li><li>Australia wide Roadside Assistance</li></ul>' WHERE `group`='car' AND path='tech-content/car/ai-01-05/' AND cssSelector='#extras';