;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        _template = null,
        _dialogId = null,
        $elements = {},
        $primaryDob = null,
        $partnerDob = null,
        $dependantsIncome = null,
        $fields = {},
        _submitCallback = null;

    function onInitialise() {

        _setupFields();

        _submitCallback = null;

        $primaryDob = $('#health_application_primary_dob');
        $partnerDob = $('#health_application_partner_dob');
        $dependantsIncome = $('#health_application_dependants_income');

        _template = _.template($('#payment-confirm-details-modal-template').html());
    }

    function _phoneticAlphabetSetup() {
        var list = [
          "A:	Alpha",
          "B:	Bravo",
          "C:	Charlie",
          "D:	Delta",
          "E:	Echo",
          "F:	Foxtrot",
          "G:	Golf",
          "H:	Hotel",
          "I:	India",
          "J:	Juliet",
          "K:	Kilo",
          "L:	Lima",
          "M:	Mike",
          "N:	November",
          "O:	Oscar",
          "P:	Papa",
          "Q:	Quebec",
          "R:	Romeo",
          "S:	Sierra",
          "T:	Tango",
          "U:	Uniform",
          "V:	Victor",
          "W:	Whisky",
          "X:	X-Ray",
          "Y:	Yankee",
          "Z:	Zulu"
        ];

        var $parentElement = $('.phonetic-alphabet');
        var listElement = $parentElement.find('ul');
        var $modal = $('#payment-confirm-details-modal .modal-dialog');
        var childElements = [];
        
        listElement.empty();
        for (var i = 0; i < list.length; i++) {
          childElements.push(getListElement(list[i]));
        }
        listElement.append(childElements);
        // adds some spacing between the two modals
        $parentElement.css({ left: $modal.width() + 10 });
        $modal.append($parentElement);
    }

    function getListElement(text) {
        return '<li>' + text + '</li>';
    }

    function _setupFields() {
        $fields = {
            primary: {
                title: $('#health_application_primary_title'),
                firstName: $('#health_application_primary_firstname'),
                middleName: $('#health_application_primary_middleName'),
                surname: $('#health_application_primary_surname'),
                dob: $('#health_application_primary_dob'),
                gender: $('input[name=health_application_primary_gender]'),
                mobileNumber: $('#health_application_mobileinput'),
                otherNumber: $('#health_application_otherinput')
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

            rebate: {
                applyRebate: $('input[name=health_healthCover_rebate]'),
                currentPercentage: $('#health_rebate'),
                tier: $('#health_healthCover_income')
            },

            partner: {
                title: $('#health_application_partner_title'),
                firstName: $('#health_application_partner_firstname'),
                surname: $('#health_application_partner_surname'),
                dob: $('#health_application_partner_dob'),
                gender: $('input[name=health_application_partner_gender]')
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
                    dob: $('#health_application_dependants_dependant' + i + '_dob')
                };
            }
        }
    }

    function _applyFormEventListeners() {
        $elements.editBtn.on('click', function() {

            // navigate to the apply step
            meerkat.modules.journeyEngine.gotoPath('apply');
            close();

        });

        $elements.submitBtn.on('click', function() {
            _onSubmit();
        });
    }

    function _setupElements() {
        $elements = {
            section: {
                your: $('.payment-confirm-details-your-details-section'),
                others: $('.payment-confirm-details-others-details-section')
            },
            editBtn: $('.edit-details-btn'),
            form: $('#payment-confirm-dtls-form'),
            submitBtn: $('.btn-continue-to-payment'),
            partnerSection: $('#partnerContainer'),
            dependentSection: $('#health_application_dependants-selection'),
            headerTopFixed: $('.header-top.navMenu-row-fixed'),
            progressBarAffix: $('.progress-bar-row.navbar-affix'),
            productSummary: $('.productSummary-affix'),
            modalBody: $('#payment-confirm-details-modal .modal-body')
        };
    }

    function open(submitCallback) {
        _createFieldsDependants();

        var htmlContent = _template(_getTemplateData());

        if (_.isEmpty(_submitCallback)) {
            _submitCallback = submitCallback;
        }

        _dialogId = meerkat.modules.dialogs.show({
            id: 'payment-confirm-details-modal',
            title: 'Application Review',
            htmlContent: htmlContent,
            showCloseBtn: false,
            onOpen: function (dialogId) {
                _setupElements();
                _applyFormEventListeners();
                _phoneticAlphabetSetup();
                meerkat.modules.jqueryValidate.setupDefaultValidationOnForm($elements.form);
            },
            onClose: function (dialogId) {
            }
        });
    }

    function _getTemplateData() {
        var email = $fields.email.val(),
            residentialAddress = _getAddressData('residential'),
            postalAddress = _getAddressData('postal'),
            mobileNumber = $fields.primary.mobileNumber.val(),
            otherNumber = $fields.primary.otherNumber.val(),
            daytimePhoneNumber = mobileNumber ? mobileNumber : otherNumber,
            rebateTier = _getRebateTier($fields.rebate.tier.val()),
            rebatePercent = rebateTier + ' - ' + $fields.rebate.currentPercentage.val() + '%',

            data = {
                primary: _getPersonData('primary'),
                rebate: { label: 'Rebate tier', value: rebatePercent },
                showRebateData: $fields.rebate.applyRebate.filter(':checked').val()
            };

        data.primary.push({ label: 'Residential address', value: residentialAddress });
        data.primary.push({ label: 'Postal address', value: postalAddress });
        data.primary.push({ label: 'Daytime phone number', value: daytimePhoneNumber });

        if (mobileNumber && otherNumber) {
            data.primary.push({ label: 'Other number', value: otherNumber });
        }

        data.primary.push({ label: 'Email address', value: email });

        if (meerkat.modules.health.hasPartner()) {
            data.partner = _getPersonData('partner');
        }

        if (meerkat.modules.healthDependants.getNumberOfDependants() > 0) {
            data.dependants = [];
            for (var i = 1; i <= meerkat.modules.healthDependants.getNumberOfDependants(); i++) {
                data.dependants.push(_getPersonData('dependant'+i));
            }
        }

        return data;
    }

    function _getPersonData(person) {
        var fullName = _getOptionText($fields[person].title) + ' ' + $fields[person].firstName.val() + ' ' +
                (!_.isUndefined($fields[person].middleName) ? $fields[person].middleName.val() + ' ' : '') +
                $fields[person].surname.val(),
            dob = _getDobFormatted($fields[person].dob),
            gender = _getGender($fields[person]),
            data = [
                { label: 'Full name' + ( person === 'primary' && '<span class="payment-confirm-warning-text">as it appears on your Medicare card</span>') , value: fullName },
                { label: 'Date of birth', value: dob },
                { label: 'Gender', value: gender }
            ];

        if (person !== 'primary') {
            data.push({
                label: 'Relationship',
                value: person === 'partner' ? 'Partner' : 'Dependant'
            });
        }

        return data;
    }

    function _getOptionText($el) {
        return $el.find('option').filter(':selected').text();
    }

    function _getGender($person) {

        if (!_.isUndefined($person.gender)) {
            return $person.gender.filter(':checked').val() === 'F' ? 'Female' : 'Male';
        } else {
            return (!_.isUndefined($person.title.val()) ? ($person.title.val() === 'MR' ? 'Male' : 'Female') : '');
        }
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
            isNonStdAddress = $fields.address[returnAddrType].nonStd.val(),
            nonStdStreet = $fields.address[returnAddrType].nonStdStreet.val(),
            unitType = $fields.address[returnAddrType].unitType.val(),
            unitNo = $fields.address[returnAddrType].unitShop.val(),
            streetNum = $fields.address[returnAddrType].streetNum.val(),
	        streetName = $fields.address[returnAddrType].streetName.val(),
	        addrLn1 = '';

        if (isNonStdAddress === 'Y' && unitType !== 'UN') {
            // Add specific prefix if required
            if (unitType === 'PO') {
                addrLn1 = "PO BOX ";
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

                if (unitNo.length > 0) {
                    addrLn1 += unitNo + "  ";
                }

            } else {
                if (unitNo.length > 0) {
                    addrLn1 += unitNo + "  ";
                }

                // for clarity a slash could be added here if both exist

                if (streetNum.length > 0) {
                    addrLn1 += streetNum + " ";
                }
            }

            if(streetName.length > 0 || nonStdStreet.length > 0) {
                addrLn1 += (streetName.length > 0 ? streetName : nonStdStreet) + " ";
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

        return addrLn1 + '<br/>'
            + (suburb ? (suburb + '  ') : '') + (state ? (state + '  ') : '')
            + postcode;
    }

    function _getRebateTier(rebateTierEnum) {
        if (rebateTierEnum > 0) {
            return 'Tier ' + rebateTierEnum;
        } else {
            return 'Base tier';
        }
    }

    function close() {
        if (meerkat.modules.dialogs.isDialogOpen(_dialogId)) {
            meerkat.modules.dialogs.close(_dialogId);
        }
    }

    function _onSubmit() {
        close();

        //trigger submitApplication() in health.js
        meerkat.modules.healthFundTimeOffset.checkBeforeSubmit(_submitCallback);
    }

    meerkat.modules.register('healthPayConfDetailsModal', {
        onInitialise: onInitialise,
        events: moduleEvents,
        open: open
    });

})(jQuery);
