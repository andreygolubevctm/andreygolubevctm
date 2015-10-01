SET @CAR_VERTICAL = (select verticalId from ctm.vertical_master where verticalCode = 'CAR');
SET @FUEL_VERTICAL = (select verticalId from ctm.vertical_master where verticalCode = 'FUEL');
SET @HOME_VERTICAL = (select verticalId from ctm.vertical_master where verticalCode = 'HOME');
SET @HOMELOAN_VERTICAL  = (select verticalId from ctm.vertical_master where verticalCode = 'HOMELOAN');
SET @CAR_LMI = (select verticalId from ctm.vertical_master where verticalCode = 'CARLMI');
SET @HOME_LMI = (select verticalId  from ctm.vertical_master where verticalCode = 'HOMELMI');
SET @ROADSIDE = (select verticalId from ctm.vertical_master where verticalCode = 'ROADSIDE');
SET @TRAVEL = (select verticalId from ctm.vertical_master where verticalCode = 'TRAVEL');
SET @UTILITIES = (select verticalId from ctm.vertical_master where verticalCode = 'UTILITIES');

SET @CAR_NO_QUOTE_TEXT = '<p>Unfortunately our providers were unable to provide a quote based on the information you have entered. This could be due to a variety of factors such as the age of the driver/s and the vehicle make and/or type etc, depending upon individual circumstances.</p>			<p>If you are unable to get a quote from one of our providers, you may want to refer to the Insurance Council of Australia\'s "Find an Insurer" website at <a href="http://www.findaninsurer.com.au/" target="_blank">www.findaninsurer.com.au</a> and they may be able to provide you with a list of companies who can assist you with cover.</p>			<p><strong>In the meantime, why not compare your other insurances and utilities to see if you can find a better deal.</strong></p>';
SET @CAR_NO_QUOTE_TITLE = '<h2>Sorry, we were unable to get a quote</h2>';
SET @GENERIC_NO_QUOTE_TEXT = '<p>Unfortunately our providers were unable to supply a quote based on the details you entered... sorry about that!</p><p><strong>If you\'d like to compare something else, just choose from the below to start comparing.</strong></p>';
SET @HOME_NO_QUOTE_TEXT = '<p>Unfortunately our providers were unable to provide a quote based on the information you have entered. This could be due to a variety of factors depending upon individual circumstances, such as property location, the age of the property, body corporate membership or running a business from the home.</p><p>If you are unable to get a quote from one of our providers, you may want to refer to the Insurance Council of Australia\'s "Find an Insurer" website at <a href="http://www.findaninsurer.com.au/">www.findaninsurer.com.au</a> and they may be able to provide you with a list of companies who can assist you with cover.</p><p><strong>In the meantime, why not compare your other insurances and utilities to see if you can find a better deal.</strong></p>';



insert into ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue)
  values(0,@CAR_VERTICAL,'CarQuoteBlur','noCarQuote','2015-09-30','2045-12-31',@CAR_NO_QUOTE_TEXT);

insert into ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue,contentStatus)
  values(0,@CAR_VERTICAL,'CarQuoteBlur','noCarQuoteTitle','2015-09-30','2045-12-31',@CAR_NO_QUOTE_TITLE,'');

  -- Test expect 2
select count(*) from ctm.content_control where verticalId = @CAR_VERTICAL and contentCode = 'CarQuoteBlur';

insert into ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue,contentStatus)
  values(0,@FUEL_VERTICAL,'GenericQuoteBlur','noQuoteTitle','2015-09-30','2045-12-31',@CAR_NO_QUOTE_TITLE,'');

insert into ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue,contentStatus)
  values(0,@FUEL_VERTICAL,'GenericQuoteBlur','noQuoteText','2015-09-30','2045-12-31',@GENERIC_NO_QUOTE_TEXT,'');
  -- Test expect 2
select count(*) from ctm.content_control where verticalId = @FUEL_VERTICAL and contentCode = 'GenericQuoteBlur';


insert into ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue,contentStatus)
  values(0,@HOME_VERTICAL,'HomeQuoteBlur','noQuoteTitle','2015-09-30','2045-12-31',@CAR_NO_QUOTE_TITLE,'');

insert into ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue,contentStatus)
  values(0,@HOME_VERTICAL,'HomeQuoteBlur','noQuoteText','2015-09-30','2045-12-31',@HOME_NO_QUOTE_TEXT,'');
  -- Test expect 2
select count(*) from ctm.content_control where verticalId = @HOME_VERTICAL and contentCode = 'HomeQuoteBlur';

insert into ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue,contentStatus)
  values(0,@HOMELOAN_VERTICAL,'HomeQuoteBlur','noQuoteTitle','2015-09-30','2045-12-31',@CAR_NO_QUOTE_TITLE,'');

insert into ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue,contentStatus)
  values(0,@HOMELOAN_VERTICAL,'HomeQuoteBlur','noQuoteText','2015-09-30','2045-12-31',@GENERIC_NO_QUOTE_TEXT,'');
  -- Test expect 2
 select count(*) from ctm.content_control where verticalId = @HOMELOAN_VERTICAL and contentCode = 'HomeQuoteBlur';


insert into ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue,contentStatus)
  values(0,@HOME_LMI,'GenericQuoteBlur','noQuoteTitle','2015-09-30','2045-12-31',@CAR_NO_QUOTE_TITLE,'');

insert into ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue,contentStatus)
  values(0,@HOME_LMI,'GenericQuoteBlur','noQuoteText','2015-09-30','2045-12-31',@GENERIC_NO_QUOTE_TEXT,'');

   -- Test expect 2
select count(*) from ctm.content_control where verticalId = @HOME_LMI and contentCode = 'GenericQuoteBlur';

insert into ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue,contentStatus)
  values(0,@CAR_LMI,'GenericQuoteBlur','noQuoteTitle','2015-09-30','2045-12-31',@CAR_NO_QUOTE_TITLE,'');

insert into ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue,contentStatus)
  values(0,@CAR_LMI,'GenericQuoteBlur','noQuoteText','2015-09-30','2045-12-31',@GENERIC_NO_QUOTE_TEXT,'');

   -- Test expect 2
select count(*) from ctm.content_control where verticalId = @CAR_LMI and contentCode = 'GenericQuoteBlur';

insert into ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue,contentStatus)
  values(0,@ROADSIDE,'GenericQuoteBlur','noQuoteTitle','2015-09-30','2045-12-31',@CAR_NO_QUOTE_TITLE,'');

insert into ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue,contentStatus)
  values(0,@ROADSIDE,'GenericQuoteBlur','noQuoteText','2015-09-30','2045-12-31',@GENERIC_NO_QUOTE_TEXT,'');

-- Test Expect 2
  select count(*) from ctm.content_control where verticalId = @ROADSIDE and contentCode = 'GenericQuoteBlur';

insert into ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue,contentStatus)
  values(0,@TRAVEL,'GenericQuoteBlur','noQuoteTitle','2015-09-30','2045-12-31',@CAR_NO_QUOTE_TITLE,'');

insert into ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue,contentStatus)
  values(0,@TRAVEL,'GenericQuoteBlur','noQuoteText','2015-09-30','2045-12-31',@GENERIC_NO_QUOTE_TEXT,'');

-- Test Expect 2
  select count(*) from ctm.content_control where verticalId = @TRAVEL and contentCode = 'GenericQuoteBlur';

insert into ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue,contentStatus)
  values(0,@UTILITIES,'GenericQuoteBlur','noQuoteTitle','2015-09-30','2045-12-31',@CAR_NO_QUOTE_TITLE,'');

insert into ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,effectiveStart,effectiveEnd,contentValue,contentStatus)
  values(0,@UTILITIES,'GenericQuoteBlur','noQuoteText','2015-09-30','2045-12-31',@GENERIC_NO_QUOTE_TEXT,'');

-- Test Expect 2
 select count(*) from ctm.content_control where verticalId = @UTILITIES and contentCode = 'GenericQuoteBlur';


