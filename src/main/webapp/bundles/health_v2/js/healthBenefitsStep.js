;(function($){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        $coverType,
        $healthSitu,
        $benefitsForm, //Stores the jQuery object for the main benefits form
        $hiddenFields,
        $hospitalCoverToggles,
        $hospitalCover,
        $allHospitalButtons,
        $defaultCover,
        $hasIconsDiv,
        customiseDialogId = null,
        hospitalBenefits = [],
        extrasBenefits = [],
        preselectedBenefitsActivated = false,
        currentCover = false;

    var events = {
            healthBenefitsStep: {
                CHANGED: 'HEALTH_BENEFITS_CHANGED',
                RESET_SWITCH_STATE: 'RESET_SWITCH_STATE' // reset bootstrap switch state.
            }
        },
        moduleEvents = events.healthBenefitsStep;

    function init() {
        $(document).ready(function () {
            if (meerkat.site.pageAction === "confirmation") return false;

            // Store the jQuery objects
            $coverType = $('#health_situation_coverType');
            $healthSitu = $('.health-situation-healthSitu');
            $defaultCover = $('#health_benefits_covertype_customise');
            $benefitsForm = $('#benefitsForm');
            $hiddenFields = $('#mainform').find('.hiddenFields');

            $extrasCover = $('.GeneralHealth_container');
            $hospitalCover = $('.Hospital_container');
            $hospitalCoverToggles = $('.hospitalCoverToggles a'),
                $allHospitalButtons = $hospitalCover.find('.children input[type="checkbox"]'),
                // done this way since it's an a/b test and
                $hasIconsDiv = $('.healthBenefits').find('.hasIcons');

            // setup groupings
            // extras middle row
            var htmlTemplate = _.template($('#extras-mid-row-groupings').html()),
                htmlContent = htmlTemplate();

            $(htmlContent).insertBefore(".HLTicon-physiotherapy");

            // extras last row
            htmlTemplate = _.template($('#extras-last-row-groupings').html()),
                htmlContent = htmlTemplate();

            $(htmlContent).insertBefore(".HLTicon-glucose-monitor");

            if (meerkat.modules.deviceMediaState.get() === 'xs') {
                $hasIconsDiv.removeClass('hasIcons');
            }

            setupPage();
            eventSubscriptions();
        });
    }

    function eventSubscriptions() {

        $coverType.find('input').on('change', toggleCoverType);

        hospitalCoverToggleEvents();

        $(document).on('click', 'a.tieredLearnMore', function showBenefitsLearnMoreModel() {
            showModal();
        });

        // setup icons
        $('.health-situation-healthCvrType').find('label:first-child').addClass("icon-hospital-extras").end().find('label:nth-child(2)').addClass('icon-hospital-only').end().find('label:last-child').addClass('icon-extras-only');

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function resultsXsBreakpointEnter() {
            $hasIconsDiv.removeClass('hasIcons');
        });

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function editDetailsEnterXsState() {
            $hasIconsDiv.addClass('hasIcons');
        });
    }

    function flushHiddenBenefits() {
        var coverType = $coverType.find('input:checked').val().toLowerCase();
        if(coverType === 'e') {
            $allHospitalButtons.each(function() {
            $(this).prop('checked', false).attr('checked', null).prop('disabled', false).change();
        });
        } else if(coverType === 'h') {
            var $extrasSection = $('.GeneralHealth_container .children').closest('fieldset');
            $extrasSection.find('input[type="checkbox"]').each(function() {
            $(this).prop('checked', false).attr('checked', null).change();
        });
        }
    }

    function toggleCoverType() {
        // TODO Temporarily re-enabling until toggle buttons are in
        //var $hospitalSection = $('.Hospital-wrapper'),
        //     $extrasSection = $('.GeneralHealth-wrapper'),
        var $hospitalSection = $('.Hospital_container').closest('fieldset'),
            $extrasSection = $('.GeneralHealth_container .children').closest('fieldset');
        var coverType = $coverType.find('input:checked').val().toLowerCase();
        var isLimited = $limitedCoverHidden.val() === 'Y';
        coverType = isLimited ? 'limited' : coverType;

        switch (coverType) {
            case 'c':
                $hasIconsDiv.show();
                $hospitalSection.slideDown();
                $extrasSection.slideDown();
                break;
            case 'h':
                $hasIconsDiv.show();
                $hospitalSection.slideDown();
                $extrasSection.slideUp();
                break;
            case 'e':
                $hospitalSection.slideUp();
                $extrasSection.slideDown();
                break;
            case 'limited':
                // Ignore - styling handled elsewhere
                break;
            default:
                $hospitalSection.slideUp();
                $extrasSection.slideUp();
                break;
        }
    }

    function applySituationBasedCopy() {

        var $hospitalText = $('.tieredHospitalCover .hospitalCover .title'),
            $extrasText = $('.tieredHospitalCover .extrasCover .title'),
            $helpText = $('.benefits-help');

        var hospitalContent = '',
            hospitalDisabledContent = '',
            extrasContent = '',
            extrasDisabledContent = '',
            helpContent = '';

        var healthSitu = $healthSitu.find('input:checked').val(),
            primary_dob = $('#health_healthCover_primary_dob').val(),
            primary_age = meerkat.modules.age.returnAge(primary_dob, true),
            partner_dob = $('#health_healthCover_partner_dob').val(),
            partner_age = meerkat.modules.age.returnAge(partner_dob, true),
            age = partner_age > primary_age ? partner_age : primary_age;

        $('.situation-wrapper').attr('class','situation-wrapper '+healthSitu);

        var coverType = $coverType.find('input:checked').val().toLowerCase();

        switch(healthSitu) {
            case 'CSF':
                if(age >= 40) {
                    hospitalContent = meerkat.site.content.hospitalFamilyOlder;
                    extrasContent = meerkat.site.content.extrasFamilyOlder;
                } else {
                    hospitalContent = meerkat.site.content.hospitalFamilyYoung;
                    extrasContent = meerkat.site.content.extrasFamilyYoung;
                }

                switch (coverType) {
                    case 'h':
                        helpContent = meerkat.site.content.hospitalFamilyHelp;
                        break;
                    case 'e':
                        helpContent = meerkat.site.content.extrasFamilyHelp;
                        break;
                    default:
                        helpContent = meerkat.site.content.combinedFamilyHelp;
                }

                hospitalDisabledContent = meerkat.site.content.hospitalFamilyDisabled;
                extrasDisabledContent = meerkat.site.content.extrasFamilyDisabled;
                break;
            case 'SF':
                if(age >= 40) {
                    hospitalContent = meerkat.site.content.hospitalSettledFamilyOlder;
                    extrasContent = meerkat.site.content.extrasSettledFamilyOlder;
                } else {
                    hospitalContent = meerkat.site.content.hospitalSettledFamilyYoung;
                    extrasContent = meerkat.site.content.extrasSettledFamilyYoung;
                }

                switch (coverType) {
                    case 'h':
                        helpContent = meerkat.site.content.hospitalSettledFamilyHelp;
                        break;
                    case 'e':
                        helpContent = meerkat.site.content.extrasSettledFamilyHelp;
                        break;
                    default:
                        helpContent = meerkat.site.content.combinedSettledFamilyHelp;
                }

                hospitalDisabledContent = meerkat.site.content.hospitalSettledFamilyDisabled;
                extrasDisabledContent = meerkat.site.content.extrasSettledFamilyDisabled;
                break;
            case 'N':
                if(age >= 40) {
                    hospitalContent = meerkat.site.content.hospitalNewOlder;
                    extrasContent = meerkat.site.content.extrasNewOlder;
                } else {
                    hospitalContent = meerkat.site.content.hospitalNewYoung;
                    extrasContent = meerkat.site.content.extrasNewYoung;
                }

                switch (coverType) {
                    case 'h':
                        helpContent = meerkat.site.content.hospitalNewHelp;
                        break;
                    case 'e':
                        helpContent = meerkat.site.content.extrasNewHelp;
                        break;
                    default:
                        helpContent = meerkat.site.content.combinedNewHelp;
                }

                hospitalDisabledContent = meerkat.site.content.hospitalNewDisabled;
                extrasDisabledContent = meerkat.site.content.extrasNewDisabled;
                break;
            case 'LC':
                if(age >= 40) {
                    hospitalContent = meerkat.site.content.hospitalCompareOlder;
                    extrasContent = meerkat.site.content.extrasCompareOlder;
                } else {
                    hospitalContent = meerkat.site.content.hospitalCompareYoung;
                    extrasContent = meerkat.site.content.extrasCompareYoung;
                }

                switch (coverType) {
                    case 'h':
                        helpContent = meerkat.site.content.hospitalCompareHelp;
                        break;
                    case 'e':
                        helpContent = meerkat.site.content.extrasCompareHelp;
                        break;
                    default:
                        helpContent = meerkat.site.content.combinedCompareHelp;
                }

                hospitalDisabledContent = meerkat.site.content.hospitalCompareDisabled;
                extrasDisabledContent = meerkat.site.content.extrasCompareDisabled;
                break;
            case 'SHN':
                if(age >= 40) {
                    hospitalContent = meerkat.site.content.hospitalSpecificOlder;
                    extrasContent = meerkat.site.content.extrasSpecificOlder;
                } else {
                    hospitalContent = meerkat.site.content.hospitalSpecificYoung;
                    extrasContent = meerkat.site.content.extrasSpecificYoung;
                }

                switch (coverType) {
                    case 'h':
                        helpContent = meerkat.site.content.hospitalSpecificHelp;
                        break;
                    case 'e':
                        helpContent = meerkat.site.content.extrasSpecificHelp;
                        break;
                    default:
                        helpContent = meerkat.site.content.combinedSpecificHelp;
                }

                hospitalDisabledContent = meerkat.site.content.hospitalSpecificDisabled;
                extrasDisabledContent = meerkat.site.content.extrasSpecificDisabled;
                break;

            case 'ATP':
                hospitalContent = meerkat.site.content.hospitalLimitedYoung;
                extrasContent = meerkat.site.content.extrasLimitedDisabled;
                extrasDisabledContent = meerkat.site.content.extrasLimitedDisabled;
                helpContent = meerkat.site.content.hospitalLimitedHelp;

        }

        switch (coverType) {
            case 'h':
                extrasContent = extrasDisabledContent;
                break;
            case 'e':
                hospitalContent = hospitalDisabledContent;
                break;
            default:
                // ignore
                break;
        }

        $hospitalText.html(hospitalContent);
        $extrasText.html(extrasContent);
        $helpText.html(helpContent);
    }

    function activateBenefitPreSelections() {
        if(preselectedBenefitsActivated === true) {
            currentCover = $('#health_benefits_covertype').val();
            if(currentCover !== 'limited') {
                $('.health-situation-healthCvrType').find('input').prop('disabled', false);
                $('.health-situation-healthCvrType').find('label').removeClass('disabled').attr('title', null);
            }
            toggleCoverType();
        } else {
            preselectedBenefitsActivated = true;
            // For loaded transactions we simply want to preselect the
            // the users original choices
            if(meerkat.modules.isNewQuote === false) {
                currentCover = $('#health_benefits_covertype').val();
                $hospitalCoverToggles.removeClass('active').filter('[data-category="' + currentCover + '"]').addClass('active');
                $allHospitalButtons.filter(':checked').change();
                $('.GeneralHealth_container .children').find('input[type="checkbox"]:checked').change();
            // For NEW quotes we want to use preselections based on user situation
            } else {
                currentCover = 'customise';
                $hospitalCoverToggles.removeClass('active').filter('[data-category="' + currentCover + '"]').addClass('active');
                $allHospitalButtons.prop('disabled', false).prop('checked', false);
                $extrasSection = $('.GeneralHealth_container .children').find('input[type="checkbox"]');
                $extrasSection.prop('disabled', false).prop('checked', false);

                var healthCvr = $('.health-situation-healthCvr').val().toLowerCase();
                var healthSitu = $healthSitu.find('input:checked').val().toLowerCase();
                var primary_dob = $('#health_healthCover_primary_dob').val();
                var primary_age = meerkat.modules.age.returnAge(primary_dob, true);
                var partner_dob = $('#health_healthCover_partner_dob').val();
                var partner_age = meerkat.modules.age.returnAge(partner_dob, true);
                var age = partner_age > primary_age ? partner_age : primary_age;

                var $elements = {
                    hospital: {
                        privateHosp: $('#health_benefits_benefitsExtras_PrHospital'),
                        heartSurgery: $('#health_benefits_benefitsExtras_Cardiac'),
                        rehabilitation: $('#health_benefits_benefitsExtras_Rehabilitation'),
                        plasticSurgery: $('#health_benefits_benefitsExtras_PlasticNonCosmetic'),
                        palliative: $('#health_benefits_benefitsExtras_Palliative'),
                        psychiatry: $('#health_benefits_benefitsExtras_Psychiatric'),
                        gastricBanding: $('#health_benefits_benefitsExtras_GastricBanding'),
                        birthServices: $('#health_benefits_benefitsExtras_Obstetric'),
                        assistedReproduction: $('#health_benefits_benefitsExtras_AssistedReproductive'),
                        sterilisation: $('#health_benefits_benefitsExtras_Sterilisation'),
                        jointReplacement: $('#health_benefits_benefitsExtras_JointReplacement'),
                        eyeSurgery: $('#health_benefits_benefitsExtras_CataractEyeLens'),
                        dialysis: $('#health_benefits_benefitsExtras_RenalDialysis'),
                    }, extras: {
                        generalDental: $('#health_benefits_benefitsExtras_DentalGeneral'),
                        majorDental: $('#health_benefits_benefitsExtras_DentalMajor'),
                        endodontic: $('#health_benefits_benefitsExtras_Endodontic'),
                        orthodontic: $('#health_benefits_benefitsExtras_Orthodontic'),
                        optical: $('#health_benefits_benefitsExtras_Optical'),
                        eyeTherapy: $('#health_benefits_benefitsExtras_EyeTherapy'),
                        podiatry: $('#health_benefits_benefitsExtras_Podiatry'),
                        orthotics: $('#health_benefits_benefitsExtras_Orthotics'),
                        physiotherapy: $('#health_benefits_benefitsExtras_Physiotherapy'),
                        speechTherapy: $('#health_benefits_benefitsExtras_SpeechTherapy'),
                        occupationalTherapy: $('#health_benefits_benefitsExtras_OccupationalTherapy'),
                        psychology: $('#health_benefits_benefitsExtras_Psychology'),
                        chiropractic: $('#health_benefits_benefitsExtras_Chiropractic'),
                        remedialMassage: $('#health_benefits_benefitsExtras_Massage'),
                        accupuncture: $('#health_benefits_benefitsExtras_Acupuncture'),
                        naturopathy: $('#health_benefits_benefitsExtras_Naturopath'),
                        glocoseMonitor: $('#health_benefits_benefitsExtras_GlucoseMonitor'),
                        hearingAids: $('#health_benefits_benefitsExtras_HearingAid'),
                        dietetics: $('#health_benefits_benefitsExtras_Dietetics'),
                        lifestyleProducts: $('#health_benefits_benefitsExtras_LifestyleProducts'),
                        pharmaceuticals: $('#health_benefits_benefitsExtras_NonPBS')
                    }
                };

                if (age < 40) {
                    if (_.indexOf(['n', 'lc'], healthSitu) >= 0) {
                        $elements.hospital.privateHosp.prop('checked', true).change();
                        $elements.extras.generalDental.prop('checked', true).change();
                    } else if (healthSitu === 'csf' && healthCvr === 'sm') {
                        $elements.hospital.privateHosp.prop('checked', true).change();
                        $elements.extras.generalDental.prop('checked', true).change();
                    } else if (healthSitu === 'csf' && _.indexOf(['sf', 'c', 'f', 'spf'], healthCvr) >= 0) {
                        $elements.hospital.privateHosp.prop('checked', true).change();
                        $elements.hospital.birthServices.prop('checked', true).change();
                        $elements.hospital.assistedReproduction.prop('checked', true).change();
                        $elements.extras.generalDental.prop('checked', true).change();
                    } else if (healthSitu === 'sf' && _.indexOf(['f', 'spf', 'c'], healthCvr) >= 0) {
                        $elements.hospital.privateHosp.prop('checked', true).change();
                        $elements.extras.generalDental.prop('checked', true).change();
                    } else if (healthSitu === 'atp') {
                        $hospitalCoverToggles.removeClass('active').filter('[data-category="limited"]').addClass('active');
                    } else if (healthSitu === 'shn') {
                        $elements.hospital.privateHosp.prop('checked', true).change();
                        $elements.extras.generalDental.prop('checked', true).change();
                    } else {
                        // Ignore - not defaults defined;
                    }
                } else {
                    if (_.indexOf(['n', 'lc'], healthSitu) >= 0) {
                        $elements.hospital.privateHosp.prop('checked', true).change();
                        $elements.hospital.heartSurgery.prop('checked', true).change();
                        $elements.extras.generalDental.prop('checked', true).change();
                        $elements.extras.optical.prop('checked', true).change();
                        $elements.extras.physiotherapy.prop('checked', true).change();
                    } else if (healthSitu === 'csf' && healthCvr === 'sm') {
                        $elements.hospital.privateHosp.prop('checked', true).change();
                        $elements.hospital.heartSurgery.prop('checked', true).change();
                        $elements.extras.generalDental.prop('checked', true).change();
                        $elements.extras.optical.prop('checked', true).change();
                        $elements.extras.physiotherapy.prop('checked', true).change();
                    } else if (healthSitu === 'csf' && _.indexOf(['sf', 'c', 'f', 'spf'], healthCvr) >= 0) {
                        $elements.hospital.privateHosp.prop('checked', true).change();
                        $elements.hospital.heartSurgery.prop('checked', true).change();
                        $elements.hospital.birthServices.prop('checked', true).change();
                        $elements.hospital.assistedReproduction.prop('checked', true).change();
                        $elements.extras.generalDental.prop('checked', true).change();
                        $elements.extras.optical.prop('checked', true).change();
                        $elements.extras.physiotherapy.prop('checked', true).change();
                    } else if (healthSitu === 'sf' && _.indexOf(['f', 'spf', 'c'], healthCvr) >= 0) {
                        $elements.hospital.privateHosp.prop('checked', true).change();
                        $elements.hospital.heartSurgery.prop('checked', true).change();
                        $elements.extras.generalDental.prop('checked', true).change();
                        $elements.extras.optical.prop('checked', true).change();
                        $elements.extras.physiotherapy.prop('checked', true).change();
                    } else if (healthSitu === 'atp') {
                        currentCover = 'limited';
                        $hospitalCoverToggles.removeClass('active').filter('[data-category="' + currentCover + '"]').addClass('active');
                    } else if (healthSitu === 'shn') {
                        $elements.hospital.privateHosp.prop('checked', true).change();
                        $elements.hospital.heartSurgery.prop('checked', true).change();
                        $elements.extras.generalDental.prop('checked', true).change();
                        $elements.extras.optical.prop('checked', true).change();
                        $elements.extras.physiotherapy.prop('checked', true).change();
                    } else {
                        // Ignore - not defaults defined;
                    }
                }
            }

            $hospitalCover.find('.coverExplanation.' + previousCover + 'Cover').addClass('hidden').end().find('.coverExplanation.' + currentCover + 'Cover').removeClass('hidden');
            previousCover = currentCover;

            applyEnabledDisabledButtonState();
        }
    }

    function unsetAllBenefitSelections() {
        unsetHospitalSelections();
        unsetExtrasSelections();
    }

    function unsetHospitalSelections() {
        $allHospitalButtons.prop('disabled', false).prop('checked', false);
    }

    function unsetExtrasSelections() {
        $extrasSection = $('.GeneralHealth_container .children').find('input[type="checkbox"]');
        $extrasSection.prop('disabled', false).prop('checked', false);
    }

    function applyHospitalCoverTypeSelections() {

        switch (currentCover) {
            case 'top':
                $allHospitalButtons.prop('checked', true);
                break;
            case 'limited':
                unsetAllBenefitSelections();
                break;
            case 'customise':
                // do nothing - retain previous selections
                break;
            default:
                unsetHospitalSelections();
                var $hospitalCoverButtons = $hospitalCover.find('.' + currentCover + ' input[type="checkbox"]');
                $allHospitalButtons.not($hospitalCoverButtons);

                // setup for customised options to be completed later
                $hospitalCoverButtons.each(function () {
                    $(this).prop('checked', true);
                });
                break;
        }

        $hospitalCover.find('.coverExplanation.' + previousCover + 'Cover').addClass('hidden').end().find('.coverExplanation.' + currentCover + 'Cover').removeClass('hidden');
        previousCover = currentCover;

        applyEnabledDisabledButtonState();
    }

    function applyEnabledDisabledButtonState() {
        // disable all buttons if customise is not selected
        if (currentCover !== 'customise') {
            $allHospitalButtons.prop('disabled', true).each(function(){
                var $btn = $(this);
                $btn.parent().on('click.customisingTHCover', _.bind(customiseCover, $btn));
            });
        } else {
            $allHospitalButtons.each(function(){
                $(this).prop('disabled', false);
                $(this).parent().off('click.customisingTHCover');
            });
        }

    }

    function showModal() {
        var htmlTemplate = _.template($('#benefits-explanation').html()),
            htmlContent = htmlTemplate(),
            modalName = 'benefits-learn-more';

        var modalId = meerkat.modules.dialogs.show({
            htmlContent: '<div class="' + modalName + '-wrapper"></div>',
            hashId: modalName,
            className: modalName,
            closeOnHashChange: true,
            onOpen: function (modalId) {
                var $benefitsLearnMore = $('.' + modalName + '-wrapper', $('#' + modalId));
                $benefitsLearnMore.html(htmlContent).show();
            }
        });
        return modalId;
    }

    function setupPage() {
        $benefitsForm.find('.hasShortlistableChildren').each(function () {
            var $this = $(this);

            // fix positioning of label and help
            $this.find('.category[class*="CTM-"] label, .hasIcons .category[class*="HLTicon-"] label').each(function () {
                var $el = $(this),
                    labelTxt = $("<span/>").addClass('iconLabel').append($.trim($el.text().replace('Need Help?', ''))),
                    helpLnk = $el.find('a').detach();
                $el.empty().append(helpLnk).append("<br>").append(labelTxt);
            });

            // Set benefits model
            hospitalBenefits = getBenefitsModelFromPage($benefitsForm.find('.hospitalCover'));
            extrasBenefits = getBenefitsModelFromPage($benefitsForm.find('.extrasCover'));
        });
    }

    function getBenefitsModelFromPage($container) {
        var benefits = [];
        $container.find('.short-list-item').each(function () {
            var benefit = {},
                $this = $(this);
            benefit.value = $this.find('input[type="checkbox"]').attr('id').replace('health_benefits_benefitsExtras_', '');
            benefit.label = $this.find('.iconLabel').text() || $.trim($this.find('label')[0].firstChild.nodeValue);
            benefit.helpId = $this.find('.help-icon').data('content').replace('helpid:', '');
            // apparently IE8 doesn't support obj.class as a new property
            benefit['class'] = ($this.hasClass('medium') ? 'medium ' : '') + ($this.hasClass('basic') ? 'basic ' : '') + ($this.hasClass('customise') ? 'customise ' : '');
            benefits.push(benefit);
        });
        return benefits;
    }

    function getHospitalBenefitsModel(){
        return hospitalBenefits;
    }

    function getExtraBenefitsModel(){
        return extrasBenefits;
    }

    function hospitalCoverToggleEvents() {
        currentCover = 'customise',
            previousCover = 'customise',
            // TODO Temporarily re-enabling until toggle buttons are in
            //$hospitalBenefitsSection = $('.Hospital-wrapper'),
            //$extrasBenefitSection = $('.GeneralHealth-wrapper'),
            $hospitalSection = $('.Hospital_container').closest('fieldset'),
            $hospitalBenefitsSection = $('.Hospital_container .children'),
            $extrasBenefitsSection = $('.GeneralHealth_container .children').closest('fieldset'),
            $benefitsCoverType = $('#health_benefits_covertype'),
            $limitedCoverHidden = $hiddenFields.find("input[name='health_situation_accidentOnlyCover']");

        $hospitalCoverToggles.on('click', function toggleHospitalCover() {
            var $item = $(this);
            currentCover = $item.data('category');

            // set the active  (not using $this here to addClass due to we have another sets of link for mobile...)
            $hospitalCoverToggles.removeClass('active').filter('[data-category="' + currentCover + '"]').addClass('active');

            // set the hidden field
            $benefitsCoverType.val(currentCover);
            $limitedCoverHidden.val('N');

            if(currentCover === 'limited') {
                $extrasBenefitsSection.slideUp('fast',function(){
                    $hasIconsDiv.slideUp();
                });
                $limitedCoverHidden.val('Y');
                $('#health_situation_coverType_H').prop('checked',true).change();
                $('.health-situation-healthCvrType').find('input').prop('disabled',true);
                $('.health-situation-healthCvrType').find('label').not('.icon-hospital-only').addClass('disabled').attr("title", "Not available for Limited cover");
            } else {
                $('.health-situation-healthCvrType').find('input').prop('disabled',false);
                $('.health-situation-healthCvrType').find('label').removeClass('disabled').attr('title',null);
                toggleCoverType();
            }

            applyHospitalCoverTypeSelections();
        });
    }

    function disableFields() {
        if ($hospitalCoverToggles.filter('.active').data('category') !== 'customise') {
            $allHospitalButtons.prop('disabled', true);
        }
    }

    function enableFields() {
        $allHospitalButtons.prop('disabled', false);
    }

    function updateHiddenFields(coverType) {
        var $hiddenHospitalCover = $hiddenFields.find('input[name="health_benefits_benefitsExtras_Hospital"]'),
            $hiddenExtraCover = $hiddenFields.find('input[name="health_benefits_benefitsExtras_GeneralHealth"]');

        switch (coverType) {
            case 'C':
                $hiddenHospitalCover.val('Y');
                $hiddenExtraCover.val('Y');
                break;
            case 'H':
                $hiddenHospitalCover.val('Y');
                $hiddenExtraCover.val('');
                break;
            case 'E':
                $hiddenHospitalCover.val('');
                $hiddenExtraCover.val('Y');
                break;
        }
    }

    /*
     * All below functions are moved from original healthBenefits.js (drop down version)
     * */

    function resetBenefitsSelection(includeHidden) {
        $benefitsForm.find("input[type='checkbox']").prop('checked', false);
        if(includeHidden === true){
            $hiddenFields.find(".benefit-item").val('');
        }
    }

    function populateBenefitsSelection(checkedBenefits) {
        resetBenefitsSelection(false);
        for (var i = 0; i < checkedBenefits.length; i++) {
            var path = checkedBenefits[i];
            $benefitsForm.find("input[name='health_benefits_benefitsExtras_" + path + "']").prop('checked', true).prop('disabled', false);
        }
    }

    function syncAccidentOnly() {
        var $limitedCoverHidden = $hiddenFields.find("input[name='health_situation_accidentOnlyCover']");

        if ($('#accidentCover').is(":checked")) {
            $limitedCoverHidden.val("");
        } else {
            $limitedCoverHidden.val("N");
        }
    }

    // Get the selected benefits from the forms hidden fields (the source of truth! - not the checkboxes)
    function getSelectedBenefits() {

        var benefits = [];

        // hidden fields, 2 only, Hospital and GeneralHealth
        $("#mainform input.benefit-item").each(function (index, element) {
            var $element = $(element);
            if ($element.val() == 'Y') {
                var key = $element.attr('data-skey');
                benefits.push(key);
            }
        });

        // other benefits
        $('#benefitsForm').find("input[type='checkbox']").each(function (index, element) {
            var $element = $(element);
            if ($element.is(':checked')) {
                var key = $element.attr('name').replace('health_benefits_benefitsExtras_', '');
                benefits.push(key);
            }
        });

        return benefits;

    }

    function customiseCover(event) {
        if(!$(event.target).is('a')) { // Allow help icon to work as normal
            event.preventDefault();
            var preselectedBtn = this;
            meerkat.modules.dialogs.close(customiseDialogId);
            customiseDialogId = meerkat.modules.dialogs.show({
                className: "customiseTHCover-modal",
                onOpen: function (modalId) {
                    // update with the text within the cover type dropdown
                    var htmlContent = $('#customise-cover-template').html(),
                        $modal = $('#' + modalId);
                    meerkat.modules.dialogs.changeContent(modalId, htmlContent); // update the content

                    // tweak the sizing to fit the content
                    $modal.find('.modal-body').outerHeight($('#' + modalId).find('.modal-body').outerHeight() - 20);
                    $modal.find('.modal-footer').outerHeight($('#' + modalId).find('.modal-footer').outerHeight() + 20);

                    // Add listeners for buttons
                    var noEvent = 'click.customiseTHCoverNO',
                        yesEvent = 'click.customiseTHCoverYES';
                    $modal.find('.customerCover-no button').off(noEvent).on(noEvent, _.bind(meerkat.modules.dialogs.close, this, modalId));
                    $modal.find('.customerCover-yes button').off(yesEvent).on(yesEvent, _.bind(onCustomiseCover, this, {
                        modalId: modalId,
                        btn: preselectedBtn
                    }));
                },
                buttons: []
            });
            return false;
        } else {
            // Must be help icon so allow to proceed unhindered
        }
    }

    function onCustomiseCover(obj) {
        meerkat.modules.dialogs.close(obj.modalId);
        $benefitsForm.find("a[data-category=customise]:visible").first().trigger('click');
        obj.btn.trigger('click');
    }

    meerkat.modules.register('healthBenefitsStep', {
        init: init,
        events: events,
        toggleCoverType: toggleCoverType,
        enableFields: enableFields,
        disableFields: disableFields,
        updateHiddenFields: updateHiddenFields,
        getSelectedBenefits: getSelectedBenefits,
        syncAccidentOnly: syncAccidentOnly,
        populateBenefitsSelection: populateBenefitsSelection,
        getHospitalBenefitsModel: getHospitalBenefitsModel,
        getExtraBenefitsModel: getExtraBenefitsModel,
        flushHiddenBenefits : flushHiddenBenefits,
        applySituationBasedCopy : applySituationBasedCopy,
        activateBenefitPreSelections : activateBenefitPreSelections
    });

})(jQuery);