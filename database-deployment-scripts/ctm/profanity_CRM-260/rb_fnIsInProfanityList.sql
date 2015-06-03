-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`voba`@`192.168.11.%` FUNCTION `rb_fnIsInProfanityList`(Value_Str VARCHAR(150)) RETURNS bit(1)
BEGIN
DECLARE word_regex varchar(100) DEFAULT "";
DECLARE v_finished INTEGER DEFAULT 0;
DECLARE isInProfanityList BIT DEFAULT 0;

DECLARE goodNameCount INTEGER DEFAULT 0;
DEClARE goodNamesList_Cursor CURSOR FOR SELECT count(*) FROM ref_tbGoodNamesList WHERE Name = Value_Str;

DECLARE profanityList_Cursor CURSOR FOR SELECT REGEX FROM ref_tbProfanityList;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;

OPEN goodNamesList_Cursor;
FETCH goodNamesList_Cursor INTO goodNameCount;

IF goodNameCount = 0 THEN
	OPEN profanityList_Cursor;
	get_regexp: LOOP
		FETCH profanityList_Cursor INTO word_regex;
		
		IF v_finished = 1 THEN 
			LEAVE get_regexp;
		END IF;
		
		IF Value_Str REGEXP word_regex THEN
			SET isInProfanityList = 1;
			LEAVE get_regexp;
		END IF;
	END LOOP get_regexp;
	CLOSE profanityList_Cursor;
END IF;

RETURN isInProfanityList;
END