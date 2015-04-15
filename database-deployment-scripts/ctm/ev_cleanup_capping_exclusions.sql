/*
IMPORTANT: These commands need to be run by a database server admin.
*/

use ctm;

-- Create the event
-- NOTE: definer may need to be changed
-- NOTE: schedule interval may need to be changed
DELIMITER $$
CREATE
  DEFINER=`server`@`%`
EVENT `ev_cleanup_capping_exclusions`
  ON SCHEDULE EVERY '1' MONTH
STARTS '2015-04-01 04:00:00'
COMMENT 'This is the monthly job to clear all capping exclusions that are out of date.'
DO
BEGIN
DELETE FROM ctm.product_capping_exclusions
WHERE curDate() > effectiveEnd
      AND productId NOT IN (
  SELECT productId FROM ctm.joins
  WHERE joinDate > DATE_SUB(NOW(), INTERVAL 1 MONTH)
);
DELETE FROM ctm.product_capping_exclusions
WHERE productId IN (
  SELECT productId FROM ctm.product_master pm
  WHERE (curDate() > pm.effectiveEnd
         OR pm.status = 'X')
        AND productId NOT IN (
    SELECT productId FROM ctm.joins
    WHERE joinDate > DATE_SUB(NOW(), INTERVAL 1 MONTH)
  )
);
END
$$

-- Enable the event
ALTER EVENT ev_cleanup_capping_exclusions ENABLE
$$
-- Enable the server to run events
SET GLOBAL event_scheduler = ON
$$

/*
To turn off:
SET GLOBAL event_scheduler = OFF;
*/