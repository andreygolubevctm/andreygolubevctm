
SET @HEALTH = (select verticalId from ctm.vertical_master where verticalCode = 'HEALTH');
SET @CTM_STYLE = (select styleCodeId from ctm.stylecodes where styleCode = 'ctm');

-- PRE test expect 3
select count(*) from ctm.content_control where contentKey in ('footerTextEnd','footerParticipatingSuppliers','footerTextStart')
 and effectiveEnd = '2038-01-19' and verticalId = @HEALTH and styleCodeId = @CTM_STYLE;

UPDATE ctm.content_control SET effectiveEnd = '2016-01-05'  WHERE verticalId = @HEALTH and styleCodeId = @CTM_STYLE
        and contentKey in ('footerTextEnd','footerParticipatingSuppliers','footerTextStart') and effectiveEnd = '2038-01-19'
      limit 3;

-- POST test expect 0
select count(*) from ctm.content_control where contentKey in ('footerTextEnd','footerParticipatingSuppliers','footerTextStart')
 and effectiveEnd = '2038-01-19' and verticalId = @HEALTH and styleCodeId = @CTM_STYLE;



insert into ctm.content_control  (styleCodeId,verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue)
 value (@CTM_STYLE,@HEALTH,'Footer','footerText','2016-01-05','2040-12-31',
'<p>The Compare The Market health comparison service (including this website and our call centre) is owned and operated by Compare The Market Pty Ltd ACN 117 323 378.</p>
<p>The health insurance products we compare are not representative of all products in the market.
<a href="http://www.comparethemarket.com.au/health-insurance/disclosures/#funds" target="_blank">Click here</a>
for details of which health funds we compare. If you have a complaint or any feedback on our health insurance comparison service, please
<a href="http://www.comparethemarket.com.au/health-insurance/complaints-idr-process/?_ga=1.161455037.1278242513.1436834902" target="_blank">Click here</a>
for details of our internal dispute procedure.</p>');

-- expect 1
select count(*) from ctm.content_control where contentKey = 'footerText' and verticalId = @HEALTH and styleCodeId = @CTM_STYLE
and effectiveEnd = '2040-12-31';



