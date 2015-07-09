/** UPDATER **/

USE aggregator;

DROP event IF EXISTS NewCarsJanuary;
DROP procedure IF EXISTS SetNewYearCarModels;

DELIMITER $$

CREATE
	DEFINER = 'server'@'%'
EVENT NewCarsJanuary
	ON SCHEDULE EVERY '1' YEAR
	STARTS '2016-01-01 01:30:40'
	COMMENT 'Fires SetNewYearCarModels'
	DO
BEGIN
call SetNewYearCarModels();
END$$

ALTER EVENT NewCarsJanuary
	ENABLE$$


CREATE DEFINER = 'server'@'%' PROCEDURE SetNewYearCarModels()
COMMENT '#DBA-30 PMM 4-10-2014 added logging; enabled event'
BEGIN

DECLARE no_more_rows boolean;
DECLARE num_rows int DEFAULT 0;
DECLARE loop_cntr int DEFAULT 0;

DECLARE _redbookCode char(8);
DECLARE _theyear int(11);
DECLARE _make char(4);
DECLARE _model char(7);
DECLARE _fuel char(3);
DECLARE _trans varchar(200);
DECLARE _des varchar(100);
DECLARE _thevalue int(11);
DECLARE _body char(4);
DECLARE _rel varchar(255);
DECLARE _currentyear int(11);

DECLARE _startDate date;
DECLARE _endDate date;

--  //--------------------------------------------------------\\ --

-- Set Cursors
DECLARE VehicleCursor CURSOR FOR
SELECT
	*
FROM `vehicles`
WHERE `year` = YEAR(DATE_SUB(CURDATE(), INTERVAL 1 year))
AND model NOT IN (SELECT
	model
	FROM `vehicles`
	WHERE `year` = YEAR(DATE_SUB(CURDATE(), INTERVAL 0 year)));


DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_rows = TRUE;

-- Set Variables
SET _rel = CONCAT(CONCAT(' (Rel ', YEAR(DATE_SUB(CURDATE(), INTERVAL 1 year))), ')');
SET _currentyear = YEAR(DATE_SUB(CURDATE(), INTERVAL 0 year));
SET _startDate = MAKEDATE(_currentyear, 1);
SET _endDate = MAKEDATE(_currentyear, 90);	-- March 31 = 90 Day of Year


--  //----------Only run between Jan 1st and Mar 31st-----------\\ --

TRUNCATE vehicles_nextyear;

IF (CURRENT_DATE() >= _startDate
	&& CURRENT_DATE() <= _endDate) THEN


	OPEN VehicleCursor;

	SELECT
	FOUND_ROWS() INTO num_rows;



	BEGIN
	-- Start Loop
	VehicleLoop:
	LOOP

		-- Loop through each item and check if there is an
		-- equivilant for the current year, and if so, ignore
		-- and move to the next oneSetFakeCarModels

		FETCH VehicleCursor INTO _redbookCode, _theyear, _make, _model, _fuel, _trans, _des, _thevalue, _body;

		-- insert the record into the temp table
		INSERT INTO vehicles_nextyear
		VALUES (_redbookCode, _theyear + 1, _make, _model, _fuel, _trans, CONCAT(_des, _rel), _thevalue, _body);

		-- count the number of times looped
		SET loop_cntr = loop_cntr + 1;

		IF no_more_rows THEN
		CLOSE VehicleCursor;
		LEAVE VehicleLoop;
		END IF;
	END LOOP VehicleLoop;

	-- 'print' the output so we can see they are the same
	SELECT
		num_rows AS 'Total Records',
		loop_cntr AS 'Actual Added';
	CALL logging.doLog(CONCAT('Total Records: ', num_rows, ' Actual Added: ', loop_cntr), 'MK-20002');

	END;

-- //------------- Truncate the Table contents as it's not between the allowed dates ---- \\ --
ELSE

	TRUNCATE vehicles_nextyear;
	CALL logging.doLog('Skipped Processing as out of periods, January to March', 'MK-20002');

END IF;

END$$

DELIMITER ;

CALL SetNewYearCarModels();

/** CHECKER
SELECT * FROM vehicles_nextyear;
**/

/** ROLLBACK
TRUNCATE vehicles_nextyear;
DROP event IF EXISTS NewCarsJanuary;
**/