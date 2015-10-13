SELECT * FROM ctm.stylecode_provider_exclusions WHERE NOW() BETWEEN excludeDateFrom AND excludeDateTo

-- 
-- ADD EXCLUSIONS
-- 

-- CAR, vertical=3
insert into ctm.stylecode_provider_exclusions (styleCodeId, verticalId, providerId, excludeDateFrom, excludeDateTo)
select distinct 0 as styleCodeId, /*p.providerCode,*/ (select verticalId from ctm.vertical_master where verticalCode = 'CAR') verticalId, p.providerId,
'2015-09-30 00:00:00', '2015-10-01 00:00:00' from ctm.provider_master p join ctm.car_product cp on p.providerId = cp.providerId where p.providerCode not in ('AI', 'WOOL', 'REAL');

-- HNC, vertical=7
insert into ctm.stylecode_provider_exclusions (styleCodeId, verticalId, providerId, excludeDateFrom, excludeDateTo)
select distinct 0 as styleCodeId, /*p.providerCode,*/ (select verticalId from ctm.vertical_master where verticalCode = 'HOME') verticalId, p.providerId,
'2015-09-30 00:00:00', '2015-10-01 00:00:00' from ctm.provider_master p join ctm.home_product hp on p.providerId = hp.providerId where p.providerCode not in ('WOOL', 'REAL');

-- 
-- DISABLE EXCLUSIONS
-- 
/*
-- Leto's version

UPDATE `ctm`.`stylecode_provider_exclusions` SET `excludeDateTo`='2015-09-30 10:00:00' WHERE `styleCodeId`='0' and`providerId`='44';
UPDATE `ctm`.`stylecode_provider_exclusions` SET `excludeDateTo`='2015-09-30 10:00:00' WHERE `styleCodeId`='0' and`providerId`='50';
UPDATE `ctm`.`stylecode_provider_exclusions` SET `excludeDateTo`='2015-09-30 10:00:00' WHERE `styleCodeId`='0' and`providerId`='54';
UPDATE `ctm`.`stylecode_provider_exclusions` SET `excludeDateTo`='2015-09-30 10:00:00' WHERE `styleCodeId`='0' and`providerId`='55';
UPDATE `ctm`.`stylecode_provider_exclusions` SET `excludeDateTo`='2015-09-30 10:00:00' WHERE `styleCodeId`='0' and`providerId`='60';
UPDATE `ctm`.`stylecode_provider_exclusions` SET `excludeDateTo`='2015-09-30 10:00:00' WHERE `styleCodeId`='0' and`providerId`='63';
UPDATE `ctm`.`stylecode_provider_exclusions` SET `excludeDateTo`='2015-09-30 10:00:00' WHERE `styleCodeId`='0' and`providerId`='72';
UPDATE `ctm`.`stylecode_provider_exclusions` SET `excludeDateTo`='2015-09-30 10:00:00' WHERE `styleCodeId`='0' and`providerId`='78';
UPDATE `ctm`.`stylecode_provider_exclusions` SET `excludeDateTo`='2015-09-30 10:00:00' WHERE `styleCodeId`='0' and`providerId`='311';
UPDATE `ctm`.`stylecode_provider_exclusions` SET `excludeDateTo`='2015-09-30 10:00:00' WHERE `styleCodeId`='0' and`providerId`='403';
UPDATE `ctm`.`stylecode_provider_exclusions` SET `excludeDateTo`='2015-09-30 10:00:00' WHERE `styleCodeId`='0' and`providerId`='54';
UPDATE `ctm`.`stylecode_provider_exclusions` SET `excludeDateTo`='2015-09-30 10:00:00' WHERE `styleCodeId`='0' and`providerId`='78';
UPDATE `ctm`.`stylecode_provider_exclusions` SET `excludeDateTo`='2015-09-30 10:00:00' WHERE `styleCodeId`='0' and`providerId`='311';

-- Carlos' version

update ctm.stylecode_provider_exclusions s set s.excludeDateTo = '2015-09-30 10:20:00' 
where exists (select a.* from 
(select distinct 0 as styleCodeId, (select verticalId from ctm.vertical_master where verticalCode = 'CAR') verticalId, p.providerId,
'2015-09-30 00:00:00' excludeDateFrom, '2015-10-01 00:00:00' excludeDateTo from ctm.provider_master p join ctm.car_product cp on p.providerId = cp.providerId where p.providerCode not in ('AI', 'WOOL', 'REAL')) as a
where a.styleCodeId = s.styleCodeId and a.verticalId = s.verticalId and a.providerId = s.providerId and a.excludeDateFrom = s.excludeDateFrom and a.excludeDateTo = s.excludeDateTo
);

update ctm.stylecode_provider_exclusions s set s.excludeDateTo = '2015-09-30 10:20:00'
where exists (select a.* from 
(select distinct 0 as styleCodeId, (select verticalId from ctm.vertical_master where verticalCode = 'HOME') verticalId, p.providerId,
'2015-09-30 00:00:00' excludeDateFrom, '2015-10-01 00:00:00' excludeDateTo from ctm.provider_master p join ctm.home_product hp on p.providerId = hp.providerId where p.providerCode not in ('WOOL', 'REAL')) as a
where a.styleCodeId = s.styleCodeId and a.verticalId = s.verticalId and a.providerId = s.providerId and a.excludeDateFrom = s.excludeDateFrom and a.excludeDateTo = s.excludeDateTo
);

*/