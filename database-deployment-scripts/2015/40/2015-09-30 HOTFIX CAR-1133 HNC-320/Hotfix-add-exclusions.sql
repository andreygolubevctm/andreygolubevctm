SELECT * FROM ctm.stylecode_provider_exclusions;

-- CAR, vertical=3
insert into ctm.stylecode_provider_exclusions (styleCodeId, verticalId, providerId, excludeDateFrom, excludeDateTo)
select distinct 0 as styleCodeId, /*p.providerCode,*/ (select verticalId from ctm.vertical_master where verticalCode = 'CAR') verticalId, p.providerId,
'2015-09-30 00:00:00', '2015-10-01 00:00:00' from ctm.provider_master p join ctm.car_product cp on p.providerId = cp.providerId where p.providerCode not in ('AI', 'WOOL', 'REAL');

-- HNC, vertical=7
insert into ctm.stylecode_provider_exclusions (styleCodeId, verticalId, providerId, excludeDateFrom, excludeDateTo)
select distinct 0 as styleCodeId, /*p.providerCode,*/ (select verticalId from ctm.vertical_master where verticalCode = 'HOME') verticalId, p.providerId,
'2015-09-30 00:00:00', '2015-10-01 00:00:00' from ctm.provider_master p join ctm.home_product hp on p.providerId = hp.providerId where p.providerCode not in ('WOOL', 'REAL');
