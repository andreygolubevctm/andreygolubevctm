SET @FOOTER_KEY = "footerSecurityBadge";
SET @FOOTER_CODE  ="Security";

update ctm.content_control set effectiveEnd = '2038-01-19' where
 contentCode = @FOOTER_CODE and contentKey = @FOOTER_KEY and effectiveEnd = '2015-12-14'
and styleCodeId = 1 and verticalId = 0 limit 1;

-- test expect 1
select count(*) from ctm.content_control where contentCode = @FOOTER_CODE and contentKey = @FOOTER_KEY and effectiveEnd = '2038-01-19'
and contentValue like '%https://images%' and styleCodeId = 1 and verticalId = 0;

delete from ctm.content_control where contentCode = @FOOTER_CODe and contentKey = @FOOTER_KEY and effectiveEnd = '2040-12-12'
and contentValue like '%//cdn.ywxi.net/%' and styleCodeId = 1 and verticalId = 0 limit 1;

-- TEST expect 0
select count(*) from ctm.content_control where contentCode = @FOOTER_CODE and contentKey = @FOOTER_KEY and effectiveEnd = '2040-12-12'
and contentValue like '%//cdn.ywxi.net/%' and styleCodeId = 1 and verticalId = 0;