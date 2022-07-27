;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        exception = meerkat.logging.exception,
        $fields = {},
        $dynamicDialogueBoxesPrimaryData = null,
        $dynamicDialogueBoxesPrimaryGender = null,
        $dynamicDialogueBoxPrimaryDOB = null,
        $dynamicDialogueBoxResidential = null,
        $dynamicDialogueBoxPostal = null,
        $dynamicDialogueBoxMobile = null,
        $dynamicDialogueBoxPrimaryEmail = null,
        $dynamicDialogueBoxMedicare = null,
        $dynamicDialogueBoxesPartnerData = null,
        $dynamicDialogueBoxesPartnerGender = null,
        $dynamicDialogueBoxPartnerDOB = null,
        $dynamicDialogueBoxDependants = null,
        $fundSpecificDynamicDialogueBoxes_MYO = null,
        $nonDynamicDialogueBoxMedicareCardSpelling = null,
        $nonDynamicDialogueBoxYourFullName = null,
        $nonDynamicDialogueBoxResidentialAddress = null,
        $nonDynamicDialogueBoxPostalAddress = null,
        $nonDynamicDialogueBoxEmailAddress = null,
        $nonDynamicDialogueBoxAllOnMedicareCard = null,
        $nonDynamicDialogueBoxAdditionalPeopleCovered = null,
        $nonDynamicDialogueBoxPartnersGender = null,
        $nonDynamicDialogueBoxThisCallIsRecorded = null,
        $nonDynamicDialogueBoxLodgingFormToClaimAGRPrivacyNote = null,
        $primaryDob = null,
        $partnerDob = null,
        _selectedProductFundCode = '',
        _stepChangedSubscribe = false,
        $dynamicScriptToggleElements = null,
        _derivedData = {},
        _states = {
            showScripting: false
        },
        _dynamicValues = [
            {
                text: '%PRIMARY_FULL_NAME%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }
                    return _derivedData.primary.fullName;
                }
            },
            {
                text: '%PRIMARY_FIRST_NAME_PHONETIC%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }
                    return natoPhoneticText(_derivedData.primary.firstName);
                }
            },
            {
                text: '%PRIMARY_MIDDLE_INITIAL_SCRIPT%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }
                    if(!_derivedData.primary.middleInitial) {
                        return '';
                    }

                    return ', middle initial ' + natoPhoneticText(_derivedData.primary.middleInitial);
                }
            },
            {
                text: '%PRIMARY_SURNAME_PHONETIC%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }
                    return 'surname ' + natoPhoneticText(_derivedData.primary.surname);
                }
            },
            {
                text: '%PRIMARY_DOB%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }
                    return _derivedData.primaryDOB ? _derivedData.primaryDOB : '';
                }
            },
            {
                text: '%PRIMARY_GENDER%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }
                    return _derivedData.primary.gender ? _derivedData.primary.gender : '';
                }
            },
            {
                text: '%RESIDENTIAL_ADDRESS%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }
                    return _derivedData.residentialAddress ? _derivedData.residentialAddress : '';
                }
            },
            {
                text: '%POSTAL_ADDRESS%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }
                    return _derivedData.postalAddress ? _derivedData.postalAddress : '';
                }
            },
            {
                text: '%PHONE_NUMBER_SCRIPT%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }

                    var returnStr = '';
                    if (_derivedData.mobileNumber && _derivedData.otherNumber) {
                        returnStr = 'And your mobile is ' + _derivedData.mobileNumber + ' and your land line is ' + _derivedData.otherNumber + '.  Is that right?';
                    } else if (_derivedData.mobileNumber) {
                        returnStr = 'And your mobile is ' + _derivedData.mobileNumber + '.  Is that right?';
                    } else if (_derivedData.otherNumber) {
                        returnStr = 'And your land line is ' + _derivedData.otherNumber + '.  Is that right?';
                    } else {
                        returnStr = 'Please provide at least one phone number';
                    }

                    return returnStr;
                }
            },
            {
                text: '%EMAIL_ADDRESS_PHONETIC%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }
                    return phoneticEmailAddress( _derivedData.emailAddress );
                }
            },
            {
                text: '%PARTNER_EMAIL_ADDRESS_PHONETIC%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }
                    return phoneticEmailAddress( $('#health_application_partner_email').val() );
                }
            },
            {
                text: '%MEDICARE_COLOUR%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }
                    if(!_derivedData.medicare) {
                        return '';
                    }

                    return _derivedData.medicare.colour ? _derivedData.medicare.colour : '';
                }
            },
            {
                text: '%MEDICARE_NUMBER%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }
                    if(!_derivedData.medicare) {
                        return '';
                    }

                    return _derivedData.medicare.number ? _derivedData.medicare.number : '';
                }
            },
            {
                text: '%MEDICARE_EXPIRY%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }
                    if(!_derivedData.medicare) {
                        return '';
                    }

                    if (_derivedData.medicare.colour) {
                        if (_derivedData.medicare.colour === 'blue' || _derivedData.medicare.colour === 'yellow') {
                            if (!_.isUndefined(_derivedData.medicare.expDay)) {
                                return (_derivedData.medicare.expDay && _derivedData.medicare.expMonth && _derivedData.medicare.expYear ? _derivedData.medicare.expDay + ' / ' + _derivedData.medicare.expMonth + ' / ' + _derivedData.medicare.expYear : '');
                            }
                        } else {
                            return (_derivedData.medicare.expMonth && _derivedData.medicare.expYear ? _derivedData.medicare.expMonth + ' / ' + _derivedData.medicare.expYear : '');
                        }
                    }

                    return '';
                }
            },
            {
                text: '%MEDICARE_POSITION%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }
                    if(!_derivedData.medicare) {
                        return '';
                    }

                    return _derivedData.medicare.position ? _derivedData.medicare.position : '';
                }
            },
            {
                text: '%PARTNER_FULL_NAME%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }
                    if(!_derivedData.partner) {
                        return '';
                    }
                    return _derivedData.partner.fullName;
                }
            },
            {
                text: '%PARTNER_FIRST_NAME_PHONETIC%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }
                    if(!_derivedData.partner) {
                        return '';
                    }
                    return natoPhoneticText(_derivedData.partner.firstName);
                }
            },
            {
                text: '%PARTNER_MIDDLE_INITIAL_SCRIPT%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }
                    if(!_derivedData.partner) {
                        return '';
                    }
                    if(!_derivedData.partner.middleInitial) {
                        return '';
                    }

                    return ', middle initial ' + natoPhoneticText(_derivedData.partner.middleInitial);
                }
            },
            {
                text: '%PARTNER_SURNAME_PHONETIC%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }
                    if(!_derivedData.partner) {
                        return '';
                    }
                    return 'surname ' + natoPhoneticText(_derivedData.partner.surname);
                }
            },
            {
                text: '%PARTNER_DOB%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }
                    if(!_derivedData.partner) {
                        return '';
                    }
                    return _derivedData.partnerDOB ? _derivedData.partnerDOB : '';
                }
            },
            {
                text: '%PARTNER_GENDER%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }
                    if(!_derivedData.partner) {
                        return '';
                    }
                    return _derivedData.partner.gender ? _derivedData.partner.gender : '';
                }
            },
            {
                text: '%DEPENDANTS_SCRIPT_TEMPLATE%',
                get: function(position) {
                    if(!_derivedData) {
                        return '';
                    }
                    if(!_derivedData.dependants) {
                        return '';
                    }

                    var returnStr = 'Dependant ' + position + '&apos;s details are ';

                    _createFieldsDependants();
                    var dependant = _getPersonData('dependant' + position);

                    returnStr += dependant.fullName + ', spelled ' + natoPhoneticText(dependant.firstName);

                    if (_selectedProductFundCode === 'BUP') {
                        returnStr += ', middle name ' + natoPhoneticText(dependant.middleName);
                    }

                    returnStr += ', surname ' + natoPhoneticText(dependant.surname) + ', ' + dependant.gender + ', ' + dependant.dateOfBirth;

                    return returnStr;
                }
            },
            {
                text: '%DATE_TODAY%',
                get: function() {
                    // this uses the application date when testing in NXI and the date is changed
                    var applicationDate = $('#health_searchDate').val();
                    var applicationDateString = '';

                    if(applicationDate) {
                        var dateSplit = applicationDate.split('/');
                        if(dateSplit.length === 3) {
                            var year = dateSplit[2];
                            var month = dateSplit[1];
                            var day = dateSplit[0];
                            applicationDateString = year + '-' + month + '-' + day;
                        }
                    }

                    var curDate = applicationDateString ? new Date(applicationDateString) : meerkat.site.serverDate;
                    return meerkat.modules.dateUtils.dateValueFormFormat(curDate);
                }
            }
        ];


    function onInitialise() {
        $dynamicScriptToggleElements = $('.simplesDynamicElements');
        $primaryDob = $('#health_application_primary_dob');
        $partnerDob = $('#health_application_partner_dob');

        _setupPrimaryDataDynamicTextTemplates();
        _setupPrimaryGenderDynamicTextTemplates();
        _setupPrimaryDOBDynamicTextTemplate();
        _setupResidentialDynamicTextTemplate();
        _setupPostalDynamicTextTemplate();
        _setupMobileDynamicTextTemplate();
        _setupPrimaryEmailDynamicTextTemplate();
        _setupMedicareDynamicTextTemplate();
        _setupPartnerDataDynamicTextTemplates();
        _setupPartnerGenderDynamicTextTemplates();
        _setupPartnerDOBDynamicTextTemplate();
        _setupDependantsDynamicTextTemplate();

        _setupMedicareCardSpellingNonDynamicTextTemplate();
        _setupYourFullNameNonDynamicTextTemplate();
        _setupResidentialAddressNonDynamicTextTemplate();
        _setupPostalAddressNonDynamicTextTemplate();
        _setupEmailAddressNonDynamicTextTemplate();
        _setupAllOnMedicareCardNonDynamicTextTemplate();
        _setupAdditionalPeopleCoveredNonDynamicTextTemplate();
        _setupPartnersGenderNonDynamicTextTemplate();
        _setupThisCallIsRecordedNonDynamicTextTemplate();
        _setupLodgingFormToClaimAGRPrivacyNoteNonDynamicTextTemplate();
    }


    function _setupListeners() {

        var dynamicPartnerEmailChanged = function() {
            performUpdatePartnerEmailDynamicDialogueBox();
        };

        if (_selectedProductFundCode === 'MYO') {
            $('#health_application_partner_email').on('change.dynamicPartnerEmailChanged', dynamicPartnerEmailChanged);
        }

        var dynamicNibNoEmailChanged = function() {
            _derivedData.emailAddress = undefined;
            _derivedData.emailAddress = (!_.isUndefined($fields.email) ? $fields.email.val() : '');
            performUpdatePrimaryEmailDynamicDialogueBox();
        };
        if (_selectedProductFundCode === 'NIB') {
            $('#health_application_no_email').on('change.dynamicNibNoEmailChanged', dynamicNibNoEmailChanged);
        }

        var dynamicScripting_DependentDtlsUpdated = function(){
            _setupDependantsDynamicTextTemplate();
            _.defer(performUpdateDependantsDynamicDialogueBox);
        };

        $('#dependents_list_options').on('click.dynamicScriptingDependentAdded', '.add-new-dependent', dynamicScripting_DependentDtlsUpdated);
        $("#health-dependants-wrapper").on('click.dynamicScriptingDependentRemoved', '.remove-dependent', dynamicScripting_DependentDtlsUpdated);
        $("#health-dependants-wrapper").on('change.dynamicScriptingDependentDtls1Updated', '.dateinput_container input.serialise, .health_dependant_details_fulltimeGroup input', dynamicScripting_DependentDtlsUpdated);
        $("#health-dependants-wrapper").on('change.dynamicScriptingDependentDtls2Updated', ':input', dynamicScripting_DependentDtlsUpdated);

        var dynamicScriptingPrimaryNameDtlsUpdated = function() {
            refreshPersonData('primary');
            performUpdatePrimaryDataDynamicDialogueBoxes();
        };

        var dynamicScriptingPrimaryTitleUpdated = function() {
            refreshPersonData('primary');
            performUpdatePrimaryDataDynamicDialogueBoxes();
            _.defer(function () {
                dynamicScriptingCheckUpdateGenderAndTitle('primary', true);
            });
        };

        var dynamicScriptingPrimaryGenderUpdated = function() {
            refreshPersonData('primary');
            dynamicScriptingCheckUpdateGenderAndTitle('primary', false);
        };

        $fields.primary.title.on('change.dynamicScriptingPrimaryTitle', dynamicScriptingPrimaryTitleUpdated);
        $fields.primary.firstName.on('change.dynamicScriptingPrimaryFirstName', dynamicScriptingPrimaryNameDtlsUpdated);
        $fields.primary.middleName.on('change.dynamicScriptingPrimaryMiddleName', dynamicScriptingPrimaryNameDtlsUpdated);

        $fields.primary.surname.on('change.dynamicScriptingPrimarySurname', dynamicScriptingPrimaryNameDtlsUpdated);
        $fields.primary.gender.on('change.dynamicScriptingPrimaryGender', dynamicScriptingPrimaryGenderUpdated);

        var dynamicScriptingPrimaryDOBUpdated = function() {
            _derivedData.primaryDOB = undefined;
            _derivedData.primaryDOB = _getPersonDOB('primary');
            performUpdatePrimaryDOBDynamicDialogueBox();
        };

        $fields.primary.dob.on('change.dynamicScriptingPrimaryDob', dynamicScriptingPrimaryDOBUpdated);

        var dynamicScriptingMobileNumbersDtlsUpdated = function() {
            _derivedData.mobileNumber = undefined;
            _derivedData.mobileNumber = (!_.isUndefined($fields.mobileNumber) ? $fields.mobileNumber.val() : '');
            performUpdateMobileDynamicDialogueBox();
        };

        $fields.mobileNumber.on('change.dynamicScriptingMobileNumber', dynamicScriptingMobileNumbersDtlsUpdated);

        var dynamicScriptingOtherNumberDtlsUpdated = function() {
            _derivedData.otherNumber = undefined;
            _derivedData.otherNumber = (!_.isUndefined($fields.otherNumber) ? $fields.otherNumber.val() : '');
            performUpdateMobileDynamicDialogueBox();
        };

        $fields.otherNumber.on('change.dynamicScriptingOtherNumber', dynamicScriptingOtherNumberDtlsUpdated);

        var dynamicScriptingEmailAddressDtlsUpdated = function() {
            _derivedData.emailAddress = undefined;
            _derivedData.emailAddress = (!_.isUndefined($fields.email) ? $fields.email.val() : '');
            performUpdatePrimaryEmailDynamicDialogueBox();
        };

        $fields.email.on('change.dynamicScriptingEmail', dynamicScriptingEmailAddressDtlsUpdated);

        var dynamicScriptingResidentialAddressDtlsUpdated = function() {

            // a delay here is necessary (using _.defer is not sufficient) although using a nested defer maybe
            // there is a LOT of logic that is fired as part of the address lookup and as a result often the address vales are not immediately available
            _.delay(function () {
                $fields.address.residential = {
                    postcode: $('#health_application_address_postCode'),
                    suburb: $('#health_application_address_suburb'),
                    unitShop: $('#health_application_address_unitShop'),
                    streetNum: $('#health_application_address_streetNum'),
                    streetName: $('#health_application_address_streetName'),
                    unitType: $('#health_application_address_unitType'),
                    nonStdStreet: $('#health_application_address_nonStdStreet'),
                    streetSearch: $('#health_application_address_streetSearch'),
                    nonStd: $('#health_application_address_nonStd'),
                    suburbName: $('#health_application_address_suburbName'),
                    state: $('#health_application_address_state'),
                    fullAddress: $('#health_application_address_fullAddress')
                };
                _derivedData.residentialAddress = undefined;
                _derivedData.residentialAddress = _getAddressData('residential');
                performUpdateResidentialDynamicDialogueBox();
            }, 1000);
        };

        $fields.address.residential.postcode.on('change.dynamicScriptingResidentialPostcode', dynamicScriptingResidentialAddressDtlsUpdated);
        $fields.address.residential.suburb.on('change.dynamicScriptingResidentialSuburb', dynamicScriptingResidentialAddressDtlsUpdated);
        $fields.address.residential.unitShop.on('change.dynamicScriptingResidentialUnitShop', dynamicScriptingResidentialAddressDtlsUpdated);
        $fields.address.residential.streetNum.on('change.dynamicScriptingResidentialStreetNum', dynamicScriptingResidentialAddressDtlsUpdated);
        $fields.address.residential.streetName.on('change.dynamicScriptingResidentialStreetName', dynamicScriptingResidentialAddressDtlsUpdated);
        $fields.address.residential.unitType.on('change.dynamicScriptingResidentialUnitType', dynamicScriptingResidentialAddressDtlsUpdated);
        $fields.address.residential.nonStdStreet.on('change.dynamicScriptingResidentialNonStdStreet', dynamicScriptingResidentialAddressDtlsUpdated);
        $fields.address.residential.streetSearch.on('change.dynamicScriptingResidentialStreetSearch', dynamicScriptingResidentialAddressDtlsUpdated);
        $fields.address.residential.nonStd.on('change.dynamicScriptingResidentialNonStd', dynamicScriptingResidentialAddressDtlsUpdated);
        $fields.address.residential.suburbName.on('change.dynamicScriptingResidentialSuburbName', dynamicScriptingResidentialAddressDtlsUpdated);
        $fields.address.residential.state.on('change.dynamicScriptingResidentialState', dynamicScriptingResidentialAddressDtlsUpdated);
        $fields.address.residential.fullAddress.on('change.dynamicScriptingResidentialFullAddress', dynamicScriptingResidentialAddressDtlsUpdated);

        var dynamicScriptingPostalAddressDtlsUpdated = function() {

            // a delay here is necessary (using _.defer is not sufficient) although using a nested defer maybe
            // there is a LOT of logic that is fired as part of the address lookup and as a result often the address vales are not immediately available
            _.delay(function () {
                $fields.address.postal = {
                    postcode: $('#health_application_postal_postCode'),
                    suburb: $('#health_application_postal_suburb'),
                    unitShop: $('#health_application_postal_unitShop'),
                    streetNum: $('#health_application_postal_streetNum'),
                    streetName: $('#health_application_postal_streetName'),
                    unitType: $('#health_application_postal_unitType'),
                    nonStdStreet: $('#health_application_postal_nonStdStreet'),
                    streetSearch: $('#health_application_postal_streetSearch'),
                    nonStd: $('#health_application_postal_nonStd'),
                    suburbName: $('#health_application_postal_suburbName'),
                    state: $('#health_application_postal_state'),
                    fullAddress: $('#health_application_postal_fullAddress')
                };
                _derivedData.postalAddress = undefined;
                _derivedData.postalAddress = _getAddressData('postal');
                performUpdatePostalDynamicDialogueBox();
            }, 1000);
        };

        $fields.postalMatch.on('change.dynamicScriptingPostalMatch', dynamicScriptingPostalAddressDtlsUpdated);
        $fields.address.postal.postcode.on('change.dynamicScriptingPostalPostcode', dynamicScriptingPostalAddressDtlsUpdated);
        $fields.address.postal.suburb.on('change.dynamicScriptingPostalSuburb', dynamicScriptingPostalAddressDtlsUpdated);
        $fields.address.postal.unitShop.on('change.dynamicScriptingPostalUnitShop', dynamicScriptingPostalAddressDtlsUpdated);
        $fields.address.postal.streetNum.on('change.dynamicScriptingPostalStreetNum', dynamicScriptingPostalAddressDtlsUpdated);
        $fields.address.postal.streetName.on('change.dynamicScriptingPostalStreetName', dynamicScriptingPostalAddressDtlsUpdated);
        $fields.address.postal.unitType.on('change.dynamicScriptingPostalUnitType', dynamicScriptingPostalAddressDtlsUpdated);
        $fields.address.postal.nonStdStreet.on('change.dynamicScriptingPostalNonStdStreet', dynamicScriptingPostalAddressDtlsUpdated);
        $fields.address.postal.streetSearch.on('change.dynamicScriptingPostalStreetSearch', dynamicScriptingPostalAddressDtlsUpdated);
        $fields.address.postal.nonStd.on('change.dynamicScriptingPostalNonStd', dynamicScriptingPostalAddressDtlsUpdated);
        $fields.address.postal.suburbName.on('change.dynamicScriptingPostalSuburbName', dynamicScriptingPostalAddressDtlsUpdated);
        $fields.address.postal.state.on('change.dynamicScriptingPostalState', dynamicScriptingPostalAddressDtlsUpdated);
        $fields.address.postal.fullAddress.on('change.dynamicScriptingPostalFullAddress', dynamicScriptingPostalAddressDtlsUpdated);

        var dynamicScriptingMedicareDtlsUpdated = function() {
            _derivedData.medicare = _getMedicareData();
            performUpdateMedicareDynamicDialogueBox();
        };

        $fields.medicare.colour.on('change.dynamicScriptingMedicareColour', dynamicScriptingMedicareDtlsUpdated);
        $fields.medicare.number.on('change.dynamicScriptingMedicareNumber', dynamicScriptingMedicareDtlsUpdated);
        $fields.medicare.expDay.on('change.dynamicScriptingMedicareExpDay', dynamicScriptingMedicareDtlsUpdated);
        $fields.medicare.expMonth.on('change.dynamicScriptingMedicareExpMonth', dynamicScriptingMedicareDtlsUpdated);
        $fields.medicare.expYear.on('change.dynamicScriptingMedicareExpYear', dynamicScriptingMedicareDtlsUpdated);
        $fields.medicare.number.on('change.dynamicScriptingMedicarePosition', dynamicScriptingMedicareDtlsUpdated);

        if (meerkat.modules.health.hasPartner()) {

            var dynamicScriptingPartnerNameDtlsUpdated = function() {
                refreshPersonData('partner');
                performUpdatePartnerDataDynamicDialogueBoxes();
            };

            var dynamicScriptingPartnerTitleUpdated = function() {
                refreshPersonData('partner');
                performUpdatePartnerDataDynamicDialogueBoxes();
                _.defer(function () {
                    dynamicScriptingCheckUpdateGenderAndTitle('partner', true);
                });
            };

            var dynamicScriptingPartnerGenderUpdated = function() {
                refreshPersonData('partner');
                dynamicScriptingCheckUpdateGenderAndTitle('partner', false);
            };

            $fields.partner.title.on('change.dynamicScriptingPartnerTitle', dynamicScriptingPartnerTitleUpdated);
            $fields.partner.firstName.on('change.dynamicScriptingPartnerFirstName', dynamicScriptingPartnerNameDtlsUpdated);
            $fields.partner.middleName.on('change.dynamicScriptingPartnerMiddleName', dynamicScriptingPartnerNameDtlsUpdated);
            $fields.partner.surname.on('change.dynamicScriptingPartnerSurname', dynamicScriptingPartnerNameDtlsUpdated);
            $fields.partner.gender.on('change.dynamicScriptingPartnerGender', dynamicScriptingPartnerGenderUpdated);

            var dynamicScriptingPartnerDOBUpdated = function() {
                _derivedData.partnerDOB = undefined;
                _derivedData.partnerDOB = _getPersonDOB('partner');
                performUpdatePartnerDOBDynamicDialogueBox();
            };
            $fields.partner.dob.on('change.dynamicScriptingPartnerDob', dynamicScriptingPartnerDOBUpdated);
        }
    }

    function refreshPersonData(person) {
        _derivedData[person] = undefined;
        _derivedData[person] = _getPersonData(person);
    }

    function dynamicScriptingCheckUpdateGenderAndTitle(person, isTitleTriggeringChange) {

        var updateBoth = true;
        var updateGender = false;

        if ($fields[person].title.val() === 'DR') {
            if (!isTitleTriggeringChange) {
                updateGender = true;
            }
            updateBoth = false;
        } else {
            if ($fields[person].gender.filter(':checked').val() === 'M'){
                if ($fields[person].title.val() === 'MR') {
                    updateBoth = false;
                    if (!isTitleTriggeringChange) {
                        updateGender = true;
                    }
                } else {
                    updateGender = true;
                }

            } else if ($fields[person].gender.filter(':checked').val() === 'F') {
                if ($fields[person].title.val() === 'MRS' || $fields[person].title.val() === 'MISS' || $fields[person].title.val() === 'MS') {
                    updateBoth = false;
                    if (!isTitleTriggeringChange) {
                        updateGender = true;
                    }
                } else {
                    updateGender = true;
                }
            }
        }

        if (person === 'primary') {
            if (updateBoth && !isTitleTriggeringChange) {
                performUpdatePrimaryDataDynamicDialogueBoxes();
            }
        } else if (person === 'partner')  {
            if (updateBoth && !isTitleTriggeringChange) {
                performUpdatePartnerDataDynamicDialogueBoxes();
            }
        }

    }

    function _setupPrimaryDataDynamicTextTemplates() {

        try {
            $dynamicDialogueBoxesPrimaryData = {
                'elementRef':$('.simples-dialogue-146'),
                'template': $('.simples-dialogue-146').html()
            };
        }
        catch(err) {
            console.error( "Required primary applicant's name dialogue box does not exist");
        }

    }

    function _setupPrimaryGenderDynamicTextTemplates() {

        try {
            $dynamicDialogueBoxesPrimaryGender = {
                'elementRef':$('.simples-dialogue-149'),
                'template': $('.simples-dialogue-149').html()
            };
        }
        catch(err) {
            console.error( "Required primary applicant's gender dialogue box does not exist");
        }

    }

    function _setupPrimaryDOBDynamicTextTemplate() {

        try {
            $dynamicDialogueBoxPrimaryDOB = {
                'elementRef':$('.simples-dialogue-147'),
                'template': $('.simples-dialogue-147').html()
            };
        }
        catch(err) {
            console.error( "Required primary applicant's DOB dialogue box does not exist");
        }

    }

    function _setupResidentialDynamicTextTemplate() {

        try {
            $dynamicDialogueBoxResidential = {
                'elementRef':$('.simples-dialogue-151'),
                'template': $('.simples-dialogue-151').html()
            };
        }
        catch(err) {
            console.error( "Required primary applicant's residential address dialogue box does not exist");
        }

    }

    function _setupPostalDynamicTextTemplate() {

        try {
            $dynamicDialogueBoxPostal = {
                'elementRef':$('.simples-dialogue-153'),
                'template': $('.simples-dialogue-153').html()
            };
        }
        catch(err) {
            console.error( "Required primary applicant's postal address dialogue box does not exist");
        }

    }

    function _setupMobileDynamicTextTemplate() {

        try {
            $dynamicDialogueBoxMobile = {
                'elementRef':$('.simples-dialogue-154'),
                'template': $('.simples-dialogue-154').html()
            };
        }
        catch(err) {
            console.error( "Required primary applicant's mobile number dialogue box does not exist");
        }

    }

    function _setupPrimaryEmailDynamicTextTemplate() {

        try {
            $dynamicDialogueBoxPrimaryEmail = {
                'elementRef':$('.simples-dialogue-156'),
                'template': $('.simples-dialogue-156').html()
            };
        }
        catch(err) {
            console.error( "Required primary applicant's email address dialogue box does not exist");
        }

    }

    function _setupMedicareDynamicTextTemplate() {

        try {
            $dynamicDialogueBoxMedicare = {
                'elementRef':$('.simples-dialogue-158'),
                'template': $('.simples-dialogue-158').html()
            };
        }
        catch(err) {
            console.error( "Required primary applicant's medicare details dialogue box does not exist");
        }

    }

    function _setupPartnerDataDynamicTextTemplates() {

        try {
            $dynamicDialogueBoxesPartnerData = {
                'elementRef':$('.simples-dialogue-160'),
                'template': $('.simples-dialogue-160').html()
            };
        }
        catch(err) {
            console.error( "Required partner applicant's name dialogue box does not exist");
        }

    }

    function _setupPartnerGenderDynamicTextTemplates() {

        try {
            $dynamicDialogueBoxesPartnerGender = {
                'elementRef':$('.simples-dialogue-163'),
                'template': $('.simples-dialogue-163').html()
            };
        }
        catch(err) {
            console.error( "Required partner applicant's gender dialogue box does not exist");
        }

    }

    function _setupPartnerEmailDynamicTextTemplate() {

        try {
            $fundSpecificDynamicDialogueBoxes_MYO = [
                {
                    'elementRef': $('.simples-dialogue-164'),
                    'template': $('.simples-dialogue-164').html()
                }
            ];
        }
        catch(err) {
            console.error( "Required partner applicant's email address dialogue box does not exist");
        }

    }

    function _setupPartnerDOBDynamicTextTemplate() {

        try {
            $dynamicDialogueBoxPartnerDOB = {
                'elementRef':$('.simples-dialogue-161'),
                'template': $('.simples-dialogue-161').html()
            };
        }
        catch(err) {
            console.error( "Required partner applicant's DOB dialogue box does not exist");
        }

    }

    function _setupDependantsDynamicTextTemplate() {
        if (meerkat.modules.healthDependants.getNumberOfDependants() > 0) {
            $dynamicDialogueBoxDependants = $dynamicDialogueBoxDependants || {};
            for (var i = 1; i <= meerkat.modules.healthDependants.getNumberOfDependants(); i++) {
                try {
                    $dynamicDialogueBoxDependants[i.toString()] = {
                        'dialog': $('#simples-dialogue-dependant' + i.toString()),
                        'elementRef': $('#simples-dialogue-dependant' + i.toString()).find('p').first(),
                        'template': $('#simples-dialogue-dependant' + i.toString()).attr('data-scripting-template')
                    };
                }
                catch (err) {
                    console.error("Required dependant" + i + " details dialogue box does not exist");
                }
            }
        }
    }

    function _setupMedicareCardSpellingNonDynamicTextTemplate() {

        try {
            $nonDynamicDialogueBoxMedicareCardSpelling = {
                'elementRef':$('.simples-dialogue-145'),
                'template': $('.simples-dialogue-145').html()
            };
        }
        catch(err) {
            console.error( "Required Medicare Card Spelling dialogue box does not exist");
        }

    }

    function _setupYourFullNameNonDynamicTextTemplate() {

        try {
            $nonDynamicDialogueBoxYourFullName = {
                'elementRef':$('.simples-dialogue-148'),
                'template': $('.simples-dialogue-148').html()
            };
        }
        catch(err) {
            console.error( "Required Spelling of Your Full Name dialogue box does not exist");
        }

    }

    function _setupResidentialAddressNonDynamicTextTemplate() {

        try {
            $nonDynamicDialogueBoxResidentialAddress = {
                'elementRef':$('.simples-dialogue-150'),
                'template': $('.simples-dialogue-150').html()
            };
        }
        catch(err) {
            console.error( "Required Residential Address dialogue box does not exist");
        }

    }

    function _setupPostalAddressNonDynamicTextTemplate() {

        try {
            $nonDynamicDialogueBoxPostalAddress = {
                'elementRef':$('.simples-dialogue-152'),
                'template': $('.simples-dialogue-152').html()
            };
        }
        catch(err) {
            console.error( "Required Postal Address dialogue box does not exist");
        }

    }

    function _setupEmailAddressNonDynamicTextTemplate() {

        try {
            $nonDynamicDialogueBoxEmailAddress = {
                'elementRef':$('.simples-dialogue-155'),
                'template': $('.simples-dialogue-155').html()
            };
        }
        catch(err) {
            console.error( "Required Email Address dialogue box does not exist");
        }

    }

    function _setupAllOnMedicareCardNonDynamicTextTemplate() {

        try {
            $nonDynamicDialogueBoxAllOnMedicareCard = {
                'elementRef':$('.simples-dialogue-157'),
                'template': $('.simples-dialogue-157').html()
            };
        }
        catch(err) {
            console.error( "Required Are All people listed on a Medicare Card dialogue box does not exist");
        }

    }

    function _setupAdditionalPeopleCoveredNonDynamicTextTemplate() {

        try {
            $nonDynamicDialogueBoxAdditionalPeopleCovered = {
                'elementRef':$('.simples-dialogue-159'),
                'template': $('.simples-dialogue-159').html()
            };
        }
        catch(err) {
            console.error( "Required There are Additional People Covered By This Policy dialogue box does not exist");
        }

    }

    function _setupPartnersGenderNonDynamicTextTemplate() {

        try {
            $nonDynamicDialogueBoxPartnersGender = {
                'elementRef':$('.simples-dialogue-162'),
                'template': $('.simples-dialogue-162').html()
            };
        }
        catch(err) {
            console.error( "Required What Is Your Partners Gender dialogue box does not exist");
        }

    }

    function _setupThisCallIsRecordedNonDynamicTextTemplate() {

        try {
            $nonDynamicDialogueBoxThisCallIsRecorded = {
                'elementRef':$('.simples-dialogue-167'),
                'template': $('.simples-dialogue-167').html()
            };
        }
        catch(err) {
            console.error( "Required This Call Is Recorded dialogue box does not exist");
        }

    }

    function _setupLodgingFormToClaimAGRPrivacyNoteNonDynamicTextTemplate() {

        try {
            $nonDynamicDialogueBoxLodgingFormToClaimAGRPrivacyNote = {
                'elementRef':$('.simples-dialogue-169'),
                'template': $('.simples-dialogue-169').html()
            };
        }
        catch(err) {
            console.error( "Required Lodging Form To Claim AGR Privacy Note dialogue box does not exist");
        }

    }

    function _setupFields() {
        $fields = {
            primary: {
                title: $('#health_application_primary_title'),
                firstName: $('#health_application_primary_firstname'),
                middleName: $('#health_application_primary_middleName'),
                surname: $('#health_application_primary_surname'),
                dob: $('#health_application_primary_dob'),
                gender: $('input[name=health_application_primary_gender]')
            },
            address: {
                residential: {
                    postcode: $('#health_application_address_postCode'),
                    suburb: $('#health_application_address_suburb'),
                    unitShop: $('#health_application_address_unitShop'),
                    streetNum: $('#health_application_address_streetNum'),
                    streetName: $('#health_application_address_streetName'),
                    unitType: $('#health_application_address_unitType'),
                    nonStdStreet: $('#health_application_address_nonStdStreet'),
                    streetSearch: $('#health_application_address_streetSearch'),
                    nonStd: $('#health_application_address_nonStd'),
                    suburbName: $('#health_application_address_suburbName'),
                    state: $('#health_application_address_state'),
                    fullAddress: $('#health_application_address_fullAddress')
                },
                postal: {
                    postcode: $('#health_application_postal_postCode'),
                    suburb: $('#health_application_postal_suburb'),
                    unitShop: $('#health_application_postal_unitShop'),
                    streetNum: $('#health_application_postal_streetNum'),
                    streetName: $('#health_application_postal_streetName'),
                    unitType: $('#health_application_postal_unitType'),
                    nonStdStreet: $('#health_application_postal_nonStdStreet'),
                    streetSearch: $('#health_application_postal_streetSearch'),
                    nonStd: $('#health_application_postal_nonStd'),
                    suburbName: $('#health_application_postal_suburbName'),
                    state: $('#health_application_postal_state'),
                    fullAddress: $('#health_application_postal_fullAddress')
                }
            },
            postalMatch: $('#health_application_postalMatch'),
            email: $('#health_application_email'),
            mobileNumber: $('#health_application_mobileinput'),
            otherNumber: $('#health_application_otherinput'),

            partner: {
                title: $('#health_application_partner_title'),
                firstName: $('#health_application_partner_firstname'),
                middleName: $('#health_application_partner_middleName'),
                surname: $('#health_application_partner_surname'),
                dob: $('#health_application_partner_dob'),
                gender: $('input[name=health_application_partner_gender]')
            },

            medicare: {
                colour: $('#health_payment_medicare_colour'),
                number: $('#health_payment_medicare_number'),
                expDay: $('#health_payment_medicare_expiry_cardExpiryDay'),
                expMonth: $('#health_payment_medicare_expiry_cardExpiryMonth'),
                expYear: $('#health_payment_medicare_expiry_cardExpiryYear'),
                position: $('#health_payment_medicare_cardPosition')
            }

        };

        _createFieldsDependants();
    }

    function _createFieldsDependants() {
        if (meerkat.modules.healthDependants.getNumberOfDependants() > 0) {
            for (var i = 1; i <= meerkat.modules.healthDependants.getNumberOfDependants(); i++) {
                $fields['dependant'+i] = {
                    title: $('#health_application_dependants_dependant' + i + '_title'),
                    firstName: $('#health_application_dependants_dependant' + i + '_firstName'),
                    surname: $('#health_application_dependants_dependant' + i + '_lastname'),
                    dob: $('#health_application_dependants_dependant' + i + '_dob'),
                    gender: $('input[name=health_application_dependants_dependant' + i + '_gender]')
                };
                if (_selectedProductFundCode === 'BUP') {
                    $fields['dependant'+i].middleName = $('#health_application_dependants_dependant' + i + '_middleName');
                }
            }
        }
    }

    function onBeforeEnterApply() {

        _selectedProductFundCode = Results.getSelectedProduct().info.FundCode;

        _eventUnsubscriptions();

        if (_selectedProductFundCode === 'MYO') {
            $('.simplesDynamicElements.onlyMyo').toggleClass('hidden', false);
            // Only cache the HTML template and element reference if this is the first time entering the apply step!
            if (!$fundSpecificDynamicDialogueBoxes_MYO) {
                _setupPartnerEmailDynamicTextTemplate();
            }
            performUpdatePartnerEmailDynamicDialogueBox();
        } else {
            $('.simplesDynamicElements.onlyMyo').toggleClass('hidden', true);
        }

        _setupFields();
        _setupListeners();

        _eventSubscriptions();

        _derivedData = _getTemplateData();
        performUpdatePrimaryDataDynamicDialogueBoxes();
        performUpdatePrimaryDOBDynamicDialogueBox();
        performUpdateResidentialDynamicDialogueBox();
        performUpdatePostalDynamicDialogueBox();
        performUpdateMobileDynamicDialogueBox();
        performUpdatePrimaryEmailDynamicDialogueBox();
        performUpdateMedicareDynamicDialogueBox();
        performUpdatePartnerDataDynamicDialogueBoxes();
        performUpdatePartnerDOBDynamicDialogueBox();
        performUpdateDependantsDynamicDialogueBox();

        performResetMedicareCardSpellingNonDynamicDialogueBox();
        performResetYourFullNameNonDynamicDialogueBox();
        performResetResidentialAddressNonDynamicDialogueBox();
        performResetPostalAddressNonDynamicDialogueBox();
        performResetEmailAddressNonDynamicDialogueBox();
        performResetAllOnMedicareCardNonDynamicDialogueBox();
        performResetAdditionalPeopleCoveredNonDynamicDialogueBox();
        performResetPartnersGenderNonDynamicDialogueBox();
        performResetThisCallIsRecordedNonDynamicDialogueBox();
        performResetLodgingFormToClaimAGRPrivacyNoteNonDynamicDialogueBox();
    }

    function performUpdatePrimaryDataDynamicDialogueBoxes() {

        try {
            var newHtml = $dynamicDialogueBoxesPrimaryData.template.valueOf();
            replacePlaceholderText($dynamicDialogueBoxesPrimaryData.elementRef, newHtml, null);
        }
        catch(err) {
            console.error( "Primary applicant's name dynamic text replacement did not occur due to an error");
        }
    }

    function performUpdatePrimaryGenderDynamicDialogueBoxes() {

        try {
            var newHtml = $dynamicDialogueBoxesPrimaryGender.template.valueOf();
            replacePlaceholderText($dynamicDialogueBoxesPrimaryGender.elementRef, newHtml, null);
        }
        catch(err) {
            console.error( "Primary applicant's gender dynamic text replacement did not occur due to an error");
        }
    }

    function performUpdatePrimaryDOBDynamicDialogueBox() {
        try {
            var newHtml = $dynamicDialogueBoxPrimaryDOB.template.valueOf();
            replacePlaceholderText($dynamicDialogueBoxPrimaryDOB.elementRef, newHtml, null);
        }
        catch(err) {
            console.error( "Primary applicant's DOB dynamic text replacement did not occur due to an error");
        }
    }

    function performUpdateResidentialDynamicDialogueBox() {
        try {
            var newHtml = $dynamicDialogueBoxResidential.template.valueOf();
            replacePlaceholderText($dynamicDialogueBoxResidential.elementRef, newHtml, null);
        }
        catch(err) {
            console.error( "Primary applicant's residential address dynamic text replacement did not occur due to an error");
        }
    }

    function performUpdatePostalDynamicDialogueBox() {
        try {
            var newHtml = $dynamicDialogueBoxPostal.template.valueOf();
            replacePlaceholderText($dynamicDialogueBoxPostal.elementRef, newHtml, null);
        }
        catch(err) {
            console.error( "Primary applicant's postal address dynamic text replacement did not occur due to an error");
        }
    }

    function performUpdateMobileDynamicDialogueBox() {
        try {
            var newHtml = $dynamicDialogueBoxMobile.template.valueOf();
            replacePlaceholderText($dynamicDialogueBoxMobile.elementRef, newHtml, null);
        }
        catch(err) {
            console.error( "Primary applicant's mobile number dynamic text replacement did not occur due to an error");
        }
    }

    function performUpdatePrimaryEmailDynamicDialogueBox() {
        try {
            var newHtml = $dynamicDialogueBoxPrimaryEmail.template.valueOf();
            replacePlaceholderText($dynamicDialogueBoxPrimaryEmail.elementRef, newHtml, null);
        }
        catch(err) {
            console.error( "Primary applicant's email address dynamic text replacement did not occur due to an error");
        }
    }

    function performUpdateMedicareDynamicDialogueBox() {
        try {
            var newHtml = $dynamicDialogueBoxMedicare.template.valueOf();
            replacePlaceholderText($dynamicDialogueBoxMedicare.elementRef, newHtml, null);
        }
        catch(err) {
            console.error( "Primary applicant's medicare details dynamic text replacement did not occur due to an error");
        }
    }

    function performUpdatePartnerDataDynamicDialogueBoxes() {
        try {
            var newHtml = $dynamicDialogueBoxesPartnerData.template.valueOf();
            replacePlaceholderText($dynamicDialogueBoxesPartnerData.elementRef, newHtml, null);
        }
        catch(err) {
            console.error( "Partner applicant's name dynamic text replacement did not occur due to an error");
        }
    }

    function performUpdatePartnerGenderDynamicDialogueBoxes() {
        try {
            var newHtml = $dynamicDialogueBoxesPartnerGender.template.valueOf();
            replacePlaceholderText($dynamicDialogueBoxesPartnerGender.elementRef, newHtml, null);
        }
        catch(err) {
            console.error( "Partner applicant's gender dynamic text replacement did not occur due to an error");
        }
    }

    function performUpdatePartnerEmailDynamicDialogueBox() {
        try {
            if ($fundSpecificDynamicDialogueBoxes_MYO) {

                $fundSpecificDynamicDialogueBoxes_MYO.forEach(function(item) {
                    var newHtml = item.template.valueOf();
                    replacePlaceholderText(item.elementRef, newHtml, null);
                });
            }
        }
        catch(err) {
            console.error( "Fund Specific (MYO) partner applicant's email address dynamic text replacement did not occur due to an error");
        }
    }

    function performUpdatePartnerDOBDynamicDialogueBox() {
        try {
            var newHtml = $dynamicDialogueBoxPartnerDOB.template.valueOf();
            replacePlaceholderText($dynamicDialogueBoxPartnerDOB.elementRef, newHtml, null);
        }
        catch(err) {
            console.error( "Partner applicant's DOB dynamic text replacement did not occur due to an error");
        }
    }

    function performUpdateDependantsDynamicDialogueBox() {
        if (meerkat.modules.healthDependants.getNumberOfDependants() > 0) {
            for (var i = 1; i <= meerkat.modules.healthDependants.getNumberOfDependants(); i++) {
                if(_.has($dynamicDialogueBoxDependants, i.toString())) {
                    try {
                        var newHtml = $dynamicDialogueBoxDependants[i.toString()].template.valueOf();
                        replacePlaceholderText($dynamicDialogueBoxDependants[i.toString()].elementRef, newHtml, null, i);
                        $dynamicDialogueBoxDependants[i.toString()].dialog.removeClass("hidden");
                    }
                    catch (err) {
                        console.error("Dependant" + i + " details dynamic text replacement did not occur due to an error", err);
                        $dynamicDialogueBoxDependants[i.toString()].dialog.addClass("hidden");
                    }
                } else {
                    console.error("Dependant" + i + " has no dynamic template defined in $dynamicDialogueBoxDependants");
                }
            }
        }
    }


    // This function requires:
    // an element selector reference  (The element to be updated),
    // the html template (the original HTML template for the element which contains the original placeholder text values),
    // onParse ( a function that can be run upon updating the element)
    //
    // It searches the _dynamicValues array for any matching placeholders and replaces any matching placeholders
    function replacePlaceholderText(elementRef, newHtml, onParse, position) {
        if(!elementRef || !newHtml) return;
        position = position || null;

        _.defer(function () {
            var dialogue = elementRef;
            var html = newHtml;

            for(var i = 0; i < _dynamicValues.length; i++) {
                var value = _dynamicValues[i];
                if(html.indexOf(value.text) > -1) {
                    html = html.replace(new RegExp(value.text, 'g'), value.get(position));
                }
            }

            dialogue.html(html);

            if(onParse && typeof onParse === 'function') {
                onParse();
            }
        });
    }


    function performResetMedicareCardSpellingNonDynamicDialogueBox() {

        try {
            var newHtml = $nonDynamicDialogueBoxMedicareCardSpelling.template.valueOf();
            $nonDynamicDialogueBoxMedicareCardSpelling.elementRef.html(newHtml);
        }
        catch(err) {
            console.error( "Resetting the Mandatory Medicare Card Spelling dialogue box did not occur due to an error");
        }
    }

    function performResetYourFullNameNonDynamicDialogueBox() {

        try {
            var newHtml = $nonDynamicDialogueBoxYourFullName.template.valueOf();
            $nonDynamicDialogueBoxYourFullName.elementRef.html(newHtml);
        }
        catch(err) {
            console.error( "Resetting the Mandatory Your Full Name dialogue box did not occur due to an error");
        }
    }

    function performResetResidentialAddressNonDynamicDialogueBox() {

        try {
            var newHtml = $nonDynamicDialogueBoxResidentialAddress.template.valueOf();
            $nonDynamicDialogueBoxResidentialAddress.elementRef.html(newHtml);
        }
        catch(err) {
            console.error( "Resetting the Mandatory Residential Address dialogue box did not occur due to an error");
        }
    }

    function performResetPostalAddressNonDynamicDialogueBox() {

        try {
            var newHtml = $nonDynamicDialogueBoxPostalAddress.template.valueOf();
            $nonDynamicDialogueBoxPostalAddress.elementRef.html(newHtml);
        }
        catch(err) {
            console.error( "Resetting the Mandatory Postal Address dialogue box did not occur due to an error");
        }
    }

    function performResetEmailAddressNonDynamicDialogueBox() {

        try {
            var newHtml = $nonDynamicDialogueBoxEmailAddress.template.valueOf();
            $nonDynamicDialogueBoxEmailAddress.elementRef.html(newHtml);
        }
        catch(err) {
            console.error( "Resetting the Mandatory Email Address dialogue box did not occur due to an error");
        }
    }

    function performResetAllOnMedicareCardNonDynamicDialogueBox() {

        try {
            var newHtml = $nonDynamicDialogueBoxAllOnMedicareCard.template.valueOf();
            $nonDynamicDialogueBoxAllOnMedicareCard.elementRef.html(newHtml);
        }
        catch(err) {
            console.error( "Resetting the Mandatory Are All people listed on a Medicare Card dialogue box did not occur due to an error");
        }
    }

    function performResetAdditionalPeopleCoveredNonDynamicDialogueBox() {

        try {
            var newHtml = $nonDynamicDialogueBoxAdditionalPeopleCovered.template.valueOf();
            $nonDynamicDialogueBoxAdditionalPeopleCovered.elementRef.html(newHtml);
        }
        catch(err) {
            console.error( "Resetting the Mandatory There are Additional People Covered By This Policy dialogue box did not occur due to an error");
        }
    }

    function performResetPartnersGenderNonDynamicDialogueBox() {

        try {
            var newHtml = $nonDynamicDialogueBoxPartnersGender.template.valueOf();
            $nonDynamicDialogueBoxPartnersGender.elementRef.html(newHtml);
        }
        catch(err) {
            console.error( "Resetting the Mandatory What Is Your Partners Gender dialogue box did not occur due to an error");
        }
    }

    function performResetThisCallIsRecordedNonDynamicDialogueBox() {

        try {
            var newHtml = $nonDynamicDialogueBoxThisCallIsRecorded.template.valueOf();
            $nonDynamicDialogueBoxThisCallIsRecorded.elementRef.html(newHtml);
        }
        catch(err) {
            console.error( "Resetting the Mandatory This Call Is Recorded dialogue box did not occur due to an error");
        }
    }

    function performResetLodgingFormToClaimAGRPrivacyNoteNonDynamicDialogueBox() {

        try {
            var newHtml = $nonDynamicDialogueBoxLodgingFormToClaimAGRPrivacyNote.template.valueOf();
            $nonDynamicDialogueBoxLodgingFormToClaimAGRPrivacyNote.elementRef.html(newHtml);
        }
        catch(err) {
            console.error( "Resetting the Mandatory Lodging Form To Claim AGR Privacy Note dialogue box did not occur due to an error");
        }
    }

    function _eventSubscriptions() {
        _stepChangedSubscribe = meerkat.messaging.subscribe(meerkat.modules.journeyEngine.events.journeyEngine.STEP_CHANGED, function stepChangedEvent(navInfo) {
            if (navInfo.isBackward && navInfo.navigationId !== 'apply') {

                if (_selectedProductFundCode === 'MYO') {
                    $('#health_application_partner_email').off('change.dynamicPartnerEmailChanged');
                }
                if (_selectedProductFundCode === 'NIB') {
                    $('#health_application_no_email').off('change.dynamicNibNoEmailChanged');
                }

                $('#dependents_list_options').off('click.dynamicScriptingDependentAdded');
                $("#health-dependants-wrapper").off('click.dynamicScriptingDependentRemoved');
                $("#health-dependants-wrapper").off('change.dynamicScriptingDependentDtls1Updated');
                $("#health-dependants-wrapper").off('change.dynamicScriptingDependentDtls2Updated');
                $fields.primary.title.off('change.dynamicScriptingPrimaryTitle');
                $fields.primary.firstName.off('change.dynamicScriptingPrimaryFirstName');

                if (_selectedProductFundCode === 'NIB' || _selectedProductFundCode === 'BUP') {
                    $fields.primary.middleName.off('change.dynamicScriptingPrimaryMiddleName');
                }

                $fields.primary.surname.off('change.dynamicScriptingPrimarySurname');
                $fields.primary.dob.off('change.dynamicScriptingPrimaryDob');
                $fields.primary.gender.off('change.dynamicScriptingPrimaryGender');
                $fields.mobileNumber.off('change.dynamicScriptingMobileNumber');
                $fields.otherNumber.off('change.dynamicScriptingOtherNumber');
                $fields.email.off('change.dynamicScriptingEmail');
                $fields.address.residential.postcode.off('change.dynamicScriptingResidentialPostcode');
                $fields.address.residential.suburb.off('change.dynamicScriptingResidentialSuburb');
                $fields.address.residential.unitShop.off('change.dynamicScriptingResidentialUnitShop');
                $fields.address.residential.streetNum.off('change.dynamicScriptingResidentialStreetNum');
                $fields.address.residential.streetName.off('change.dynamicScriptingResidentialStreetName');
                $fields.address.residential.unitType.off('change.dynamicScriptingResidentialUnitType');
                $fields.address.residential.nonStdStreet.off('change.dynamicScriptingResidentialNonStdStreet');
                $fields.address.residential.streetSearch.off('change.dynamicScriptingResidentialStreetSearch');
                $fields.address.residential.nonStd.off('change.dynamicScriptingResidentialNonStd');
                $fields.address.residential.suburbName.off('change.dynamicScriptingResidentialSuburbName');
                $fields.address.residential.state.off('change.dynamicScriptingResidentialState');
                $fields.address.residential.fullAddress.off('change.dynamicScriptingResidentialFullAddress');
                $fields.postalMatch.off('change.dynamicScriptingPostalMatch');
                $fields.address.postal.postcode.off('change.dynamicScriptingPostalPostcode');
                $fields.address.postal.suburb.off('change.dynamicScriptingPostalSuburb');
                $fields.address.postal.unitShop.off('change.dynamicScriptingPostalUnitShop');
                $fields.address.postal.streetNum.off('change.dynamicScriptingPostalStreetNum');
                $fields.address.postal.streetName.off('change.dynamicScriptingPostalStreetName');
                $fields.address.postal.unitType.off('change.dynamicScriptingPostalUnitType');
                $fields.address.postal.nonStdStreet.off('change.dynamicScriptingPostalNonStdStreet');
                $fields.address.postal.streetSearch.off('change.dynamicScriptingPostalStreetSearch');
                $fields.address.postal.nonStd.off('change.dynamicScriptingPostalNonStd');
                $fields.address.postal.suburbName.off('change.dynamicScriptingPostalSuburbName');
                $fields.address.postal.state.off('change.dynamicScriptingPostalState');
                $fields.address.postal.fullAddress.off('change.dynamicScriptingPostalFullAddress');
                $fields.medicare.colour.off('change.dynamicScriptingMedicareColour');
                $fields.medicare.number.off('change.dynamicScriptingMedicareNumber');
                $fields.medicare.expDay.off('change.dynamicScriptingMedicareExpDay');
                $fields.medicare.expMonth.off('change.dynamicScriptingMedicareExpMonth');
                $fields.medicare.expYear.off('change.dynamicScriptingMedicareExpYear');
                $fields.medicare.number.off('change.dynamicScriptingMedicarePosition');
                $fields.partner.title.off('change.dynamicScriptingPartnerTitle');
                $fields.partner.firstName.off('change.dynamicScriptingPartnerFirstName');
                $fields.partner.middleName.off('change.dynamicScriptingPartnerMiddleName');
                $fields.partner.surname.off('change.dynamicScriptingPartnerSurname');
                $fields.partner.dob.off('change.dynamicScriptingPartnerDob');
                $fields.partner.gender.off('change.dynamicScriptingPartnerGender');
            }

            if (navInfo.isBackward && navInfo.navigationId === 'results' && _states.fetchResults) {
                meerkat.modules.journeyEngine.loadingShow('...updating your quotes...', true);
                meerkat.modules.healthResults.get();
            }
        });
    }

    function _eventUnsubscriptions() {
        meerkat.messaging.unsubscribe(meerkat.modules.journeyEngine.events.journeyEngine.STEP_CHANGED, _stepChangedSubscribe);
    }

    function natoPhoneticText( textToParse) {
        if(!textToParse) return '';

        var natoConfig = {
            'B': 'B for Bravo',
            'D': 'D for Delta',
            'F': 'F for Foxtrot',
            'M': 'M for Mike',
            'N': 'N for November',
            'P': 'P for Papa',
            'S': 'S for Sierra',
            'T': 'T for Tango',
            'V': 'V for Victor',
            'Y': 'Y for Yankee',
            'Z': 'Z for Zulu',
            ' ': 'and',
            '-': 'hyphen'
        };

        var result = '';

        for (var i = 0; i < textToParse.length; i++)
        {
            var letter = textToParse.toUpperCase().charAt(i);
            var output = letter in natoConfig ? natoConfig[letter] : letter;
            result = result + output + ' ';
        }
        return result.trim();
    }

    function webPhoneticText( textToParse) {
        if(!textToParse) return '';

        textToParse = natoPhoneticText(textToParse);

        var emailConfig = {
            '_': 'underscore',
            '.': 'dot',
            '@': 'at'
        };

        var result = '';

        for (var i = 0; i < textToParse.length; i++)
        {
            var letter = textToParse.charAt(i);
            var output = letter in emailConfig ? emailConfig[letter] : letter;
            result = result + output;
        }
        return result;
    }


    function phoneticEmailAddress( emailAddressToParse ) {
        var returnVal = 'PLEASE ENTER A VALID EMAIL ADDRESS';

        var emailInput = emailAddressToParse.trim();
        var emailInputLength = emailInput.length;

        if (emailInputLength >= 6) {
            var atCharIndex = emailInput.lastIndexOf("@");

            // shortest valid email example j@j.co
            if (atCharIndex > 0 && (emailInputLength >= atCharIndex + 5)) {

                returnVal = '';

                var localPart = emailInput.slice(0, atCharIndex+1);
                var fulldomain = emailInput.slice(atCharIndex+1);
                var exactMatchFullDomain = false;

                switch (fulldomain.toLowerCase()) {
                    case 'gmail.com':
                        returnVal = webPhoneticText(localPart) + ' gmail dot com';
                        exactMatchFullDomain = true;
                        break;
                    case 'hotmail.com':
                        returnVal = webPhoneticText(localPart) + ' hotmail dot com';
                        exactMatchFullDomain = true;
                        break;
                    case 'bigpond.com':
                        returnVal = webPhoneticText(localPart) + ' bigpond dot com';
                        exactMatchFullDomain = true;
                        break;
                    case 'outlook.com':
                        returnVal = webPhoneticText(localPart) + ' outlook dot com';
                        exactMatchFullDomain = true;
                        break;
                    case 'yahoo.com.au':
                        returnVal = webPhoneticText(localPart) + ' yahoo dot com dot au';
                        exactMatchFullDomain = true;
                        break;
                    case 'yahoo.com':
                        returnVal = webPhoneticText(localPart) + ' yahoo dot com';
                        exactMatchFullDomain = true;
                        break;
                    case 'live.com.au':
                        returnVal = webPhoneticText(localPart) + ' live dot com dot au';
                        exactMatchFullDomain = true;
                        break;
                    case 'live.com':
                        returnVal = webPhoneticText(localPart) + ' live dot com';
                        exactMatchFullDomain = true;
                        break;
                    case 'optusnet.com.au':
                        returnVal = webPhoneticText(localPart) + ' optusnet dot com dot au';
                        exactMatchFullDomain = true;
                        break;
                    case 'icloud.com':
                        returnVal = webPhoneticText(localPart) + ' icloud dot com';
                        exactMatchFullDomain = true;
                        break;
                    case 'bigpond.net.au':
                        returnVal = webPhoneticText(localPart) + ' bigpond dot net dot au';
                        exactMatchFullDomain = true;
                        break;
                    case 'hotmail.co.uk':
                        returnVal = webPhoneticText(localPart) + ' hotmail dot co dot uk';
                        exactMatchFullDomain = true;
                        break;
                    case 'iinet.net.au':
                        returnVal = webPhoneticText(localPart) + ' iinet dot net dot au';
                        exactMatchFullDomain = true;
                        break;
                    case 'me.com':
                        returnVal = webPhoneticText(localPart) + ' me dot com';
                        exactMatchFullDomain = true;
                        break;
                    case 'y7mail.com':
                        returnVal = webPhoneticText(localPart) + ' y7mail dot com';
                        exactMatchFullDomain = true;
                        break;
                    case 'tpg.com.au':
                        returnVal = webPhoneticText(localPart) + ' tpg dot com dot au';
                        exactMatchFullDomain = true;
                        break;
                    case 'hotmail.com.au':
                        returnVal = webPhoneticText(localPart) + ' hotmail dot com dot au';
                        exactMatchFullDomain = true;
                        break;
                    case 'outlook.com.au':
                        returnVal = webPhoneticText(localPart) + ' outlook dot com dot au';
                        exactMatchFullDomain = true;
                        break;
                    case 'msn.com':
                        returnVal = webPhoneticText(localPart) + ' msn dot com';
                        exactMatchFullDomain = true;
                        break;
                    case 'yahoo.co.uk':
                        returnVal = webPhoneticText(localPart) + ' yahoo dot co dot uk';
                        exactMatchFullDomain = true;
                        break;
                    case 'westnet.com.au':
                        returnVal = webPhoneticText(localPart) + ' westnet dot com dot au';
                        exactMatchFullDomain = true;
                        break;
                    case 'ymail.com':
                        returnVal = webPhoneticText(localPart) + ' ymail dot com';
                        exactMatchFullDomain = true;
                        break;
                    case 'bigpond.com.au':
                        returnVal = webPhoneticText(localPart) + ' bigpond dot com dot au';
                        exactMatchFullDomain = true;
                        break;
                    case 'mail.com':
                        returnVal = webPhoneticText(localPart) + ' mail dot com';
                        exactMatchFullDomain = true;
                        break;
                    case 'iprimus.com.au':
                        returnVal = webPhoneticText(localPart) + ' iprimus dot com dot au';
                        exactMatchFullDomain = true;
                        break;
                    case 'internode.on.net':
                        returnVal = webPhoneticText(localPart) + ' internode dot on dot net';
                        exactMatchFullDomain = true;
                        break;
                    case 'aol.com':
                        returnVal = webPhoneticText(localPart) + ' aol dot com';
                        exactMatchFullDomain = true;
                        break;
                    case 'dodo.com.au':
                        returnVal = webPhoneticText(localPart) + ' dodo dot com dot au';
                        exactMatchFullDomain = true;
                        break;
                    case 'ozemail.com.au':
                        returnVal = webPhoneticText(localPart) + ' ozemail dot com dot au';
                        exactMatchFullDomain = true;
                        break;
                    case 'yahoo.co.in':
                        returnVal = webPhoneticText(localPart) + ' yahoo dot co dot in';
                        exactMatchFullDomain = true;
                        break;
                    case 'aapt.net.au':
                        returnVal = webPhoneticText(localPart) + ' aapt dot net dot au';
                        exactMatchFullDomain = true;
                        break;
                    case 'live.co.uk':
                        returnVal = webPhoneticText(localPart) + ' live dot co dot uk';
                        exactMatchFullDomain = true;
                        break;
                    case 'googlemail.com':
                        returnVal = webPhoneticText(localPart) + ' googlemail dot com';
                        exactMatchFullDomain = true;
                        break;
                    case 'rocketmail.com':
                        returnVal = webPhoneticText(localPart) + ' rocketmail dot com';
                        exactMatchFullDomain = true;
                        break;
                    case 'mac.com':
                        returnVal = webPhoneticText(localPart) + ' mac dot com';
                        exactMatchFullDomain = true;
                        break;
                    case 'telstra.com':
                        returnVal = webPhoneticText(localPart) + ' telstra dot com';
                        exactMatchFullDomain = true;
                        break;
                    case 'windowslive.com':
                        returnVal = webPhoneticText(localPart) + ' windowslive dot com';
                        exactMatchFullDomain = true;
                        break;
                }

                if (!exactMatchFullDomain) {
                    // 6 letter domain name endings  eg .com.au
                    var sixLetterDomainEnding = emailInput.slice(-7);
                    var sixLetterDomainName = emailInput.slice(0, -7);

                    var exactMatch6LetterDomain = false;

                    switch (sixLetterDomainEnding.toLowerCase()) {
                        case '.com.au':
                            returnVal = webPhoneticText(sixLetterDomainName) + ' dot com dot au';
                            exactMatch6LetterDomain = true;
                            break;
                        case '.net.au':
                            returnVal = webPhoneticText(sixLetterDomainName) + ' dot net dot au';
                            exactMatch6LetterDomain = true;
                            break;
                        case '.edu.au':
                            returnVal = webPhoneticText(sixLetterDomainName) + ' dot edu dot au';
                            exactMatch6LetterDomain = true;
                            break;
                        case '.gov.au':
                            returnVal = webPhoneticText(sixLetterDomainName) + ' dot gov dot au';
                            exactMatch6LetterDomain = true;
                            break;
                    }

                    if (!exactMatch6LetterDomain) {

                        // check 3 letter domain name endings eg .com
                        var threeLetterDomainEnding = emailInput.slice(-4);
                        var threeLetterDomainName = emailInput.slice(0, -4);
                        var exactMatch3LetterDomain = false;

                        switch (threeLetterDomainEnding.toLowerCase()) {
                            case '.com':
                                returnVal = webPhoneticText(threeLetterDomainName) + ' dot com';
                                exactMatch3LetterDomain = true;
                                break;
                            case '.net':
                                returnVal = webPhoneticText(threeLetterDomainName) + ' dot net';
                                exactMatch3LetterDomain = true;
                                break;
                            case '.org':
                                returnVal = webPhoneticText(threeLetterDomainName) + ' dot org';
                                exactMatch3LetterDomain = true;
                                break;
                        }

                        if (!exactMatch3LetterDomain) {
                            // check 4 letter domain name endings eg .co.uk
                            var fourLetterDomainEnding = emailInput.slice(-6);
                            var fourLetterDomainName = emailInput.slice(0, -6);
                            var exactMatch4LetterDomain = false;

                            switch (fourLetterDomainEnding.toLowerCase()) {
                                case '.co.uk':
                                    returnVal = webPhoneticText(fourLetterDomainName) + ' dot co dot uk';
                                    exactMatch4LetterDomain = true;
                                    break;
                                case '.co.nz':
                                    returnVal = webPhoneticText(fourLetterDomainName) + ' dot co dot nz';
                                    exactMatch4LetterDomain = true;
                                    break;
                            }

                            if (!exactMatch4LetterDomain) {
                                // email address does not match any commonly used domain names
                                return webPhoneticText(emailInput);
                            }

                        }
                    }
                }
            }
        } else if (emailInputLength === 0) {
            returnVal = 'NO EMAIL ADDRESS SUPPLIED';
        }

        return returnVal;
    }

    function _getTemplateData() {
        var email = (!_.isUndefined($fields.email) ? $fields.email.val() : ''),
            residentialAddress = _getAddressData('residential'),
            postalAddress = _getAddressData('postal'),
            mobileNumber = (!_.isUndefined($fields.mobileNumber) ? $fields.mobileNumber.val() : ''),
            otherNumber = (!_.isUndefined($fields.otherNumber) ? $fields.otherNumber.val() : ''),
            primaryDOB = _getPersonDOB('primary'),
            data = {
                primary: _getPersonData('primary'),
                medicare: _getMedicareData()
            };

        data.primaryDOB = primaryDOB;
        data.residentialAddress = residentialAddress;
        data.postalAddress = postalAddress;
        data.mobileNumber = mobileNumber;
        data.otherNumber = otherNumber;

        data.emailAddress = email;

        if (meerkat.modules.health.hasPartner()) {
            data.partner = _getPersonData('partner');
            var partnerDOB = _getPersonDOB('partner');
            data.partnerDOB = partnerDOB;
        }

        if (meerkat.modules.healthDependants.getNumberOfDependants() > 0) {
            data.dependants = [];
            for (var i = 1; i <= meerkat.modules.healthDependants.getNumberOfDependants(); i++) {
                data.dependants.push(_getPersonData('dependant'+i));
            }
        }

        return data;
    }

    function _getMedicareData() {

        _derivedData.medicare = {};

        var colour = (!_.isUndefined($fields.medicare.colour) ? $fields.medicare.colour.val() : ''),
            number = (!_.isUndefined($fields.medicare.number) ? $fields.medicare.number.val() : ''),
            expMonth = (!_.isUndefined($fields.medicare.expMonth) ? $fields.medicare.expMonth.val() : ''),
            expYear = (!_.isUndefined($fields.medicare.expYear) ? $fields.medicare.expYear.val() : ''),
            position = (!_.isUndefined($fields.medicare.position) ? $fields.medicare.position.val() : ''),
            data = {
                colour: colour,
                number: number,
                expMonth: expMonth,
                expYear: expYear,
                position: position
            };

        if (data.colour === 'yellow' || data.colour === 'blue') {
            var expDay = (!_.isUndefined($fields.medicare.expDay) ? $fields.medicare.expDay.val() : '');
            if (expDay) {
                data.expDay = expDay;
            }
        }

        return data;
    }

    // The following functions handle collating text to be used by dynamic placeholders
    function _getPersonData(person) {
        var fullName = (!_.isUndefined($fields[person].title) ? (_getOptionText($fields[person].title) !== 'Title' ? _getOptionText($fields[person].title) + ' ' : '') : '') +
            (!_.isUndefined($fields[person].firstName) ? $fields[person].firstName.val() + ' ' : ''),
            firstName = (!_.isUndefined($fields[person].firstName) ? $fields[person].firstName.val().trim() : ''),
            middleInitial = '',
            middleName = '',
            surname = (!_.isUndefined($fields[person].surname) ? $fields[person].surname.val().trim() : ''),
            gender = _getGender($fields[person]);

        middleName = (!_.isUndefined($fields[person].middleName) ? $fields[person].middleName.val() : '');
        middleInitial = (middleName.length > 0 ? middleName.charAt(0) : '');
        fullName += (!_.isUndefined($fields[person].middleName) ? $fields[person].middleName.val() + ' ' : '') +
            (!_.isUndefined($fields[person].surname) ? $fields[person].surname.val() : '');

        var data = {
                fullName: fullName,
                firstName: firstName,
                middleInitial: middleInitial,
                middleName: middleName,
                surname: surname,
                gender: gender
            };

        if (person !== 'primary') {
            data.relationship = (person === 'partner' ? 'Partner' : 'Dependant');
        }

        if (data.relationship === 'Dependant') {
            var dob = (!_.isUndefined($fields[person].dob) ? _getDobFormatted($fields[person].dob) : '');
            data.dateOfBirth = dob;
        }

        return data;
    }

    function _getPersonDOB(person) {
        return (!_.isUndefined($fields[person].dob) ? _getDobFormatted($fields[person].dob) : '');
    }

    function _getOptionText($el) {
        return $el.find('option').filter(':selected').text();
    }

    function _getGender($person) {
        var returnVal = '';
        if (!_.isUndefined($person.gender)) {
            if (!_.isUndefined($person.gender.filter(':checked').val()) && $person.gender.filter(':checked').val()) {
                returnVal = (($person.gender.filter(':checked').val()) ? ($person.gender.filter(':checked').val() === 'F' ? 'Female' : 'Male') : '');
            } else {
                returnVal = ((!_.isUndefined($person.title.val()) && $person.title.val()) ? ($person.title.val() === 'MR' ? 'Male' : ($person.title.val() === 'DR' ? '' : 'Female')) : '');
            }
        } else {
            returnVal = ((!_.isUndefined($person.title.val()) && $person.title.val()) ? ($person.title.val() === 'MR' ? 'Male' : ($person.title.val() === 'DR' ? '' : 'Female')) : '');
        }
        return returnVal;
    }

    function _getDobFormatted($el) {
        var dob = meerkat.modules.dateUtils.returnDate($el.val());

        return meerkat.modules.dateUtils.format(new Date(dob), 'D MMMM YYYY');
    }

    function _getAddressData(addressType) {

        var isPostalMatch = ($fields.postalMatch.filter(':checked').length > 0),
            returnAddrType = isPostalMatch ? 'residential': addressType,
            //nonStdStreet and streetSearch cannot be trusted without checking the value of elasticSearch
            fullAddress = $fields.address[returnAddrType].fullAddress.val(),
            suburb = $fields.address[returnAddrType].suburbName.val(),
            state = $fields.address[returnAddrType].state.val(),
            postcode = $fields.address[returnAddrType].postcode.val(),
            isNonStdAddress = $fields.address[returnAddrType].nonStd.filter(':checked').val(),
            nonStdStreet = $fields.address[returnAddrType].nonStdStreet.val(),
            unitType = $fields.address[returnAddrType].unitType.val(),
            unitNo = $fields.address[returnAddrType].unitShop.val(),
            streetNum = $fields.address[returnAddrType].streetNum.val(),
            streetName = $fields.address[returnAddrType].streetName.val(),
            addrLn1 = '';

        if (isNonStdAddress === 'Y' && unitType !== 'UN') {
            // Add specific prefix if required
            if (unitType === 'PO') {
                addrLn1 = "Post Office Box ";
            } else if (unitType === 'SH') {
                addrLn1 = "Shop ";
            } else if (unitType === 'L') {
                addrLn1 = "Level ";
            }

            if (unitType === 'PO') {
                // There should not be a situation where both of these fields are populated (it would be better to hide the unit number field if PO is chosen to avoid confusion)
                // none the less should the situation arise somehow the 'po box No' should be displayed first
                if (streetNum.length > 0) {
                    addrLn1 += streetNum + " ";
                }

            } else {
                if (unitNo.length > 0) {
                    addrLn1 += unitNo + " ";
                }

                if (unitNo.length > 0 && streetNum.length > 0) {
                    addrLn1 += "/ ";
                }

                if (streetNum.length > 0) {
                    addrLn1 += streetNum + " ";
                }
            }

            if(streetName.length > 0 || nonStdStreet.length > 0) {
                addrLn1 += (streetName.length > 0 ? streetName : nonStdStreet) + ' ';
            }
        } else if (isNonStdAddress === 'Y') {
            if (unitNo.length > 0) {
                addrLn1 += unitNo + " ";
            }

            if (unitNo.length > 0 && streetNum.length > 0) {
                addrLn1 += "/ ";
            }

            if (streetNum.length > 0) {
                addrLn1 += streetNum + " ";
            }

            if(streetName.length > 0 || nonStdStreet.length > 0) {
                addrLn1 += (streetName.length > 0 ? streetName : nonStdStreet) + ' ';
            }
        } else {
            if (fullAddress.lastIndexOf(suburb) > 1) {
                addrLn1 = fullAddress.substr(0, (fullAddress.lastIndexOf(suburb) - 1));
            } else if (fullAddress.lastIndexOf(state) > 1) {
                addrLn1 = fullAddress.substr(0, (fullAddress.lastIndexOf(state) - 1));
            } else {
                addrLn1 = fullAddress.substr(0, (fullAddress.lastIndexOf(postcode) - 1));
            }
        }

        return addrLn1 + ' '
            + (suburb ? (suburb + ' ') : '') + (state ? (state + ' ') : '')
            + postcode;
    }

    meerkat.modules.register('healthApplicationDynamicScripting', {
        onInitialise: onInitialise,
        onBeforeEnterApply: onBeforeEnterApply,
        events: moduleEvents
    });

})(jQuery);
