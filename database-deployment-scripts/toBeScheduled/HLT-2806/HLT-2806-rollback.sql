SET @HEALTH = (select verticalId from ctm.vertical_master where verticalCode = 'HEALTH');
SET @CTM_STYLE = (select styleCodeId from ctm.stylecodes where styleCode = 'ctm');

delete from  ctm.content_control where contentKey = 'footerText' and verticalId = @HEALTH and styleCodeId = @CTM_STYLE
 limit 1;

 UPDATE ctm.content_control SET effectiveEnd = '2038-01-19'  WHERE verticalId = @HEALTH and styleCodeId = @CTM_STYLE
        and contentKey in ('footerTextEnd','footerParticipatingSuppliers','footerTextStart') and effectiveEnd = '2016-01-05'
      limit 3;

-- test expect 3
select count(*) from ctm.content_control where contentKey in ('footerTextEnd','footerParticipatingSuppliers','footerTextStart')
 and effectiveEnd = '2038-01-19' and verticalId = @HEALTH and styleCodeId = @CTM_STYLE;

 -- expect 0
select count(*) from ctm.content_control where contentKey = 'footerText' and verticalId = @HEALTH and styleCodeId = @CTM_STYLE
and effectiveEnd = '2040-12-31';