-- UPDATER
SET @hospitalId = (SELECT id FROM aggregator.features_details WHERE Name = 'Hospital Cover' AND type='section' AND vertical='health' AND className='hospitalCover');
SET @extrasId = (SELECT id FROM aggregator.features_details WHERE Name = 'Extras Cover' AND type='section' AND vertical='health' AND className='extrasCover');
UPDATE aggregator.features_details SET extraText = 'click to view all <strong>HOSPITAL COVER</strong> inclusions, exclusions and restrictions' WHERE id=@hospitalId;
UPDATE aggregator.features_details SET extraText = 'click to view all <strong>EXTRAS COVER</strong> inclusions, exclusions and restrictions' WHERE id=@extrasId;

-- CHECKER - after update the extraText will end with ', exclusions and restrictions'
SELECT className, extraText FROM aggregator.features_details WHERE Name IN ('Hospital Cover','Extras Cover') AND type='section' AND vertical='health' AND className IN ('hospitalCover','extrasCover');

/* ROLLBACK
SET @hospitalId = (SELECT id FROM aggregator.features_details WHERE Name = 'Hospital Cover' AND type='section' AND vertical='health' AND className='hospitalCover');
SET @extrasId = (SELECT id FROM aggregator.features_details WHERE Name = 'Extras Cover' AND type='section' AND vertical='health' AND className='extrasCover');
UPDATE aggregator.features_details SET extraText = 'click to view all <strong>HOSPITAL COVER</strong> inclusions' WHERE id=@hospitalId;
UPDATE aggregator.features_details SET extraText = 'click to view all <strong>EXTRAS COVER</strong> inclusions' WHERE id=@extrasId;
*/