(function ($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var $healthContactTypeRadio,
        $healthContactType,
        $healthContactTypeTrial,
        $healthCoverRebate,
        $healthSituationCvr,
        $healthSitCoverType,
        $healthPrimaryCover,
        $healthPartnerCover,
        $dialoguePrimaryCover,
        $dialoguePartnerCover,
        $dialogue74,
        $healthSituationMedicare,
        $aboutYouFieldset,
        $yourDetailsFieldset,
        $followupCallCheckboxDialogue,
        $followupCallCheckbox,
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
        $applicantWrappers = {},
        currentFamilyType = null,
        $limitedCoverHidden,
        $moreInfoDialogue,
        $dialogue36,
        $cashRewardsDialogue,
        $rewardGatewaryDialogue,
        $nzMedicareRules,
        $nzMedicareRulesToggle;

    function init() {
        $(document).ready(function () {

            // cache selectors
            $healthContactTypeRadio = $('input[name=health_simples_contactTypeRadio]');
            $healthContactType = $('#health_simples_contactType');
            $healthContactTypeTrial = $('#health_simples_contactTypeTrial');
            $healthCoverRebate = $('input[name=health_healthCover_rebate]');
            $healthSituationCvr = $('select[name=health_situation_healthCvr]');
            $healthSitCoverType = $('#health_situation_coverType');
            $healthPrimaryCover = $('input[name=health_healthCover_primary_cover]');
            $healthPartnerCover = $('input[name=health_healthCover_partner_cover]');
            $dialoguePrimaryCover = $('.simples-dialogue-primary-current-cover');
            $dialoguePartnerCover = $('.simples-dialogue-partner-current-cover');
            $dialogue74 = $('.simples-dialogue-74');
            $healthSituationMedicare = $('.health_situation_medicare');
            $aboutYouFieldset = $('#healthAboutYou > .content');
            $yourDetailsFieldset = $('#health-contact-fieldset .content');
            $followupCallCheckboxDialogue = $('.simples-dialogue-68');
            $followupCallCheckbox = $('#health_simples_dialogue-checkbox-68');
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
            $applicantWrappers.primary = $('#health-contact-fieldset .content:first');
            $applicantWrappers.partner = $('#partner-health-cover .content:first');
	        $privatePatientDialogue = $('.simples-dialogue-24');
            $limitedCoverHidden = $("input[name='health_situation_accidentOnlyCover']");
            $dialogue36 = $('.simples-dialogue-36');
            $cashRewardsDialogue = $('.simples-dialogue-79');
            $rewardGatewaryDialogue = $('.simples-dialogue-80');
	        $nzMedicareRules = $('#healthAboutYou .nz-medicare-rules');
	        $nzMedicareRulesToggle = $nzMedicareRules.find('a:first');
	        $nzMedicareRulesCopy = $nzMedicareRules.find('.copy:first');

            // Handle pre-filled
            populatePrevAssignedRadioBtnGroupValue();
            toggleInboundOutbound();
            toggleBenefitsDialogue();
            initDBDrivenCheckboxes();
            toggleFollowupCallDialog();

            applyEventListeners();
            eventSubscriptions();

            meerkat.modules.provider_testing.setApplicationDateCalendar();
        });
    }

    function populatePrevAssignedRadioBtnGroupValue() {

        // if data already exists for xpath load data into radio btn
	    var contactType = $healthContactType.val();
        if (!_.isEmpty(contactType)) {
            if ($healthContactTypeTrial.val() === 'Trial Campaign') {
                $('#health_simples_contactTypeRadio_trialcampaign').prop("checked", true).change();
            } else {
                if (contactType === 'inbound') {
                    $('#health_simples_contactTypeRadio_inbound').prop("checked", true).change();
                } else if (contactType === 'outbound') {
                    $('#health_simples_contactTypeRadio_outbound').prop("checked", true).change();
                } else if (contactType === 'cli') {
                    $('#health_simples_contactTypeRadio_clioutbound').prop("checked", true).change();
                }
            }
        }
    }

    function _moveSituationMedicareField() {
        // check if the field is still on the About you fieldset on  step 1
        if ($aboutYouFieldset.find($healthSituationMedicare).length === 1) {
            $healthSituationMedicare.appendTo($yourDetailsFieldset);
        }
    }

    function _resetSituationMedicareField() {
        // check if the field is still on the About you fieldset on  step 1
        if ($aboutYouFieldset.find($healthSituationMedicare).length === 0) {
            $healthSituationMedicare.appendTo($aboutYouFieldset);
        }
    }

    /**
     * Move the medicare fields to sit under partner fieldset if family/couple otherwise
     * the default is under primary fieldset
     */
    function updateSimplesMedicareCoverQuestionPosition() {
        if(getCallType() === 'outbound') {
            var familyType = meerkat.modules.health.getSituation();
            if (!_.isEmpty(familyType) && (_.isNull(currentFamilyType) || familyType !== currentFamilyType)) {
                var $tempMedicareForm = $simplesMedicareCoverForm.detach();
                var $wrapperToUse = $applicantWrappers[_.indexOf(['F', 'C', 'EF'], familyType) > -1 ? 'partner' : 'primary'];
                $wrapperToUse.append($tempMedicareForm);
                currentFamilyType = familyType;
            }
        }
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
        $healthContactTypeRadio.on('change', function(){
            toggleInboundOutbound();
            toggleFollowupCallDialog();
        });
        // Handle callback checkbox 68
        $followupCallCheckbox.on('change', toggleFollowupCallDialog);
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
    }

    function openBridgingPage(e) {
        var i = 0,
            needsValidation;

        $('#resultsForm .simples-dialogue').find('input[type=checkbox]').each(function() {
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

    // Hide/show simple dialogues when toggle inbound/outbound in simples journey
    function toggleInboundOutbound() {
        var $body = $('body');

        // Inbound
        if ($('#health_simples_contactTypeRadio_inbound').is(':checked')) {

            $healthContactType.val('inbound');
            $healthContactTypeTrial.val('');

            $body
                .removeClass('outbound')
                .addClass('inbound');

            _resetSituationMedicareField();
        }
        // Outbound
        else {
            $body
                .removeClass('inbound')
                .addClass('outbound');

            if (($('#health_simples_contactTypeRadio_outbound').is(':checked')) || ($('#health_simples_contactTypeRadio_trialcampaign').is(':checked'))) {
                _moveSituationMedicareField();

                $healthContactType.val('outbound');

                if ($('#health_simples_contactTypeRadio_outbound').is(':checked')) {
                    $healthContactTypeTrial.val('');
                } else {
                    $healthContactTypeTrial.val('Trial Campaign');
                }

            } else {
                // cli outbound
                $healthContactTypeTrial.val('');
                $healthContactType.val('cli');
            }

        }
    }

    function getCallType() {
        var callTypeToBeReturned = $healthContactTypeRadio.is(':checked') ? $healthContactTypeRadio.filter(':checked').val() : null;

        // treat trial campaign as outbound
        // for all intents and purposes trial campaign should be handled as an outbound call type - just have a different value stored in the DB
        // unsure if cli outbound should be handled here too
        if (callTypeToBeReturned === 'trialcampaign') {
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

    function toggleRebateDialogue() {

        var healthSituationCover = $healthSituationCvr.val();

        $dialogue74.toggleClass('hidden', !(healthSituationCover === "ESP" || healthSituationCover === "EF"));
    }

    function toggleBenefitsDialogue() {
        var $hospitalScripts = $('.simples-dialogue-hospital-cover'),
            $extrasScripts = $('.simples-dialogue-extras-cover');

        switch ($healthSitCoverType.find('input:checked').val().toLowerCase()) {
            case 'c':
                $hospitalScripts.show();
                $extrasScripts.show();
                break;
            case 'h':
                $hospitalScripts.show();
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
        $privatePatientDialogue.toggleClass('hidden', $limitedCoverHidden.val() !== 'Y');
    }

    function toggleMoreInfoDialogue() {
        $moreInfoDialogue = $('.simples-dialogue-76');
        $moreInfoDialogue.toggleClass('hidden', $healthSitCoverType.find('input:checked').val().toLowerCase() === "e");
    }

    function toggleAffiliateRewardsDialogue(affiliateId) {
        $cashRewardsDialogue.toggleClass('hidden', affiliateId !== 'cashRewards');
        $rewardGatewaryDialogue.toggleClass('hidden', affiliateId !== 'rewardGateway');
    }

    meerkat.modules.register("simplesBindings", {
        init: init,
        updateSimplesMedicareCoverQuestionPosition: updateSimplesMedicareCoverQuestionPosition,
        toggleLimitedCoverDialogue: toggleLimitedCoverDialogue,
        toggleRebateDialogue: toggleRebateDialogue,
        toggleMoreInfoDialogue: toggleMoreInfoDialogue,
        toggleAffiliateRewardsDialogue: toggleAffiliateRewardsDialogue
    });

})(jQuery);
