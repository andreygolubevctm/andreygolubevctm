USE `simples`;
DROP FUNCTION IF EXISTS `isInAntiHawkingTimeframe`;

DELIMITER $$
USE `simples`$$
CREATE DEFINER=`server`@`%` FUNCTION `isInAntiHawkingTimeframe`(
	_date DATETIME,
	_state VARCHAR(3)
)
RETURNS INT
DETERMINISTIC
BEGIN
-- -----------------------------
-- NOTE: Please ensure that any changes to this procedure are recorded via SVN.
-- -----------------------------
DECLARE _isInAntiHawkingTimeframe INT;

SELECT COUNT(id)
INTO _isInAntiHawkingTimeframe
FROM simples.message_config
WHERE Status = 1
AND DAYOFWEEK(_date) = dayOfWeek
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

RETURN _isInAntiHawkingTimeframe;

END$$

DELIMITER ;