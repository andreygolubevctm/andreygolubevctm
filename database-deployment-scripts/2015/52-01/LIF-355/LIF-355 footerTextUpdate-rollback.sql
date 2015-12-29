SET @LIFE = (select verticalId from ctm.vertical_master where verticalCode = 'LIFE');
SET @IP = (select verticalId from ctm.vertical_master where verticalCode = 'IP');

update ctm.content_control set effectiveEnd='2015-12-23' where verticalId in (@LIFE,@IP) and contentKey='footerTextStart' and effectiveEnd='2038-01-19';

insert into ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue)
 values (1,@LIFE,'Footer','footerTextStart','2015-12-24','2038-01-19','<p>The Compare the Market website and the Compare the Market brand and trading name are owned by, licensed to and/or operated by Compare The Market Pty Ltd ("CTM") ACN 117323 378, AFSL 422926.</p><p>In respect of life insurance and income protection insurance ("Life Products") CTM is (a) an authorised representative (AR 434310) of Lifebroker Pty Ltd ACN 115 153 243("Lifebroker"); AFSL 400209 in relation to products made available by Lifebroker; and (b) an authorised representative (AR 434310) of Auto & General Services Pty Ltd ACN 003 617 909 ("AGS") AFSL 241411 in relation to products made available by AGS. CTM and AGS are related bodies corporate.</p>  <p>The comparison service and any other information provided on this site is factual information or general advice. None of it is a personal recommendation, suggestion or advice about the suitability of a particular insurance product for you and your needs.</p><p>Before acting on the guidance we provide and when using the comparison service, evaluate your needs, objectives and situation and which products are suitable for you.</p><p>Review the relevant Product Disclosure Statement before making any decision to acquire or hold a Life Product. Learn more with the Lifebroker Financial Services Guide, Terms of use, Privacy Policy and guide to its participating insurers.The Life Products compared on this site are not representative of all products available in the market. This site compares the following Life Product brands:');

insert into ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue)
 values (1,@IP,'Footer','footerTextStart','2015-12-24','2038-01-19','<p>The Compare the Market website and the Compare the Market brand and trading name are owned by, licensed to and/or operated by Compare The Market Pty Ltd ("CTM") ACN 117323 378, AFSL 422926.</p><p>In respect of life insurance and income protection insurance ("Life Products") CTM is (a) an authorised representative (AR 434310) of Lifebroker Pty Ltd ACN 115 153 243("Lifebroker"); AFSL 400209 in relation to products made available by Lifebroker; and (b) an authorised representative (AR 434310) of Auto & General Services Pty Ltd ACN 003 617 909 ("AGS") AFSL 241411 in relation to products made available by AGS. CTM and AGS are related bodies corporate.</p>  <p>The comparison service and any other information provided on this site is factual information or general advice. None of it is a personal recommendation, suggestion or advice about the suitability of a particular insurance product for you and your needs.</p><p>Before acting on the guidance we provide and when using the comparison service, evaluate your needs, objectives and situation and which products are suitable for you.</p><p>Review the relevant Product Disclosure Statement before making any decision to acquire or hold a Life Product. Learn more with the Lifebroker Financial Services Guide, Terms of use, Privacy Policy and guide to its participating insurers.The Life Products compared on this site are not representative of all products available in the market. This site compares the following Life Product brands:');

 -- test expect 1
select count(*) from ctm.content_control where contentValue like '%Learn more with the Lifebroker%' and verticalId = @IP;

-- test expect 1
select count(*) from ctm.content_control where contentValue like '%Learn more with the Lifebroker%' and verticalId = @LIFE;

-- rollback
/*
update ctm.content_control set effectiveEnd='2038-01-19' where verticalId in (@LIFE,@IP) and contentKey='footerTextStart' and effectiveEnd='2015-12-23';

delete from ctm.content_control where effectiveStart = '2015-12-24' and verticalId = @LIFE and contentKey = 'footerTextStart' and effectiveEnd='2038-01-19';

*/
