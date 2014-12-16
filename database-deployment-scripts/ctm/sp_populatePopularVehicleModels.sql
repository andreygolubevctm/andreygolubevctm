-- ---------------------------------------------------------------------------------
-- Description: this function attempts to populate aggregator.vehicle_popular_models
-- with the counts of vehicle models.
--
-- Jira Ticket: CAR-679
-- Usage: CALL `aggregator`.`populatePopularVehicleModels`();
-- ---------------------------------------------------------------------------------

USE aggregator;

DROP procedure IF EXISTS populatePopularVehicleModels;

DELIMITER $$

CREATE PROCEDURE populatePopularVehicleModels()

BEGIN

	-- Limit popular models per make to this variable
	DECLARE model_limit INT DEFAULT 10;

	-- Used to confirm records found before flushing live popular models table
	DECLARE records_found INT;
	
	-- Vars needed for the CURSOR to limit the popular models to 'model_limit' per make
	DECLARE _make CHAR(4);
	DECLARE _model CHAR(7);
	DECLARE _count INT;
	DECLARE search_finished INTEGER DEFAULT 0;
	DECLARE active_make CHAR(4);
	DECLARE inserted_count INT DEFAULT 0;
	DECLARE make_inserted_count INT DEFAULT 0;
	DECLARE popular_models_cursor CURSOR FOR	
			SELECT v.make, v.model, COUNT(v.model) AS count, last_update 
				FROM temp_redbook_codes r
				LEFT JOIN vehicles AS v ON v.redbookCode = r.redbookCode
				WHERE v.model IS NOT NULL AND v.make IS NOT NULL
				GROUP BY v.model 
				ORDER BY v.make ASC, count DESC, v.model ASC;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET search_finished = 1;

	-- Need to increase the memory to account for data needed in temporary tables
	-- especially re temp_redbook_codes
	SET tmp_table_size = 1024 * 1024 * 64;
	SET max_heap_table_size = 1024 * 1024 * 64;

	-- Date limit for searching transaction header to get application transactions
	SET @dateLimit = DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR);

	-- [1] Create temporary table to store a subset of transactions details data - only
	-- 	   need the redbook codes to search through. We'll use this table to join on later
	DROP TEMPORARY TABLE IF EXISTS temp_redbook_codes;
	CREATE TEMPORARY TABLE temp_redbook_codes 
	ENGINE=MEMORY 
	SELECT d.textValue AS redbookCode 
		FROM transaction_details AS d 
		JOIN transaction_header AS h 
			ON (h.transactionId = d.transactionId AND h.ProductType = 'CAR' AND h.StartDate > @dateLimit) 
		WHERE d.xpath = 'quote/vehicle/redbookCode' AND d.textValue != '' 
		ORDER BY d.transactionId DESC 
		LIMIT 250000;
	
	-- [2] Create a temporary table to store popular model counts. We'll populate this table with data
	-- 	   and when finished we'll push them all at once to vehicle_popular_models
	DROP TEMPORARY TABLE IF EXISTS temp_vehicle_popular_models;
	CREATE TEMPORARY TABLE temp_vehicle_popular_models (
		make CHAR(4) NOT NULL,
		model CHAR(7) NOT NULL,
		count INT NOT NULL,
		last_update DATETIME NOT NULL
		PRIMARY KEY (`make`, `model`)
	)
	ENGINE=MEMORY;
	
	-- [3] Source the current popular models data and push into temporary table
    -- 	   Use CURSOR to loop through results and only insert 'model_limit' per make
	OPEN popular_models_cursor; 
	get_popular_models : LOOP
		FETCH popular_models_cursor INTO _make, _model, _count;
		-- Jump out now if at end of results
		IF search_finished = 1 THEN 
			LEAVE get_popular_models;
		END IF;
		-- Set default active make
		IF(inserted_count = 0) THEN
			SET active_make = _make;
		END IF;
		-- Only insert if new make or still inside limit per make
		IF(active_make != _make OR make_inserted_count < model_limit) THEN			
			INSERT INTO temp_vehicle_popular_models (make, model, count, last_update) VALUES (_make, _model, _count, CURRENT_DATE);
			SET inserted_count = inserted_count + 1;
			IF(active_make != _make) THEN
				SET active_make = _make;
				SET make_inserted_count = 0;
			END IF;
			SET make_inserted_count = make_inserted_count + 1;
		END IF;
	END LOOP get_popular_models;
	CLOSE popular_models_cursor;
		
	-- [4] Check we have results in temporary table - otherwise leave the live table as is
	SELECT COUNT(model) INTO records_found 
		FROM temp_vehicle_popular_models;		
	IF(records_found > 0) THEN
	
	-- [5] Ensure the offical popular models table exists and clear if of all existing data
		CREATE TABLE IF NOT EXISTS vehicle_popular_models (
			make CHAR(4) NOT NULL,
			model CHAR(7) NOT NULL,
			count INT NOT NULL,
			last_update DATETIME NOT NULL
			PRIMARY KEY (`make`, `model`)
		);
		TRUNCATE vehicle_popular_models;
	
	-- [6] Publish the temporary popular models data to live popular models table
		INSERT INTO vehicle_popular_models (make, model, count, last_update)
		SELECT make, model, count, last_update FROM temp_vehicle_popular_models;
		
	END IF;
		
	-- [7] Drop all temporary tables and free up da memory
	DROP TEMPORARY TABLE temp_redbook_codes;
	DROP TEMPORARY TABLE temp_vehicle_popular_models;

END$$

DELIMITER ;