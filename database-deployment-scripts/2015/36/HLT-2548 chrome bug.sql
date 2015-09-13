/* Hospital */
UPDATE `aggregator`.`features_details` SET `sequence`='3' WHERE `shortlistKey`='PlasticNonCosmetic';
UPDATE `aggregator`.`features_details` SET `sequence`='4' WHERE `shortlistKey`='PuHospital';
UPDATE `aggregator`.`features_details` SET `sequence`='5' WHERE `shortlistKey`='Sterilisation';
UPDATE `aggregator`.`features_details` SET `sequence`='6' WHERE `shortlistKey`='Cardiac';
UPDATE `aggregator`.`features_details` SET `sequence`='8' WHERE `shortlistKey`='Obstetric';
UPDATE `aggregator`.`features_details` SET `sequence`='10' WHERE `shortlistKey`='AssistedReproductive';
UPDATE `aggregator`.`features_details` SET `sequence`='12' WHERE `shortlistKey`='CataractEyeLens';
UPDATE `aggregator`.`features_details` SET `sequence`='14' WHERE `shortlistKey`='JointReplacement';
UPDATE `aggregator`.`features_details` SET `sequence`='7' WHERE `shortlistKey`='GastricBanding';
UPDATE `aggregator`.`features_details` SET `sequence`='9' WHERE `shortlistKey`='RenalDialysis';
UPDATE `aggregator`.`features_details` SET `sequence`='11' WHERE `shortlistKey`='Palliative';
UPDATE `aggregator`.`features_details` SET `sequence`='13' WHERE `shortlistKey`='Psychiatric';

/* Extra */
UPDATE `aggregator`.`features_details` SET `sequence`='5' WHERE `shortlistKey`='Endodontic';
UPDATE `aggregator`.`features_details` SET `sequence`='7' WHERE `shortlistKey`='Orthodontic';
UPDATE `aggregator`.`features_details` SET `sequence`='9' WHERE `shortlistKey`='Optical';
UPDATE `aggregator`.`features_details` SET `sequence`='11' WHERE `shortlistKey`='Physiotherapy';
UPDATE `aggregator`.`features_details` SET `sequence`='13' WHERE `shortlistKey`='Chiropractic';
UPDATE `aggregator`.`features_details` SET `sequence`='15' WHERE `shortlistKey`='Podiatry';
UPDATE `aggregator`.`features_details` SET `sequence`='17' WHERE `shortlistKey`='Acupuncture';
UPDATE `aggregator`.`features_details` SET `sequence`='19' WHERE `shortlistKey`='Naturopath';
UPDATE `aggregator`.`features_details` SET `sequence`='21' WHERE `shortlistKey`='Massage';
UPDATE `aggregator`.`features_details` SET `sequence`='2' WHERE `shortlistKey`='Psychology';
UPDATE `aggregator`.`features_details` SET `sequence`='4' WHERE `shortlistKey`='GlucoseMonitor';
UPDATE `aggregator`.`features_details` SET `sequence`='6' WHERE `shortlistKey`='HearingAid';
UPDATE `aggregator`.`features_details` SET `sequence`='8' WHERE `shortlistKey`='NonPBS';
UPDATE `aggregator`.`features_details` SET `sequence`='10' WHERE `shortlistKey`='Orthotics';
UPDATE `aggregator`.`features_details` SET `sequence`='12' WHERE `shortlistKey`='SpeechTherapy';
UPDATE `aggregator`.`features_details` SET `sequence`='14' WHERE `shortlistKey`='OccupationalTherapy';
UPDATE `aggregator`.`features_details` SET `sequence`='16' WHERE `shortlistKey`='Dietetics';
UPDATE `aggregator`.`features_details` SET `sequence`='18' WHERE `shortlistKey`='EyeTherapy';
UPDATE `aggregator`.`features_details` SET `sequence`='20' WHERE `shortlistKey`='LifestyleProducts';


/* ROLL BACK

-- Hospital
UPDATE `aggregator`.`features_details` SET `sequence`='9' WHERE `shortlistKey`='PlasticNonCosmetic';
UPDATE `aggregator`.`features_details` SET `sequence`='3' WHERE `shortlistKey`='PuHospital';
UPDATE `aggregator`.`features_details` SET `sequence`='10' WHERE `shortlistKey`='Sterilisation';
UPDATE `aggregator`.`features_details` SET `sequence`='4' WHERE `shortlistKey`='Cardiac';
UPDATE `aggregator`.`features_details` SET `sequence`='5' WHERE `shortlistKey`='Obstetric';
UPDATE `aggregator`.`features_details` SET `sequence`='6' WHERE `shortlistKey`='AssistedReproductive';
UPDATE `aggregator`.`features_details` SET `sequence`='7' WHERE `shortlistKey`='CataractEyeLens';
UPDATE `aggregator`.`features_details` SET `sequence`='8' WHERE `shortlistKey`='JointReplacement';
UPDATE `aggregator`.`features_details` SET `sequence`='11' WHERE `shortlistKey`='GastricBanding';
UPDATE `aggregator`.`features_details` SET `sequence`='12' WHERE `shortlistKey`='RenalDialysis';
UPDATE `aggregator`.`features_details` SET `sequence`='13' WHERE `shortlistKey`='Palliative';
UPDATE `aggregator`.`features_details` SET `sequence`='14' WHERE `shortlistKey`='Psychiatric';

-- Extra
UPDATE `aggregator`.`features_details` SET `sequence`='4' WHERE `shortlistKey`='Endodontic';
UPDATE `aggregator`.`features_details` SET `sequence`='5' WHERE `shortlistKey`='Orthodontic';
UPDATE `aggregator`.`features_details` SET `sequence`='6' WHERE `shortlistKey`='Optical';
UPDATE `aggregator`.`features_details` SET `sequence`='7' WHERE `shortlistKey`='Physiotherapy';
UPDATE `aggregator`.`features_details` SET `sequence`='8' WHERE `shortlistKey`='Chiropractic';
UPDATE `aggregator`.`features_details` SET `sequence`='9' WHERE `shortlistKey`='Podiatry';
UPDATE `aggregator`.`features_details` SET `sequence`='10' WHERE `shortlistKey`='Acupuncture';
UPDATE `aggregator`.`features_details` SET `sequence`='11' WHERE `shortlistKey`='Naturopath';
UPDATE `aggregator`.`features_details` SET `sequence`='12' WHERE `shortlistKey`='Massage';
UPDATE `aggregator`.`features_details` SET `sequence`='13' WHERE `shortlistKey`='Psychology';
UPDATE `aggregator`.`features_details` SET `sequence`='14' WHERE `shortlistKey`='GlucoseMonitor';
UPDATE `aggregator`.`features_details` SET `sequence`='15' WHERE `shortlistKey`='HearingAid';
UPDATE `aggregator`.`features_details` SET `sequence`='16' WHERE `shortlistKey`='NonPBS';
UPDATE `aggregator`.`features_details` SET `sequence`='17' WHERE `shortlistKey`='Orthotics';
UPDATE `aggregator`.`features_details` SET `sequence`='18' WHERE `shortlistKey`='SpeechTherapy';
UPDATE `aggregator`.`features_details` SET `sequence`='19' WHERE `shortlistKey`='OccupationalTherapy';
UPDATE `aggregator`.`features_details` SET `sequence`='20' WHERE `shortlistKey`='Dietetics';
UPDATE `aggregator`.`features_details` SET `sequence`='21' WHERE `shortlistKey`='EyeTherapy';
UPDATE `aggregator`.`features_details` SET `sequence`='22' WHERE `shortlistKey`='LifestyleProducts';

*/