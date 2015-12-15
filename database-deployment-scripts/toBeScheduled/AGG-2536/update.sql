SET @FOOTER_KEY = "footerSecurityBadge";
SET @FOOTER_CODE  = "Security";
-- change effective date


update ctm.content_control set effectiveEnd = '2015-12-14' where
 contentCode = @FOOTER_CODE and contentKey = @FOOTER_KEY and effectiveEnd = '2038-01-19'
and styleCodeId = 1 and verticalId = 0 limit 1;
-- TEST expect 1
select count(*) from ctm.content_control where contentCode = @FOOTER_CODE and contentKey = @FOOTER_KEY and effectiveEnd = '2015-12-14'
and contentValue like '%https://images%' and styleCodeId = 1 and verticalId = 0;


insert into ctm.content_control (styleCodeId, verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue)
 values ('1','0',@FOOTER_CODE,@FOOTER_KEY,'2015-12-15','2040-12-12',
'<div id="footer_mcafee"><a target="_blank" href="https://www.mcafeesecure.com/verify?host=secure.comparethemarket.com.au"><img class="mfes-trustmark" border="0" src="//cdn.ywxi.net/meter/secure.comparethemarket.com.au/101.gif" width="125" height="55" title="McAfee SECURE sites help keep you safe from identity theft, credit card fraud, spyware, spam, viruses and online scams" alt="McAfee SECURE sites help keep you safe from identity theft, credit card fraud, spyware, spam, viruses and online scams" oncontextmenu="window.open(\'https://www.mcafeesecure.com/verify?host=secure.comparethemarket.com.au\'); return false;"></a></div>');
-- TEST expect 1
select count(*) from ctm.content_control where contentCode = @FOOTER_CODE and contentKey = @FOOTER_KEY and effectiveEnd = '2040-12-12'
and contentValue like '%//cdn.ywxi.net/%' and styleCodeId = 1 and verticalId = 0;
