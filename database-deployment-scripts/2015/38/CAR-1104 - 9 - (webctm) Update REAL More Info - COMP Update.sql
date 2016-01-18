-- UPDATER 
SET @COMP_inc = (SELECT id FROM ctm.scrapes WHERE verticalId=3 AND path = 'tech-content/car/rein-01-02/' AND cssSelector='#inclusions');
UPDATE ctm.scrapes SET html='<ul>  <li>24-month new for old car replacement cover if the car is a total loss</li>  <li>Cover for towing costs</li>  <li>Damage to trailer and caravan if attached to your car (belonging to you) ($1000)</li>  <li>Damage to personal property in your car ($500)</li>  <li>Child safety seats and prams replacement ($500)</li>  <li>Emergency travel and accommodation cover ($500)</li>  <li>Third party property damage cover for a substitute car</li>  <li>Locks and keys replacement ($1000)</li>  <li>Cover for your car while in transit</li>  <li>Essential repairs after an accident ($300)</li> </ul>', last_updated='2015-09-07 07:46:00' WHERE id=@COMP_inc;

-- CHECKER
SET @COMP_inc = (SELECT id FROM ctm.scrapes WHERE verticalId=3 AND path = 'tech-content/car/rein-01-02/' AND cssSelector='#inclusions');
SELECT * FROM ctm.scrapes  WHERE id IN (@COMP_inc);

-- ROLLBACK
/*
SET @COMP_inc = (SELECT id FROM ctm.scrapes WHERE verticalId=3 AND path = 'tech-content/car/rein-01-02/' AND cssSelector='#inclusions');
UPDATE ctm.scrapes SET html='<ul>  <li>12-month new for old car replacement cover if the car is a total loss</li>  <li>Cover for towing costs</li>  <li>Damage to trailer and caravan if attached to your car (belonging to you) ($1000)</li>  <li>Accidental damage to personal property ($500)</li>  <li>Child safety seats and prams replacement ($500)</li>  <li>Emergency transport and accommodation cover ($500 in total)</li>  <li>Third party property damage cover for a substitute car</li>  <li>Locks and keys replacement ($1000)</li>  <li>Cover for your car while in transit</li>  <li>Essential repairs after an accident or theft ($300)</li> </ul>', last_updated='2013-11-06 15:20:27' WHERE id=@COMP_inc;
*/