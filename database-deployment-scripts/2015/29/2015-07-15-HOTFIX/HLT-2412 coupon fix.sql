-- 2 records should be deleted
DELETE FROM `ctm`.`coupon_rules` 
WHERE xpath IN (
	'health/contactDetails/contactNumber/mobile',
	'health/contactDetails/contactNumber/other'
);