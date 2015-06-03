
-- ====================== This is query for extracting Homeloan Handover Source for washing  ===============================================================
SELECT DISTINCT	-- c.TransID as `transactionId`	,
	Substring(	
					XMLdata, 
					 Instr(XMLdata,'<emailAddress>') 									+ length('<emailAddress>'), 
					(Instr(XMLdata,'/emailAddress>') - Instr(XMLdata, '<emailAddress>') - length('<emailAddress>') -1 )
				 )		AS `emailAddress`
FROM 	 aggregator.transaction_header h
  	JOIN aggregator.transaction_details d  ON d.transactionId = h.transactionId 
	JOIN ctm.confirmations c ON (h.rootId = c.TransID OR d.transactionId = c.TransID)
		AND						 d.textValue = Substring(	
														  XMLdata, 
														  Instr(XMLdata,'<emailAddress>') 									 + length('<emailAddress>'), 
														 (Instr(XMLdata,'/emailAddress>') - Instr(XMLdata, '<emailAddress>') - length('<emailAddress>') -1 )
														)	
WHERE 	/*h.ProductType = 'Homeloan'
 	and*/ d.xpath like 'homeloan/%/email' 
-- ===========================================================================================================================================







;
SELECT transactionId, textValue FROM aggregator.transaction_details where xpath = 'homeloan/flexOpportunityId';


SELECT DISTINCT TransID, -- Time, -- XMLdata,
	substring(	
				XMLdata, 
				 Instr(XMLdata,'<emailAddress>') + length('<emailAddress>'), 
				(Instr(XMLdata,'/emailAddress>') - Instr(XMLdata, '<emailAddress>') - length('<emailAddress>') -1 )
			 )	AS `emailAddress` -- ,
/*	substring(	
				XMLdata, 
				 Instr(XMLdata,'<flexOpportunityId>') + length('<flexOpportunityId>'), 
				(Instr(XMLdata,'/flexOpportunityId>') - Instr(XMLdata, '<flexOpportunityId>') - length('<flexOpportunityId>') -1 )
			 )	AS `flexOpportunityId`,
	substring(	
				XMLdata, 
				 Instr(XMLdata,'<lender>') + length('<lender>'), 
				(Instr(XMLdata,'/lender>') - Instr(XMLdata, '<lender>') - length('<lender>') -1 )
			 )	AS `lender`
*/
FROM ctm.confirmations 
WHERE 	substring(	
				XMLdata, 
				 Instr(XMLdata,'<lender>') + length('<lender>'), 
				(Instr(XMLdata,'/lender>') - Instr(XMLdata, '<lender>') - length('<lender>') -1 )
			 )	<> ''
;



-- ================================================================

SELECT	DISTINCT
		h.rootId, 
		h.transactionId as `HdrTranId`, 
		c.TransID 		as `CnfTranId`, 
 		d.textValue 	as `DtlEmail` ,
		substring(	
					XMLdata, 
					 Instr(XMLdata,'<emailAddress>') + length('<emailAddress>'), 
					(Instr(XMLdata,'/emailAddress>') - Instr(XMLdata, '<emailAddress>') - length('<emailAddress>') -1 )
				 )		AS `CnfEmailAddress`,
		substring(	
					XMLdata, 
					 Instr(XMLdata,'<flexOpportunityId>') + length('<flexOpportunityId>'), 
					(Instr(XMLdata,'/flexOpportunityId>') - Instr(XMLdata, '<flexOpportunityId>') - length('<flexOpportunityId>') -1 )
				 )		AS `flexOpportunityId`,
		substring(	
					XMLdata, 
					 Instr(XMLdata,'<lender>') + length('<lender>'), 
					(Instr(XMLdata,'/lender>') - Instr(XMLdata, '<lender>') - length('<lender>') -1 )
				 )		AS `lender`
FROM 	 transaction_header h
  	JOIN aggregator.transaction_details d ON d.transactionId = h.transactionId 
	JOIN ctm.confirmations c ON (h.rootId = c.TransID OR h.transactionId = c.TransID)
		AND						 d.textValue = substring(	
														  XMLdata, 
														  Instr(XMLdata,'<emailAddress>') + length('<emailAddress>'), 
														 (Instr(XMLdata,'/emailAddress>') - Instr(XMLdata, '<emailAddress>') - length('<emailAddress>') -1 )
														)	
WHERE 	h.ProductType = 'Homeloan'
 	and d.xpath like 'homeloan/%/email' 
-- 	and d.xpath = 'homeloan/flexOpportunityId';
;



-- --------------------- only one transId in common! AND flexOpportunityIds are NOT MATCHING!  -----------------------------------------------
SELECT * 
FROM 	 ctm.confirmations 
	join aggregator.transaction_details ON xpath = 'homeloan/flexOpportunityId' and TransID = transactionId
WHERE 	substring(	
				XMLdata, 
				 Instr(XMLdata,'<lender>') + length('<lender>'), 
				(Instr(XMLdata,'/lender>') - Instr(XMLdata, '<lender>') - length('<lender>') -1 )
			 )	<> ''
;

