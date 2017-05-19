;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            healthApplyReview: {
            }
        },
        _template = null,
        _states = {
            activated: false,
            show: true,
            fetchResults: false
        },
        _dialoglId = null,
        $elements = {},
        $fields = {},
        _tempStartDate = null;

    function initAGRModal(funds) {
        _states.activated = false;
        _states.show = true;
        _states.fetchResults = false;

        if (_.contains(funds, Results.getSelectedProduct().info.FundCode) &&
            meerkat.modules.healthRebate.isRebateApplied()) {

            _template = _.template($('#agr-modal-template').html());

            _setupFields();
            _eventSubscriptions();

            _states.activated = true;
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
                    unitType: $('#health_application_address_unitType'),
                    nonStdStreet: $('#health_application_address_nonStdStreet'),
                    streetSearch: $('#health_application_address_streetSearch'),
                    nonStd: $('#health_application_address_nonStd'),
                    suburbName: $('#health_application_address_suburbName'),
                    state: $('#health_application_address_state'),
                    addrLn1: $('#health_application_address_fullAddressLineOne')
                },
                postal: {
                    postcode: $('#health_application_postal_postCode'),
                    suburb: $('#health_application_postal_suburb'),
                    unitShop: $('#health_application_postal_unitShop'),
                    streetNum: $('#health_application_postal_streetNum'),
                    unitType: $('#health_application_postal_unitType'),
                    nonStdStreet: $('#health_application_postal_nonStdStreet'),
                    streetSearch: $('#health_application_postal_streetSearch'),
                    nonStd: $('#health_application_postal_nonStd'),
                    suburbName: $('#health_application_postal_suburbName'),
                    state: $('#health_application_postal_state'),
                    addrLn1: $('#health_application_postal_fullAddressLineOne')
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
            }

        };

        if (meerkat.modules.healthPrimary.getCurrentCover() === 'Y') {
            $fields.previousFund = {
                name: $('#health_previousfund_primary_fundName'),
                memberId: $('#health_previousfund_primary_memberID')
            };
        }

        if (meerkat.modules.healthChoices.hasPartner()) {
            $fields.partner = {
                title: $('#health_application_partner_title'),
                firstName: $('#health_application_partner_firstname'),
                surname: $('#health_application_partner_surname'),
                dob: $('#health_application_partner_dob'),
                gender: $('#health_application_partner_gender')
            };
        }

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

    function _applyEventListeners() {
        $elements.editBtn.on('click', function() {
            var section = $(this).parent().hasClass('agr-your-details-section') ? 'your' : 'others';

            _scrollToSection(section);
            close();
        });

        $elements.viewRebateTableBtn.on('click', function() {
            $(this).find('.icon').toggleClass('icon-angle-down icon-angle-up');
            _toggleRebateTable();
        });

        $('#applicationDetailsForm :input').not($fields.coverStartDate).on('change', function() {
            _states.show = true;
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
            $elements.rebateNo.trigger('click');

            // close the dialog
            _states.show = false;
            _states.fetchResults = true;
            close();
            meerkat.modules.journeyEngine.gotoPath('payment');
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
            hiddenApplicantCovered: $('#health_application_govtRebateDeclaration_applicantCovered'),
            hiddenEntitledToMedicare: $('#health_application_govtRebateDeclaration_entitledToMedicare'),
            hiddenDeclare: $('#health_application_govtRebateDeclaration_declaration'),
            hiddenDeclareDate: $('#health_application_govtRebateDeclaration_declarationDate'),
            continueWithoutRebateLink: $('a.continue-without-rebate'),
            rebateNo: $('input[name=health_healthCover_rebate][value=N]'),
            partnerSection: $('#partnerContainer'),
            dependentSection: $('#health_application_dependants-selection'),
            headerTopFixed: $('.header-top.navMenu-row-fixed'),
            progressBarAffix: $('.progress-bar-row.navbar-affix'),
            productSummary: $('.productSummary-affix')
        };
    }

    function _eventSubscriptions() {
        meerkat.messaging.subscribe(meerkat.modules.journeyEngine.events.journeyEngine.STEP_CHANGED, function stepChangedEvent(navInfo) {
            if (navInfo.isBackward && navInfo.navigationId === 'results' && _states.fetchResults) {
                meerkat.modules.journeyEngine.loadingShow('...updating your quotes...', true);
                meerkat.modules.healthResults.get();
            }
        });
    }

    function isActivated() {
        return _states.activated;
    }

    function open() {
        if (_states.show) {
            var htmlContent = _template(_getTemplateData());

            _dialogId = meerkat.modules.dialogs.show({
                id: 'agr-modal',
                title: 'Application Review',
                htmlContent: htmlContent,
                showCloseBtn: false,
                onOpen: function (dialogId) {
                    _setupElements();
                    _applyEventListeners();

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
            coverStartDate = $fields.coverStartDate.val(),
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
            rebatePercent = rebateTier + ' ' + meerkat.modules.healthRates.getRebate() + '%',
            rebateTierTable = getRebateTableData('current'),

            data = {
                primary: _getPersonData('primary'),
                rebate: { label: 'Rebate tier', value: rebatePercent },
                rebateTierTable: rebateTierTable,
                medicareDetails: [
                    { label: 'Full name', value: medicareFullName },
                    { label: 'Medicare card number', value: medicareNumber },
                    { label: 'Medicare expiry', value: medicareExpiry }
                ]
            };

        data.primary.push({ label: 'Residential address', value: residentialAddress });
        data.primary.push({ label: 'Postal address', value: postalAddress });
        data.primary.push({ label: 'Daytime phone number', value: daytimePhoneNumber });

        if (mobileNumber && otherNumber) {
            data.primary.push({ label: 'Other number', value: otherNumber });
        }

        data.primary.push({ label: 'Email address', value: email });
        data.primary.push({ label: 'Date policy commences', value: coverStartDate });

        if (!_.isUndefined($fields.previousFund)) {
            var previousFundName = _getOptionText($fields.previousFund.name),
                previousFundMemberId = $fields.previousFund.memberId.val() ? $fields.previousFund.memberId.val() : 'N/A';

            data.previousFund = [
                { label: 'Name of current health fund', value: previousFundName },
                { label: 'Membership number', value: previousFundMemberId }
            ];
        }

        if (!_.isUndefined($fields.partner)) {
            data.partner = _getPersonData('partner');
        }

        if (meerkat.modules.healthDependants.getNumberOfDependants() > 0) {
            data.dependants = [];
            for (var i = 1; i <= meerkat.modules.healthDependants.getNumberOfDependants(); i++) {
                data.dependants.push(_getPersonData('dependant'+i));
            }
        }

        // data.declarationDate = now();

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
        var isPostalMatch = ($fields.postalMatch.filter(':checked').length > 0);
        var returnAddrType = isPostalMatch ? 'residential': addressType;

        /*
        if (isPostalMatch && (addressType === 'postal')) {
            return 'As Above';
        }
        */

        var addressStr =  $fields.address[returnAddrType].addrLn1.val() + "<br/>"
            + $fields.address[returnAddrType].suburbName.val() + "  " + $fields.address[returnAddrType].state.val() + "  "
            + $fields.address[returnAddrType].postcode.val();

        return addressStr;
    }


    function _getRebateTier(rebateTierEnum) {
        if (rebateTierEnum > 0) {
            return "Tier " + rebateTierEnum;
        } else {
            return "Base tier";
        }
    }

    // rates period can be 'previous', 'current, 'future'
    function getRebateTableData(ratesPeriod) {

        var rebateTableIncomeRange = meerkat.modules.healthTiers.getRebateIncomeRange(),
            rebateTablePercentageTiers = meerkat.modules.healthRates.getRates()['rebateTiersPercentage'],
            rebateTableData = [];

        for (var i = 0; i < rebateTableIncomeRange.length; i++) {
            //return a json data table
            rebateTableData.push({label: _getRebateTier(i), incomeRange: rebateTableIncomeRange[i], rebate: rebateTablePercentageTiers[ratesPeriod][i] });
        }

        return rebateTableData;
    }

    function close() {
        meerkat.modules.dialogs.close(_dialogId);
    }

    function show() {
        if (_tempStartDate !== $fields.coverStartDate.val()) {
            _states.show = true;
        }

        return _states.show;
    }

    function _areFieldsAcceptable() {
        return (_isCoveredBy() && _isAllPeopleEntitled());
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

    function _toggleRebateTable() {
        $(".agrRebateTierTable").slideToggle("fast");
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
        $elements.hiddenApplicantCovered.val(flushIt ? '' : $elements.applicantCovered.filter(':checked').val());
        $elements.hiddenEntitledToMedicare.val(flushIt ? '' : $elements.entitledToMedicare.filter(':checked').val());
        $elements.hiddenDeclare.val(flushIt ? '' : $elements.declare.is(':checked') ? 'Y' : 'N');
        $elements.hiddenDeclareDate.val(flushIt ? '' : $elements.declareDate.text());
    }

    meerkat.modules.register('healthAGRModal', {
        initAGRModal: initAGRModal,
        events: moduleEvents,
        isActivated: isActivated,
        open: open,
        show: show,
        getRebateTableData: getRebateTableData
    });

})(jQuery);