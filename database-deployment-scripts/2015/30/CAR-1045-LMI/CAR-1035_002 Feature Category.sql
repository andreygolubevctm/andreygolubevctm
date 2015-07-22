/*
-- Query: SELECT * FROM aggregator.features_category where vertical like 'CARLMI'
LIMIT 0, 1000

-- Date: 2015-07-08 16:50
*/
INSERT INTO aggregator.`features_category` (`id`,`name`,`sequence`,`vertical`) VALUES (686,'Type of Policy',1,'CARLMI'),
(687,'Part of Vehicle Definition',3,'CARLMI'),
(688,'Features and Benefits - Comprehensive Policies',2,'CARLMI'),
(689,'Features and Benefits - Third Party Property Damage',8,'CARLMI'),
(690,'Features and Benefits - Third Party Fire and Theft',7,'CARLMI'),
(691,'Legal Liability',4,'CARLMI'),
(692,'Excess',5,'CARLMI'),
(693,'Conditions and Exclusions',9,'CARLMI'),
(694,'Additional Information',6,'CARLMI');

-- ROLLBACK:
-- DELETE FROM aggregator.features_category WHERE vertical = 'CARLMI' LIMIT 9;