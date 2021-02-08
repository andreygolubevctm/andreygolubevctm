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
        $dialogue97,
        $dialogue102,
        $cliCallCheckboxDialogue,
        $nonCliCallCheckboxDialogue,
        $outboundIntroDialogue,
        $outboundFollowupDialogue,
        $inboundQuestionsetFollowupDialogue,
        $inboundQuestionsetFollowupToggles,
        $inboundApplicationFollowupDialogue,
        $inboundApplicationFollowupToggles,
        $followupDialogueContentContainers,
        $simplesMedicareCoverForm = null,
        $simplesinternationalStudentForm = null,
        $applicantWrappers = {},
        $limitedCoverHidden,
        $dialogue111,
        $dialogue112,
        $dialogue21,
        $dialogue26,
        $dialogue36,
        $dialogue37,
        $dialogue38,
        $dialogue40,
        $dialogue210,
        $pricePromisePromotionDialogue,
        $affiliatesDialogue,
        $dialogue106,
        $optin_email,
	      $optin_email_app,
        $optin_phone,
        $optin_privacy,
        $optin_optin,
        // List of affiliates who must be ommited from auto optin functionality
        affiliatesOptinBlacklist = [
            "trialcampaignFacebook",
            "trialcampaignHealthEngine",
            "trialcampaignHealthEngineLP",
            "trialcampaignJackMedia",
            "trialcampaignMicrosite",
            "trialcampaignOmnilead",
            "trialcampaignOptimise",
            "nextgenOutbound",
            "nextgenCLI",
            "trialCampaignRedlands"
        ],
        $medicare_isaustralian,
        $medicare_nzcitizen,
        $medicare_nzcitizen_question,
        $medicare_hasmedicarecard,
        $medicare_hasmedicarecard_question,
        $medicare_isreciprocalorinterim,
        $medicare_isreciprocalorinterim_question,
        $medicare_confirmeligibilitymedicarecard,
        $medicare_medicarelevysurcharge,
        $medicare_medicarelevysurcharge_question,
        $medicare_medicarelevysurchargereci,
        $medicare_medicarelevysurchargereci_question,
        $medicare_medicarelevysurcharge_yes,
        $medicare_medicarelevysurcharge_yesreci,
        $medicare_nooverseasstudentcoverreci,
        $medicare_LHCmedicarelevysurcharge,
        $medicare_overseasvistorcoverreci,
        $medicare_internationalstudent,
        $medicare_internationalstudent_question,
        $medicare_internationalstudentreci,
        $medicare_internationalstudentreci_question,
        $medicare_nooverseasstudentcover,
        $medicare_overseasvistorcover,
        $medicare_hascard_notpayingmls,
        $medicare_nocard_notpayingmls,
        $norebate_checkbox,
        isAustralian = null,
        isNZCitizen = null,
        hasMedicareCard = null,
        isAvoidSurcharge = null
    ;

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
	          $dialogue97 = $('.simples-dialogue-97');
	          $dialogue102 = $('.simples-dialogue-102');
            $cliCallCheckboxDialogue = $('.simples-dialogue-78');
            $nonCliCallCheckboxDialogue = $('.simples-dialogue-20');
            $outboundIntroDialogue = $('.simples-dialogue-135');
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
            $limitedCoverHidden = $("input[name='health_situation_accidentOnlyCover']");
            $dialogue21 = $('.simples-dialogue-21');
            $dialogue26 = $('.simples-dialogue-26');
            $dialogue36 = $('.simples-dialogue-36');
            $dialogue37 = $('.simples-dialogue-37');
            $dialogue38 = $('.simples-dialogue-38');
            $dialogue40 = $('.simples-dialogue-40');
            $pricePromisePromotionDialogue = $('.simples-dialogue-101');
            $affiliatesDialogue = $('.simples-dialogue-105');
            $dialogue106 = $('.simples-dialogue-106');
            $dialogue111 = $('.simples-dialogue-111');
            $dialogue112 = $('.simples-dialogue-112');
            $optin_email = $('#health_contactDetails_optInEmail');
	          $optin_email_app = $('#health_application_optInEmail');
	          $optin_phone = $('#health_contactDetails_call');
	          $optin_privacy = $('#health_privacyoptin');
	          $optin_optin = $('#health_contactDetails_optin');
            $medicare_isaustralian = $('#health_healthCover_cover');
            $medicare_nzcitizen = $('#medicare-questions-nzcitizen');
            $medicare_nzcitizen_question = $('#health_situation_nzcitzen_wrapper');
            $medicare_hasmedicarecard = $('#medicare-questions-hasmedicarecard');
            $medicare_hasmedicarecard_question = $('#health_situation_hasmedicarecard_wrapper');
            $medicare_isreciprocalorinterim = $('#medicare-questions-isreciprocalorinterim');
            $medicare_isreciprocalorinterim_question = $('#health_situation_isreciprocalorinterim_wrapper');
            $medicare_confirmeligibilitymedicarecard = $('#simples-dialogue-190');
            $medicare_medicarelevysurcharge = $('#medicare-questions-medicarelevysurcharge');
            $medicare_medicarelevysurcharge_question = $('#health_situation_medicarelevysurcharge_wrapper');
            $medicare_medicarelevysurchargereci = $('#medicare-questions-medicarelevysurchargereci');
            $medicare_medicarelevysurchargereci_question = $('#health_situation_medicarelevysurchargereci_wrapper');
            $norebate_checkbox = $('#health_healthCover_health_cover_rebate_dontApplyRebate');
            $medicare_medicarelevysurcharge_yes = $('.simples_surcharge_dialogue_196');
            $medicare_medicarelevysurcharge_yesreci = $('.simples_reciprocal_dialogue_196');
            $medicare_nooverseasstudentcoverreci = $('.simples_reciprocal_dialogue_198');
            $medicare_overseasvistorcoverreci = $('.simples_reciprocal_dialogue_199');
            $medicare_LHCmedicarelevysurcharge = $('.simples_dialogue_medicare_143');
            $medicare_internationalstudent = $('#medicare-questions-internationalstudent');
            $medicare_internationalstudent_question = $('#health_situation_internationalstudent_wrapper');
            $medicare_internationalstudentreci = $('#medicare-questions-internationalstudentreci');
            $medicare_internationalstudentreci_question = $('#health_situation_internationalstudentreci_wrapper');
            $medicare_nooverseasstudentcover = $('.simples_nomccard_dialogue_198');
            $medicare_overseasvistorcover = $('.simples_nomccard_dialogue_199');
            $medicare_hascard_notpayingmls = $('#medicare-questions-isreciprocalorinterim .simples-dialogue-200');
            $medicare_nocard_notpayingmls = $('#medicare-questions-medicarelevysurcharge .simples-dialogue-200');
            $dialogue210 = $('#simples-dialogue-210');

            // Handle pre-filled
            populatePrevAssignedRadioBtnGroupValue();
            toggleInboundOutbound();
            toggleBenefitsDialogue();
            initDBDrivenCheckboxes();
            toggleFollowupCallDialog();
            toggleReferralCallDialog();
            initNaturpathyDialog();
            applyEventListeners();
            eventSubscriptions();
            _toggleInternationalStudentField();
            toggleEnergyCrossSell();
            toggleCoverDialogues();
            _toggleRebateFromMedicareDetails();

            meerkat.modules.provider_testing.setApplicationDateCalendar();
        });
    }

    function initNaturpathyDialog() {
        var $naturopathCheckbox = $('#health_benefits_benefitsExtras_Naturopathy');
        var $naturopathDialog = $('<div class="naturopathWarning" id="naturopathWarningDialog">');
        $naturopathDialog.html('<p class="blackText"><strong>If customer mentions one of the 16 natural therapies being removed from April 1.</strong></p>'
            + '<p class="blackText">Natural therapies being removed are: Alexander technique, aromatherapy, Bowen therapy, Buteyko, Feldenkrais, herbalism, homeopathy, iridology, kinesiology, naturopathy, Pilates, reflexology, Rolfing, shiatsu, tai chi, and yoga</p>'
            + '<p>I\'m happy to include it for you in our search, however as it\’s being removed from all products from April 1st, you may not receive any benefit from it due to the potential 2 month waiting period, would you still like me to take this into account when picking a policy?</p>'
        );
        $naturopathDialog.insertAfter($naturopathCheckbox.closest('.categoriesCell'));
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
	        toggleBenefitsDialogue();
	        toggleEnergyCrossSell();
			toggleRedlandsTrailCampaign();
            cleanupOptins();
        });
        // Handle callback checkbox 68
        $followupCallCheckbox.on('change', toggleFollowupCallDialog);
	    // Handle callback checkbox 93
	    $referralCallCheckbox.on('change', toggleReferralCallCheckbox);
        // Handle toggle rebateDialogue
        $healthCoverRebate.add($healthSituationCvr).on('change', function(){
            toggleRebateDialogue();
            toggleCoverDialogues();
        });
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

        $healthSituationMedicareField.on('change', function(){
            _toggleInternationalStudentField();
        });

        $healthInternationalStudentField.on('change', function(){
            _toggleInternationalStudentFieldMsg();
        });

        // Medicare Questions
        $medicare_isaustralian.find(':input').on('click', function() {
            _unsetInputsForElements($medicare_nzcitizen);
            $medicare_confirmeligibilitymedicarecard.add($medicare_LHCmedicarelevysurcharge).add($medicare_medicarelevysurcharge_yes).add($medicare_medicarelevysurcharge_yesreci).add($medicare_nocard_notpayingmls).add($medicare_overseasvistorcoverreci).add($medicare_nooverseasstudentcover).add($medicare_nooverseasstudentcoverreci).add($medicare_overseasvistorcover).add($medicare_overseasvistorcoverreci).addClass('hidden');
            isAustralian = $(this).val() === 'Y';
            isNZCitizen = null;
            hasMedicareCard = null;
            isAvoidSurcharge = null;
            $medicare_nzcitizen.toggleClass('hidden', isAustralian);
            $medicare_nzcitizen_question.toggleClass('hidden', isAustralian);
            _toggleRebateFromMedicareDetails();
        });
        $medicare_nzcitizen_question.find(':input').on('click', function(){
            _unsetInputsForElements($medicare_hasmedicarecard);
            $medicare_confirmeligibilitymedicarecard.add($medicare_LHCmedicarelevysurcharge).add($medicare_medicarelevysurcharge_yes).add($medicare_medicarelevysurcharge_yesreci).add($medicare_nocard_notpayingmls).add($medicare_overseasvistorcoverreci).add($medicare_nooverseasstudentcover).add($medicare_nooverseasstudentcoverreci).add($medicare_overseasvistorcover).add($medicare_overseasvistorcoverreci).addClass('hidden');
            isNZCitizen = $(this).val() === 'Y';
            hasMedicareCard = null;
            isAvoidSurcharge = null;
            $medicare_hasmedicarecard.removeClass('hidden');
            $medicare_hasmedicarecard_question.removeClass('hidden');
            _toggleRebateFromMedicareDetails();
        });
        $medicare_hasmedicarecard_question.find(':input').on('click', function(){
            hasMedicareCard = $(this).val() === 'Y';
            isAvoidSurcharge = null;
            _unsetInputsForElements($medicare_medicarelevysurchargereci.add($medicare_isreciprocalorinterim).add($medicare_medicarelevysurcharge));
            $medicare_confirmeligibilitymedicarecard.add($medicare_LHCmedicarelevysurcharge).add($medicare_medicarelevysurcharge_yes).add($medicare_medicarelevysurcharge_yesreci).add($medicare_nocard_notpayingmls).add($medicare_overseasvistorcoverreci).add($medicare_nooverseasstudentcover).add($medicare_nooverseasstudentcoverreci).add($medicare_overseasvistorcover).add($medicare_overseasvistorcoverreci).addClass('hidden');
            if(isNZCitizen) {
                $medicare_confirmeligibilitymedicarecard.toggleClass('hidden', hasMedicareCard);
            } else {
                $medicare_medicarelevysurchargereci.toggleClass('hidden', hasMedicareCard);
                $medicare_isreciprocalorinterim.toggleClass('hidden', !hasMedicareCard);
                $medicare_isreciprocalorinterim_question.toggleClass('hidden', !hasMedicareCard);
                $medicare_medicarelevysurcharge.toggleClass('hidden', hasMedicareCard);
                $medicare_medicarelevysurcharge_question.toggleClass('hidden', hasMedicareCard);
            }
            _toggleRebateFromMedicareDetails();
        });
        $medicare_isreciprocalorinterim_question.find(':input').on('click', function(){
            _unsetInputsForElements($medicare_medicarelevysurchargereci);
            $medicare_nooverseasstudentcoverreci.add($medicare_overseasvistorcoverreci).add($medicare_medicarelevysurcharge_yesreci).addClass('hidden');
            var isReciprocal = $(this).val() === 'I';
            $medicare_medicarelevysurchargereci.toggleClass('hidden', isReciprocal);
            $medicare_medicarelevysurchargereci_question.toggleClass('hidden', isReciprocal);
            _toggleRebateFromMedicareDetails();
        });
        $medicare_medicarelevysurchargereci_question.find(':input').on('click', function(){
            _unsetInputsForElements($medicare_medicarelevysurcharge_yesreci.add($medicare_internationalstudentreci).add($medicare_hascard_notpayingmls));
            $medicare_nooverseasstudentcoverreci.add($medicare_overseasvistorcoverreci).add($medicare_LHCmedicarelevysurcharge).addClass('hidden');
            isAvoidSurcharge = $(this).val() === 'Y';
            $medicare_medicarelevysurcharge_yesreci.toggleClass('hidden', !isAvoidSurcharge);
            $medicare_internationalstudentreci.toggleClass('hidden', isAvoidSurcharge);
            $medicare_internationalstudentreci_question.toggleClass('hidden', isAvoidSurcharge);
            $medicare_hascard_notpayingmls.toggleClass('hidden', !isAvoidSurcharge);
            _toggleRebateFromMedicareDetails();
        });
        $medicare_internationalstudentreci.find('.health_situation_medicare_internationalstudentreci').find(':input').on('click', function(){
            $medicare_nooverseasstudentcoverreci.add($medicare_overseasvistorcoverreci).addClass('hidden');
            var isInternationalStudent = $(this).val() === 'Y';
            $medicare_nooverseasstudentcoverreci.toggleClass('hidden', !isInternationalStudent);
            $medicare_overseasvistorcoverreci.toggleClass('hidden', isInternationalStudent);
            _toggleRebateFromMedicareDetails();
        });
        $medicare_medicarelevysurcharge_question.find(':input').on('click', function(){
            _unsetInputsForElements($medicare_LHCmedicarelevysurcharge.add($medicare_internationalstudent).add($medicare_nocard_notpayingmls));
            $medicare_nooverseasstudentcover.add($medicare_overseasvistorcover).add($medicare_medicarelevysurcharge_yes).add($medicare_nocard_notpayingmls).addClass('hidden');
            isAvoidSurcharge = $(this).val() === 'Y';
            $medicare_medicarelevysurcharge_yes.toggleClass('hidden', !isAvoidSurcharge);
            $medicare_internationalstudent.toggleClass('hidden', isAvoidSurcharge);
            $medicare_internationalstudent_question.toggleClass('hidden', isAvoidSurcharge);
            $medicare_nocard_notpayingmls.toggleClass('hidden', !isAvoidSurcharge);
            _toggleRebateFromMedicareDetails();
        });
        $medicare_internationalstudent.find('.health_situation_medicare_internationalstudent').find(':input').on('click', function(){
            var isInternationalStudent = $(this).val() === 'Y';
            $medicare_nooverseasstudentcover.toggleClass('hidden', !isInternationalStudent);
            $medicare_overseasvistorcover.toggleClass('hidden', isInternationalStudent);
            _toggleRebateFromMedicareDetails();
        });
    }

    function _toggleRebateFromMedicareDetails() {
        if((isNZCitizen === true && hasMedicareCard === false) || (isNZCitizen === false && hasMedicareCard === false)) {
            $norebate_checkbox.prop("checked", true).change();
			$dialogue37.toggleClass('hidden', true);
            $dialogue210.hide();
            $medicare_LHCmedicarelevysurcharge.removeClass('hidden');
            $('#health_healthCover_tier').hide();
            $('#health_healthCover_incomeBase').hide();
            $('.health_cover_details_dependants').hide();
        } else {
            $norebate_checkbox.prop("checked", false).change();
			$dialogue37.toggleClass('hidden', false);
            $dialogue210.show();
            $medicare_LHCmedicarelevysurcharge.addClass('hidden');
            $('#health_healthCover_tier').show();

            var situation = $('.health-situation-healthCvr').val();
            if (_.indexOf(["SM", "SF", "C"], situation) !== -1) {
                $('#health_healthCover_incomeBase').show();
            } else {
                $('.health_cover_details_dependants').show();
            }

            if ($medicare_medicarelevysurcharge_yes.is(':visible')) {
                $norebate_checkbox.prop("checked", true).change();
				$dialogue37.toggleClass('hidden', true);
                $medicare_LHCmedicarelevysurcharge.removeClass('hidden');
                $('#health_healthCover_tier').hide();
                $('#health_healthCover_incomeBase').hide();
                $('.health_cover_details_dependants').hide();
            }
        }
    }

    function openBridgingPage(e) {
        var i = 0,
            needsValidation;

        $('#resultsForm .simples-dialogue').not('.hidden').find('input[type=checkbox]').each(function() {
            if (!$(this).prop('checked')) {
                i++;
            }
        });

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

    // When lead originates from a nominated affiliate source then we cannot
    // automatically opt them in for anything - all default to N
    function cleanupOptins() {
	    var contactType = $healthContactTypeField.val();
	    if(!_.isUndefined(contactType) && !_.isEmpty(contactType)) {
	        var optin = _.indexOf(affiliatesOptinBlacklist, contactType) === -1 ? "Y" : "N";
	        // Set any marketing optins to NO
		    $optin_email.add($optin_phone).add($optin_email_app).val(optin);
        }
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
                .removeClass('outbound cli')
                .removeClass('nextgen')
	            .removeClass('nextgenoutbound')
	            .removeClass('nextgencli')
                .removeClass('energycross')
                .removeClass('energytransfer')
			.removeClass('trialCampaignRedlands')
                .addClass('inbound');
        }
        else if(healthContactTypeSelection === 'nextgen') {
            $healthContactType.val('inbound');
            $healthContactTypeTrial.val('nextgen');

            $body
                .removeClass('outbound trial')
                .removeClass('outbound cli')
                .removeClass('inbound')
                .removeClass('energycross')
                .removeClass('energytransfer')
				.removeClass('trialCampaignRedlands')
                .addClass('nextgen');
        }
        // Outbound
        else {
	        var healthContactTypeSelectionStr = healthContactTypeSelection.toLowerCase();
            $body
                .removeClass('inbound cli trial nextgen nextgenoutbound nextgencli energycross energytransfer trialCampaignRedlands')
	            .toggleClass(healthContactTypeSelectionStr, isOutboundNextGenContactType(healthContactTypeSelection))
                .addClass('outbound');


            var contatTypeTrialRegex = new RegExp('trial','i');
            var isTrialContactType = contatTypeTrialRegex.test(healthContactTypeSelection);

            if (isTrialContactType) {
                $body.addClass('trial');
            }

            if (healthContactTypeSelection === 'cli') {
                $body.addClass('cli');
            }

            if ((healthContactTypeSelection === 'outbound') || isTrialContactType) {
	            //contact type is set to outbound when Outbound or a trial is selected
	            $healthContactType.val('outbound');

	            if (healthContactTypeSelection === 'outbound') {
		            $healthContactTypeTrial.val('');
	            } else {
		            $healthContactTypeTrial.val($healthContactTypeSelectOption.filter(':selected').text().trim());
	            }
            } else if(isOutboundNextGenContactType(healthContactTypeSelection)) {
                $body.addClass(healthContactTypeSelectionStr);
	            $healthContactType.val('outbound');
	            $healthContactTypeTrial.val(healthContactTypeSelectionStr);
            } else {
                $healthContactTypeTrial.val('');

                if (healthContactTypeSelection === 'webchat') {
                    $healthContactType.val('webchat');
                } else if(healthContactTypeSelection === 'energyCrossSell') {
                    $healthContactType.val('outbound');
                    $healthContactTypeTrial.val('energyCrossSell');
                } else if(healthContactTypeSelection === 'energyTransfer') {
                    $healthContactType.val('inbound');
                    $healthContactTypeTrial.val('energyTransfer');
                } else {
                    // cli outbound
                    $healthContactType.val('cli');
                }
            }

        }
    }

    function isOutboundNextGenContactType(type) {
        type = type || $healthContactTypeField.val() || "";
        return _.indexOf(['nextgenoutbound', 'nextgencli'], type.toLowerCase()) >= 0;
    }

    function isContactTypeNextGenOutbound() {
        var $type = $healthContactTypeField.val() || "";
        return $type.toLowerCase() === "nextgenoutbound";
    }

	function isContactTypeNextGenCli() {
		var $type = $healthContactTypeField.val() || "";
		return $type.toLowerCase() === "nextgencli";
	}

	function toggleEnergyCrossSell() {
        if ($healthContactTypeField.val() === 'energyCrossSell') {
            $healthContactType.val('outbound');

            $('body')
                .removeClass('outbound')
                .addClass('inbound')
                .toggleClass('energycross');
        }
        else if ($healthContactTypeField.val() === 'energyTransfer') {
            $healthContactType.val('inbound');

            $('body')
                .removeClass('outbound')
                .addClass('inbound')
                .toggleClass('energytransfer');
        }
    }

    function toggleRedlandsTrailCampaign() {
		$('body').toggleClass('trialCampaignRedlands', $healthContactTypeField.val() === 'trialCampaignRedlands');
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
        var isValidCallType = false;
        var isFollowupCall = $followupCallCheckbox.is(':checked');
        var isOutbound = meerkat.modules.healthContactType.is('outbound');
        // Set the calltype variables
        callType = getCallType();
        if (!_.isEmpty(callType)) {
            isValidCallType = _.indexOf(['outbound','inbound','cli','nextgen','nextgenoutbound','nextgencli','energyCrossSell','energyTransfer'], callType) >= 0;
        }
        // Toggle visibility of followup call checkbox
        $followupCallCheckboxDialogue.toggleClass('hidden',!isValidCallType);
        $cliCallCheckboxDialogue.toggleClass('hidden',(getCallType()=== null ? true : isValidCallType));
        $outboundIntroDialogue.toggleClass('hidden', !isOutbound);
        if(isOutbound) {
            $nonCliCallCheckboxDialogue.toggleClass('hidden', true);
        }else{
            $nonCliCallCheckboxDialogue.toggleClass('hidden',!(getCallType() === null ? true : isValidCallType));
        }

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
    	var validCallType = !_.isEmpty(callType) && _.indexOf(['inbound','nextgen','nextgenoutbound','nextgencli'], callType) < 0;
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

        if(isOutboundNextGenContactType()) {
	        $dialogue36.show();
        } else {
	        if (!isInbound && isReferral) {
	            $dialogue36.toggle(isReferral);
	        } else {
	            $dialogue36.toggle(isInbound);
	        }
        }
	}

	function toggleWebChatDialog() {
        var isWebChat = webChatInProgress();
        $dialogue21.toggle(!isWebChat);
        $dialogue26.toggleClass('hidden', isWebChat);
        $dialogue37.toggleClass('hidden', isWebChat);
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
            isHospitalPublic = !_.isUndefined(selectedProduct) && _.has(selectedProduct, 'custom') && selectedProduct.custom.reform.tab1.benefits && selectedProduct.custom.reform.tab1.benefits.find(function(benefit) { return benefit.covered === 'Y'; }) === undefined && selectedProduct.accident.covered === 'N';

        $dialogue97.add($dialogue102).toggleClass('hidden', true);

	    switch ($healthSitCoverType.find('input:checked').val().toLowerCase()) {
            case 'c':
	            toggleCoverTypeScripts($hospitalScripts, true);
                $dialogue97.toggleClass('hidden', isHospitalPublic);
                $dialogue102.toggleClass('hidden', !isHospitalPublic);
                $hospitalNonPublic.toggleClass('hidden', isHospitalPublic);
                $hospitalPublic.toggleClass('hidden', !isHospitalPublic);
	            toggleCoverTypeScripts($extrasScripts, true);
                break;
            case 'h':
	            toggleCoverTypeScripts($hospitalScripts, true);
                $dialogue97.toggleClass('hidden', isHospitalPublic);
                $dialogue102.toggleClass('hidden', !isHospitalPublic);
	            $hospitalNonPublic.toggleClass('hidden', isHospitalPublic);
	            $hospitalPublic.toggleClass('hidden', !isHospitalPublic);
	            toggleCoverTypeScripts($extrasScripts, false);
                break;
            case 'e':
	            toggleCoverTypeScripts($hospitalScripts, false);
	            toggleCoverTypeScripts($extrasScripts, true);
                break;
            default:
	            toggleCoverTypeScripts($hospitalScripts, false);
	            toggleCoverTypeScripts($extrasScripts, false);
                break;
        }
    }


    function toggleCoverTypeScripts($elements, show) {
        $elements.hide();
        if(show) {
            switch ($healthContactTypeField.val()) {
                case 'nextgenCLI':
                    $elements.filter('.simples-dialog-nextgencli')
                      .show();
                    break;
                case 'nextgenOutbound':
                    $elements.filter('.simples-dialog-nextgenoutbound')
                      .show();
                    break;
                case 'outbound':
                    $elements.not('.simples-dialog-nextgenoutbound, .simples-dialog-nextgencli, .simples-dialog-inbound').show();
                    break;
                default:
                    $elements.not('.simples-dialog-nextgenoutbound, .simples-dialog-nextgencli, .simples-dialog-outbound').show();
            }
        }
    }

    function toggleCoverDialogues() {
        togglePrimaryCoverDialogue();
        togglePartnerCoverDialogue();
    }

    function togglePrimaryCoverDialogue() {
        var isChecked = $healthPrimaryCover.filter(':checked').val() === "Y";
        var isOutbound = meerkat.modules.healthContactType.is('outbound');
        var isNextGenOutbound = meerkat.modules.healthContactType.is('nextgenOutbound');

        $dialoguePrimaryCover.filter('.simples-dialogue-53').toggleClass('hidden', !isChecked);
        $dialoguePrimaryCover.filter('.simples-dialogue-134').toggleClass('hidden', !(isOutbound || isNextGenOutbound) || !isChecked);
    }

    function togglePartnerCoverDialogue() {
        var hasPartner = meerkat.modules.healthChoices.hasSpouse();
        var isChecked = $healthPartnerCover.filter(':checked').val() === "Y";
        var isOutbound = meerkat.modules.healthContactType.is('outbound');
        var isNextGenOutbound = meerkat.modules.healthContactType.is('nextgenOutbound');

        $dialoguePartnerCover.filter('.simples-dialogue-191').toggleClass('hidden', !hasPartner || !isChecked);
        $dialoguePartnerCover.filter('.simples-dialogue-134').toggleClass('hidden', !hasPartner || (!(isOutbound || isNextGenOutbound) || !isChecked));
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

    function _unsetInputsForElements($element) {
        $element.find(":input").filter(":checked").each(function(){
            $(this).prop("checked", false);
        });
        $element.find(".active").removeClass("active");
        if($element.hasClass("fieldrow")) {
            $element.addClass("hidden");
        } else {
            var $rows = $element.find(".fieldrow");
            if($rows.length) {
                $rows.addClass("hidden");
            }
        }
    }

    meerkat.modules.register("simplesBindings", {
        init: init,
        toggleRebateDialogue: toggleRebateDialogue,
        toggleAffiliateRewardsDialogue: toggleAffiliateRewardsDialogue,
        getCallType: getCallType,
        togglePricePromisePromoDialogue: togglePricePromisePromoDialogue,
        toggleBenefitsDialogue: toggleBenefitsDialogue,
		webChatInProgress: webChatInProgress
    });

})(jQuery);
