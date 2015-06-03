SET @QuoteFrom  = '2015-01-01';
SET @QuoteTo    = '2015-05-30';
SET @DobFrom    = '1988-12-31';
SET @DobTo      = '1994-01-01';

SELECT DISTINCT -- 'Hot'
                  td3.textValue AS FirstName
                , td2.textValue AS EmailAddress
                , STR_TO_DATE(td1.textValue, '%d/%m/%Y') AS DOB
                , CONCAT('https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp? vertical=', th.productType, '&email=', td2.textValue, '&unsubscribe_email=', emHash.hashedEmail) AS `unsubscribeURL`
FROM   transaction_header th
       INNER JOIN ctm.touches t           ON th.TransactionId = t.transaction_id  AND th.ProductType = 'Car' AND t.date >= @QuoteFrom AND t.date <= @QuoteTo
       INNER JOIN transaction_details td1 ON th.TransactionId = td1.transactionId AND (td1.xpath = 'quote/drivers/regular/dob')
       INNER JOIN transaction_details td2 ON th.TransactionId = td2.transactionId AND (td2.xpath = 'quote/contact/email')
       INNER JOIN transaction_details td3 ON th.TransactionId = td3.transactionId AND (td3.xpath = 'quote/drivers/regular/firstname')
       INNER JOIN ctm.marketingOptIn mo   ON mo.optInTarget = td2.textValue       AND mo.optInStatus = 1 AND mo.styleCodeId = 1 AND fieldcategory = 1
       INNER JOIN aggregator.email_master emHash ON td2.textValue = emHash.emailAddress AND emHash.StyleCodeId = 1
WHERE  STR_TO_DATE(td1.textValue, '%d/%m/%Y') > @DobFrom 
   AND STR_TO_DATE(td1.textValue, '%d/%m/%Y') < @DobTo

UNION

SELECT DISTINCT -- 'Hot'
                  td3.textValue AS FirstName
                , td2.textValue AS EmailAddress
                , STR_TO_DATE(td1.textValue, '%d/%m/%Y') AS DOB
                , CONCAT('https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp? vertical=', th.productType, '&email=', td2.textValue, '&unsubscribe_email=', emHash.hashedEmail) AS `unsubscribeURL`
FROM   transaction_header th
       INNER JOIN ctm.touches t           ON th.TransactionId = t.transaction_id  AND th.ProductType = 'Travel1' AND t.date >= @QuoteFrom AND t.date <= @QuoteTo
       INNER JOIN transaction_details td1 ON th.TransactionId = td1.transactionId AND (td1.xpath = 'travel/oldest')
       INNER JOIN transaction_details td2 ON th.TransactionId = td2.transactionId AND (td2.xpath = 'travel/email')
       INNER JOIN transaction_details td3 ON th.TransactionId = td3.transactionId AND (td3.xpath = 'travel/firstName')
       INNER JOIN ctm.marketingOptIn mo   ON mo.optInTarget = td2.textValue       AND mo.optInStatus = 1 AND mo.styleCodeId = 1 AND fieldcategory = 1
       INNER JOIN aggregator.email_master emHash ON td2.textValue = emHash.emailAddress AND emHash.StyleCodeId = 1
WHERE  DATE_SUB(th.StartDate, INTERVAL (td1.textValue) YEAR) > @DobFrom 
   AND DATE_SUB(th.StartDate, INTERVAL (td1.textValue) YEAR) < @DobTo
   

UNION


SELECT DISTINCT -- 'Cold'
                  td3.textValue AS FirstName
                , td2.textValue AS EmailAddress
                , STR_TO_DATE(td1.textValue, '%d/%m/%Y') AS DOB
                , CONCAT('https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp? vertical=', 'Car', '&email=', td2.textValue, '&unsubscribe_email=', emHash.hashedEmail) AS `unsubscribeURL`
FROM   transaction_header2_cold th
       INNER JOIN ctm.touches t                   ON th.TransactionId = t.transaction_id  AND th.verticalId = 3 /*'Car'*/ AND t.date >= @QuoteFrom AND t.date <= @QuoteTo
       INNER JOIN transaction_details2_cold td1   ON th.TransactionId = td1.transactionId AND td1.verticalId = th.verticalId AND td1.fieldId = 1064 -- 'quote/drivers/regular/dob '
       INNER JOIN transaction_details2_cold td2   ON th.TransactionId = td2.transactionId AND td2.verticalId = th.verticalId AND td2.fieldId = 1058 -- 'quote/contact/email'
       INNER JOIN transaction_details2_cold td3   ON th.TransactionId = td3.transactionId AND td3.verticalId = th.verticalId AND td3.fieldId = 1070 -- 'quote/drivers/regular/firstname'
       INNER JOIN ctm.marketingOptIn mo           ON mo.optInTarget = td2.textValue       AND mo.optInStatus = 1 AND mo.styleCodeId = 1 AND fieldcategory = 1
       INNER JOIN aggregator.email_master emHash  ON td2.textValue = emHash.emailAddress  AND emHash.StyleCodeId = 1
WHERE  STR_TO_DATE(td1.textValue, '%d/%m/%Y') > @DobFrom 
   AND STR_TO_DATE(td1.textValue, '%d/%m/%Y') < @DobTo
   
UNION

SELECT DISTINCT -- 'Cold'
                  td3.textValue AS FirstName
                , td2.textValue AS EmailAddress
                , STR_TO_DATE(td1.textValue, '%d/%m/%Y') AS DOB
                , CONCAT('https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp? vertical=', 'Travel', '&email=', td2.textValue, '&unsubscribe_email=', emHash.hashedEmail) AS `unsubscribeURL`
FROM   transaction_header2_cold th
       INNER JOIN ctm.touches t                   ON th.TransactionId = t.transaction_id  AND th.verticalId = 2 /*'Travel1'*/ AND t.date >= @QuoteFrom AND t.date <= @QuoteTo
       INNER JOIN transaction_details2_cold td1   ON th.TransactionId = td1.transactionId AND td1.verticalId = th.verticalId AND td1.fieldId = 1590 -- 'travel/oldest'
       INNER JOIN transaction_details2_cold td2   ON th.TransactionId = td2.transactionId AND td2.verticalId = th.verticalId AND td2.fieldId = 1585 -- 'travel/email'
       INNER JOIN transaction_details2_cold td3   ON th.TransactionId = td3.transactionId AND td3.verticalId = th.verticalId AND td3.fieldId = 1586 -- 'travel/firstName'
       INNER JOIN ctm.marketingOptIn mo           ON mo.optInTarget = td2.textValue       AND mo.optInStatus = 1 AND mo.styleCodeId = 1 AND fieldcategory = 1
       INNER JOIN aggregator.email_master emHash  ON td2.textValue = emHash.emailAddress  AND emHash.StyleCodeId = 1
WHERE  DATE_SUB(th.transactionStartDateTime, INTERVAL (td1.textValue) YEAR) > @DobFrom 
   AND DATE_SUB(th.transactionStartDateTime, INTERVAL (td1.textValue) YEAR) < @DobTo
;   
-- ========================================================================


