-- Run this before deployment
ALTER ONLINE TABLE aggregator.email_master CHANGE brand brand VARCHAR(4);

-- RUN THE FOLLOWING IN THE NEXT CYCLE.
-- Following two SQL must be zero before running other SQL statements.
select * from aggregator.email_master where styleCodeId is null group by emailAddress having count(*) > 1;
select count(*) from aggregator.email_master em join ctm.stylecodes sc on em.brand=sc.styleCode where sc.styleCodeId is null
and emailId not in (SELECT emailId from aggregator.email_master em1 where em.emailAddress=em1.emailAddress and em1.styleCodeId=sc.styleCodeId);

-- It returns the number of rows that should be updated
select count(*) from aggregator.email_master where styleCodeId is null;

UPDATE aggregator.email_master em SET em.styleCodeId = (select sc.styleCodeId from ctm.stylecodes sc where lower(sc.styleCode)=lower(em.brand)) WHERE em.styleCodeId IS NULL;

ALTER ONLINE TABLE aggregator.email_master DROP COLUMN brand;

