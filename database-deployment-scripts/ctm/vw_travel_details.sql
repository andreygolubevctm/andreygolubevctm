/* ****************************
VIEW: vw_travel_details
**************************** */
-- Used retrieve travel details like more info, benefits etc...

CREATE OR REPLACE VIEW `ctm`.`travel_details` AS
	select 
		`prop`.`ProductId` AS `ProductId`,
		`prop`.`PropertyId` AS `PropertyId`,
		`prop`.`SequenceNo` AS `SequenceNo`,
		`prop`.`benefitOrder` AS `benefitOrder`,
		`prop`.`Value` AS `Value`,
		IF (`prop_text`.`Text` IS NOT NULL, `prop_text`.`Text`, `prop`.`Text`) AS `Text`,
		`prop`.`Date` AS `Date` 
	from 
		(`ctm`.`product_properties` `prop` 
		join `ctm`.`product_master` `mast` on `mast`.`ProductId` = `prop`.`ProductId` 
		left join `ctm`.`product_properties_text` `prop_text` ON `prop`.`ProductId` = `prop_text`.`ProductId` AND `prop`.`PropertyId` = `prop_text`.`PropertyId`) 
	where ((`mast`.`ProductCat` = 'TRAVEL') 
		and (now() between `mast`.`EffectiveStart` and `mast`.`EffectiveEnd`) 
		and (`mast`.`Status` = ' ') 
		and (now() between `prop`.`EffectiveStart` and `prop`.`EffectiveEnd`) 
		and (`prop`.`SequenceNo` = 0) 
		and (`prop`.`Status` = ' '));