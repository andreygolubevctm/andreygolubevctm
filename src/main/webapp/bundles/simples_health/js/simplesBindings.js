(function ($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var $healthContactTypeField,
        $healthContactTypeSelectOption,
        $healthContactType,
        $healthContactTypeTrial,
        $healthCoverRebate,
        $healthSituationCvr,
        $healthSitCoverType,
        $healthCvrDtlsIncomeBasedOn,
        $healthPrimaryCover,
        $healthPartnerCover,
        $dialoguePrimaryCover,
        $dialoguePartnerCover,
        $dialogue74,
        $healthSituationMedicare,
        $healthSituationMedicareField,
        $healthInternationalStudent,
        $healthInternationalStudentField,
        $healthInternationalStudentMsg1,
        $healthInternationalStudentMsg2,
	    $followupCallCheckboxDialogue,
	    $followupCallCheckbox,
	    $referralCallCheckboxDialogue,
	    $referralCallCheckbox,
	    $referralCallPaymentStepDialogue1,
	    $referralCallPaymentStepDialogue2,
        $cliCallCheckboxDialogue,
        $nonCliCallCheckboxDialogue,
        $outboundFollowupDialogue,
        $inboundQuestionsetFollowupDialogue,
        $inboundQuestionsetFollowupToggles,
        $inboundApplicationFollowupDialogue,
        $privatePatientDialogue,
        $inboundApplicationFollowupToggles,
        $followupDialogueContentContainers,
        $simplesMedicareCoverForm = null,
        $simplesinternationalStudentForm = null,
        $applicantWrappers = {},
        currentFamilyType = null,
        $limitedCoverHidden,
        $moreInfoDialogue,
        $moreInfoDialogueRadio,
        $notifyInclusionsExclusionsVia,
        $dialogue111,
        $dialogue112,
        $dialogue21,
        $dialogue26,
        $dialogue36,
        $dialogue37,
        $nzMedicareRules,
        $nzMedicareRulesToggle,
        $nzMedicareRulesCopy,
        $pricePromisePromotionDialogue,
        $affiliatesDialogue,
        $dialogue106,
        $dialogue109;

    function init() {
        $(document).ready(function () {

            // cache selectors
            $healthContactTypeField = $(':input[name="health_simples_contactTypeRadio"]');
            $healthContactTypeSelectOption = $(':input[name="health_simples_contactTypeRadio"] option');
            $healthContactType = $('#health_simples_contactType');
            $healthContactTypeTrial = $('#health_simples_contactTypeTrial');
            $healthCoverRebate = $('input[name=health_healthCover_rebate]');
            $healthSituationCvr = $('select[name=health_situation_healthCvr]');
            $healthSitCoverType = $('#health_situation_coverType');
            $healthCvrDtlsIncomeBasedOn = $('.health_cover_details_incomeBasedOn');
            $healthPrimaryCover = $('input[name=health_healthCover_primary_cover]');
            $healthPartnerCover = $('input[name=health_healthCover_partner_cover]');
            $dialoguePrimaryCover = $('.simples-dialogue-primary-current-cover');
            $dialoguePartnerCover = $('.simples-dialogue-partner-current-cover');
            $dialogue74 = $('.simples-dialogue-74');
            $healthSituationMedicare = $('.health_situation_medicare');
            $healthSituationMedicareField = $('input[name=health_situation_cover]');
            $healthInternationalStudent = $('.health_situation_internationalstudent');
            $healthInternationalStudentField = $('input[name=health_situation_internationalstudent]');
            $healthInternationalStudentMsg1 = $('.healthInternationalStudentMsg1');
            $healthInternationalStudentMsg2 = $('.healthInternationalStudentMsg2');
            $followupCallCheckboxDialogue = $('.simples-dialogue-68');
            $followupCallCheckbox = $('#health_simples_dialogue-checkbox-68');
	        $referralCallCheckboxDialogue = $('.simples-dialogue-93');
	        $referralCallCheckbox = $('#health_simples_dialogue-checkbox-93');
	        $referralCallPaymentStepDialogue1 = $('.simples-dialogue-94');
	        $referralCallPaymentStepDialogue2 = $('.simples-dialogue-95');
            $cliCallCheckboxDialogue = $('.simples-dialogue-78');
            $nonCliCallCheckboxDialogue = $('.simples-dialogue-20');
            $outboundFollowupDialogue = $('.simples-dialogue-69');
            $inboundQuestionsetFollowupDialogue = $('.simples-dialogue-70');
            $inboundQuestionsetFollowupToggles = $inboundQuestionsetFollowupDialogue.find('a');
            $inboundApplicationFollowupDialogue = $('.simples-dialogue-71');
            $inboundApplicationFollowupToggles = $inboundApplicationFollowupDialogue.find('a');
            $followupDialogueContentContainers = $inboundQuestionsetFollowupDialogue
                .add($inboundApplicationFollowupDialogue).find('div[class]');
            $simplesMedicareCoverForm = $('#health_situation_cover_wrapper');
            $simplesinternationalStudentForm = $('#health_situation_internationalstudent_wrapper');
            $applicantWrappers.primary = $('#health-contact-fieldset .content:first');
            $applicantWrappers.partner = $('#partner-health-cover .content:first');
	        $privatePatientDialogue = $('.simples-dialogue-24');
            $limitedCoverHidden = $("input[name='health_situation_accidentOnlyCover']");
            $dialogue21 = $('.simples-dialogue-21');
            $dialogue26 = $('.simples-dialogue-26');
            $dialogue36 = $('.simples-dialogue-36');
            $dialogue37 = $('.simples-dialogue-37');
            $moreInfoDialogue = $('.simples-dialogue-76');
            $moreInfoDialogueRadio = $('input[name=health_simples_dialogue-radio-76]');
            $notifyInclusionsExclusionsVia = $('#health_simples_notifyInclusionsExclusionsVia');
            $nzMedicareRules = $('#health_situation_cover_wrapper .nz-medicare-rules');
            $nzMedicareRulesToggle = $nzMedicareRules.find('a:first');
            $nzMedicareRulesCopy = $nzMedicareRules.find('.copy:first');
            $pricePromisePromotionDialogue = $('.simples-dialogue-101');
            $affiliatesDialogue = $('.simples-dialogue-105');
            $dialogue106 = $('.simples-dialogue-106');
            $dialogue109 = $('.simples-dialogue-109');
            $dialogue111 = $('.simples-dialogue-111');
            $dialogue112 = $('.simples-dialogue-112');

            // Handle pre-filled
            populatePrevAssignedRadioBtnGroupValue();
            toggleInboundOutbound();
            toggleBenefitsDialogue();
            initDBDrivenCheckboxes();
            toggleFollowupCallDialog();
	        toggleReferralCallDialog();

            applyEventListeners();
            eventSubscriptions();
            _toggleInternationalStudentField();

            meerkat.modules.provider_testing.setApplicationDateCalendar();
        });
    }

    function populatePrevAssignedRadioBtnGroupValue() {

        // if data already exists for xpath load data into radio btn
	    var contactType = $healthContactType.val();
        if (!_.isEmpty(contactType)) {

            if ($healthContactTypeTrial.val().length > 0) {
                // trial campaigns
                $healthContactTypeSelectOption.filter(function() {
                    return ($(this).text().trim() === $healthContactTypeTrial.val());
                }).prop('selected', true).change();
            } else {
                // inbound / outbound / cli / webchat
                $(':input[name="health_simples_contactTypeRadio"] option').filter(function() {
                    return ($(this).val() === contactType);
                }).prop('selected', true);
            }
        }
        toggleWebChatDialog();
    }

    function _toggleInternationalStudentField() {
        var medicareCoverVal = $healthSituationMedicareField.is(':checked') ? $healthSituationMedicareField.filter(':checked').val() : null;
        $healthInternationalStudent.toggleClass('hidden', medicareCoverVal !== 'N');
    }

    function _toggleInternationalStudentFieldMsg() {
        var internationalStudentVal = $healthInternationalStudentField.is(':checked') ? $healthInternationalStudentField.filter(':checked').val() : null;
        $healthInternationalStudentMsg1.toggleClass('hidden', internationalStudentVal !== 'Y');
        $healthInternationalStudentMsg2.toggleClass('hidden', internationalStudentVal !== 'N');
    }

    // Check dynamic checkboxes on preload=true
    function initDBDrivenCheckboxes() {
        if (!meerkat.site.hasOwnProperty('simplesCheckboxes')) return;

        var simplesObj = meerkat.site.simplesCheckboxes.simples;
        if (!_.isEmpty(simplesObj)) {
            for (var key in simplesObj) {
                var $element = $('#health_simples_' + key);
                if($element.is(':checkbox')) {
                    $element.prop('checked', simplesObj[key] === 'Y');
                }
            }
        }
    }

    function applyEventListeners() {
        // General Toggle
        $('.simples-dialogue.optionalDialogue h3.toggle').parent('.simples-dialogue').addClass('toggle').on('click', function () {
            $(this).find('h3 + div').slideToggle(200);
        });

        // Handle toggle inbound/outbound
        $healthContactTypeField.on('change', function(){
            toggleInboundOutbound();
            toggleFollowupCallDialog();
            toggleReferralCallDialog();
            toggleWebChatDialog();
            toggleAfricaCompDialog();
        });
        // Handle callback checkbox 68
        $followupCallCheckbox.on('change', toggleFollowupCallDialog);
	    // Handle callback checkbox 93
	    $referralCallCheckbox.on('change', toggleReferralCallCheckbox);
        // Handle toggle rebateDialogue
        $healthCoverRebate.add($healthSituationCvr).on('change', toggleRebateDialogue);
        // Handle toggle benefitsDialogue
        $healthSitCoverType.on('change', toggleBenefitsDialogue);
        // Handle toggle primaryCoverDialogue
        $healthPrimaryCover.on('change', togglePrimaryCoverDialogue);
        // Handle toggle partnerCoverDialogue
        $healthPartnerCover.on('change', togglePartnerCoverDialogue);

        // open bridging page
        $('#resultsPage').on("click", ".btn-more-info", openBridgingPage);

        $dialogue36.find('a').on('click', function toggleMoreText() {
            $dialogue36.find('.simples-dialogue-36-extra-text').toggleClass('hidden');
        });

	    $nzMedicareRulesToggle.text($nzMedicareRulesToggle.attr('data-copy-off'));
        $nzMedicareRulesToggle.on('click', function(){
            var $btn = $(this);
            var isOn = $nzMedicareRulesCopy.is(':visible');
            $btn.text($btn.attr('data-copy-' + (isOn?'off':'on')));
            $nzMedicareRulesCopy.toggle(!isOn);
        });

        $healthSituationMedicareField.on('change', function(){
            _toggleInternationalStudentField();
        });

        $healthInternationalStudentField.on('change', function(){
            _toggleInternationalStudentFieldMsg();
        });
    }

    function openBridgingPage(e) {
        var i = 0,
            needsValidation;

        $('#resultsForm .simples-dialogue').not('.hidden').find('input[type=checkbox]').each(function() {
            if (!$(this).prop('checked')) {
                i++;
            }
        });

        if ($('#resultsForm .simples-dialogue-76').not('.hidden').length === 1) {
            if (_.isUndefined($moreInfoDialogueRadio.filter(':checked').val())) {
                i++;
            }
        }

        needsValidation = i !== 0;

        if (needsValidation) {
            e.stopImmediatePropagation();
            $('#resultsForm').valid();
        }

        return i === 0;
    }

    function eventSubscriptions() {
        var $simplesResults = $('.simples-dialogue-results'),
            $simplesMoreInfo = $('.simples-dialogue-more-info');

        meerkat.messaging.subscribe(meerkatEvents.moreInfo.bridgingPage.SHOW, function () {
            $simplesResults.hide();
            $simplesMoreInfo.show();
        });

        meerkat.messaging.subscribe(meerkatEvents.moreInfo.bridgingPage.HIDE, function () {
            $simplesMoreInfo.hide();
            $simplesResults.show();
        });
    }

    // Hide/show simple dialogues when toggle inbound/outbound in simples journey
    function toggleInboundOutbound() {
        var $body = $('body');
        var healthContactTypeSelection = $healthContactTypeField.val();

        // Inbound
        if (healthContactTypeSelection === 'inbound') {

            $healthContactType.val('inbound');
            $healthContactTypeTrial.val('');

            $body
                .removeClass('outbound trial')
                .addClass('inbound');
        }
        // Outbound
        else {
            $body
                .removeClass('inbound trial')
                .addClass('outbound');

            var contatTypeTrialRegex = new RegExp('trial','i');
            var isTrialContactType = contatTypeTrialRegex.test(healthContactTypeSelection);

            if (isTrialContactType) {
                $body.addClass('trial');
            }

            if ((healthContactTypeSelection === 'outbound') || isTrialContactType) {
                //contact type is set to outbound when Outbound or a trial is selected
                $healthContactType.val('outbound');

                if (healthContactTypeSelection === 'outbound') {
                    $healthContactTypeTrial.val('');
                } else {
                    $healthContactTypeTrial.val($healthContactTypeSelectOption.filter(':selected').text().trim());
                }

            } else {
                $healthContactTypeTrial.val('');

                if (healthContactTypeSelection === 'webchat') {
                    $healthContactType.val('webchat');
                } else {
                    // cli outbound
                    $healthContactType.val('cli');
                }
            }

        }
    }

    function getRawCallType() {
        var healthContactTypeSelection = $healthContactTypeField.val();
        var callTypeToBeReturned = $healthContactTypeSelectOption.is(':selected') ? (healthContactTypeSelection != "" ? healthContactTypeSelection : null) : null;
        var contatTypeTrialRegex = new RegExp('trial','i');

        // treat trial campaigns as outbound
        // for all intents and purposes trial campaign should be handled as an outbound call type - just have a different value stored in the DB
        // unsure if cli outbound should be handled here too
        if (callTypeToBeReturned !== null) {
            if (contatTypeTrialRegex.test(callTypeToBeReturned)){
                callTypeToBeReturned = 'trial';
            }
        }

        return callTypeToBeReturned;
    }

    function getCallType() {
        var callTypeToBeReturned = getRawCallType();

        if (callTypeToBeReturned === 'trial') {
            callTypeToBeReturned = 'outbound';
        }

        return callTypeToBeReturned;
    }

    // Toggle visibility on follow call dialogs based on call type and whether is a followup call
    function toggleFollowupCallDialog() {
        var callType = false;
        var isValidCallType = false;
        var isFollowupCall = $followupCallCheckbox.is(':checked');
        // Set the calltype variables
        callType = getCallType();
        if (!_.isEmpty(callType)) {
            isValidCallType = _.indexOf(['outbound','inbound','cli'],callType) >= 0;
        }
        // Toggle visibility of followup call checkbox
        $followupCallCheckboxDialogue.toggleClass('hidden',!isValidCallType);
        $cliCallCheckboxDialogue.toggleClass('hidden',(getCallType()=== null ? true : isValidCallType));
        $nonCliCallCheckboxDialogue.toggleClass('hidden',!(getCallType() === null ? true : isValidCallType));
        if (isFollowupCall && isValidCallType) {
            if (_.indexOf(['outbound','cli'], callType) >= 0) {
                // Hide inbound dialogs and show outbound
                $inboundQuestionsetFollowupDialogue
                    .add($inboundApplicationFollowupDialogue)
                    .addClass('hidden');
                $outboundFollowupDialogue.removeClass('hidden');
            } else {
                // Hide outbound dialogs and show inbound
                $outboundFollowupDialogue
                    .add($followupDialogueContentContainers)
                    .addClass('hidden');
                $inboundQuestionsetFollowupDialogue
                    .add($inboundApplicationFollowupDialogue)
                    .removeClass('hidden');
                // Add listeners to the content toggles
                $inboundQuestionsetFollowupToggles
                    .add($inboundApplicationFollowupToggles)
                    .each(function(){
                        $(this).off('click.inboundFollowupClick').on('click.inboundFollowupClick',function(){
                            var label = $(this).attr('data-copy-container');
                            $followupDialogueContentContainers
                                .not('.' + label).addClass('hidden').end()
                                .filter('.' + label).removeClass('hidden');
                        });
                    });
            }
        } else {
            // Hide all inbound/outbound followup dialogs if not applicable
            $outboundFollowupDialogue
                .add($inboundQuestionsetFollowupDialogue)
                .add($inboundApplicationFollowupDialogue)
                .addClass('hidden');
        }
    }

	// Toggle visibility on referral call dialogs based on if NOT inbound call
	function toggleReferralCallDialog() {
    	var callType = getRawCallType();
    	var validCallType = !_.isEmpty(callType) && callType !== 'inbound';
		$referralCallCheckboxDialogue.toggle(validCallType);
		if(!validCallType && $referralCallCheckbox.is(':checked')) {
			$referralCallCheckbox.prop("checked", null).trigger("change");
		}
		toggleReferralCallCheckbox(callType);
	}
	// Toggle visibility of referral related dialogs when referral selected
	function toggleReferralCallCheckbox(callType) {
        callType = callType || false;
        var isInbound = callType === "inbound";
        var suppressTrialToggle = false;
        var dblChkCallType = "";
        var brandCodeIsCtm = meerkat.site.tracking.brandCode === 'ctm';

        if (brandCodeIsCtm && Object(callType)) {
            dblChkCallType = getRawCallType();
            if (dblChkCallType === "trial") {
                callType = dblChkCallType;
                suppressTrialToggle = true;
            }
        }

        if (brandCodeIsCtm && callType === "trial") {
            $referralCallCheckbox.prop("checked", true);

            if (!suppressTrialToggle){
                $referralCallCheckbox.trigger("change");
            }
        }

        var isReferral = callType !== false && isInbound === false && $referralCallCheckbox.is(':checked');

        if (!isInbound && isReferral) {
            $dialogue36.add($referralCallPaymentStepDialogue1).add($referralCallPaymentStepDialogue2).toggle(isReferral);
        } else {
            $referralCallPaymentStepDialogue1.add($referralCallPaymentStepDialogue2).toggle(isReferral);
            $dialogue36.toggle(isInbound);
            if (brandCodeIsCtm && callType === "trial") {
                $dialogue36.add($referralCallPaymentStepDialogue1).add($referralCallPaymentStepDialogue2).toggle(true);
            }
        }

	}

	function toggleWebChatDialog() {
        var isWebChat = webChatInProgress();
        $dialogue21.toggle(!isWebChat);
        $dialogue26.toggleClass('hidden', isWebChat);
        $dialogue37.toggleClass('hidden', isWebChat);
        $moreInfoDialogue.toggleClass('hidden', isWebChat);
        $dialogue109.toggleClass('hidden', isWebChat);
        $healthSituationMedicare.toggleClass('hidden', isWebChat);
        $healthCvrDtlsIncomeBasedOn.toggleClass('hidden', isWebChat);

        if (isWebChat) {
            $referralCallCheckboxDialogue.toggle(!isWebChat);
        }

		meerkat.modules.simplesWebChat.setup(isWebChat);
    }

    function toggleAfricaCompDialog() {
        var healthContactTypeSelection = $healthContactTypeField.val();
        $dialogue106.toggle(healthContactTypeSelection === 'inbound' || healthContactTypeSelection.indexOf('trail'));
    }

	function webChatInProgress() {

		var callType = getCallType();
		var isWebChat = !_.isEmpty(callType) && callType === 'webchat';

		return isWebChat;
	}

    function toggleRebateDialogue() {

        var healthSituationCover = $healthSituationCvr.val();

        $dialogue74.toggleClass('hidden', !(healthSituationCover === "ESP" || healthSituationCover === "EF"));
    }

    function toggleBenefitsDialogue() {
        var $hospitalScripts = $('.simples-dialogue-hospital-cover'),
            $hospitalNonPublic = $hospitalScripts.filter('.classification-nonPublic'),
            $hospitalPublic = $hospitalScripts.filter('.classification-public'),
            $extrasScripts = $('.simples-dialogue-extras-cover'),
            selectedProduct = Results.getSelectedProduct(),
            isHospitalPublic = !_.isUndefined(selectedProduct) && _.has(selectedProduct, 'hospital') &&
                _.has(selectedProduct.hospital, 'ClassificationHospital') && selectedProduct.hospital.ClassificationHospital === 'Public';

        switch ($healthSitCoverType.find('input:checked').val().toLowerCase()) {
            case 'c':
                $hospitalScripts.show();
                $hospitalNonPublic.toggleClass('hidden', isHospitalPublic);
                $hospitalPublic.toggleClass('hidden', !isHospitalPublic);
                $extrasScripts.show();
                break;
            case 'h':
                $hospitalScripts.show();
                $hospitalNonPublic.toggleClass('hidden', isHospitalPublic);
                $hospitalPublic.toggleClass('hidden', !isHospitalPublic);
                $extrasScripts.hide();
                break;
            case 'e':
                $hospitalScripts.hide();
                $extrasScripts.show();
                break;
            default:
                $hospitalScripts.hide();
                $extrasScripts.hide();
                break;
        }
    }

    function togglePrimaryCoverDialogue() {
        $dialoguePrimaryCover.toggleClass('hidden', $healthPrimaryCover.filter(':checked').val() !== "Y");
    }

    function togglePartnerCoverDialogue() {
        $dialoguePartnerCover.toggleClass('hidden', $healthPartnerCover.filter(':checked').val() !== "Y");
    }

    function toggleLimitedCoverDialogue() {
        var _toggle = $limitedCoverHidden.val() === 'N' || ($limitedCoverHidden.val() === 'Y' && _isHospitalPublic() === false);

        $privatePatientDialogue.toggleClass('hidden', _toggle);
    }

    function toggleMoreInfoDialogue() {
        if (webChatInProgress()) {
            $moreInfoDialogue.toggleClass('hidden', true);
        } else {
            toggleResultsMandatoryDialogue();
        }
    }

    function toggleAffiliateRewardsDialogue() {
        var dialogueHTML = $affiliatesDialogue.html();

        dialogueHTML = dialogueHTML.replace(/affiliateName/g, meerkat.site.affiliate_details.name).replace(/affiliateURL/g, meerkat.site.affiliate_details.url);

        $affiliatesDialogue
            .removeClass('hidden')
            .html(dialogueHTML);
    }

    function togglePricePromisePromoDialogue(pricePromiseMentioned) {
        if (pricePromiseMentioned) {
            $pricePromisePromotionDialogue.slideDown();
        } else {
            $pricePromisePromotionDialogue.slideUp();
        }
    }

    function _isHospitalPublic() {
        var selectedProduct = Results.getSelectedProduct();

        return (!_.isUndefined(selectedProduct) && _.has(selectedProduct, 'hospital') &&
                _.has(selectedProduct.hospital, 'ClassificationHospital') && selectedProduct.hospital.ClassificationHospital === 'Public');
    }

    function toggleResultsMandatoryDialogue() {
        // needs to be deferred, when retrieving limited cover quote
        _.defer(function() {
            $moreInfoDialogue.toggleClass('hidden', $limitedCoverHidden.val() === 'Y');
            $dialogue109.toggleClass('hidden', $limitedCoverHidden.val() === 'N');
        });
    }

    meerkat.modules.register("simplesBindings", {
        init: init,
        toggleLimitedCoverDialogue: toggleLimitedCoverDialogue,
        toggleRebateDialogue: toggleRebateDialogue,
        toggleMoreInfoDialogue: toggleMoreInfoDialogue,
        toggleAffiliateRewardsDialogue: toggleAffiliateRewardsDialogue,
        getCallType: getCallType,
        togglePricePromisePromoDialogue: togglePricePromisePromoDialogue,
        toggleBenefitsDialogue: toggleBenefitsDialogue,
        toggleResultsMandatoryDialogue: toggleResultsMandatoryDialogue,
		webChatInProgress: webChatInProgress
    });

})(jQuery);
