/**
  *
  * AHM RULES
  *
  **/
INSERT INTO `ctm`.`health_provider_rules` (`providerId`, `effectiveStart`, `effectiveEnd`, `middleNameAsked`, `commencementDateStartOffset`, `commencementDateEndOffset`, `receiveInformationAsked`, `emailAddressMandatory`, `ageMinimum`, `ageMaximum`, `previousFundMemberIdRule`, `previousFundMemberIdMaximumLength`, `medicareDetailsMandatory`, `governmentRebateFormAsked`, `primaryPreviousFundAuthorityAsked`, `partnerPreviousFundAuthorityAsked`, `partnerFundAuthorityAsked`, `provideBankDetailsForRefundsRule`, `dependantsIntroductionText`, `dependantsAgeMinimum`, `dependantsAgeMaximum`, `creditCardGateway`, `declarationLabel`)
VALUES
  (9, '2015-11-01', '2040-01-01', 0, 0, 28, 0, 1, 16, 120, 'MANDATORY', 10, 0, 1, 1, 1, 0,
   'OPTIONAL',
   'ahm Health Insurance provides cover for your children up to the age of 21 plus students who are single and studying full time aged between 21 and 25. Adult dependants outside this criteria can be covered by an additional premium on certain covers so please call Compare the Market on 1800777712 or chat to our consultants online to discuss your health cover needs.',
   0, 25, 'WESTPAC',
   'I can confirm that I have read and understood the Join Declaration and the information relating to my product choice. I declare that the information I have provided is true and correct.'
  );

SET @PARENT_ROW = (SELECT `healthProviderRulesId` FROM `ctm`.`health_provider_rules` WHERE providerId = 9);
/*
INSERT INTO ctm.health_provider_rules_declarations (`healthProviderRulesId`, `label`)
VALUES
  (@PARENT_ROW,
   'I can confirm that I have read and understood the Join Declaration and the information relating to my product choice. I declare that the information I have provided is true and correct.');
*/
INSERT INTO `ctm`.`health_provider_rules_deductions` (`healthProviderRulesId`, `selectionLabel`, `selectionValue`, `optionsLength`, `dateCalculationsStartFrom`, `dateCalculationStartOffset`, `dateCalculationsAcceptableDays`, `dateCalculationsIncludeWeekends`)
VALUES (@PARENT_ROW, 'DAY', 'DATE', 28, 'COVER_START', 3, '1-28', 1);

INSERT INTO `ctm`.`health_provider_rules_dependant_schools` (`healthProviderRulesId`, `schoolAgeMinimum`, `mustBeFullTimeStudent`, `schoolNameInputMethod`, `schoolNameLabel`, `studentIdRule`, `studentIdMaximumLength`, `commencedDateRule`, `apprenticeRule`)
VALUES (@PARENT_ROW, 21, 0, 'SELECT', 'Tertiary Institution this dependant is attending', 'MANDATORY', 10, 'MANDATORY', 'FALSE');

INSERT INTO `ctm`.`health_provider_rules_payment_frequencies` (`healthProviderRulesId`, `type`,  `weekly`, `fortnightly`, `monthly`, `quarterly`, `halfYearly`, `annually`)
VALUES (@PARENT_ROW, 'CC', 1, 1, 1, 1, 1, 1);

INSERT INTO `ctm`.`health_provider_rules_payment_frequencies` (`healthProviderRulesId`, `type`,  `weekly`, `fortnightly`, `monthly`, `quarterly`, `halfYearly`, `annually`)
VALUES (@PARENT_ROW, 'BANK', 1, 1, 1, 1, 1, 1);

/** END AHM **/

/**
  *
  * AUF RULES
  *
  **/
INSERT INTO `ctm`.`health_provider_rules` (`providerId`, `effectiveStart`, `effectiveEnd`, `middleNameAsked`, `commencementDateStartOffset`, `commencementDateEndOffset`, `receiveInformationAsked`, `emailAddressMandatory`, `ageMinimum`, `ageMaximum`, `previousFundMemberIdRule`, `previousFundMemberIdMaximumLength`, `medicareDetailsMandatory`, `governmentRebateFormAsked`, `primaryPreviousFundAuthorityAsked`, `partnerPreviousFundAuthorityAsked`, `partnerFundAuthorityAsked`, `provideBankDetailsForRefundsRule`, `dependantsIntroductionText`, `dependantsAgeMinimum`, `dependantsAgeMaximum`, `creditCardGateway`, `declarationLabel`)
VALUES
  (1, '2015-11-01', '2040-01-01',
   0, /* middleNameAsked */
   0, /* commencementDateStartOffset */
   30, /* commencementDateEndOffset */
   0, /* receiveInformationAsked */
   1, /* emailAddressMandatory */
   16, /* ageMinimum */
   120, /* ageMaximum */
   'MANDATORY',  /* previousFundMemberIdRule */
   50,  /* previousFundMemberIdMaximumLength */
   0,  /* medicareDetailsMandatory */
   0,  /* governmentRebateFormAsked */
   0,  /* primaryPreviousFundAuthorityAsked */
   0,  /* partnerPreviousFundAuthorityAsked */
   0, /* partnerFundAuthorityAsked */
   'FALSE', /* provideBankDetailsForRefundsRule */
   'This policy provides cover for children under the age of 23 or who are aged between 23-25 years and engaged in full time study. Student dependants do not need to be living at home to be added to the policy. Adult dependants outside these criteria can still be covered by applying for a separate singles policy.',
   0,  /* dependantsAgeMinimum */
   25,  /* dependantsAgeMaximum */
   'INLINE', /* creditCardGateway */
   null /* declarationLabel */
  );

SET @PARENT_ROW = (SELECT `healthProviderRulesId` FROM `ctm`.`health_provider_rules` WHERE providerId = 1);

INSERT INTO `ctm`.`health_provider_rules_deductions` (`healthProviderRulesId`, `selectionLabel`, `selectionValue`, `optionsLength`, `dateCalculationsStartFrom`, `dateCalculationStartOffset`, `dateCalculationsAcceptableDays`, `dateCalculationsIncludeWeekends`)
VALUES (@PARENT_ROW, 'DAY', 'DATE', 5, 'COVER_START', 0, '1-31', 0);

INSERT INTO `ctm`.`health_provider_rules_dependant_schools` (`healthProviderRulesId`, `schoolAgeMinimum`, `mustBeFullTimeStudent`, `schoolNameInputMethod`, `schoolNameLabel`, `studentIdRule`, `studentIdMaximumLength`, `commencedDateRule`, `apprenticeRule`)
VALUES (@PARENT_ROW,
        21, /* schoolAgeMinimum */
        0, /* mustBeFullTimeStudent */
        'TEXT_INPUT', /* schoolNameInputMethod */
        'Name of school your child is attending', /* schoolNameLabel */
        'FALSE', /* studentIdRule */
        null, /* studentIdMaximumLength*/
        'FALSE', /* commencedDateRule */
        'FALSE' /* apprenticeRule */
);

INSERT INTO `ctm`.`health_provider_rules_payment_frequencies` (`healthProviderRulesId`, `type`,  `weekly`, `fortnightly`, `monthly`, `quarterly`, `halfYearly`, `annually`)
VALUES (@PARENT_ROW, 'CC', 0, 0, 1, 1, 0, 1);

INSERT INTO `ctm`.`health_provider_rules_payment_frequencies` (`healthProviderRulesId`, `type`,  `weekly`, `fortnightly`, `monthly`, `quarterly`, `halfYearly`, `annually`)
VALUES (@PARENT_ROW, 'BANK', 0, 0, 1, 1, 0, 1);

INSERT INTO `ctm`.`health_provider_rules_inline_creditcards` (`healthProviderRulesId`, `visa`, `mastercard`, `amex`, `diners`) VALUES (@PARENT_ROW, 1,1,0,0);


/** END AUF **/

/**
  *
  * BUD RULES
  *
  **/
INSERT INTO `ctm`.`health_provider_rules` (`providerId`, `effectiveStart`, `effectiveEnd`, `middleNameAsked`, `commencementDateStartOffset`, `commencementDateEndOffset`, `receiveInformationAsked`, `emailAddressMandatory`, `ageMinimum`, `ageMaximum`, `previousFundMemberIdRule`, `previousFundMemberIdMaximumLength`, `medicareDetailsMandatory`, `governmentRebateFormAsked`, `primaryPreviousFundAuthorityAsked`, `partnerPreviousFundAuthorityAsked`, `partnerFundAuthorityAsked`, `provideBankDetailsForRefundsRule`, `dependantsIntroductionText`, `dependantsAgeMinimum`, `dependantsAgeMaximum`, `creditCardGateway`, `declarationLabel`)
VALUES
  (54, '2015-11-01', '2040-01-01',
   0, /* middleNameAsked */
   0, /* commencementDateStartOffset */
   60, /* commencementDateEndOffset */
   0, /* receiveInformationAsked */
   1, /* emailAddressMandatory */
   17, /* ageMinimum */
   120, /* ageMaximum */
   'MANDATORY',  /* previousFundMemberIdRule */
   50,  /* previousFundMemberIdMaximumLength */
   1,  /* medicareDetailsMandatory */
   0,  /* governmentRebateFormAsked */
   1,  /* primaryPreviousFundAuthorityAsked */
   0,  /* partnerPreviousFundAuthorityAsked */
   0, /* partnerFundAuthorityAsked */
   'FALSE', /* provideBankDetailsForRefundsRule */
   'This policy provides cover for children until their 21st birthday. Adult dependants over 21 years old can be covered by applying for a separate singles policy.',
   0,  /* dependantsAgeMinimum */
   21,  /* dependantsAgeMaximum */
   'INLINE', /* creditCardGateway */
   'I can confirm that I have read and understood the Join Declaration and the information relating to my product choice. I declare that the information I have provided is true and correct.' /* declarationLabel */
  );

SET @PARENT_ROW = (SELECT `healthProviderRulesId` FROM `ctm`.`health_provider_rules` WHERE providerId = 54);

INSERT INTO `ctm`.`health_provider_rules_deductions` (`healthProviderRulesId`, `deductionText`)
VALUES (@PARENT_ROW, 'Monthly Payments:
Cover start date today – Your first payment will be debited in the next 24 hours and thereafter on the same day each month.
Cover starts later than today - Your first payment will be debited on the policy start date and thereafter on the same day each month.
Annual Payments:
Cover start date today – Your payment will be debited in the next 24 hours.
Cover starts later than today – Your payment will be debited on your policy start date.');


INSERT INTO `ctm`.`health_provider_rules_payment_frequencies` (`healthProviderRulesId`, `type`,  `weekly`, `fortnightly`, `monthly`, `quarterly`, `halfYearly`, `annually`)
VALUES (@PARENT_ROW, 'CC', 0, 1, 1, 0, 0, 1);

INSERT INTO `ctm`.`health_provider_rules_payment_frequencies` (`healthProviderRulesId`, `type`,  `weekly`, `fortnightly`, `monthly`, `quarterly`, `halfYearly`, `annually`)
VALUES (@PARENT_ROW, 'BANK', 0, 1, 1, 0, 0, 1);

INSERT INTO `ctm`.`health_provider_rules_inline_creditcards` (`healthProviderRulesId`, `visa`, `mastercard`, `amex`, `diners`) VALUES (@PARENT_ROW, 1,1,0,0);


/** END BUD **/

/**
  *
  * BUP RULES
  *
  **/
INSERT INTO `ctm`.`health_provider_rules` (`providerId`, `effectiveStart`, `effectiveEnd`, `middleNameAsked`, `commencementDateStartOffset`, `commencementDateEndOffset`, `receiveInformationAsked`, `emailAddressMandatory`, `ageMinimum`, `ageMaximum`, `previousFundMemberIdRule`, `previousFundMemberIdMaximumLength`, `medicareDetailsMandatory`, `governmentRebateFormAsked`, `primaryPreviousFundAuthorityAsked`, `partnerPreviousFundAuthorityAsked`, `partnerFundAuthorityAsked`, `provideBankDetailsForRefundsRule`, `dependantsIntroductionText`, `dependantsAgeMinimum`, `dependantsAgeMaximum`, `creditCardGateway`, `declarationLabel`)
VALUES
  (15, '2015-11-01', '2040-01-01',
   1, /* middleNameAsked */
   0, /* commencementDateStartOffset */
   60, /* commencementDateEndOffset */
   0, /* receiveInformationAsked */
   1, /* emailAddressMandatory */
   17, /* ageMinimum */
   120, /* ageMaximum */
   'FALSE',  /* previousFundMemberIdRule */
   null,  /* previousFundMemberIdMaximumLength */
   1,  /* medicareDetailsMandatory */
   0,  /* governmentRebateFormAsked */
   1,  /* primaryPreviousFundAuthorityAsked */
   1,  /* partnerPreviousFundAuthorityAsked */
   0, /* partnerFundAuthorityAsked */
   'FALSE', /* provideBankDetailsForRefundsRule */
   'Dependent child means a person who does not have a partner and is (i) aged under 21 or (ii) is receiving a full time education at a school, college or university recognised by the company and who is not aged 25 or over.',
   0,  /* dependantsAgeMinimum */
   25,  /* dependantsAgeMaximum */
   'IPP', /* creditCardGateway */
   'I can confirm that I have read and understood the Join Declaration and the information relating to my product choice. I declare that the information I have provided is true and correct.' /* declarationLabel */
  );

SET @PARENT_ROW = (SELECT `healthProviderRulesId` FROM `ctm`.`health_provider_rules` WHERE providerId = 15);

INSERT INTO `ctm`.`health_provider_rules_deductions` (`healthProviderRulesId`, `deductionText`)
VALUES (@PARENT_ROW, 'Your account will be debited within the next 24 hours. Note, fortnightly payments will be charged as one month in advance and fortnightly thereafter.');

INSERT INTO `ctm`.`health_provider_rules_payment_frequencies` (`healthProviderRulesId`, `type`,  `weekly`, `fortnightly`, `monthly`, `quarterly`, `halfYearly`, `annually`)
VALUES (@PARENT_ROW, 'CC', 0, 0, 1, 1, 1, 1);

INSERT INTO `ctm`.`health_provider_rules_payment_frequencies` (`healthProviderRulesId`, `type`,  `weekly`, `fortnightly`, `monthly`, `quarterly`, `halfYearly`, `annually`)
VALUES (@PARENT_ROW, 'BANK', 0, 1, 1, 1, 1, 1);



/** END BUP **/

/**
  *
  * CBH RULES
  *
  **/
INSERT INTO `ctm`.`health_provider_rules` (`providerId`, `effectiveStart`, `effectiveEnd`, `middleNameAsked`, `commencementDateStartOffset`, `commencementDateEndOffset`, `receiveInformationAsked`, `emailAddressMandatory`, `ageMinimum`, `ageMaximum`, `customQuestionSet`, `previousFundMemberIdRule`, `previousFundMemberIdMaximumLength`, `medicareDetailsMandatory`, `governmentRebateFormAsked`, `primaryPreviousFundAuthorityAsked`, `partnerPreviousFundAuthorityAsked`, `partnerFundAuthorityAsked`, `provideBankDetailsForRefundsRule`, `dependantsIntroductionText`, `dependantsAgeMinimum`, `dependantsAgeMaximum`, `creditCardGateway`, `declarationLabel`)
VALUES
  (10, '2015-11-01', '2040-01-01',
   0, /* middleNameAsked */
   0, /* commencementDateStartOffset */
   29, /* commencementDateEndOffset */
   0, /* receiveInformationAsked */
   1, /* emailAddressMandatory */
   16, /* ageMinimum */
   120, /* ageMaximum */
   'CBH', /* custom question */
   'MANDATORY',  /* previousFundMemberIdRule */
   50,  /* previousFundMemberIdMaximumLength */
   0,  /* medicareDetailsMandatory */
   0,  /* governmentRebateFormAsked */
   0,  /* primaryPreviousFundAuthorityAsked */
   0,  /* partnerPreviousFundAuthorityAsked */
   0, /* partnerFundAuthorityAsked */
   'MANDATORY', /* provideBankDetailsForRefundsRule */
   'CBHS policies provide cover for all dependents under the age of 18 including step and foster children. Adult dependents who are aged between 18 and 24 years and who are: studying full time (min 20 hours per week), 1st or 2nd year apprentices or employed on an unpaid internship may continue to be covered by CBHS policies. Other adult dependents can apply for a separate policy (subject to meeting eligibility criteria).',
   0,  /* dependantsAgeMinimum */
   24,  /* dependantsAgeMaximum */
   null, /* creditCardGateway */
   'I can confirm that I have read and understood the Join Declaration and the information relating to my product choice. I declare that the information I have provided is true and correct.' /* declarationLabel */
  );

SET @PARENT_ROW = (SELECT `healthProviderRulesId` FROM `ctm`.`health_provider_rules` WHERE providerId = 10);

INSERT INTO `ctm`.`health_provider_rules_deductions` (`healthProviderRulesId`, `deductionText`)
VALUES (@PARENT_ROW, 'Monthly payments will be deducted on the 15th of each month.
Fortnightly payments will be deducted on a Thursday.');

INSERT INTO `ctm`.`health_provider_rules_dependant_schools` (`healthProviderRulesId`, `schoolAgeMinimum`, `mustBeFullTimeStudent`, `schoolNameInputMethod`, `schoolNameLabel`, `studentIdRule`, `studentIdMaximumLength`, `commencedDateRule`, `apprenticeRule`)
VALUES (@PARENT_ROW, 18, 0, 'TEXT_INPUT', 'Name of school your child is attending', 'FALSE', null, 'FALSE', 'FALSE');

INSERT INTO `ctm`.`health_provider_rules_payment_frequencies` (`healthProviderRulesId`, `type`,  `weekly`, `fortnightly`, `monthly`, `quarterly`, `halfYearly`, `annually`)
VALUES (@PARENT_ROW, 'INVOICE', 0, 0, 0, 1, 1, 1);

INSERT INTO `ctm`.`health_provider_rules_payment_frequencies` (`healthProviderRulesId`, `type`,  `weekly`, `fortnightly`, `monthly`, `quarterly`, `halfYearly`, `annually`)
VALUES (@PARENT_ROW, 'BANK', 0, 1, 1, 0, 0, 0);



/** END CBH **/


/**
  *
  * CUA RULES
  *
  **/
INSERT INTO `ctm`.`health_provider_rules` (`providerId`, `effectiveStart`, `effectiveEnd`, `middleNameAsked`, `commencementDateStartOffset`, `commencementDateEndOffset`, `receiveInformationAsked`, `emailAddressMandatory`, `ageMinimum`, `ageMaximum`, `previousFundMemberIdRule`, `previousFundMemberIdMaximumLength`, `medicareDetailsMandatory`, `governmentRebateFormAsked`, `primaryPreviousFundAuthorityAsked`, `partnerPreviousFundAuthorityAsked`, `partnerFundAuthorityAsked`, `provideBankDetailsForRefundsRule`, `dependantsIntroductionText`, `dependantsAgeMinimum`, `dependantsAgeMaximum`, `creditCardGateway`, `declarationLabel`)
VALUES
  (12, '2015-11-01', '2040-01-01',
   0, /* middleNameAsked */
   0, /* commencementDateStartOffset */
   90, /* commencementDateEndOffset */
   0, /* receiveInformationAsked */
   1, /* emailAddressMandatory */
   16, /* ageMinimum */
   99, /* ageMaximum */
   'MANDATORY',  /* previousFundMemberIdRule */
   10,  /* previousFundMemberIdMaximumLength */
   0,  /* medicareDetailsMandatory */
   0,  /* governmentRebateFormAsked */
   1,  /* primaryPreviousFundAuthorityAsked */
   1,  /* partnerPreviousFundAuthorityAsked */
   1, /* partnerFundAuthorityAsked */
   'OPTIONAL', /* provideBankDetailsForRefundsRule */
   'Family policies provide cover for the policy holder, their spouse and any dependant children/young adults until their 23rd birthday. Full-time student dependants are covered up until they turn 25. Student dependants must be registered each year from when they turn 23 years of age.',
   0,  /* dependantsAgeMinimum */
   25,  /* dependantsAgeMaximum */
   'NAB', /* creditCardGateway */
   'I can confirm that I have read and understood the Join Declaration and the information relating to my product choice. I declare that the information I have provided is true and correct.' /* declarationLabel */
  );

SET @PARENT_ROW = (SELECT `healthProviderRulesId` FROM `ctm`.`health_provider_rules` WHERE providerId = 12);

INSERT INTO `ctm`.`health_provider_rules_deductions` (`healthProviderRulesId`, `selectionLabel`, `selectionValue`, `optionsLength`, `dateCalculationsStartFrom`, `dateCalculationStartOffset`, `dateCalculationsAcceptableDays`, `dateCalculationsIncludeWeekends`)
VALUES (@PARENT_ROW, 'DATE', 'DATE', 14, 'COVER_START', 0, '1-28', 1);

INSERT INTO `ctm`.`health_provider_rules_payment_frequencies` (`healthProviderRulesId`, `type`,  `weekly`, `fortnightly`, `monthly`, `quarterly`, `halfYearly`, `annually`)
VALUES (@PARENT_ROW, 'CC', 1, 1, 1, 1, 1, 1);

INSERT INTO `ctm`.`health_provider_rules_payment_frequencies` (`healthProviderRulesId`, `type`,  `weekly`, `fortnightly`, `monthly`, `quarterly`, `halfYearly`, `annually`)
VALUES (@PARENT_ROW, 'BANK', 1, 1, 1, 1, 1, 1);


/** END CUA **/

/**
  *
  * FRA RULES
  *
  **/
INSERT INTO `ctm`.`health_provider_rules` (`providerId`, `effectiveStart`, `effectiveEnd`, `middleNameAsked`, `commencementDateStartOffset`, `commencementDateEndOffset`, `receiveInformationAsked`, `emailAddressMandatory`, `ageMinimum`, `ageMaximum`, `previousFundMemberIdRule`, `previousFundMemberIdMaximumLength`, `medicareDetailsMandatory`, `governmentRebateFormAsked`, `primaryPreviousFundAuthorityAsked`, `partnerPreviousFundAuthorityAsked`, `partnerFundAuthorityAsked`, `provideBankDetailsForRefundsRule`, `dependantsIntroductionText`, `dependantsAgeMinimum`, `dependantsAgeMaximum`, `creditCardGateway`, `declarationLabel`)
VALUES
  (8, '2015-11-01', '2040-01-01',
   0, /* middleNameAsked */
   0, /* commencementDateStartOffset */
   30, /* commencementDateEndOffset */
   0, /* receiveInformationAsked */
   1, /* emailAddressMandatory */
   16, /* ageMinimum */
   120, /* ageMaximum */
   'MANDATORY',  /* previousFundMemberIdRule */
   50,  /* previousFundMemberIdMaximumLength */
   1,  /* medicareDetailsMandatory */
   0,  /* governmentRebateFormAsked */
   1,  /* primaryPreviousFundAuthorityAsked */
   0,  /* partnerPreviousFundAuthorityAsked */
   0, /* partnerFundAuthorityAsked */
   'MANDATORY', /* provideBankDetailsForRefundsRule */
   'This policy provides cover for children until their 21st birthday. Adult dependants over 21 years old can be covered by applying for a separate singles policy.',
   0,  /* dependantsAgeMinimum */
   21,  /* dependantsAgeMaximum */
   'INLINE', /* creditCardGateway */
   null /* declarationLabel */
  );

SET @PARENT_ROW = (SELECT `healthProviderRulesId` FROM `ctm`.`health_provider_rules` WHERE providerId = 8);

INSERT INTO `ctm`.`health_provider_rules_deductions` (`healthProviderRulesId`, `deductionText`)
VALUES (@PARENT_ROW, 'Monthly Payments:
Cover start date today – Your first payment will be debited in the next 24 hours and thereafter on the same day each month.
Cover starts later than today - Your first payment will be debited on the policy start date and thereafter on the same day each month.
Annual Payments:
Cover start date today – Your payment will be debited in the next 24 hours.
Cover starts later than today – Your payment will be debited on your policy start date.');

INSERT INTO `ctm`.`health_provider_rules_payment_frequencies` (`healthProviderRulesId`, `type`,  `weekly`, `fortnightly`, `monthly`, `quarterly`, `halfYearly`, `annually`)
VALUES (@PARENT_ROW, 'CC', 0, 1, 1, 0, 0, 1);

INSERT INTO `ctm`.`health_provider_rules_payment_frequencies` (`healthProviderRulesId`, `type`,  `weekly`, `fortnightly`, `monthly`, `quarterly`, `halfYearly`, `annually`)
VALUES (@PARENT_ROW, 'BANK', 0, 0, 1, 0, 0, 1);

INSERT INTO `ctm`.`health_provider_rules_inline_creditcards` (`healthProviderRulesId`, `visa`, `mastercard`, `amex`, `diners`) VALUES (@PARENT_ROW, 1,1,0,0);


/** END FRA **/

/**
  *
  * GMH RULES
  *
  **/
INSERT INTO `ctm`.`health_provider_rules` (`providerId`, `effectiveStart`, `effectiveEnd`, `middleNameAsked`, `commencementDateStartOffset`, `commencementDateEndOffset`, `receiveInformationAsked`, `emailAddressMandatory`, `ageMinimum`, `ageMaximum`, `previousFundMemberIdRule`, `previousFundMemberIdMaximumLength`, `medicareDetailsMandatory`, `governmentRebateFormAsked`, `primaryPreviousFundAuthorityAsked`, `partnerPreviousFundAuthorityAsked`, `partnerFundAuthorityAsked`, `provideBankDetailsForRefundsRule`, `dependantsIntroductionText`, `dependantsAgeMinimum`, `dependantsAgeMaximum`, `creditCardGateway`, `declarationLabel`)
VALUES
  (5, '2015-11-01', '2040-01-01',
   0, /* middleNameAsked */
   0, /* commencementDateStartOffset */
   30, /* commencementDateEndOffset */
   0, /* receiveInformationAsked */
   1, /* emailAddressMandatory */
   16, /* ageMinimum */
   120, /* ageMaximum */
   'MANDATORY',  /* previousFundMemberIdRule */
   50,  /* previousFundMemberIdMaximumLength */
   1,  /* medicareDetailsMandatory */
   0,  /* governmentRebateFormAsked */
   1,  /* primaryPreviousFundAuthorityAsked */
   0,  /* partnerPreviousFundAuthorityAsked */
   0, /* partnerFundAuthorityAsked */
   'MANDATORY', /* provideBankDetailsForRefundsRule */
   'This policy provides cover for your children aged less than 22 years plus students studying full time between the ages of 22 and 24. You can still obtain cover for your adult child outside these criteria by applying for a separate singles policy.',
   0,  /* dependantsAgeMinimum */
   24,  /* dependantsAgeMaximum */
   'INLINE', /* creditCardGateway */
   'I can confirm that I have read and understood the Join Declaration and the information relating to my product choice. I declare that the information I have provided is true and correct.' /* declarationLabel */
  );

SET @PARENT_ROW = (SELECT `healthProviderRulesId` FROM `ctm`.`health_provider_rules` WHERE providerId = 5);

INSERT INTO `ctm`.`health_provider_rules_deductions` (`healthProviderRulesId`, `deductionText`)
VALUES (@PARENT_ROW, 'Monthly Payments:
Cover start date today – Your first payment will be debited in the next 24 hours and thereafter on the same day each month.
Cover starts later than today - Your first payment will be debited on the policy start date and thereafter on the same day each month.
Annual Payments:
Cover start date today – Your payment will be debited in the next 24 hours.
Cover starts later than today – Your payment will be debited on your policy start date.');

INSERT INTO `ctm`.`health_provider_rules_dependant_schools` (`healthProviderRulesId`, `schoolAgeMinimum`, `mustBeFullTimeStudent`, `schoolNameInputMethod`, `schoolNameLabel`, `studentIdRule`, `studentIdMaximumLength`, `commencedDateRule`, `apprenticeRule`)
VALUES (@PARENT_ROW,
        21, /* schoolAgeMinimum */
        0, /* mustBeFullTimeStudent */
        'TEXT_INPUT', /* schoolNameInputMethod */
        'Name of school/employer/educational institution your child is attending', /* schoolNameLabel */
        'OPTIONAL', /* studentIdRule */
        50, /* studentIdMaximumLength*/
        'FALSE', /* commencedDateRule */
        'FALSE' /* apprenticeRule */
);

INSERT INTO `ctm`.`health_provider_rules_payment_frequencies` (`healthProviderRulesId`, `type`,  `weekly`, `fortnightly`, `monthly`, `quarterly`, `halfYearly`, `annually`)
VALUES (@PARENT_ROW, 'CC', 0, 0, 1, 0, 0, 1);

INSERT INTO `ctm`.`health_provider_rules_payment_frequencies` (`healthProviderRulesId`, `type`,  `weekly`, `fortnightly`, `monthly`, `quarterly`, `halfYearly`, `annually`)
VALUES (@PARENT_ROW, 'BANK', 0, 1, 1, 0, 0, 1);

INSERT INTO `ctm`.`health_provider_rules_inline_creditcards` (`healthProviderRulesId`, `visa`, `mastercard`, `amex`, `diners`) VALUES (@PARENT_ROW, 1,1,0,0);


/** END GMH **/

/**
  *
  * HCF RULES
  *
  **/
INSERT INTO `ctm`.`health_provider_rules` (`providerId`, `effectiveStart`, `effectiveEnd`, `middleNameAsked`, `commencementDateStartOffset`, `commencementDateEndOffset`, `receiveInformationAsked`, `emailAddressMandatory`, `ageMinimum`, `ageMaximum`, `previousFundMemberIdRule`, `previousFundMemberIdMaximumLength`, `medicareDetailsMandatory`, `governmentRebateFormAsked`, `primaryPreviousFundAuthorityAsked`, `partnerPreviousFundAuthorityAsked`, `partnerFundAuthorityAsked`, `provideBankDetailsForRefundsRule`, `dependantsIntroductionText`, `dependantsAgeMinimum`, `dependantsAgeMaximum`, `creditCardGateway`, `declarationLabel`)
VALUES
  (2, '2015-11-01', '2040-01-01',
   0, /* middleNameAsked */
   0, /* commencementDateStartOffset */
   90, /* commencementDateEndOffset */
   0, /* receiveInformationAsked */
   1, /* emailAddressMandatory */
   16, /* ageMinimum */
   120, /* ageMaximum */
   'MANDATORY',  /* previousFundMemberIdRule */
   50,  /* previousFundMemberIdMaximumLength */
   0,  /* medicareDetailsMandatory */
   0,  /* governmentRebateFormAsked */
   0,  /* primaryPreviousFundAuthorityAsked */
   0,  /* partnerPreviousFundAuthorityAsked */
   0, /* partnerFundAuthorityAsked */
   'FALSE', /* provideBankDetailsForRefundsRule */
   'This policy provides cover for your children aged less than 22 years plus students studying full time between the ages of 22 and 24. You can still obtain cover for your adult child outside these criteria by applying for a separate singles policy.',
   0,  /* dependantsAgeMinimum */
   24,  /* dependantsAgeMaximum */
   'INLINE', /* creditCardGateway */
   'I can confirm that I have read and understood the Join Declaration and the information relating to my product choice. I declare that the information I have provided is true and correct.' /* declarationLabel */
  );

SET @PARENT_ROW = (SELECT `healthProviderRulesId` FROM `ctm`.`health_provider_rules` WHERE providerId = 2);

INSERT INTO `ctm`.`health_provider_rules_deductions` (`healthProviderRulesId`, `selectionLabel`, `selectionValue`, `optionsLength`, `dateCalculationsStartFrom`, `dateCalculationStartOffset`, `dateCalculationsAcceptableDays`, `dateCalculationsIncludeWeekends`)
VALUES (@PARENT_ROW, 'DAY', 'DAY', 31, null, null, null, null);

INSERT INTO `ctm`.`health_provider_rules_dependant_schools` (`healthProviderRulesId`, `schoolAgeMinimum`, `mustBeFullTimeStudent`, `schoolNameInputMethod`, `schoolNameLabel`, `studentIdRule`, `studentIdMaximumLength`, `commencedDateRule`, `apprenticeRule`)
VALUES (@PARENT_ROW,
        21, /* schoolAgeMinimum */
        0, /* mustBeFullTimeStudent */
        'TEXT_INPUT', /* schoolNameInputMethod */
        'Name of school your child is attending', /* schoolNameLabel */
        'FALSE', /* studentIdRule */
        null, /* studentIdMaximumLength*/
        'FALSE', /* commencedDateRule */
        'FALSE' /* apprenticeRule */
);

INSERT INTO `ctm`.`health_provider_rules_payment_frequencies` (`healthProviderRulesId`, `type`,  `weekly`, `fortnightly`, `monthly`, `quarterly`, `halfYearly`, `annually`)
VALUES (@PARENT_ROW, 'CC', 0, 1, 1, 0, 0, 1);

INSERT INTO `ctm`.`health_provider_rules_payment_frequencies` (`healthProviderRulesId`, `type`,  `weekly`, `fortnightly`, `monthly`, `quarterly`, `halfYearly`, `annually`)
VALUES (@PARENT_ROW, 'BANK', 0, 1, 1, 0, 0, 1);

INSERT INTO `ctm`.`health_provider_rules_inline_creditcards` (`healthProviderRulesId`, `visa`, `mastercard`, `amex`, `diners`) VALUES (@PARENT_ROW, 1,1,1,0);


/** END HCF **/


/**
  *
  * NIB RULES
  *
  **/
INSERT INTO `ctm`.`health_provider_rules` (`providerId`, `effectiveStart`, `effectiveEnd`, `middleNameAsked`, `commencementDateStartOffset`, `commencementDateEndOffset`, `receiveInformationAsked`, `emailAddressMandatory`, `ageMinimum`, `ageMaximum`, `previousFundMemberIdRule`, `previousFundMemberIdMaximumLength`, `medicareDetailsMandatory`, `governmentRebateFormAsked`, `primaryPreviousFundAuthorityAsked`, `partnerPreviousFundAuthorityAsked`, `partnerFundAuthorityAsked`, `provideBankDetailsForRefundsRule`, `dependantsIntroductionText`, `dependantsAgeMinimum`, `dependantsAgeMaximum`, `creditCardGateway`, `declarationLabel`)
VALUES
  (3, '2015-11-01', '2040-01-01',
   0, /* middleNameAsked */
   0, /* commencementDateStartOffset */
   29, /* commencementDateEndOffset */
   1, /* receiveInformationAsked */
   0, /* emailAddressMandatory */
   16, /* ageMinimum */
   120, /* ageMaximum */
   'MANDATORY',  /* previousFundMemberIdRule */
   50,  /* previousFundMemberIdMaximumLength */
   0,  /* medicareDetailsMandatory */
   0,  /* governmentRebateFormAsked */
   1,  /* primaryPreviousFundAuthorityAsked */
   1,  /* partnerPreviousFundAuthorityAsked */
   1, /* partnerFundAuthorityAsked */
   'OPTIONAL', /* provideBankDetailsForRefundsRule */
   'This policy provides cover for your children up to their 21st birthday and dependants aged between 21 and 24 who are studying full time. Adult dependants outside these criteria can still be covered by applying for a separate policy.',
   0,  /* dependantsAgeMinimum */
   24,  /* dependantsAgeMaximum */
   'INLINE', /* creditCardGateway */
   null /* declarationLabel */
  );

SET @PARENT_ROW = (SELECT `healthProviderRulesId` FROM `ctm`.`health_provider_rules` WHERE providerId = 3);

INSERT INTO `ctm`.`health_provider_rules_deductions` (`healthProviderRulesId`, `selectionLabel`, `selectionValue`, `optionsLength`, `dateCalculationsStartFrom`, `dateCalculationStartOffset`, `dateCalculationsAcceptableDays`, `dateCalculationsIncludeWeekends`)
VALUES (@PARENT_ROW, 'DAY', 'DATE', 27, 'TODAY', 0, '1-27', 1);

INSERT INTO `ctm`.`health_provider_rules_dependant_schools` (`healthProviderRulesId`, `schoolAgeMinimum`, `mustBeFullTimeStudent`, `schoolNameInputMethod`, `schoolNameLabel`, `studentIdRule`, `studentIdMaximumLength`, `commencedDateRule`, `apprenticeRule`)
VALUES (@PARENT_ROW,
        21, /* schoolAgeMinimum */
        0, /* mustBeFullTimeStudent */
        'TEXT_INPUT', /* schoolNameInputMethod */
        'Name of school your child is attending', /* schoolNameLabel */
        'OPTIONAL', /* studentIdRule */
        50, /* studentIdMaximumLength*/
        'FALSE', /* commencedDateRule */
        'FALSE' /* apprenticeRule */
);

INSERT INTO `ctm`.`health_provider_rules_payment_frequencies` (`healthProviderRulesId`, `type`,  `weekly`, `fortnightly`, `monthly`, `quarterly`, `halfYearly`, `annually`)
VALUES (@PARENT_ROW, 'CC', 0, 1, 1, 0, 0, 1);

INSERT INTO `ctm`.`health_provider_rules_payment_frequencies` (`healthProviderRulesId`, `type`,  `weekly`, `fortnightly`, `monthly`, `quarterly`, `halfYearly`, `annually`)
VALUES (@PARENT_ROW, 'BANK', 0, 0, 1, 0, 0, 1);

INSERT INTO `ctm`.`health_provider_rules_inline_creditcards` (`healthProviderRulesId`, `visa`, `mastercard`, `amex`, `diners`) VALUES (@PARENT_ROW, 1,1,0,0);


/** END NIB **/

/**
  *
  * QCF RULES
  *
  **/
INSERT INTO `ctm`.`health_provider_rules` (`providerId`, `effectiveStart`, `effectiveEnd`, `middleNameAsked`, `commencementDateStartOffset`, `commencementDateEndOffset`, `receiveInformationAsked`, `emailAddressMandatory`, `ageMinimum`, `ageMaximum`, `previousFundMemberIdRule`, `previousFundMemberIdMaximumLength`, `medicareDetailsMandatory`, `governmentRebateFormAsked`, `primaryPreviousFundAuthorityAsked`, `partnerPreviousFundAuthorityAsked`, `partnerFundAuthorityAsked`, `provideBankDetailsForRefundsRule`, `dependantsIntroductionText`, `dependantsAgeMinimum`, `dependantsAgeMaximum`, `creditCardGateway`, `declarationLabel`)
VALUES
  (16, '2015-11-01', '2040-01-01',
   0, /* middleNameAsked */
   0, /* commencementDateStartOffset */
   29, /* commencementDateEndOffset */
   0, /* receiveInformationAsked */
   1, /* emailAddressMandatory */
   18, /* ageMinimum */
   120, /* ageMaximum */
   'OPTIONAL',  /* previousFundMemberIdRule */
   10,  /* previousFundMemberIdMaximumLength */
   0,  /* medicareDetailsMandatory */
   0,  /* governmentRebateFormAsked */
   0,  /* primaryPreviousFundAuthorityAsked */
   0,  /* partnerPreviousFundAuthorityAsked */
   0, /* partnerFundAuthorityAsked */
   'FALSE', /* provideBankDetailsForRefundsRule */
   'Queensland Country Health Fund(QCHF) policies provide cover for all dependents up to the age of 21, including step and foster children. Adult dependents who are single, aged between 21 and 25 years and who are: studying full time at a school, college or university, or are training as an apprentice and earning no more than $30,000 p.a. may continue to be covered by QCHF policies.',
   0,  /* dependantsAgeMinimum */
   25,  /* dependantsAgeMaximum */
   'NAB', /* creditCardGateway */
   'I can confirm that I have read and understood the Join Declaration and the information relating to my product choice. I declare that the information I have provided is true and correct.' /* declarationLabel */
  );

SET @PARENT_ROW = (SELECT `healthProviderRulesId` FROM `ctm`.`health_provider_rules` WHERE providerId = 16);

INSERT INTO `ctm`.`health_provider_rules_deductions` (`healthProviderRulesId`, `deductionText`)
VALUES (@PARENT_ROW, 'Your first premium payment will be deducted from your nominated bank account on receipt of your application by us, or from the actual start date of your policy.');

INSERT INTO `ctm`.`health_provider_rules_dependant_schools` (`healthProviderRulesId`, `schoolAgeMinimum`, `mustBeFullTimeStudent`, `schoolNameInputMethod`, `schoolNameLabel`, `studentIdRule`, `studentIdMaximumLength`, `commencedDateRule`, `apprenticeRule`)
VALUES (@PARENT_ROW,
        21, /* schoolAgeMinimum */
        1, /* mustBeFullTimeStudent */
        'TEXT_INPUT', /* schoolNameInputMethod */
        'Please supply the name of the school your child is attending eg. UNSW', /* schoolNameLabel */
        'FALSE', /* studentIdRule */
        null, /* studentIdMaximumLength*/
        'FALSE', /* commencedDateRule */
        'MANDATORY' /* apprenticeRule */
);

INSERT INTO `ctm`.`health_provider_rules_payment_frequencies` (`healthProviderRulesId`, `type`,  `weekly`, `fortnightly`, `monthly`, `quarterly`, `halfYearly`, `annually`)
VALUES (@PARENT_ROW, 'CC', 1, 1, 1, 1, 1, 1);

INSERT INTO `ctm`.`health_provider_rules_payment_frequencies` (`healthProviderRulesId`, `type`,  `weekly`, `fortnightly`, `monthly`, `quarterly`, `halfYearly`, `annually`)
VALUES (@PARENT_ROW, 'BANK', 1, 1, 1, 1, 1, 1);


/** END QCF **/