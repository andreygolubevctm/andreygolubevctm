SET @LIFE_ID = (SELECT verticalId FROM  ctm.vertical_master where verticalCode = 'LIFE');
SET @IP_ID = (select verticalId from ctm.vertical_master where verticalCode = 'IP');
SET @UTILITIES_ID = (select verticalId from ctm.vertical_master where verticalCode = 'UTILITIES');
SET @HEALTH_ID = (select verticalId from ctm.vertical_master where verticalCode = 'HEALTH');
SET @CONTENT_KEY  = 'competitionCheckboxText';
SET @STYLECODE = (select styleCodeId from ctm.stylecodes where styleCode = 'ctm');
SET @PARTICIPATING_SUPPLIER_LINK = 'participatingSuppliersLink';



UPDATE ctm.content_control SET contentValue = 'Yes, I agree to the <a target=\'_blank\'  href=\'http://www.comparethemarket.com.au/competition/5000competition.pdf\'>competition terms and conditions</a>.'
  where contentKey = @CONTENT_KEY
  and styleCodeId = @STYLECODE and CURDATE() between effectiveStart and effectiveEnd and verticalId = @LIFE_ID limit 1;

-- test expect 1
select count(*) from ctm.content_control where contentKey = @CONTENT_KEY and styleCodeId = @STYLECODE and verticalId = @LIFE_ID
 and contentValue = 'Yes, I agree to the <a target=\'_blank\'  href=\'http://www.comparethemarket.com.au/competition/5000competition.pdf\'>competition terms and conditions</a>.';

UPDATE ctm.content_control SET contentValue = 'Yes, I agree to the <a target=\'_blank\'  href=\'http://www.comparethemarket.com.au/competition/5000competition.pdf\'>competition terms and conditions</a>.'
  where contentKey = @CONTENT_KEY
  and styleCodeId = @STYLECODE and CURDATE() between effectiveStart and effectiveEnd and verticalId = @IP_ID limit 1;

-- test expect 1
select count(*) from ctm.content_control where contentKey = @CONTENT_KEY and styleCodeId = @STYLECODE and verticalId = @IP_ID
 and contentValue = 'Yes, I agree to the <a target=\'_blank\'  href=\'http://www.comparethemarket.com.au/competition/5000competition.pdf\'>competition terms and conditions</a>.';

UPDATE ctm.content_control SET contentValue = 'Yes, I agree to the <a target=\'_blank\'  href=\'http://www.comparethemarket.com.au/competition/5000competition.pdf\'>competition terms and conditions</a>.'
  where contentKey = @CONTENT_KEY
  and styleCodeId = @STYLECODE and CURDATE() between effectiveStart and effectiveEnd and verticalId = @UTILITIES_ID limit 1;

-- test expect 1
select count(*) from ctm.content_control where contentKey = @CONTENT_KEY and styleCodeId = @STYLECODE and verticalId = @UTILITIES_ID
 and contentValue = 'Yes, I agree to the <a target=\'_blank\'  href=\'http://www.comparethemarket.com.au/competition/5000competition.pdf\'>competition terms and conditions</a>.';


 insert into ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue) values
  (@STYLECODE,@UTILITIES_ID,'Content',@PARTICIPATING_SUPPLIER_LINK,'2015-12-07','2040-12-31','http://www.comparethemarket.com.au/energy/');

-- test expect 1
SELECT count(*) FROM ctm.content_control WHERE verticalId = @UTILITIES_ID AND contentKey= @PARTICIPATING_SUPPLIER_LINK;

update ctm.content_control set effectiveEnd = '2015-12-06' where verticalId = @HEALTH_ID and
 styleCodeId = @STYLECODE and contentKey = @PARTICIPATING_SUPPLIER_LINK limit 1;

insert into ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue) values
 (@STYLECODE,@HEALTH_ID,'Content',@PARTICIPATING_SUPPLIER_LINK,'2015-12-07','2040-12-31','http://www.comparethemarket.com.au/health-insurance/');

 -- test expect 1
 SELECT count(*) FROM ctm.content_control WHERE
       verticalId = @HEALTH_ID
       AND contentKey= @PARTICIPATING_SUPPLIER_LINK
       and contentValue = 'http://www.comparethemarket.com.au/health-insurance/';






