-- TEST - Should be 581 products

SELECT * FROM ctm.product_master
WHERE ProviderId = 6
      AND Status <> 'X'
      AND NOW() < EffectiveEnd;

-- Turn off all THF Products
UPDATE ctm.product_master
SET Status = 'X'
WHERE ProviderId = 6
      AND Status <> 'X'
      AND NOW() < EffectiveEnd;

-- Turn the brand off as well which will exclude it from the filter
INSERT INTO `ctm`.`stylecode_provider_exclusions` (`styleCodeId`, `verticalId`, `providerId`, `excludeDateFrom`, `excludeDateTo`) VALUES ('0', '4', '6', NOW(), '2040-12-31 23:59:59');

-- Update footer fund list
UPDATE `ctm`.`content_control` SET `contentValue`='ahm, Australian Unity, Budget Direct, Bupa, CBHS, CUA, Frank, GMHBA, HCF, HIF and nib'
WHERE `contentKey`='footerParticipatingSuppliers'
      AND styleCodeId = 1
      AND verticalId = 4;

-- ROLLBACK
-- UPDATE `ctm`.`content_control` SET `contentValue`='Frank, Australian Unity, HCF, GMF, GMHBA, nib, ahm, CBHS, HIF, CUA, Bupa and Budget Direct'
-- WHERE `contentKey`='footerParticipatingSuppliers'
-- AND styleCodeId = 1
-- AND verticalId = 4;

-- Update footer second paragraph
UPDATE `ctm`.`content_control`
SET `contentValue`='. Not all insurance products offered by the participating health insurance providers are compared. Not all Participating Health Products are compared through the CTM call centre (some Participating Health Products are only compared on this site). The Participating Health Products can vary from time to time and when we provide you with a comparison, we are only comparing those Participating Health Products which may suit your needs. At times, not all brands may be available.</p><p>If you decide to purchase a Participating Health Product using this site, you will be taken to web pages owned and operated by us to make your application. If you decide to use the telephone contact details to purchase health insurance, you will do so via the CTM call centre. Not all Participating Health Products are available via the CTM call centre.</p><p>If you decide to purchase a Participating Health Product using this site or the call centre, we will act as an agent for the health insurance provider and we will receive a commission from the insurer for arranging the insurance.</p><p>The comparison service and any other information provided on this site or in the call centre is factual information or general advice. None of it is a personal recommendation, suggestion or advice about the suitability of a particular insurance product for you and your needs. Before acting on the guidance we provide and when using the comparison service, evaluate your needs, objectives and situation and which products are suitable for you. Review the relevant policy documents before making any decision to acquire or hold health insurance.</p><p><a href=\"http://www.comparethemarket.com.au/health-insurance/complaints-idr-process/\" target=\"_blank\">Click here</a> for details of our internal dispute resolution procedures in respect of our health insurance services.</p>'
WHERE `contentKey`='footerTextEnd'
      AND styleCodeId = 1
      AND verticalId = 4;

-- ROLLBACK
-- UPDATE `ctm`.`content_control`
-- SET `contentValue`='. Not all insurance products offered by the participating health insurance providers are compared. Not all Participating Health Products are compared through the CTM call centre (some Participating Health Products are only compared on this site). The Participating Health Products can vary from time to time and when we provide you with a comparison, we are only comparing those Participating Health Products which may suit your needs.</p><p>If you decide to purchase a Participating Health Product using this site, you will be taken to web pages owned and operated by us to make your application. If you decide to use the telephone contact details to purchase health insurance, you will do so via the CTM call centre. Not all Participating Health Products are available via the CTM call centre.</p><p>If you decide to purchase a Participating Health Product using this site or the call centre, we will act as an agent for the health insurance provider and we will receive a commission from the insurer for arranging the insurance.</p><p>The comparison service and any other information provided on this site or in the call centre is factual information or general advice. None of it is a personal recommendation, suggestion or advice about the suitability of a particular insurance product for you and your needs. Before acting on the guidance we provide and when using the comparison service, evaluate your needs, objectives and situation and which products are suitable for you. Review the relevant policy documents before making any decision to acquire or hold health insurance.</p><p><a href=\"http://www.comparethemarket.com.au/health-insurance/complaints-idr-process/\" target=\"_blank\">Click here</a> for details of our internal dispute resolution procedures in respect of our health insurance services.</p>'
-- WHERE `contentKey`='footerParticipatingSuppliers'
-- AND styleCodeId = 1
-- AND verticalId = 4;


-- TEST Should be 0 products
SELECT * FROM ctm.product_master
WHERE ProviderId = 6
      AND Status <> 'X'
      AND NOW() < EffectiveEnd;

SELECT * FROM ctm.stylecode_provider_exclusions where verticalId = 4 and styleCodeId = 0;

SELECT * FROM ctm.content_control where verticalId = 4 AND contentKey LIKE '%footerParticipatingSuppliers%';

SELECT * FROM ctm.content_control where verticalId = 4 AND contentKey LIKE '%footerTextEnd%';