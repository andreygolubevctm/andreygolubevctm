;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        _getRequiredFundsAjax = null,
        _funds = {},
        _template = null,
        _states = {
            show: true,
            fetchResults: false
        },
        _stepChangedSubscribe = false,
        _dialogId = null,
        $elements = {},
        $primaryDob = null,
        $partnerDob = null,
        $dependantsIncome = null,
        $fields = {},
        $hiddenFields = {},
        _tempStartDate = null,
        // because we will never know the membership is going to be until they have paid, this is hardcoded
        _defaultFundMembershipNum = 'To be provided by your new health fund';

    function onInitialise() {
        // get AGR required funds
        _getRequiredFunds();
        _setupFields();

        $primaryDob = $('#health_application_primary_dob');
        $partnerDob = $('#health_application_partner_dob');
        $dependantsIncome = $('#health_application_dependants_income');

        $hiddenFields = {
            applicantCovered: $('#health_application_govtRebateDeclaration_applicantCovered'),
            entitledToMedicare: $('#health_application_govtRebateDeclaration_entitledToMedicare'),
            declare: $('#health_application_govtRebateDeclaration_declaration'),
            declareDate: $('#health_application_govtRebateDeclaration_declarationDate')
        };

        _template = _.template($('#agr-modal-template').html());
    }

    function _getRequiredFunds() {
        _getRequiredFundsAjax = meerkat.modules.comms.get({
            url: 'spring/content/getsupplementary.json',
            data: {
                vertical: 'HEALTH',
                key: 'FundsRequiringAgr'
            },
            cache: true,
            dataType: 'json',
            useDefaultErrorHandling: false,
            errorLevel: 'silent',
            timeout: 5000,
            onSuccess: function onSubmitSuccess(data) {
                // store supplementary value into _funds
                data.supplementary.forEach(function(item) {
                   _funds[item.supplementaryKey] = item.supplementaryValue;
                });
            }
        });
    }

    function onBeforeEnterApply() {
        _updateHiddenXpaths(true);
        _eventUnsubscriptions();
        _unApplyEventListeners();

        _getRequiredFundsAjax && _getRequiredFundsAjax.done(function() {
            if (isActivated()) {
                _states.show = true;
                _states.fetchResults = false;

                _eventSubscriptions();
                _applyEventListeners();
            }
        });
    }

    function _setupFields() {
        $fields = {
            primary: {
                title: $('#health_application_primary_title'),
                firstName: $('#health_application_primary_firstname'),
                middleName: $('#health_application_primary_middleName'),
                surname: $('#health_application_primary_surname'),
                dob: $('#health_application_primary_dob'),
                gender: $('#health_application_primary_gender'),
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
            coverStartDate: $('#health_payment_details_start'),
            medicare: {
                firstName: $('#health_payment_medicare_firstName'),
                middleName: $('#health_payment_medicare_middleName'),
                surname: $('#health_payment_medicare_surname'),
                number: $('#health_payment_medicare_number'),
                expiryMonth: $('#health_payment_medicare_expiry_cardExpiryMonth'),
                expiryYear: $('#health_payment_medicare_expiry_cardExpiryYear')
            },
            rebate: {
                currentPercentage: $('#health_rebate'),  //need to confirm if it is the rebate or the rebateChangeover field
                tier: $('#health_healthCover_income'),
                tierIncomeBracket: $('#health_healthCover_incomelabel')
            },
            partner: {
                title: $('#health_application_partner_title'),
                firstName: $('#health_application_partner_firstname'),
                surname: $('#health_application_partner_surname'),
                dob: $('#health_application_partner_dob'),
                gender: $('#health_application_partner_gender')
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

    function _eventSubscriptions() {
        _stepChangedSubscribe = meerkat.messaging.subscribe(meerkat.modules.journeyEngine.events.journeyEngine.STEP_CHANGED, function stepChangedEvent(navInfo) {
            if (navInfo.isBackward) {
                close();
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

    function _unApplyEventListeners() {
        // $('#applicationDetailsForm :input') not cached because application fields are dynamic such as for the dependants
        $('#applicationDetailsForm :input').not($fields.coverStartDate).off('change.AGR');
        $primaryDob.add($partnerDob).add($dependantsIncome).off('change.AGR');
    }

    function _applyEventListeners() {
        $('#applicationDetailsForm :input').not($fields.coverStartDate).on('change.AGR', function() {
            _states.show = true;
        });

        $primaryDob.add($partnerDob).add($dependantsIncome).on('change.AGR', function updateThePremiumOnInput() {
            meerkat.messaging.publish(meerkatEvents.TRIGGER_UPDATE_PREMIUM);
        });
    }

    function _applyFormEventListeners() {
        $elements.editBtn.on('click', function() {
            var section = $(this).parent().hasClass('agr-your-details-section') ? 'your' : 'others';

            _scrollToSection(section);
            close();
        });

        $elements.viewRebateTableBtn.on('click', function() {
            var $viewHideText = $(this).find('.view-hide-text');

            $viewHideText.text($viewHideText.text() === 'View' ? 'Hide' : 'View');
            $(this).find('.icon').toggleClass('icon-angle-down icon-angle-up');
            _toggleRebateTable();
        });

        $elements.form.find(':input').on('change', function() {
            // are form fields acceptable, if yes enable submit button
            $elements.submitBtn.attr('disabled', _areFieldsAcceptable() === false);

            _toggleNoHelp($(this));
        });

        $elements.submitBtn.on('click', function() {
            _onSubmit();
        });

        $elements.continueWithoutRebateLink.on('click', function() {
            // uncheck rebate
            $elements.rebateNo.prop('checked', true).trigger('change');

            // close the dialog
            close();
            _states.show = false;
            _states.fetchResults = true;
            meerkat.modules.journeyEngine.gotoPath('payment');
            _updateHiddenXpaths(true);

            // handle displaying the estimated taxable income menu
            if (meerkat.modules.healthDependants.getNumberOfDependants() > 0) {
                meerkat.modules.healthDependants.updateApplicationDetails();
            }
        });

        $elements.affixedJumpToFormLink.on('click', function() {
            _scrollToForm();
        });

        $elements.modalBody.off("scroll.toggleAffixedJumpToForm").on("scroll.toggleAffixedJumpToForm", function () {
            _toggleAffixedJumpToForm();
        });
    }

    function _setupElements() {
        $elements = {
            section: {
                your: $('.agr-your-details-section'),
                others: $('.agr-others-details-section')
            },
            editBtn: $('.edit-details-btn'),
            viewRebateTableBtn: $('.view-rebate-table-btn'),
            form: $('#agr-form'),
            submitBtn: $('.btn-continue-to-payment'),
            applicantCovered: $('input[name=health_application_agr_applicantCovered]'),
            entitledToMedicare: $('input[name=health_application_agr_entitledToMedicare]'),
            declare: $('#health_application_agr_declaration'),
            declareDate: $('.declaration-date'),
            continueWithoutRebateLink: $('a.continue-without-rebate'),
            rebateNo: $('input[name=health_healthCover_rebate][value=N]'),
            partnerSection: $('#partnerContainer'),
            dependentSection: $('#health_application_dependants-selection'),
            headerTopFixed: $('.header-top.navMenu-row-fixed'),
            progressBarAffix: $('.progress-bar-row.navbar-affix'),
            productSummary: $('.productSummary-affix'),
            affixedJumpToForm: $('.affixed-jump-to-form'),
            affixedJumpToFormLink: $('a.jump-to-rebate'),
            modalBody: $('#agr-modal .modal-body'),
            rebateTierTable: $('.agrRebateTierTable')
        };
    }

    function isActivated() {
        return ( Results.getSelectedProduct().info.FundCode in _funds &&
            meerkat.modules.healthRebate.isRebateApplied() );
    }

    function open() {
        if (_states.show) {
            _createFieldsDependants();

            var htmlContent = _template(_getTemplateData());

            _dialogId = meerkat.modules.dialogs.show({
                id: 'agr-modal',
                title: 'Application Review',
                htmlContent: htmlContent,
                showCloseBtn: false,
                rightBtn: {
                    label: 'Jump to declaration',
                    className: 'btn-sm affixed-jump-to-form',
                    callback: _scrollToForm
                },
                onOpen: function (dialogId) {
                    _setupElements();
                    _applyFormEventListeners();

                    meerkat.modules.jqueryValidate.setupDefaultValidationOnForm($elements.form);
                },
                onClose: function (dialogId) {
                }
            });

            _tempStartDate = $fields.coverStartDate.val();
            _updateHiddenXpaths(true);
        }
    }

    function _getTemplateData() {
        var email = $fields.email.val(),
            medicareFullName = $fields.medicare.firstName.val() + ' ' + $fields.medicare.middleName.val() + ' ' +
                $fields.medicare.surname.val(),
            medicareNumber = $fields.medicare.number.val(),
            medicareExpiry = $fields.medicare.expiryMonth.val() + '/' + $fields.medicare.expiryYear.val(),
            residentialAddress = _getAddressData('residential'),
            postalAddress = _getAddressData('postal'),
            mobileNumber = $fields.primary.mobileNumber.val(),
            otherNumber = $fields.primary.otherNumber.val(),
            daytimePhoneNumber = mobileNumber ? mobileNumber : otherNumber,
            rebateTier = _getRebateTier($fields.rebate.tier.val()),
            rebatePercent = rebateTier + ' - ' + $fields.rebate.currentPercentage.val() + '%',
            rebateTierTable = getRebateTableData('current'),
            fundName = _funds[Results.getSelectedProduct().info.FundCode],
            coverStartDate = $fields.coverStartDate.val(),

            data = {
                primary: _getPersonData('primary'),
                rebate: { label: 'Rebate tier', value: rebatePercent },
                rebateTierTable: rebateTierTable,
                medicareDetails: [
                    { label: 'Full name', value: medicareFullName },
                    { label: 'Medicare card number', value: medicareNumber },
                    { label: 'Medicare expiry', value: medicareExpiry }
                ],
                fund: [
                    { label: 'Name of health fund', value: fundName },
                    { label: 'Membership number', value: _defaultFundMembershipNum },
                    { label: 'Date policy commences', value: coverStartDate }
                ]
            };

        data.primary.push({ label: 'Residential address', value: residentialAddress });
        data.primary.push({ label: 'Postal address', value: postalAddress });
        data.primary.push({ label: 'Daytime phone number', value: daytimePhoneNumber });

        if (mobileNumber && otherNumber) {
            data.primary.push({ label: 'Other number', value: otherNumber });
        }

        data.primary.push({ label: 'Email address', value: email });

        if (meerkat.modules.healthChoices.hasPartner()) {
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
                { label: 'Full name', value: fullName },
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
        return !_.isUndefined($person.gender) ? ($person.gender.val() === 'F' ? 'Female' : 'Male') :
            ($person.title.val() === 'MR' ? 'Male' : 'Female');
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
                    addrLn1 += streetNum + "  ";
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

	            if (streetName.length > 0) {
		            addrLn1 += streetName + " ";
	            }
            }

            if (nonStdStreet.length > 0) {
                addrLn1 += nonStdStreet + " ";
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

    // rates period can be 'previous', 'current, 'future'
    function getRebateTableData(ratesPeriod) {
        var rebateTableIncomeRange = meerkat.modules.healthTiers.getRebateIncomeRange(),
            rebateTablePercentageTiers = meerkat.modules.healthRates.getRates()['rebateTiersPercentage'],
            rebateTableData = [];

        for (var i = 0; i < rebateTableIncomeRange.length; i++) {
            //return a json data table
            rebateTableData.push({
                label: _getRebateTier(i),
                incomeRange: rebateTableIncomeRange[i],
                rebate: rebateTablePercentageTiers[ratesPeriod][i]
            });
        }

        return rebateTableData;
    }

    function close() {
        if (meerkat.modules.dialogs.isDialogOpen(_dialogId)) {
            meerkat.modules.dialogs.close(_dialogId);
        }
    }

    function show() {
        if (_tempStartDate !== $fields.coverStartDate.val()) {
            _states.show = true;
        }

        if (meerkat.modules.healthTiers.getIncome() === '3') {
            _states.show = false;
            _updateHiddenXpaths(true);
        }

        return _states.show;
    }

    function _areFieldsAcceptable() {
        return (_isCoveredBy() && _isAllPeopleEntitled() && _isDeclared());
    }

    function _isCoveredBy() {
        return $elements.applicantCovered.filter('[value=Y]').is(':checked');
    }

    function _isAllPeopleEntitled() {
        return $elements.entitledToMedicare.filter('[value=Y]').is(':checked');
    }

    function _isDeclared() {
        return $elements.declare.is(':checked');
    }

    function _toggleNoHelp($el) {
        if ($el.length) {
            $('.' + $el.attr('name') + '-no-help').toggleClass('hidden', $el.filter(':checked').val() === 'Y');
        }
    }

    function _scrollToSection(section) {
        var isXS = (meerkat.modules.deviceMediaState.get() === 'xs'),
            extraHeight = (meerkat.modules.deviceMediaState.get() === 'lg') ? $elements.progressBarAffix.find('li').outerHeight() : 0,
            offsetHeight = (isXS ? $elements.productSummary.outerHeight() : 0) +
                $elements[isXS ? 'headerTopFixed' : 'progressBarAffix'].outerHeight() + extraHeight,
            scrollTop = section === 'your' ? 0 :
                $elements[(meerkat.modules.healthChoices.hasPartner() ? 'partner' : 'dependent') + 'Section'].offset().top - offsetHeight;

        $('html,body').animate({
            scrollTop: scrollTop
        }, 500);
    }

    function _scrollToForm() {
        var isXS = (meerkat.modules.deviceMediaState.get() === 'xs'),
            offsetHeight = isXS ? 40 : 0,
            scrollTop = $elements.modalBody[0].scrollHeight - $elements.form.height() - offsetHeight;

        $elements.modalBody.animate({
            scrollTop: scrollTop
        }, 500);
    }

    function _toggleRebateTable() {
        $elements.rebateTierTable.slideToggle('fast');
    }

    function _toggleAffixedJumpToForm() {
        if ($elements.form[0].getBoundingClientRect().top > $elements.modalBody.height()) {
            $elements.affixedJumpToForm.stop(true, true).fadeIn('fast');
        } else {
            $elements.affixedJumpToForm.stop(true, true).fadeOut('fast');
        }
    }

    function _onSubmit() {
        if ($elements.form.valid() && _.isUndefined($elements.submitBtn.attr('disabled'))) {
            _states.show = false;
            close();
            meerkat.modules.journeyEngine.gotoPath('payment');

            // update hidden xpaths for submission
            _updateHiddenXpaths();
        }
    }

    function _updateHiddenXpaths(flushIt) {
        $hiddenFields.applicantCovered.val(flushIt ? '' : $elements.applicantCovered.filter(':checked').val());
        $hiddenFields.entitledToMedicare.val(flushIt ? '' : $elements.entitledToMedicare.filter(':checked').val());
        $hiddenFields.declare.val(flushIt ? '' : $elements.declare.is(':checked') ? 'Y' : 'N');
        $hiddenFields.declareDate.val(flushIt ? '' :
            meerkat.modules.dateUtils.format(meerkat.modules.dateUtils.returnDate($elements.declareDate.text()), 'YYYY-MM-DD'));
    }

    meerkat.modules.register('healthAGRModal', {
        onInitialise: onInitialise,
        onBeforeEnterApply: onBeforeEnterApply,
        events: moduleEvents,
        isActivated: isActivated,
        open: open,
        show: show,
        getRebateTableData: getRebateTableData
    });

})(jQuery);