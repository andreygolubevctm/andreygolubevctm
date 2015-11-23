
SET @PVIDER = (select providerId from ctm.provider_master where providerCode = 'FAST');

SET @NEW_DESCRIPTION = 'Fast Cover are travel insurance specialists as they only sell travel insurance.<br>From quote to the claims process, Fast Cover pride themselves on providing a service which is fast and simple.<br>Fast Cover Travel Insurance sells quality travel insurance that\'s flexible, easy to understand and great value for money.<br><br><ul><li>14 day money back guarantee</li><li>Kids covered Free of additional charge</li><li>5% OFF when you book for 2 adults</li><li>Underwritten by Allianz</li><li>No age limits</li><li>Suitable for holidays/work</li></ul><br><br>All policies include:<br><ul><li>Unlimited Overseas Medical Cover</li><li>Unlimited Cancellation Cover</li><li>Unlimited Worldwide Emergency Assistance Cover</li><li>Travel Delay Cover</li><li>Cover for 43 pre-existing medical conditions – no medical required, see PDS for full list.</li></ul>';
SET @OLD_DESCRIPTION = 'Fast Cover are travel insurance specialists as they only sell travel insurance.<br>From quote to the claims process, Fast Cover pride themselves on providing a service which is fast and simple.<br>Fast Cover Travel Insurance sells quality travel insurance that\'s flexible, easy to understand and great value for money.<br><br><ul><li>14 day money back guarantee</li><li>Kids covered Free of additional charge</li><li>5% OFF when you book for 2 adults</li><li>Underwritten by Allianz</li><li>No age limits</li><li>Suitable for holidays/work</li></ul><br><br>All policies include:<br><ul><li>Unlimited Overseas Medical Cover</li><li>Unlimited Cancellation Cover</li><li>Unlimited Worldwide Emergency Assistance Cover</li><li>Travel Delay Cover</li><li>Missed Connections Cover</li><li>Cover for 43 pre-existing medical conditions - no medical required, see PDS for full list.</li></ul>';

SET @NEW_DESCRIPTION2 = 'Fast Cover are travel insurance specialists as they only sell travel insurance.<br>From quote to the claims process, Fast Cover pride themselves on providing a service which is fast and simple.<br>Fast Cover Travel Insurance sells quality travel insurance that\'s flexible, easy to understand and great value for money.<br><br><ul><li>14 day money back guarantee</li><li>Kids covered Free of additional charge</li><li>5% OFF when you book for 2 adults</li><li>Underwritten by Allianz</li><li>No age limits</li><li>Suitable for holidays/work</li></ul><br><br>All policies include:<br><ul><li>Unlimited Overseas Medical Cover</li><li>Unlimited Cancellation Cover</li><li>Unlimited Worldwide Emergency Assistance Cover</li><li>Cover for 43 pre-existing medical conditions – no medical required, see PDS for full list.</li></ul>';
SET @OLD_DESCRIPTION2 = 'Fast Cover are travel insurance specialists as they only sell travel insurance.<br>From quote to the claims process, Fast Cover pride themselves on providing a service which is fast and simple.<br>Fast Cover Travel Insurance sells quality travel insurance that\'s flexible, easy to understand and great value for money.<br><br><ul><li>14 day money back guarantee</li><li>Kids covered Free of additional charge</li><li>5% OFF when you book for 2 adults</li><li>Underwritten by Allianz</li><li>No age limits</li><li>Suitable for holidays/work</li></ul><br><br>All policies include:<br><ul><li>Unlimited Overseas Medical Cover</li><li>Unlimited Cancellation Cover</li><li>Unlimited Worldwide Emergency Assistance Cover</li><li>Missed Connections Cover</li><li>Cover for 43 pre-existing medical conditions – no medical required, see PDS for full list.</li></ul>';

update ctm.travel_product set description = @NEW_DESCRIPTION where providerId = @PVIDER and baseProduct = 0
   and productCode in ('FAST-TRAVEL-44','FAST-TRAVEL-45') and description = @OLD_DESCRIPTION limit 2;

update ctm.travel_product set description = @NEW_DESCRIPTION2 where providerId = @PVIDER and baseProduct = 0
   and productCode in ('FAST-TRAVEL-40','FAST-TRAVEL-47') and description = @OLD_DESCRIPTION2 limit 2;

insert into ctm.travel_product (providerId,productCode,title,description,baseProduct,providerProductCode,effectiveStart,effectiveEnd)
 values (@PVIDER,'FAST-TRAVEL-41','Fast Cover Comprehensive',@NEW_DESCRIPTION2,0,'FAST-TRAVEL-41','2015-09-24','2040-12-31');

insert into ctm.travel_product (providerId,productCode,title,description,baseProduct,providerProductCode,effectiveStart,effectiveEnd)
 values (@PVIDER,'FAST-TRAVEL-46','Fast Cover Comprehensive Cruise',@NEW_DESCRIPTION2,0,'FAST-TRAVEL-46','2015-09-24','2040-12-31');

insert into ctm.travel_product (providerId,productCode,title,description,baseProduct,providerProductCode,effectiveStart,effectiveEnd)
 values (@PVIDER,'FAST-TRAVEL-42','Fast Cover Comprehensive Snow',@NEW_DESCRIPTION2,0,'FAST-TRAVEL-42','2015-09-24','2040-12-31');

insert into ctm.travel_product (providerId,productCode,title,description,baseProduct,providerProductCode,effectiveStart,effectiveEnd)
 values (@PVIDER,'FAST-TRAVEL-48','Fast Cover Comprehensive Cruise with Snow',@NEW_DESCRIPTION2,0,'FAST-TRAVEL-48','2015-09-24','2040-12-31');


-- test expect 2
select count(*) from ctm.travel_product where providerId = @PVIDER and description = @NEW_DESCRIPTION;

-- test expect 6
select count(*) from ctm.travel_product where providerId = @PVIDER and description = @NEW_DESCRIPTION2;
