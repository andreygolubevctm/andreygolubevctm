-- UPDATER 
UPDATE aggregator.features SET field_value='O',description='Optional cover available for the repair or replacement of the front windscreen of your car if it is accidentally broken or damaged during the insurance period. No excess will apply for the first windscreen claim made in any one period of insurance.' WHERE productId='REIN-01-01' AND code='windscreen';

-- CHECKER
SELECT * FROM aggregator.features WHERE code='windscreen' AND productId='REIN-01-01' ORDER BY code ASC;

-- ROLLBACK
/*
UPDATE aggregator.features SET field_value='O',description='Optional cover available for the repair or replacement of the front windscreen of your car if it is accidentally broken during the insurance period. No excess will apply for the first windscreen claim made in any one period of insurance.' WHERE productId='REIN-01-01' AND code='windscreen';
*/