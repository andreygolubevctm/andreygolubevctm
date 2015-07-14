/*tester expect 1*/
select count(*) from ctm.country_master where countryName like 'Bali';

delete from ctm.country_master where isoCode = 'BAL' LIMIT 1;

/* tester expect 0*/
select count(*) from ctm.country_master where countryName like 'Bali';

/* roll back 
insert into ctm.country_master (isoCode,countryName) values ('ID','Bali');
*/
