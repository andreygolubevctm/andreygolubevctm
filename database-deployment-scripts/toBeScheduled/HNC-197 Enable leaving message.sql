-- Should return 0 results.
-- SELECT * FROM ctm.configuration WHERE configCode IN('leavePageWarningEnabled','leavePageWarningMessage') AND environmentCode = '0' AND styleCodeId = '0' AND verticalId = 7;

INSERT INTO ctm.configuration VALUES('leavePageWarningEnabled', '0', '0', 7, 'true'), 
			('leavePageWarningMessage', '0', '0', 7, "You're leaving?! Before you go, why don't you save your quote so you can easily review your home and contents insurance options at a later date");

-- Should return 2 results.
-- SELECT * FROM ctm.configuration WHERE configCode IN('leavePageWarningEnabled','leavePageWarningMessage') AND environmentCode = '0' AND styleCodeId = '0' AND verticalId = 7;