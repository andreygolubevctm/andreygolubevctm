SET @CAR_VERTICAL = (select verticalId from ctm.vertical_master where verticalCode = 'CAR');
SET @FUEL_VERTICAL = (select verticalId from ctm.vertical_master where verticalCode = 'FUEL');
SET @HOME_VERTICAL = (select verticalId from ctm.vertical_master where verticalCode = 'HOME');
SET @HOMELOAN_VERTICAL  = (select verticalId from ctm.vertical_master where verticalCode = 'HOMELOAN');
SET @CAR_LMI = (select verticalId from ctm.vertical_master where verticalCode = 'CARLMI');
SET @HOME_LMI = (select verticalId  from ctm.vertical_master where verticalCode = 'HOMELMI');
SET @ROADSIDE = (select verticalId from ctm.vertical_master where verticalCode = 'ROADSIDE');
SET @TRAVEL = (select verticalId from ctm.vertical_master where verticalCode = 'TRAVEL');
SET @UTILITIES = (select verticalId from ctm.vertical_master where verticalCode = 'UTILITIES');


delete from ctm.content_control where verticalId = @CAR_VERTICAL and contentCode = 'CarQuoteBlur' limit 2;
  -- Test expect 0
select count(*) from ctm.content_control where verticalId = @CAR_VERTICAL and contentCode = 'CarQuoteBlur';

delete from ctm.content_control where verticalId = @FUEL_VERTICAL and contentCode = 'GenericQuoteBlur' limit 2;
 -- Test expect 0
select count(*) from ctm.content_control where verticalId = @FUEL_VERTICAL and contentCode = 'GenericQuoteBlur';

delete from ctm.content_control where verticalId = @HOME_VERTICAL and contentCode = 'HomeQuoteBlur' limit 2;
-- Test expect 0
select count(*) from ctm.content_control where verticalId = @HOME_VERTICAL and contentCode = 'HomeQuoteBlur';

delete from ctm.content_control where verticalId = @HOMELOAN_VERTICAL and contentCode = 'HomeQuoteBlur' limit 2;
-- Test expect 0
select count(*) from ctm.content_control where verticalId = @HOMELOAN_VERTICAL and contentCode = 'HomeQuoteBlur';

delete from ctm.content_control where verticalId = @HOME_LMI and contentCode = 'GenericQuoteBlur' limit 2;
-- Test expect 0
select count(*) from ctm.content_control where verticalId = @HOME_LMI and contentCode = 'GenericQuoteBlur';

delete from ctm.content_control where verticalId = @CAR_LMI and contentCode = 'GenericQuoteBlur' limit 2;
-- Test expect 0
select count(*) from ctm.content_control where verticalId = @CAR_LMI and contentCode = 'GenericQuoteBlur';

delete from ctm.content_control where verticalId = @ROADSIDE and contentCode = 'GenericQuoteBlur' limit 2;
-- Test Expect 2
select count(*) from ctm.content_control where verticalId = @ROADSIDE and contentCode = 'GenericQuoteBlur';

delete from ctm.content_control where verticalId = @TRAVEL and contentCode = 'GenericQuoteBlur' limit 2;
-- Test Expect 0
select count(*) from ctm.content_control where verticalId = @TRAVEL and contentCode = 'GenericQuoteBlur';


delete from ctm.content_control where verticalId = @UTILITIES and contentCode = 'GenericQuoteBlur' limit 2;
-- Test Expect 0
 select count(*) from ctm.content_control where verticalId = @UTILITIES and contentCode = 'GenericQuoteBlur';


