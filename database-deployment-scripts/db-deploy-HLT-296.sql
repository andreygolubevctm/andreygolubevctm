534162
539888
541341
556560

INSERT INTO aggregator.transaction_header
			(TransactionId,rootId,PreviousId,ProductType,emailAddress,ipAddress,startDate,startTime,styleCode,advertKey,sessionId,status)
values (0,0,OLD_ID,'HEALTH',
(
SELECT textValue FROM aggregator.transaction_details td
WHERE   td.transactionId  = OLD_ID
and xpath like 'health/contactDetails/email' LIMIT 1),
'',
(SELECT Min(t.date) FROM ctm.touches t
where transaction_id = OLD_ID),(SELECT Min(t.time) FROM ctm.touches t
where transaction_id = OLD_ID),'CTM',0,'','');

SELECT * FROM aggregator.transaction_header
WHERE previousId = OLD_ID;

UPDATE aggregator.transaction_header
SET previousId = 0
where transactionid = NEW_ID;

UPDATE ctm.touches
SET transaction_id = NEW_ID
where transaction_id = OLD_ID;

SELECT *
FROM  ctm.touches
where transaction_id = NEW_ID;

UPDATE aggregator.transaction_details
SET transactionid = NEW_ID
where transactionid = OLD_ID;

SELECT * FROM aggregator.transaction_details
where transactionid = NEW_ID;