-- Insert new inInEnabled config
-- It's deactivated by default because we don't want it live immediately.
INSERT INTO `ctm`.`configuration` (`configCode`, `environmentCode`, `styleCodeId`, `verticalId`, `configValue`) VALUES ('inInEnabled', '0', '0', '0', 'false');

-- Test the insert
SELECT * FROM `ctm`.`configuration` WHERE configCode = 'inInEnabled';

/*
ROLLBACK / turn off InIn and go back to use Avaya

UPDATE `ctm`.`configuration` SET `configValue`='false' WHERE `configCode`='inInEnabled';

 */
