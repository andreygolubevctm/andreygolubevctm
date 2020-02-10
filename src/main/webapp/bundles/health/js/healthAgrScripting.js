;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        exception = meerkat.logging.exception,
        _submitCallback = null,
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
        $nonDynamicDialogueBoxRemoveRebate1 = null,
        $nonDynamicDialogueBoxRemoveRebate2 = null,
        $agrOnlineComplianceElements = null,
        $simplesHiddenAgrFields = null,
        $dynamicDialogueBoxAGRApplicationComplete = null,
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
            },
            {
                text: '%TRANSACTION_ID%',
                get: function() {
                    return $('#contactForm .transactionIdContainer .transactionId').text() || '';
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
            consentBtnGroup: $('#health_application_agr_compliance_voiceConsentRow'),
            removeRebate1BtnGroup: $('#health_application_agr_compliance_removeRebate1Row'),
            coveredByPolicyBtnGroup: $('#health_application_agr_compliance_applicantCoveredRow'),
            childOnlyPolicyBtnGroup: $('#health_application_agr_compliance_childOnlyPolicyRow'),
            removeRebate2BtnGroup: $('#health_application_agr_compliance_removeRebate2Row'),
            consentFields: $('input[name=health_application_agr_compliance_voiceConsent]'),
            removeRebate1Dialogue: $('.simples-dialogue-170'),
            removeRebate1Fields: $('input[name=health_application_agr_compliance_removeRebate1]'),
            coveredByPolicyFields: $('input[name=health_application_agr_compliance_applicantCovered]'),
            childOnlyPolicyFields: $('input[name=health_application_agr_compliance_childOnlyPolicy]'),
            removeRebate2Dialogue: $('.simples-dialogue-171'),
            removeRebate2Fields: $('input[name=health_application_agr_compliance_removeRebate2]'),
        };

        $agrOnlineComplianceElements = {
            entitledToMedicare: $('input[name=health_application_govtRebateDeclaration_entitledToMedicare]'),
            declaration: $('input[name=health_application_govtRebateDeclaration_declaration]'),
            declarationDate: $('input[name=health_application_govtRebateDeclaration_declarationDate]')
        };

        $simplesHiddenAgrFields = {
            voiceConsent: $('input[name=health_application_govtRebateDeclaration_voiceConsent]'),
            childOnlyPolicy: $('input[name=health_application_govtRebateDeclaration_childOnlyPolicy]'),
            applicantCovered: $('input[name=health_application_govtRebateDeclaration_applicantCovered]'),
        };

        _setupAGRConsentDynamicTextTemplate();
        _setupCoverStartDateDynamicTextTemplate();

        _setupAllRemoveRebate1NonDynamicTextTemplate();
        _setupAllRemoveRebate2NonDynamicTextTemplate();
        _setupAGRApplicationCompleteDynamicTextTemplate();

        _clearAgrFields();
    }

    function _clearAgrFields() {

        $agrComplianceElements.consentFields.prop('checked', false);
        $agrComplianceElements.consentFields.removeAttr('checked');
        $agrComplianceElements.consentFields.parent().toggleClass('active', false);

        $agrComplianceElements.coveredByPolicyFields.prop('checked', false);
        $agrComplianceElements.coveredByPolicyFields.removeAttr('checked');
        $agrComplianceElements.coveredByPolicyFields.parent().toggleClass('active', false);

        $agrComplianceElements.childOnlyPolicyFields.prop('checked', false);
        $agrComplianceElements.childOnlyPolicyFields.removeAttr('checked');
        $agrComplianceElements.childOnlyPolicyFields.parent().toggleClass('active', false);

        $agrComplianceElements.removeRebate1Fields.prop('checked', false);
        $agrComplianceElements.removeRebate1Fields.removeAttr('checked');
        $agrComplianceElements.removeRebate1Fields.parent().toggleClass('active', false);

        $agrComplianceElements.removeRebate2Fields.prop('checked', false);
        $agrComplianceElements.removeRebate2Fields.removeAttr('checked');
        $agrComplianceElements.removeRebate2Fields.parent().toggleClass('active', false);
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

    // Submits an HTTP request to InIn for VAGR call snipping
    // start action: true
    // stop action: false
    function _performCallSnippetRequest(action) {
        meerkat.modules.comms.post({
            url: 'spring/rest/simples/apiCallSnipping.json',
            data: {
                snippingOn: action,
                transactionId: $('#contactForm .transactionIdContainer .transactionId').text(),
                operatorId: $('#health_operatorid').val()
            },
            cache: true,
            dataType: 'json',
            useDefaultErrorHandling: false,
            errorLevel: 'silent',
            timeout: 5000
        });
    }

    // This is used to cache selectors and the original HTML for for field labels dialogue boxes etc that have
    // placeholder text to be replaced - note that if the html does not exist when onInitialise is run it will
    // not be cached - this may actually cause the AGR scripts to be hidden - due to this a try catch has been added.
    function _setupAGRConsentDynamicTextTemplate() {

        try {
            $dynamicDialogueBoxAGRConsent = {
                'elementRef':$('label[for="health_application_agr_compliance_voiceConsent"]'),
                'template': $('label[for="health_application_agr_compliance_voiceConsent"]').html()
            };
        }
        catch(err) {
            console.error( "Required Health AGR voiceConsent dialogue box does not exist");
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

    function _setupAllRemoveRebate1NonDynamicTextTemplate() {

        try {
            $nonDynamicDialogueBoxRemoveRebate1 = {
                'elementRef':$('.simples-dialogue-170'),
                'template': $('.simples-dialogue-170').html()
            };
        }
        catch(err) {
            console.error( "Required Process your application without the Australian government rebate 1 dialogue box does not exist");
        }

    }

    function _setupAllRemoveRebate2NonDynamicTextTemplate() {

        try {
            $nonDynamicDialogueBoxRemoveRebate2 = {
                'elementRef':$('.simples-dialogue-171'),
                'template': $('.simples-dialogue-171').html()
            };
        }
        catch(err) {
            console.error( "Required Process your application without the Australian government rebate 2 dialogue box does not exist");
        }

    }


    function _setupAGRApplicationCompleteDynamicTextTemplate() {

        try {
            $dynamicDialogueBoxAGRApplicationComplete = {
                'elementRef':$('.simples-dialogue-172'),
                'template': $('.simples-dialogue-172').html()
            };
        }
        catch(err) {
            console.error( "Required AGR Application complete Please notify fund if you want to stop claiming the rebate dialogue box does not exist");
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
        updateHiddenXpaths(true);
        _clearAgrFields();

        _getRequiredFundsAjax && _getRequiredFundsAjax.then(function() {
            if (isActivated()) {

                _setupFields();
                _setupListeners();

                _states.showScripting = true;
                _states.scriptingAgrFund = true;

                _eventSubscriptions();

                _states.showAgrScriptingNonToggle = shouldAgrScriptingBeVisible();

                _derivedData = _getTemplateData();
                performUpdateAGRConsentDynamicDialogueBox();
                performUpdateCoverStartDateDynamicDialogueBox();

                performResetRemoveRebate1NonDynamicDialogueBox();
                performResetRemoveRebate2NonDynamicDialogueBox();

                performUpdateAGRApplicationCompleteDynamicDialogueBox();

                // Send a snippet recording start request when rebate scripting is on for selected fund and rebate % is > 0
                if ((meerkat.modules.healthTiers.getIncome() !== '3') || ($doYouWantToClaimTheRebateFields.filter(':checked').val() === 'Y')) {
                    _performCallSnippetRequest(true);
                }
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
            console.error( "Health AGR voiceConsent dynamic text replacement did not occur due to an error");
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


    function performUpdateAGRApplicationCompleteDynamicDialogueBox() {
        try {
            var newHtml = $dynamicDialogueBoxAGRApplicationComplete.template.valueOf();
            replacePlaceholderText($dynamicDialogueBoxAGRApplicationComplete.elementRef, newHtml, null);
        }
        catch(err) {
            console.error( "AGR Application Complete dynamic text replacement did not occur due to an error");
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

    function performResetRemoveRebate1NonDynamicDialogueBox() {
        try {
            var newHtml = $nonDynamicDialogueBoxRemoveRebate1.template.valueOf();
            replacePlaceholderText($nonDynamicDialogueBoxRemoveRebate1.elementRef, newHtml, null);
        }
        catch(err) {
            console.error( "Resetting the Process your application without the Australian government rebate 1 dialogue box did not occur due to an error");
        }
    }

    function performResetRemoveRebate2NonDynamicDialogueBox() {
        try {
            var newHtml = $nonDynamicDialogueBoxRemoveRebate2.template.valueOf();
            replacePlaceholderText($nonDynamicDialogueBoxRemoveRebate2.elementRef, newHtml, null);
        }
        catch(err) {
            console.error( "Resetting the Process your application without the Australian government rebate 1 dialogue box did not occur due to an error");
        }
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

                // Send a snippet recording stop request when user navigates back to any of the pages before the application page
                _performCallSnippetRequest(false);
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

    function updateHiddenXpaths(flushIt) {

        $agrOnlineComplianceElements.entitledToMedicare.val('');
        $agrOnlineComplianceElements.declaration.val('');

        $simplesHiddenAgrFields.voiceConsent.val('');
        $simplesHiddenAgrFields.childOnlyPolicy.val('');
        $simplesHiddenAgrFields.applicantCovered.val('');


        if (!flushIt && _states.showScripting) {

            var consent = $agrComplianceElements.consentFields.filter(':checked').val();
            var coveredByPolicy = $agrComplianceElements.coveredByPolicyFields.filter(':checked').val();
            var childOnlyPolicy = $agrComplianceElements.childOnlyPolicyFields.filter(':checked').val();

            if (consent === 'Y') {
                if (coveredByPolicy === 'Y') {
                    $simplesHiddenAgrFields.voiceConsent.val(consent);
                    $simplesHiddenAgrFields.applicantCovered.val(coveredByPolicy);
                    $agrOnlineComplianceElements.entitledToMedicare.val('Y');
                    $agrOnlineComplianceElements.declaration.val('Y');
                } else if (coveredByPolicy === 'N' && childOnlyPolicy === 'Y') {
                    $simplesHiddenAgrFields.voiceConsent.val(consent);
                    $simplesHiddenAgrFields.applicantCovered.val(coveredByPolicy);
                    $simplesHiddenAgrFields.childOnlyPolicy.val(childOnlyPolicy);
                    $agrOnlineComplianceElements.entitledToMedicare.val('Y');
                    $agrOnlineComplianceElements.declaration.val('Y');
                }
            }

            // set the declaration date if required
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
            $agrOnlineComplianceElements.declarationDate.val(meerkat.modules.dateUtils.dateValueServerFormat(curDate));
        } else {
            $agrOnlineComplianceElements.declarationDate.val('');
        }
    }

    function submitSnipKeepIfRequired(submitCallback) {
        if (_.isEmpty(_submitCallback)) {
            _submitCallback = submitCallback;
        }
        _onSubmitPaymentStepFinished();
    }

    function _onSubmitPaymentStepFinished() {
        if ((_states.scriptingAgrFund && _states.showScripting) || (_states.scriptingAgrFund && $agrComplianceElements.removeRebate1Fields.filter(':checked').val() === 'Y')) {
            // Send a snippet recording stop request when user submits the application
            _performCallSnippetRequest(false);
        }
        meerkat.modules.healthFundTimeOffset.checkBeforeSubmit(_submitCallback);
    }

    meerkat.modules.register('healthAGRScripting', {
        onInitialise: onInitialise,
        onBeforeEnterApply: onBeforeEnterApply,
        updateAgrXpaths: updateHiddenXpaths,
        events: moduleEvents,
        submitSnipKeepIfRequired: submitSnipKeepIfRequired
    });

})(jQuery);
