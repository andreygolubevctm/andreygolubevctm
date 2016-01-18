-- Updater
SET @providerId = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='BNKW' AND Name='Bankwest');
SET @qantasMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-FF');
SET @qantasGoldMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-FFG');
SET @qantasPlatinumMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-FFP');
SET @qantasBreezeMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-BLR');
SET @qantasBreezeGoldMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-BLRG');
SET @qantasBreezePlatinumMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-BLRP');
SET @qantasZeroMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-Z');
SET @qantasZeroGoldMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-ZG');
SET @qantasZeroPlatinumMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-ZP');
UPDATE ctm.product_properties SET Text='http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=12765718&PluID=0&ord=[timestamp]' WHERE productId=@qantasMasterCard AND PropertyId='handover-url';
UPDATE ctm.product_properties SET Text='http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=12765719&PluID=0&ord=[timestamp]' WHERE productId=@qantasGoldMasterCard AND PropertyId='handover-url';
UPDATE ctm.product_properties SET Text='http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=12765722&PluID=0&ord=[timestamp]' WHERE productId=@qantasPlatinumMasterCard AND PropertyId='handover-url';
UPDATE ctm.product_properties SET Text='http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=12741585&PluID=0&ord=[timestamp]' WHERE productId=@qantasBreezeMasterCard AND PropertyId='handover-url';
UPDATE ctm.product_properties SET Text='http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=12741979&PluID=0&ord=[timestamp]' WHERE productId=@qantasBreezeGoldMasterCard AND PropertyId='handover-url';
UPDATE ctm.product_properties SET Text='http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=12742025&PluID=0&ord=[timestamp]' WHERE productId=@qantasBreezePlatinumMasterCard AND PropertyId='handover-url';
UPDATE ctm.product_properties SET Text='http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=12741595&PluID=0&ord=[timestamp]' WHERE productId=@qantasZeroMasterCard AND PropertyId='handover-url';
UPDATE ctm.product_properties SET Text='http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=12742030&PluID=0&ord=[timestamp]' WHERE productId=@qantasZeroGoldMasterCard AND PropertyId='handover-url';
UPDATE ctm.product_properties SET Text='http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=15193650&PluID=0&ord=[timestamp]' WHERE productId=@qantasZeroPlatinumMasterCard AND PropertyId='handover-url';

-- Checker - returns 9 handover urls
SET @providerId = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='BNKW' AND Name='Bankwest');
SET @qantasMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-FF');
SET @qantasGoldMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-FFG');
SET @qantasPlatinumMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-FFP');
SET @qantasBreezeMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-BLR');
SET @qantasBreezeGoldMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-BLRG');
SET @qantasBreezePlatinumMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-BLRP');
SET @qantasZeroMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-Z');
SET @qantasZeroGoldMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-ZG');
SET @qantasZeroPlatinumMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-ZP');
SELECT p.ShortTitle, pp.* FROM ctm.product_properties AS pp RIGHT JOIN ctm.product_master AS p ON p.productId=pp.productId WHERE pp.productId IN (@qantasMasterCard,@qantasGoldMasterCard,@qantasPlatinumMasterCard,@qantasBreezeMasterCard,@qantasBreezeGoldMasterCard,@qantasBreezePlatinumMasterCard,@qantasZeroMasterCard,@qantasZeroGoldMasterCard,@qantasZeroPlatinumMasterCard) AND pp.PropertyId='handover-url';

-- Rollback
/*SET @providerId = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='BNKW' AND Name='Bankwest');
SET @qantasMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-FF');
SET @qantasGoldMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-FFG');
SET @qantasPlatinumMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-FFP');
SET @qantasBreezeMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-BLR');
SET @qantasBreezeGoldMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-BLRG');
SET @qantasBreezePlatinumMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-BLRP');
SET @qantasZeroMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-Z');
SET @qantasZeroGoldMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-ZG');
SET @qantasZeroPlatinumMasterCard = (SELECT productId FROM ctm.product_master WHERE providerId=@providerId AND ProductCode='BNKW-ZP');
UPDATE ctm.product_properties SET Text='http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=12765718&PluID=0&ord=[timestamp]' WHERE productId=@qantasMasterCard AND PropertyId='handover-url';
UPDATE ctm.product_properties SET Text='http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=12765719&PluID=0&ord=[timestamp]' WHERE productId=@qantasGoldMasterCard AND PropertyId='handover-url';
UPDATE ctm.product_properties SET Text='http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=12765722&PluID=0&ord=[timestamp]' WHERE productId=@qantasPlatinumMasterCard AND PropertyId='handover-url';
UPDATE ctm.product_properties SET Text='http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=12741585&PluID=0&ord=[timestamp]' WHERE productId=@qantasBreezeMasterCard AND PropertyId='handover-url';
UPDATE ctm.product_properties SET Text='http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=12741979&PluID=0&ord=[timestamp]' WHERE productId=@qantasBreezeGoldMasterCard AND PropertyId='handover-url';
UPDATE ctm.product_properties SET Text='http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=12742025&PluID=0&ord=[timestamp]' WHERE productId=@qantasBreezePlatinumMasterCard AND PropertyId='handover-url';
UPDATE ctm.product_properties SET Text='http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=12741595&PluID=0&ord=[timestamp]' WHERE productId=@qantasZeroMasterCard AND PropertyId='handover-url';
UPDATE ctm.product_properties SET Text='http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=12742030&PluID=0&ord=[timestamp]' WHERE productId=@qantasZeroGoldMasterCard AND PropertyId='handover-url';
UPDATE ctm.product_properties SET Text='http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=12742031&PluID=0&ord=[timestamp]' WHERE productId=@qantasZeroPlatinumMasterCard AND PropertyId='handover-url';
*/