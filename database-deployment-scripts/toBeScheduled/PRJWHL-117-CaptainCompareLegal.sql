-- Run the following on NXQ only
-- UPDATE ctm.configuration set configValue = '/ctm/legal/cc/website_terms_of_use.pdf' WHERE configCode = 'websiteTermsUrl' AND styleCodeId = 3;
-- UPDATE ctm.configuration set configValue = '/ctm/legal/cc/privacy_policy.pdf' WHERE configCode = 'privacyPolicyUrl' AND styleCodeId = 3;
-- UPDATE ctm.configuration set configValue = '/ctm/legal/cc/FSG.pdf' WHERE configCode = 'fsgUrl' AND styleCodeId = 3;
-- DELETE FROM ctm.configuration WHERE configCode = 'kampyleFeedback' AND styleCodeId > 1;
-- INSERT INTO ctm.configuration (`configCode`, `environmentCode`, `styleCodeId`, `verticalId`, `configValue`) VALUES ('kampyleFeedback', '0', 0, 0, 'N');
-- DELETE FROM ctm.configuration WHERE configCode = 'sendUrl' AND styleCodeId > 0;
-- INSERT INTO ctm.configuration (`configCode`, `environmentCode`, `styleCodeId`, `verticalId`, `configValue`)	VALUES ('sendUrl', '0', 0, 0, '../../dreammail/send.jsp');
-- INSERT INTO ctm.configuration (`configCode`, `environmentCode`, `styleCodeId`, `verticalId`, `configValue`)	VALUES ('sendUrl', 'PRO', 0, 0, '/dreammail/send.jsp');


DELETE FROM ctm.content_control where verticalId = 3 and (contentKey = 'footerTextStart' or contentKey = 'footerTextEnd');

-- Add defaults
INSERT INTO `ctm`.`content_control` (`styleCodeId`,`verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) 
VALUES (0,3, 'Footer', 'footerTextStart', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'ERROR');

INSERT INTO `ctm`.`content_control` (`styleCodeId`,`verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) 
VALUES (0,3, 'Footer', 'footerTextEnd', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'ERROR');

-- Add CtM footerText
INSERT INTO `ctm`.`content_control` (`styleCodeId`,`verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) 
VALUES (1,3, 'Footer', 'footerTextStart', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'The Compare the Market website and the Compare the Market brand and trading name are owned by, licensed to and/or operated by Compare The Market Pty Ltd ("CTM") ACN 117323 378, AFSL 422926.</p>
<p>The car insurance products compared on this site are not representative of all products available in the market. This site compares the following car insurance brands:  ');

INSERT INTO `ctm`.`content_control` (`styleCodeId`,`verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) 
VALUES (1,3, 'Footer', 'footerTextEnd',  '2014-01-01 00:00:00', '2038-01-19 00:00:00', '. All car insurance brands other than Real Insurance, AI Insurance and Woolworths Car Insurance ("Auto &amp; General  Car Brands") are policies arranged by Auto &amp; General Services Pty Ltd ("AGS") ACN 003 617 909 AFSL 241 411, for and on behalf of the insurer, Auto &amp; General Insurance Company Limited (ABN 42 111 586 353, AFSL 285 571) ("Auto &amp; General"). CTM, AGS and Auto &amp; General are related bodies corporate. </p>
<p>If you purchase the Auto &amp; General Car Brands, AGS will earn commission from Auto &amp; General and we will earn a fee from AGS. If you decide to purchase car insurance from another provider using a link on this site, you will be taken to that provider\'s website to make your application. If you decide to use the telephone contact details to purchase car insurance from another provider, you will do so via that provider\'s call centre. We earn a referral fee for any policy purchased as a result of the use of the comparison service. Details of our fees can be found in our <a href="legal/FSG.pdf" target="_blank" class="showDoc" data-title="Financial Services Guide">Financial Services Guide (General Insurance Products)</a>.</p>
<p>The comparison service and any other information provided on this site is factual information or general advice. None of it is a personal recommendation, suggestion or advice about the suitability of a particular insurance product for you and your needs. Before acting on the guidance we provide and when using the comparison service, evaluate your needs, objectives and situation and which products are suitable for you. Review the relevant Product Disclosure Statement before making any decision to acquire or hold car insurance.</p>
<p>Vehicle information has been provided by Red Book (refer <a href="legal/website_terms_of_use.pdf" target="_blank" class="showDoc" data-title="Website Terms and Conditions">Website Terms and Conditions</a>).');

-- Add CC footerText
INSERT INTO `ctm`.`content_control` (`styleCodeId`,`verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) 
VALUES (3,3, 'Footer', 'footerTextStart', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'Captain Compare is a brand, trading name and website owned by Auto & General Services Pty Ltd (ABN 61 003 617 909, AFSL 241 411).</p><p>Only those providers who have chosen to participate are compared on this site. This site compares the following car insurance brands: ');

INSERT INTO `ctm`.`content_control` (`styleCodeId`,`verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) 
VALUES (3,3, 'Footer', 'footerTextEnd', '2014-01-01 00:00:00', '2038-01-19 00:00:00', '. All car insurance brands other than AI Insurance ("Auto & General Car Brands") are policies arranged by Auto & General Services Pty Ltd, for and on behalf of the insurer, Auto & General Insurance Company Limited (ABN 42 111 586 353, AFSL 285 571) ("Auto & General"), which is a related company. 
</p><p>If you purchase the Auto & General Car Brands, we will earn commission from Auto & General. If you decide to purchase car insurance from another provider using a link on this site, you will be taken to that provider\'s website to make your application. If you decide to use the telephone contact details to purchase car insurance from another provider, you will do so via that provider\'s call centre. We earn a referral fee for any policy purchased as a result of the use of the comparison service. Details of our commission and referral fees can 
be found in our <a href="legal/cc/FSG.pdf" target="_blank" class="showDoc" data-title="Financial Services Guide">Financial Services Guide</a>.</p><p>The comparison service and any other information provided on this site is factual information or general advice. None of it is a personal recommendation, suggestion or advice about the suitability of a particular insurance product for you and your needs. Before acting on the guidance we provide and when using the comparison service, evaluate your needs, objectives and situation and which products are suitable for you. Review the relevant Product Disclosure Statement before making any decision to acquire or hold car insurance. Vehicle information has been provided by Red Book (refer <a href="legal/cc/website_terms_of_use.pdf" target="_blank" class="showDoc" data-title="Website Terms and Conditions">Website Terms and Conditions</a>)');