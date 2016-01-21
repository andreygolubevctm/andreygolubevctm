-- Insert new IninEnabled config
INSERT INTO `ctm`.`configuration` (`configCode`, `environmentCode`, `styleCodeId`, `verticalId`, `configValue`) VALUES ('inInEnabled', '0', '0', '0', 'true');

-- Test the insert
SELECT * FROM `ctm`.`configuration` WHERE configCode = 'inInEnabled';

-- ROLLBACK to use Avaya
-- UPDATE `ctm`.`configuration` SET `configValue`='false' WHERE `configCode`='inInEnabled';
