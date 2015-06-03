USE logging;

DELIMITER $$


CREATE DEFINER = 'server'@'%'
PROCEDURE logging.saveLog ()
COMMENT 'Reads out values of the temporary log tmpLog into the main log;'
BEGIN

  DECLARE v_finished integer DEFAULT 0;

  DECLARE v_logId int(11);
  DECLARE v_error_code char(9);
  DECLARE v_logtime timestamp;
  DECLARE v_logMsg varchar(512);


  DECLARE fetchLog CURSOR FOR
  SELECT
    logId,
    error_code,
    logtime,
    logMsg
  FROM logging.tmplog
  ORDER BY logId;


  DECLARE CONTINUE HANDLER
  FOR NOT FOUND SET v_finished = 1;

  OPEN fetchLog;
logging_loop:
  LOOP
    FETCH fetchlog
    INTO v_logId, v_error_code, v_logtime, v_logMsg;

    IF v_finished THEN
      LEAVE logging_loop;
    END IF;

    INSERT INTO sp_error_log (error_code, logtime, logmsg)
      VALUES (v_error_code, v_logtime, v_logMsg);

    DELETE
      FROM logging.tmplog
    WHERE logId = v_logId; -- clean-up after itself

  END LOOP; -- logging_loop

END
$$

DELIMITER ;