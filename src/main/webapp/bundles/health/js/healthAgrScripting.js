;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        exception = meerkat.logging.exception,
        _getRequiredFundsAjax = null,
        _funds = {},
        $fields = {},
        _states = {
            showScripting: false,
            scriptingAgrFund: false,
            showAgrScriptingNonToggle: false
        },
        _stepChangedSubscribe = false,
        $agrScriptToggleElements = null,
        $agrScriptNonToggleElements = null,
        $doYouWantToClaimTheRebateFields = null,
        $dontApplyTheRebateField = null,
        $agrComplianceElements = {},
        $coverStartDateFieldPaymentStep = null,
        $dynamicDialogueBoxCoverStartDate = null,
        $dependantsIncome = null,
        // this was adapted from simplesDynamicDialogue.js
        _derivedData = {},
        _dynamicValues = [
            {
                text: '%FUND_NAME%',
                get: function() {
                    return _getFullAgrFundNameByFundCode(Results.getSelectedProduct().info.FundCode);
                }
            },
            {
                text: '%COVER_START_DATE%',
                get: function() {
                    var coverStartDate = $coverStartDateFieldPaymentStep.val();
                    var coverStartDateString = '';

                    if(coverStartDate) {
                        var dateSplit = coverStartDate.split('/');
                        if(dateSplit.length == 3) {
                            var year = dateSplit[2];
                            var month = dateSplit[1];
                            var day = dateSplit[0];
                            coverStartDateString = year + '-' + month + '-' + day;
                        }
                    }

                    var curDate = coverStartDateString ? new Date(coverStartDateString) : meerkat.site.serverDate;
                    return meerkat.modules.dateUtils.dateValueFormFormat(curDate);
                }
            },
            {
                text: '%REBATE_TIER%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }
                    if (!_derivedData.rebate) {
                        return '';
                    }

                    return _derivedData.rebate.tier ? _derivedData.rebate.tier : '';
                }
            }
        ];


    function onInitialise() {
        // get AGR required funds
        _getRequiredFunds();

        $doYouWantToClaimTheRebateFields = $(':input[name="health_healthCover_rebate_dontApplyRebate"]');
        $dontApplyTheRebateField = $('#health_healthCover_health_cover_rebate_dontApplyRebate');
        $agrScriptToggleElements = $('.simplesAgrElementsToggle');
        $agrScriptNonToggleElements = $('.simplesAgrElementsNoToggle');
        $agrScriptToggleElements.toggleClass('hidden', true);
        $agrScriptNonToggleElements.toggleClass('hidden', true);
        $coverStartDateFieldPaymentStep = $('#health_payment_details_start');
        $dependantsIncome = $('#health_application_dependants_income');

        $agrComplianceElements = {
            consentBtnGroup: $('#health_application_agr_compliance_consentRow'),
            removeRebate1BtnGroup: $('#health_application_agr_compliance_removeRebate1Row'),
            coveredByPolicyBtnGroup: $('#health_application_agr_compliance_coveredByPolicyRow'),
            childOnlyPolicyBtnGroup: $('#health_application_agr_compliance_childOnlyPolicyRow'),
            removeRebate2BtnGroup: $('#health_application_agr_compliance_removeRebate2Row'),
            consentFields: $('input[name=health_application_agr_compliance_consent]'),
            removeRebate1Dialogue: $('.simples-dialogue-170'),
            removeRebate1Fields: $('input[name=health_application_agr_compliance_removeRebate1]'),
            coveredByPolicyFields: $('input[name=health_application_agr_compliance_coveredByPolicy]'),
            childOnlyPolicyFields: $('input[name=health_application_agr_compliance_childOnlyPolicy]'),
            removeRebate2Dialogue: $('.simples-dialogue-171'),
            removeRebate2Fields: $('input[name=health_application_agr_compliance_removeRebate2]'),
        };

        _setupAGRConsentDynamicTextTemplate();
        _setupCoverStartDateDynamicTextTemplate();
    }


    function setDoYoWishToClaimTheRebate (applyRebate) {
        var currentlyApplyingForRebate = !$dontApplyTheRebateField.is(":checked");

        // Only change rebate if required
        if (applyRebate !== currentlyApplyingForRebate) {
            $dontApplyTheRebateField.prop("checked", !applyRebate).trigger('change');
        }

        checkStateAndToggleAgrScripting();
    }

    function _toggleAgrFieldsAndRebateStatus() {
        var consent = $agrComplianceElements.consentFields.filter(':checked').val();
        var removeRebate1 = $agrComplianceElements.removeRebate1Fields.filter(':checked').val();
        var coveredByPolicy = $agrComplianceElements.coveredByPolicyFields.filter(':checked').val();
        var childOnlyPolicy = $agrComplianceElements.childOnlyPolicyFields.filter(':checked').val();
        var removeRebate2 = $agrComplianceElements.removeRebate2Fields.filter(':checked').val();

        var showRemoveRebate1 = false, showCoveredByPolicy = false, showChildOnlyPolicy = false, showRemoveRebate2 = false, claimRebate = true;

        if (consent === 'N') {
            showRemoveRebate1 = true;

            if (removeRebate1 === 'Y') {
                claimRebate = false;
            }
        } else if (consent === 'Y') {
            showCoveredByPolicy = true;

            if (coveredByPolicy === 'N') {
                showChildOnlyPolicy = true;

                if (childOnlyPolicy === 'N') {
                    showRemoveRebate2 = true;

                    if (removeRebate2 === 'Y') {
                        claimRebate = false;
                    }
                }
            }
        }

        $agrComplianceElements.removeRebate1Dialogue.toggleClass('hidden', !showRemoveRebate1);
        $agrComplianceElements.removeRebate1BtnGroup.toggleClass('hidden', !showRemoveRebate1);
        $agrComplianceElements.coveredByPolicyBtnGroup.toggleClass('hidden', !showCoveredByPolicy);
        $agrComplianceElements.childOnlyPolicyBtnGroup.toggleClass('hidden', !showChildOnlyPolicy);
        $agrComplianceElements.removeRebate2Dialogue.toggleClass('hidden', !showRemoveRebate2);
        $agrComplianceElements.removeRebate2BtnGroup.toggleClass('hidden', !showRemoveRebate2);

        setDoYoWishToClaimTheRebate(claimRebate);
    }

    function _setupListeners() {

        var complianceCheck = function() {
            _toggleAgrFieldsAndRebateStatus();
        };

        $agrComplianceElements.consentFields.on('change.agrComplianceConsentFieldsChanged', complianceCheck);
        $agrComplianceElements.removeRebate1Fields.on('change.agrComplianceRemoveRebate1FieldsChanged', complianceCheck);
        $agrComplianceElements.coveredByPolicyFields.on('change.agrComplianceCoveredByPolicyFieldsChanged', complianceCheck);
        $agrComplianceElements.childOnlyPolicyFields.on('change.agrComplianceChildOnlyPolicyFieldsChanged', complianceCheck);
        $agrComplianceElements.removeRebate2Fields.on('change.agrComplianceRemoveRebate2FieldsChanged', complianceCheck);

        $coverStartDateFieldPaymentStep.on('change.agrScriptingCoverStartDateChanged', function agrScripting_CoverStartDateChanged() {
            performUpdateCoverStartDateDynamicDialogueBox();
        });

        var agrScriptingApplyRebateTierUpdated = function(){
            _derivedData.rebate = _getRebateData();

            performUpdateCoverStartDateDynamicDialogueBox();
            checkStateAndToggleAgrScripting();

        };

        $dependantsIncome.on('change.agrScriptingDependantRebateTierUpdated', agrScriptingApplyRebateTierUpdated);
    }

    // check if the selected provider is a participating AGR fund
    // (stored in the content_supplementary data table - join on the content_control table using the 'FundsRequiringAgr' contentKey )
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


    // This is used to cache selectors and the original HTML for for field labels dialogue boxes etc that have
    // placeholder text to be replaced - note that if the html does not exist when onInitialise is run it will
    // not be cached - this may actually cause the AGR scripts to be hidden - due to this a try catch has been added.
    function _setupAGRConsentDynamicTextTemplate() {

        try {
            $dynamicDialogueBoxAGRConsent = {
                'elementRef':$('label[for="health_application_agr_compliance_consent"]'),
                'template': $('label[for="health_application_agr_compliance_consent"]').html()
            };
        }
        catch(err) {
            console.error( "Required Health AGR Consent dialogue box does not exist");
        }

    }

    function _setupCoverStartDateDynamicTextTemplate() {

        try {
            $dynamicDialogueBoxCoverStartDate = {
                'elementRef':$('.simples-dialogue-168'),
                'template': $('.simples-dialogue-168').html()
            };
        }
        catch(err) {
            console.error( "Required cover start date dialogue box does not exist");
        }

    }

    function _setupFields() {
        $fields = {
            rebate: {
                applyRebate: $('input[name=health_healthCover_rebate]'),
                currentPercentage: $('#health_rebate'),
                tier: $('#health_healthCover_income')
            }
        };
    }

    function onBeforeEnterApply() {

        _eventUnsubscriptions();

        _getRequiredFundsAjax && _getRequiredFundsAjax.then(function() {
            if (false && isActivated()) {

                _setupFields();
                _setupListeners();

                _states.showScripting = true;
                _states.scriptingAgrFund = true;

                _eventSubscriptions();

                _states.showAgrScriptingNonToggle = shouldAgrScriptingBeVisible();

                _derivedData = _getTemplateData();
                performUpdateAGRConsentDynamicDialogueBox();
                performUpdateCoverStartDateDynamicDialogueBox();

            } else {
                _states.showAgrScriptingNonToggle = false;
                _states.showScripting = false;
                _states.scriptingAgrFund = false;
            }

            $agrScriptNonToggleElements.toggleClass('hidden', !_states.showAgrScriptingNonToggle);

            if (_states.showAgrScriptingNonToggle) {
                _toggleAgrFieldsAndRebateStatus();
            } else {
                toggleAgrScripting();
            }
        })
        .catch(function onError(obj, txt, errorThrown) {
            exception(txt + ': ' + errorThrown);
        });
    }

    function toggleAgrScripting() {
        $agrScriptToggleElements.toggleClass('hidden', !_states.showScripting);
    }

    function checkStateAndToggleAgrScripting() {
        shouldAgrScriptingBeVisible();
        toggleAgrScripting();
    }

    function performUpdateAGRConsentDynamicDialogueBox() {

        try {
            var newHtml = $dynamicDialogueBoxAGRConsent.template.valueOf();
            replacePlaceholderText($dynamicDialogueBoxAGRConsent.elementRef, newHtml, null);
        }
        catch(err) {
            console.error( "Health AGR Consent dynamic text replacement did not occur due to an error");
        }
    }

    function performUpdateCoverStartDateDynamicDialogueBox() {
        try {
            var newHtml = $dynamicDialogueBoxCoverStartDate.template.valueOf();
            replacePlaceholderText($dynamicDialogueBoxCoverStartDate.elementRef, newHtml, null);
        }
        catch(err) {
            console.error( "Cover start date dynamic text replacement did not occur due to an error");
        }
    }

    // This function requires:
    // an element selector reference  (The element to be updated),
    // the html template (the original HTML template for the element which contains the original placeholder text values),
    // onParse ( a function that can be run upon updating the element)
    //
    // It searches the _dynamicValues array for any matching placeholders and replaces any matching placeholders
    function replacePlaceholderText(elementRef, newHtml, onParse) {
        if(!elementRef || !newHtml) return;

        _.defer(function () {
            var dialogue = elementRef;
            var html = newHtml;

            for(var i = 0; i < _dynamicValues.length; i++) {
                var value = _dynamicValues[i];
                if(html.indexOf(value.text) > -1) {
                    html = html.replace(new RegExp(value.text, 'g'), value.get());
                }
            }

            dialogue.html(html);

            if(onParse && typeof onParse === 'function') {
                onParse();
            }
        });
    }

    function _eventSubscriptions() {
        _stepChangedSubscribe = meerkat.messaging.subscribe(meerkat.modules.journeyEngine.events.journeyEngine.STEP_CHANGED, function stepChangedEvent(navInfo) {
            if (navInfo.isBackward && navInfo.navigationId !== 'apply') {

                $agrComplianceElements.consentFields.off('change.agrComplianceConsentFieldsChanged');
                $agrComplianceElements.removeRebate1Fields.off('change.agrComplianceRemoveRebate1FieldsChanged');
                $agrComplianceElements.coveredByPolicyFields.off('change.agrComplianceCoveredByPolicyFieldsChanged');
                $agrComplianceElements.childOnlyPolicyFields.off('change.agrComplianceChildOnlyPolicyFieldsChanged');
                $agrComplianceElements.removeRebate2Fields.off('change.agrComplianceRemoveRebate2FieldsChanged');
                $coverStartDateFieldPaymentStep.off('change.agrScriptingCoverStartDateChanged');
                $dependantsIncome.off('change.agrScriptingDependantRebateTierUpdated');
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

    function isActivated() {
        return ( Results.getSelectedProduct().info.FundCode in _funds &&
            meerkat.modules.healthCoverDetails.isRebateApplied() );
    }

    function shouldAgrScriptingBeVisible() {

        if (_states.scriptingAgrFund) {
            if ((meerkat.modules.healthTiers.getIncome() === '3') || ($doYouWantToClaimTheRebateFields.filter(':checked').val() === 'N')) {
                _states.showScripting = false;
            } else {
                _states.showScripting = true;
            }
        } else {
            _states.showScripting = false;
        }

        return _states.showScripting;
    }

    // returns the full fund name of a specific participating AGR funds
    // (stored in the content_supplementary data table - join on the content_control table using the 'FundsRequiringAgr' contentKey )
    function _getFullAgrFundNameByFundCode(fundCode) {
        if(!_funds) return;
        if(!fundCode) return;
        return _funds[fundCode] ? _funds[fundCode] : '';
    }

    function _getTemplateData() {
        var data = {
                rebate: _getRebateData()
            };

        return data;
    }

    function _getRebateData() {

        _derivedData.rebate = {};

        var rebateTier = _getRebateTier($fields.rebate.tier.val()),
            rebatePercent = $fields.rebate.currentPercentage.val() + '%',
            rebatePretty = ((!_.isUndefined(rebateTier) &&  !_.isUndefined(rebatePercent))? (rebateTier + ' - ' + rebatePercent) : ''),
            aboutYouPageApplyRebateFieldVal = $fields.rebate.applyRebate.filter(':checked').val(),
            data =  {
                tier: rebateTier,
                percent: rebatePercent,
                prettyPrinted: rebatePretty,
                aboutYouPageApplyRebateFieldVal: aboutYouPageApplyRebateFieldVal
            };

        return data;
    }

    function _getRebateTier(rebateTierEnum) {
        if (rebateTierEnum > 0) {
            return 'Tier ' + rebateTierEnum;
        } else {
            return 'Base tier';
        }
    }

    meerkat.modules.register('healthAGRScripting', {
        onInitialise: onInitialise,
        onBeforeEnterApply: onBeforeEnterApply,
        events: moduleEvents
    });

})(jQuery);
