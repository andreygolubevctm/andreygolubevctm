-- UPDATER 
SET @PAYD_ben = (SELECT id FROM ctm.scrapes WHERE verticalId=3 AND path = 'tech-content/car/rein-01-01/' AND cssSelector='#benefits');
UPDATE ctm.scrapes SET html='<ul> <li>Agreed value or market value – choose your own level of cover.</li>  <li>Effortless claims – make a claim in minutes online 24 hours a day or over the phone.</li> </ul>', last_updated='2015-09-07 07:46:00' WHERE id=@PAYD_ben;
SET @PAYD_ext = (SELECT id FROM ctm.scrapes WHERE verticalId=3 AND path = 'tech-content/car/rein-01-01/' AND cssSelector='#extras');
UPDATE ctm.scrapes SET html='<ul>  <li>Hire car cover</li>  <li>Excess-free windscreen cover</li>  <li>Option to take out Roadside Assistance cover.</li>  </ul>', last_updated='2015-09-07 07:46:00' WHERE id=@PAYD_ext;

-- CHECKER
SET @PAYD_ben = (SELECT id FROM ctm.scrapes WHERE verticalId=3 AND path = 'tech-content/car/rein-01-01/' AND cssSelector='#benefits');
SET @PAYD_ext = (SELECT id FROM ctm.scrapes WHERE verticalId=3 AND path = 'tech-content/car/rein-01-01/' AND cssSelector='#extras');
SELECT * FROM ctm.scrapes  WHERE id IN (@PAYD_ben,@PAYD_ext);

-- ROLLBACK
/*
SET @PAYD_ben = (SELECT id FROM ctm.scrapes WHERE verticalId=3 AND path = 'tech-content/car/rein-01-01/' AND cssSelector='#benefits');
UPDATE ctm.scrapes SET html='<ul>  <li>Option to take out Roadside Assistance cover.</li>  <li>Agreed value or market value – choose your own level of cover from a range of current values.</li>  <li>Effortless claims – make a claim in minutes online 24 hours a day or over the phone.</li> </ul>', last_updated='2013-11-14 16:28:03' WHERE id=@PAYD_ben;
SET @PAYD_ext = (SELECT id FROM ctm.scrapes WHERE verticalId=3 AND path = 'tech-content/car/rein-01-01/' AND cssSelector='#extras');
UPDATE ctm.scrapes SET html='<ul>  <li>Pet cover ($1000)</li>  <li>Bicycle cover ($1000)</li>  <li>Hire car cover</li>  <li>Excess-free windscreen cover</li> </ul>', last_updated='2013-11-06 15:20:32' WHERE id=@PAYD_ext;
*/