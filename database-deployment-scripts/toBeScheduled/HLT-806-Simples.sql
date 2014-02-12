-- TEST
SELECT * FROM `ctm`.`dialogue`
WHERE `dialogueId`='28';

START TRANSACTION;
UPDATE `ctm`.`dialogue`
SET `text`='Today we will be comparing some products from our ''participating brands'' and these brands can vary from time to time. For a full list of our ''participating brands'' please see our website comparethemarket.com.au.  If you decide to purchase from us, we will arrange the sale on behalf of the fund and we''ll receive a commission from them so we don''t charge you a fee for our service.<br/><br/>We also compare 2 Restricted Health Funds. One is Commonwealth Bank of Australia (CBHS) and the other is Teachers Health Fund. To see if you are eligible may I ask if you or anyone close to you:<ul class="plainBulletPoints"><li> Work for or have worked for CBA, Colonial State Bank or Bank West?</li><li> Are a current or former member of a relevant education union<div class="help_icon simples_help_icon" id="help_523" onclick="Help.helpIconClicked"></div> or are related to anyone eligible to join Teachers Health Fund?</li><li> (Only if from NSW) Are you currently or have you ever worked for, Institute of Teachers, TAFE Commission, Teachers Mutual Bank, NSW Board of Studies, NSW Department of Education and Communities, NSW Teachers Federation?</li></ul.<br/><br/><strong>SIS Confirmation</strong><br/>''Based on the Standard Information Statement I have in front of me provided by privatehealth.gov.au'''
WHERE `dialogueId`='28'
-- Rollback