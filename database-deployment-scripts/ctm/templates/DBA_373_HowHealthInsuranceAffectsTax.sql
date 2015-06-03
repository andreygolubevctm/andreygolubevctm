Select distinct
--     'Hot',
    td3.textValue As FirstName,
    td2.textValue As Email,
    td1.textValue As HealthSitu,
    CONCAT('https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp? vertical=',
            th.productType,
            '&email=',
            td2.textValue,
            '&unsubscribe_email=',
            emHash.hashedEmail) AS `unsubscribeURL`
From
    aggregator.transaction_header th
        Inner Join
    ctm.touches t ON th.TransactionId = t.transaction_id
        and th.ProductType = 'Health'
        and t.date >= '2015-01-01'
        and t.date <= '2015-05-19'
        Inner Join
    aggregator.transaction_details td1 ON th.TransactionId = td1.transactionId
        and td1.xpath = 'health/situation/healthSitu'
        Inner Join
    aggregator.transaction_details td2 ON th.TransactionId = td2.transactionId
        and td2.xpath = 'health/contactDetails/email'
        Inner Join
    aggregator.transaction_details td3 ON th.TransactionId = td3.transactionId
        and td3.xpath = 'health/contactDetails/name'
        Inner Join
    ctm.marketingOptIn mo ON mo.optInTarget = td2.textValue
        and mo.optInStatus = 1
        and mo.styleCodeId = 1
        and fieldcategory = 1
        Inner Join
    aggregator.email_master emHash ON td2.textValue = emHash.emailAddress
        AND emHash.StyleCodeId = 1
Where
    td1.textValue = 'ATP' 

UNION 

Select distinct
 --    'Cold',
    td2c3.textValue As FirstName,
    td2c2.textValue As Email,
    td2c1.textValue As HealthSitu,
    CONCAT('https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp? vertical=',
            'health',
            '&email=',
            td2c2.textValue,
            '&unsubscribe_email=',
            emHash.hashedEmail) AS `unsubscribeURL`
From
    aggregator.transaction_header2_cold th2c
        Inner Join
    ctm.touches t ON th2c.TransactionId = t.transaction_id
        and th2c.verticalId = 4
        and t.date >= '2015-01-01'
        and t.date <= '2015-05-19'
        Inner Join
    aggregator.transaction_details2_cold td2c1 ON th2c.TransactionId = td2c1.transactionId
        and td2c1.fieldId = 552
        Inner Join
    aggregator.transaction_details2_cold td2c2 ON th2c.TransactionId = td2c2.transactionId
        and td2c2.fieldId = 411
        Inner Join
    aggregator.transaction_details2_cold td2c3 ON th2c.TransactionId = td2c3.transactionId
        and td2c3.fieldId = 416
        Inner Join
    ctm.marketingOptIn mo ON mo.optInTarget = td2c2.textValue
        and mo.optInStatus = 1
        and mo.styleCodeId = 1
        and fieldcategory = 1
        Inner Join
    aggregator.email_master emHash ON td2c2.textValue = emHash.emailAddress
        AND emHash.StyleCodeId = 1
Where
    td2c1.textValue = 'ATP'		