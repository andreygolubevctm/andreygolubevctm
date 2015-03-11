USE `simples`;
DROP procedure IF EXISTS `message_check_config`;

DELIMITER $$
USE `simples`$$
CREATE DEFINER=`server`@`%` PROCEDURE `message_check_config`(
	IN _date DATETIME,
	IN _state VARCHAR(3)
)
BEGIN
-- -----------------------------
-- NOTE: Please ensure that any changes to this procedure are recorded via SVN.
-- -----------------------------

SELECT COUNT(id) AS isInAntiHawkingTimeframe
FROM simples.message_config
WHERE Status = 1
AND DAYOFWEEK(_date) IN (dayOfWeek)
AND (
	-- No need to convert QLD time because that's our local time!
	   (_state = 'QLD' AND TIME(_date) BETWEEN startTime AND endTime)
	-- These can be hardcoded timezones because they don't have daylight saving:
	OR (_state = 'WA' AND TIME(CONVERT_TZ(_date, '+10:00', '+08:00')) BETWEEN startTime AND endTime)
	OR (_state = 'NT' AND TIME(CONVERT_TZ(_date, '+10:00', '+09:30')) BETWEEN startTime AND endTime)
	-- These require daylight savings support:
	OR (_state = 'SA' AND TIME(CONVERT_TZ(_date, '+10:00', 'Australia/Adelaide')) BETWEEN startTime AND endTime)
	OR (_state = 'NSW' AND TIME(CONVERT_TZ(_date, '+10:00', 'Australia/Sydney')) BETWEEN startTime AND endTime)
	OR (_state = 'TAS' AND TIME(CONVERT_TZ(_date, '+10:00', 'Australia/Hobart')) BETWEEN startTime AND endTime)
	OR (_state = 'VIC' AND TIME(CONVERT_TZ(_date, '+10:00', 'Australia/Melbourne')) BETWEEN startTime AND endTime)
	OR (_state = 'ACT' AND TIME(CONVERT_TZ(_date, '+10:00', 'Australia/Canberra')) BETWEEN startTime AND endTime)
);

END$$

DELIMITER ;