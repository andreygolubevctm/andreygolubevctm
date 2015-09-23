-- UPDATER 
UPDATE aggregator.features SET field_value='O',description='Optional cover available for the repair or replacement of the front windscreen of your car if it is accidentally broken during the insurance period. No excess will apply for the first windscreen claim made in any one period of insurance.' WHERE productId='REIN-01-02' AND code='windscreen';
UPDATE aggregator.features SET field_value='Y',description='Covers up to $500 for loss or damage to personal items which are designed to be worn or carried.' WHERE productId='REIN-01-02' AND code='personalEf';
UPDATE aggregator.features SET field_value='2 Years',description='' WHERE productId='REIN-01-02' AND code='newRep';
UPDATE aggregator.features SET field_value='Y',description='Guaranteed repairs by repairer appointed by Real Insurance.' WHERE productId='REIN-01-02' AND code='lifRep';

-- CHECKER
SELECT * FROM aggregator.features WHERE code IN ('windscreen','personalEf','newRep','lifRep') AND productId='REIN-01-02' ORDER BY code ASC;

-- ROLLBACK
/*
UPDATE aggregator.features SET field_value='O',description='Optional cover available for the repair or replacement of the windscreen of your car if it is maliciously or accidentally broken during the insurance period. No excess will apply for the first windscreen claim made in any one insurance policy period.' WHERE productId='REIN-01-02' AND code='windscreen';
UPDATE aggregator.features SET field_value='Y',description='Limit $500 for personal property belonging to Insured or family normally residing with Insured which is damaged in same incident, excludes cash negotiable documents or goods connected with any trade business or occupation' WHERE productId='REIN-01-02' AND code='personalEf';
UPDATE aggregator.features SET field_value='2 Year Optional',description='Real Insurance offer a 24 month option at an additional cost.' WHERE productId='REIN-01-02' AND code='newRep';
UPDATE aggregator.features SET field_value='Y',description='Guaranteed repairs by repairers appointed by Real Insurance.' WHERE productId='REIN-01-02' AND code='lifRep';
*/