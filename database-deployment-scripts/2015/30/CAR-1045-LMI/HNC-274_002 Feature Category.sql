/*
-- Query: SELECT * FROM aggregator.features_category where vertical like 'homelmi'
LIMIT 0, 1000

-- Date: 2015-07-09 13:09
*/
INSERT INTO aggregator.`features_category` (`id`,`name`,`sequence`,`vertical`) VALUES  (695,'Type of Cover',1,'HOMELMI'),
(696,'Basis of Cover',2,'HOMELMI'),
(697,'Related Benefits',7,'HOMELMI'),
(698,'Limits of Cover at Risk Address',4,'HOMELMI'),
(699,'Personal Effects and Valuables (additional to Temporary Removal)',8,'HOMELMI'),
(700,'Workers Compensation',14,'HOMELMI'),
(701,'Legal Liability',5,'HOMELMI'),
(702,'Occupancy of Building',13,'HOMELMI'),
(703,'Definition',3,'HOMELMI'),
(704,'Part of Building Definition',9,'HOMELMI'),
(705,'Part of Contents Definition',10,'HOMELMI'),
(706,'Exclusions and Conditions',12,'HOMELMI'),
(707,'Separate Basis of Settlement Clause',11,'HOMELMI'),
(708,'Additional Information',6,'HOMELMI');

-- ROLLBACK:
-- DELETE FROM aggregator.features_category WHERE vertical = 'HOMELMI' LIMIT 14;