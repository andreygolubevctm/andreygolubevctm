-- TO BE RUN ONLY ON NXQ ANY OTHER ENVIRONMENT IGNORE
-- TO BE RUN ONLY ON NXQ ANY OTHER ENVIRONMENT IGNORE
-- TO BE RUN ONLY ON NXQ ANY OTHER ENVIRONMENT IGNORE


UPDATE ctm.content_control SET effectiveStart='2015-12-10' WHERE verticalId IN (6,8) AND contentkey='footerParticipatingSuppliers' AND effectiveStart='2015-12-15 07:00:00' limit 2;

-- test expect 2
select count(*) from ctm.content_control where effectiveStart='2015-12-10' and verticalId in (6,8) and contentKey = 'footerParticipatingSuppliers';

-- rollback
-- update ctm.content_control set effectiveStart='2015-12-15 07:00:00' where verticalId in (6,8) and contentkey='footerParticipatingSuppliers' AND effectiveStart='2015-12-10' limit 2;
-- test expect 2
-- select count(*) from ctm.content_control where effectiveStart='2015-12-15 07:00:00' and verticalId in (6,8) and contentKey = 'footerParticipatingSuppliers';