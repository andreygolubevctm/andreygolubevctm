INSERT INTO ctm.confirmations (TransID, KeyID, Time, Vertical, XMLdata)
SELECT distinct t.transaction_id as TransID, 
CONCAT(CAST(th.sessionId AS CHAR) , '-' , CAST(t.transaction_id AS CHAR)) as KeyId,
ADDTIME(CAST(t.date as DATETIME),MAX(t.time)) as Time,
'CTMH' as Vertical,
CONCAT('<?xml version=\"1.0\" encoding=\"UTF-8\"?><data><transID>' , CAST(t.transaction_id AS CHAR), '</transID>',		
'<status>OK</status>' ,	
'<vertical>CTMH</vertical>' ,	
'<startDate>unavailable</startDate>' ,	
'<frequency>"', afd.textValue ,'"</frequency><about><![CDATA[ <div class=\"about-the-fund\"></div> ]]></about>' ,	
'<whatsNext><![CDATA[ <div class=\"next-info\"></div> ]]></whatsNext>' ,
'<product><![CDATA[ {"transactionId":' , CAST(t.transaction_id AS CHAR), ',"ambulance":{"otherInformation":"-",',
'"refund":"-","emergency":{"interstate":"unavailable","air":"unavailable","road":"unavailable"},"nonEmergency":{"interstate":"","air":"","road":""},',
'"waitingPeriod":"","covered":""},"promo":"","premium":{"weekly":{"pricing":"', ad.textValue ,'","text":"', ad.textValue ,'","discounted":"N","value":0},"halfyearly":{',
'"pricing":"', ad.textValue ,'","text":"', ad.textValue ,'","discounted":"N","value":"', ad.textValue ,'"},',
'"annually":{"pricing":"', ad.textValue ,'","text":"', ad.textValue ,'","discounted":"N","value":"', ad.textValue ,'"},',
'"monthly":{"pricing":"', ad.textValue ,'","text":"$', ad.textValue ,'","discounted":"N","value":"', ad.textValue ,'"},"fortnightly":{',
'"pricing":"unavailable","text":"unavailable","discounted":"N","value":"unavailable"},"quarterly":{',
'"pricing":"unavailable","text":"unavailable","discounted":"N","value":"unavailable"}},',
'"service":"PHIO","available":"Y",',
'"hospital":{"inclusions":{"excess":"unavailable","OtherExclusions":false,"LimitedProduct":false,"copayment":"unavailable",',
'"HospitalAmbulance":"","OtherProductFeatures":"","OtherBLP":false,"privateHospital":"Y","ClassificationHospital":"",',
'"waivers":"unavailable","OtherRestrictions":false,"GapCoverProvided":true,',
'"waitingPeriods":{"PreExisting":"unavailable","SubAcute":"unavailable","Ambulance":"unavailable",',
'"Other":"unavailable"},"hospitalPDF":""},"benefits":{',
'"exclusions":{"cover":""}}},"extras":"","info":{"des":"unavailable","promotions":"unavailable","about":"unavailable",',
'"ProductURL":"unavailable","OtherProductFeatures":"unavailable",',
'"MedicareLevySurchargeExempt":"unavailable","rank":"unavailable","TableCode":"","ProductType":"', pp.text ,'","name":"', pn.text ,'","afsLicenceNo":"",',
'"DateIssued":"unavailable","PremiumHospitalComponent":"unavailable","DateValidFrom":"unavailable","acn":"unavailable","productCode":"","ProductStatus":"",',
'"trackCode":"unavailable","FundCode":"unavailable","provider":"', pd.textValue ,'","Premium":"unavailable","Name":"","Category":"unavailable","State":"unavailable","PremiumNoRebate":"NA",',
'"providerName":"","productId":"', td.textValue ,'","premium":"unavailable","promoText":"unavailable","discountText":""},',
'"productId":"', td.textValue ,'","custom":{"info":{"exclusions":{"cover":""}}}}]]></product>',
'<policyNo></policyNo></data>')	 as XMLData
FROM ctm.touches as t
LEFT JOIN aggregator.transaction_header th 
ON th.transactionid = t.transaction_id 
AND (th.ProductType = 'HEALTH' OR th.ProductType = 'health')
LEFT JOIN ctm.confirmations c 
ON c.transId = t.transaction_id
LEFT JOIN aggregator.transaction_details td
ON td.transactionId = t.transaction_id 
AND td.xpath = 'health/application/productId'
LEFT JOIN aggregator.transaction_details pd
ON pd.transactionId = t.transaction_id 
AND pd.xpath = 'health/application/provider'
LEFT JOIN aggregator.transaction_details ad
ON ad.transactionId = t.transaction_id 
AND ad.xpath = 'health/application/paymentFreq'
LEFT JOIN aggregator.transaction_details afd
ON afd.transactionId = t.transaction_id 
AND afd.xpath = 'health/payment/details/frequency'
LEFT JOIN ctm.product_properties pp
ON pp.ProductId = SUBSTRING(td.textValue, 13, 21)
AND pp.propertyId = 'ProductType'
LEFT JOIN ctm.product_properties pn
ON pn.ProductId = SUBSTRING(td.textValue, 13, 21)
AND pn.propertyId LIKE '%Name%'
WHERE t.type ='C'
AND c.transId IS NULL
AND th.transactionid IS NOT NULL
group by t.transaction_id, t.date, th.sessionId;