
SET @NEW_CONTENT_VAL = 'I agree to receive news &amp; offer emails from comparethemarket.com.au &amp; the insurance provider that presents the lowest price.';
SET @OLD_CONTENT_VAL = 'I agree to receive news &amp; offer emails from Compare the Market &amp; the insurance provider that presents the lowest price.';

-- Tester  BEFORE update Expect 0
SET @NEW_CONTENT_VAL = 'I agree to receive news &amp; offer emails from comparethemarket.com.au &amp; the insurance provider that presents the lowest price.';
select count(contentControlId) from ctm.content_control where contentKey = 'okToEmail' and styleCodeId = 1 and verticalId = 7 and contentCode = 'Optin' and
 contentValue like @NEW_CONTENT_VAL;

-- Tester B expect 1
SET @OLD_CONTENT_VAL = 'I agree to receive news &amp; offer emails from Compare the Market &amp; the insurance provider that presents the lowest price.';
select count(contentControlId) from ctm.content_control where contentKey = 'okToEmail' and styleCodeId = 1 and verticalId = 7 and contentCode = 'Optin' and
 contentValue like @OLD_CONTENT_VAL;

-- Updater
SET @OLD_CONTENT_VAL = 'I agree to receive news &amp; offer emails from Compare the Market &amp; the insurance provider that presents the lowest price.';
SET @NEW_CONTENT_VAL = 'I agree to receive news &amp; offer emails from comparethemarket.com.au &amp; the insurance provider that presents the lowest price.'; 
UPDATE ctm.content_control 
 set contentValue = @NEW_CONTENT_VAL 
 where contentKey = 'okToEmail' 
 and styleCodeId = 1 and verticalId = 7 and contentCode = 'Optin'
 and contentValue like @OLD_CONTENT_VAL LIMIT 1;

-- Tester AFTER update expect 1
SET @NEW_CONTENT_VAL = 'I agree to receive news &amp; offer emails from comparethemarket.com.au &amp; the insurance provider that presents the lowest price.';
select count(contentControlId) from ctm.content_control where contentKey = 'okToEmail' and styleCodeId = 1 and verticalId = 7 and contentCode = 'Optin' and
 contentValue like @NEW_CONTENT_VAL;

/*
SET @OLD_CONTENT_VAL = 'I agree to receive news &amp; offer emails from Compare the Market &amp; the insurance provider that presents the lowest price.';
SET @NEW_CONTENT_VAL = 'I agree to receive news &amp; offer emails from comparethemarket.com.au &amp; the insurance provider that presents the lowest price.'; 
-- rollback
 UPDATE ctm.content_control 
 set contentValue = @OLD_CONTENT_VAL 
 where contentKey = 'okToEmail' 
 and styleCodeId = 1 and verticalId = 7 and contentCode = 'Optin'
 and contentValue like @NEW_CONTENT_VAL;
*/
