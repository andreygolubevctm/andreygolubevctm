/* INSERT Add tracking key xpaths to content control */
INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `contentStatus`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('0', '2', 'Tracking', 'trackingKeyXpaths', '', '2014-12-01 00:00:00', '2040-12-31 23:59:59', 'travel/policyType/S,travel/policyType/A,travel/oldest,travel/dates/fromDateInput,travel/dates/toDateInput,travel/destinations/af/af,travel/destinations/am/us,travel/destinations/am/ca,travel/destinations/am/sa,travel/destinations/as/ch,travel/destinations/as/hk,travel/destinations/as/jp,travel/destinations/as/in,travel/destinations/as/th,travel/destinations/au/au,travel/destinations/pa/ba,travel/destinations/pa/in,travel/destinations/pa/nz,travel/destinations/pa/pi,travel/destinations/eu/eu,travel/destinations/eu/uk,travel/destinations/me/me,travel/destinations/do/do');

/* VERIFY INSERT */
-- SELECT * FROM `ctm`.`content_control` WHERE `styleCodeId`='0' AND `verticalid`=`2` AND `contentCode`='Tracking' AND `contentKey`='trackingKeyXpaths'   ORDER BY contentControlId DESC;

/** ROLLBACK **/
-- DELETE FROM `ctm`.`content_control` WHERE `styleCodeId`='0' AND `verticalId`='2' AND `contentCode`='Tracking' AND `contentKey`='trackingKeyXpaths' LIMIT 1;