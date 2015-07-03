
SET @NEW_CONTENT_VAL = 'I agree to receive news &amp; offer emails from comparethemarket.com.au &amp; the insurance provider that presents the lowest price.';
SET @OLD_CONTENT_VAL = 'I agree to receive news &amp; offer emails from Compare the Market &amp; the insurance provider that presents the lowest price.';

-- Tester Expect 0
select count(contentControlId) from ctm.content_control where contentKey = 'okToEmail' and styleCodeId = 1 and verticalId = 7 and contentCode = 'Optin' and
 contentValue like @NEW_CONTENT_VAL;

-- Tester B note value as this is should be the same the last test
select count(contentControlId) from ctm.content_control where contentKey = 'okToEmail' and styleCodeId = 1 and verticalId = 7 and contentCode = 'Optin' and
 contentValue like @OLD_CONTENT_VAL;

-- Updater
UPDATE ctm.content_control 
 set contentValue = @NEW_CONTENT_VAL 
 where contentKey = 'okToEmail' 
 and styleCodeId = 1 and verticalId = 7 and contentCode = 'Optin'
 and contentValue like @OLD_CONTENT_VAL;

-- Tester expect same as Tester b

select count(contentControlId) from ctm.content_control where contentKey = 'okToEmail' and styleCodeId = 1 and verticalId = 7 and contentCode = 'Optin' and
 contentValue like @NEW_CONTENT_VAL;


