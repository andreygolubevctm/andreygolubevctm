-- UPDATER
UPDATE ctm.scrapes SET html='<ul><li>12 months or 20,000km new for old car replacement cover</li><li>Finance gap cover up to a maximum of 20% of the MV</li><li>Tax audit cover up to a maximum of $5,000 </li></ul>' WHERE `group`='car' AND path='tech-content/car/ai-01-04/' AND cssSelector='#inclusions';
UPDATE ctm.scrapes SET html='<ul><li>12 months or 20,000km new for old car replacement cover</li><li>Finance gap cover up to a maximum of 20% of the MV</li><li>Tax audit cover up to a maximum of $5,000 </li></ul>' WHERE `group`='car' AND path='tech-content/car/ai-01-05/' AND cssSelector='#inclusions';

-- CHECKER
SELECT * FROM ctm.scrapes WHERE `group` LIKE 'car' AND cssSelector='#inclusions' AND (path LIKE '%/ai-01-04%' or path LIKE '%/ai-01-05%');

-- ROLLBACK
-- UPDATE ctm.scrapes SET html='<ul><li>12 months or 20,000km new for old car replacement cover</li><li>Trade goods in transit cover up to a maximum of $5,000 per claim</li><li>Trade tools cover up to a maximum of $5,000 per claim</li><li>Trailer cover up to a maximum of $3,000 per claim</li><li>Finance gap cover up to a maximum of 20% of the MV</li><li>Tax audit cover up to a maximum of $5,000 </li></ul>' WHERE `group`='car' AND path='tech-content/car/ai-01-04/' AND cssSelector='#inclusions';
-- UPDATE ctm.scrapes SET html='<ul><li>12 months or 20,000km new for old car replacement cover</li><li>Trade goods in transit cover up to a maximum of $5,000 per claim</li><li>Trade tools cover up to a maximum of $5,000 per claim</li><li>Trailer cover up to a maximum of $3,000 per claim</li><li>Finance gap cover up to a maximum of 20% of the MV</li><li>Tax audit cover up to a maximum of $5,000 </li></ul>' WHERE `group`='car' AND path='tech-content/car/ai-01-05/' AND cssSelector='#inclusions';