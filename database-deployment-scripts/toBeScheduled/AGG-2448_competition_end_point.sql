ALTER TABLE ctm.competition ADD COLUMN reference VARCHAR(8) NULL AFTER styleCodeId;
ALTER TABLE ctm.competition ADD COLUMN returnUrl VARCHAR(128) NULL AFTER reference;
ALTER TABLE ctm.competition ADD COLUMN competitionSource VARCHAR(20) NULL AFTER competitionName;

UPDATE ctm.competition SET competitionSource='RobeOfBugundy' WHERE competitionId=1;
UPDATE ctm.competition SET competitionSource='OctPromo1000grubs' WHERE competitionId=2;
UPDATE ctm.competition SET competitionSource='OctHealthNWealthy' WHERE competitionId=3;
UPDATE ctm.competition SET competitionSource='NovHealthNWealthy' WHERE competitionId=4;
UPDATE ctm.competition SET competitionSource='12DaysChristmas2013' WHERE competitionId=5;
UPDATE ctm.competition SET competitionSource='H&CPreSignup' WHERE competitionId=6;
UPDATE ctm.competition SET competitionSource='LoveThePump' WHERE competitionId=7;
UPDATE ctm.competition SET competitionSource='$1000PromoJune2014' WHERE competitionId=8;
UPDATE ctm.competition SET competitionSource='AugFuel2014$1000' WHERE competitionId=9;
UPDATE ctm.competition SET competitionSource='AugHealth2014$1000' WHERE competitionId=10;
UPDATE ctm.competition SET competitionSource='Car$1000Oct2014' WHERE competitionId=11;
UPDATE ctm.competition SET competitionSource='NovHealth2014$1000' WHERE competitionId=12;
UPDATE ctm.competition SET competitionSource='Life$1000CashNov2014' WHERE competitionId=13;
UPDATE ctm.competition SET competitionSource='Energy$1000Jan2015' WHERE competitionId=14;
UPDATE ctm.competition SET competitionSource='Feb2015HealthJEEP' WHERE competitionId=15;
UPDATE ctm.competition SET competitionSource='FebHealth2015$1000' WHERE competitionId=16;
UPDATE ctm.competition SET competitionSource='Life$1000CashFeb2015' WHERE competitionId=17;
UPDATE ctm.competition SET competitionSource='CC$1000CashApril2015' WHERE competitionId=18;
UPDATE ctm.competition SET competitionSource='MayHealth2015$1000' WHERE competitionId=19;
UPDATE ctm.competition SET competitionSource='YHOO-May2015$1000' WHERE competitionId=20;
UPDATE ctm.competition SET competitionSource='Energy$1000May2015' WHERE competitionId=21;
UPDATE ctm.competition SET competitionSource='Life$1000June2015' WHERE competitionId=22;

UPDATE ctm.competition SET reference=SUBSTRING(MD5(competitionSource),1,8);

ALTER TABLE ctm.competition CHANGE COLUMN competitionSource competitionSource VARCHAR(64) NOT NULL;


INSERT INTO ctm.competition (competitionId, styleCodeId, competitionName, competitionSource, reference, returnUrl, effectiveStart, effectiveEnd) VALUES (23, 1, 'Sergei Spy Kit', 'SergeiSpyKit', SUBSTRING(MD5('SergeiSpyKit'),1,8), 'http://qa.comparethemarket.com.au/meerkat/mission-impawsible/thankyou/','2015-07-09 07:00:00','2015-08-06 06:59:59');

INSERT INTO ctm.content_control (styleCodeId, verticalId, contentCode, contentKey, contentValue, effectiveStart, effectiveEnd) VALUES (1, 12, 'Competition', 'competitionBanner', 'http://www.comparethemarket.com.au/meerkat/wp-content/uploads/2015/06/banner.jpg','2015-07-09 07:00:00','2015-08-06 06:59:59');
INSERT INTO ctm.content_control (styleCodeId, verticalId, contentCode, contentKey, contentValue, effectiveStart, effectiveEnd) VALUES (1, 12, 'Competition', 'competitionDetails', '	<p style="font-size:16px;line-height:22px;">Spy kit includes many devices Sergei used during mission, which can now be yours. Including:</p>	<ul class="items">		<li>One-of-a-kind decoy Sergei toy</li>		<li>Walkie talkies</li>		<li>Stethoscopamajig</li>		<li>“World’s greatest spykat” mug</li>		<li>Spy costume</li>		<li>Fancy video recording pen</li>		<li>Tiny safe, for safe keeping</li>	</ul>	<p style="font-size:16px;line-height:22px;padding-bottom:20px;">If you would like to win Sergei''s old spy kit, please fill in forms.</p>','2015-07-09 07:00:00','2015-08-06 06:59:59');
INSERT INTO ctm.content_control (styleCodeId, verticalId, contentCode, contentKey, contentValue, effectiveStart, effectiveEnd) VALUES (1, 12, 'Competition', 'competitionCode', '482d195d','2015-07-09 07:00:00','2015-08-06 06:59:59');
INSERT INTO ctm.content_control (styleCodeId, verticalId, contentCode, contentKey, contentValue, effectiveStart, effectiveEnd) VALUES (1, 12, 'Competition', 'competitionTermsUrl', 'http://www.comparethemeerkat.com.au/competition/spy-kit-termsandconditions.pdf','2015-07-09 07:00:00','2015-08-06 06:59:59');

INSERT INTO ctm.configuration (`configCode`, `environmentCode`, `styleCodeId`, `verticalId`, `configValue`) VALUES ('exitUrl', '0', 1, 12, 'http://www.comparethemeerkat.com.au/');
INSERT INTO ctm.configuration (`configCode`, `environmentCode`, `styleCodeId`, `verticalId`, `configValue`) VALUES ('brandName', '0', 1, 12, 'Compare the Meerkat Australia');
INSERT INTO ctm.configuration (`configCode`, `environmentCode`, `styleCodeId`, `verticalId`, `configValue`) VALUES ('windowTitle', '0', 1, 12, 'Compare the Meerkat Australia');
