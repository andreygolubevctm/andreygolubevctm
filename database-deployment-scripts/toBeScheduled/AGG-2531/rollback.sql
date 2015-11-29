SET @LIFE_ID = (SELECT verticalId FROM  ctm.vertical_master where verticalCode = 'LIFE');
SET @IP_ID = (select verticalId from ctm.vertical_master where verticalCode = 'IP');
SET @UTILITIES_ID = (select verticalId from ctm.vertical_master where verticalCode = 'UTILITIES');
SET @CONTENT_KEY  = 'competitionCheckboxText';
SET @STYLECODE = (select styleCodeId from ctm.stylecodes where styleCode = 'ctm');

UPDATE ctm.content_control SET contentValue = 'I agree to the <a target=\'_blank\'  href=\'http://www.comparethemarket.com.au/competition/5000competition.pdf\'>terms and conditions</a>.'
  where contentKey = @CONTENT_KEY
  and styleCodeId = @STYLECODE and CURDATE() between effectiveStart and effectiveEnd and verticalId = @LIFE_ID limit 1;

-- test expect 1
select count(*) from ctm.content_control where contentKey = @CONTENT_KEY and styleCodeId = @STYLECODE and verticalId = @LIFE_ID
 and contentValue = 'I agree to the <a target=\'_blank\'  href=\'http://www.comparethemarket.com.au/competition/5000competition.pdf\'>terms and conditions</a>.';


UPDATE ctm.content_control SET contentValue = 'I agree to the <a target=\'_blank\'  href=\'http://www.comparethemarket.com.au/competition/5000competition.pdf\'>terms and conditions</a>.'
  where contentKey = @CONTENT_KEY
  and styleCodeId = @STYLECODE and CURDATE() between effectiveStart and effectiveEnd and verticalId = @IP_ID limit 1;

-- test expect 1
select count(*) from ctm.content_control where contentKey = @CONTENT_KEY and styleCodeId = @STYLECODE and verticalId = @IP_ID
 and contentValue = 'I agree to the <a target=\'_blank\'  href=\'http://www.comparethemarket.com.au/competition/5000competition.pdf\'>terms and conditions</a>.';


UPDATE ctm.content_control SET contentValue = 'I agree to the <a target=\'_blank\'  href=\'http://www.comparethemarket.com.au/competition/5000competition.pdf\'>terms and conditions</a>.'
  where contentKey = @CONTENT_KEY
  and styleCodeId = @STYLECODE and CURDATE() between effectiveStart and effectiveEnd and verticalId = @UTILITIES_ID limit 1;

-- test expect 1
select count(*) from ctm.content_control where contentKey = @CONTENT_KEY and styleCodeId = @STYLECODE and verticalId = @UTILITIES_ID
 and contentValue = 'I agree to the <a target=\'_blank\'  href=\'http://www.comparethemarket.com.au/competition/5000competition.pdf\'>terms and conditions</a>.';
