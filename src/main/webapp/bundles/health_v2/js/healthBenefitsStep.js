;(function($){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        $coverType,
        $healthSitu,
        $benefitsForm, //Stores the jQuery object for the main benefits form
        $hiddenFields,
        $limitedCoverHidden,
        $hospitalCoverToggles,
        $hospitalCover,
        $allHospitalButtons,
        $hospitalCoverWrapper,
        $hospitalCoverBenefits,
        $extrasCoverWrapper,
        $extrasCoverBenefits,
        $defaultCover,
        $hasIconsDiv,
        $hospitalCoverTogglesWrapper,
        $benefitCheckbox,
        $hospitalCoverIconsWrapper,
        $benefitsCoverType,
        $primary_dob,
        $partner_dob,
        customiseDialogId = null,
        hospitalBenefits = [],
        extrasBenefits = [],
        currentCover = false,
        previousCover = false,
        currentSituation = false,
        currentAge = false, // Is the max age if partner exists
        currentFamilyType = false;

    var ALT_JOURNEY_ACTIVE = false;

    var events = {
            healthBenefitsStep: {
                CHANGED: 'HEALTH_BENEFITS_CHANGED'
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
            $limitedCoverHidden = $hiddenFields.find("input[name='health_situation_accidentOnlyCover']");
            $extrasCoverWrapper = $('.GeneralHealth_container').closest('fieldset');
            $extrasCoverBenefits = $extrasCoverWrapper.find('.children');
            $hospitalCover = $('.Hospital_container');
            $hospitalCoverWrapper = $hospitalCover.closest('fieldset');
            $hospitalCoverBenefits = $hospitalCoverWrapper.find('.children');
            $hospitalCoverTogglesWrapper = $('.hospitalCoverToggles');
            $hospitalCoverToggles = $hospitalCoverTogglesWrapper.find('a');
            $allHospitalButtons = $hospitalCover.find('.children input[type="checkbox"]');
            // done this way since it's an a/b test and
            $hasIconsDiv = $('.healthBenefits').find('.hasIcons');
            $hospitalCoverIconsWrapper = $benefitsForm.find('fieldset.tieredHospitalCover .hospitalCover').closest('fieldset');
            $benefitsCoverType = $('#health_benefits_covertype');
            $primary_dob = $('#health_healthCover_primary_dob');
            $partner_dob = $('#health_healthCover_partner_dob');

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

            $benefitCheckbox = {
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
                    dialysis: $('#health_benefits_benefitsExtras_RenalDialysis')
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

            setupPage();
            eventSubscriptions();

            _.defer(function(){
                // Helper to turn on alt view if param in querystring
                if(/[?&]showAltBenefitsJourney=/.test(window.location.href)) {
                    toggleJourney(true);
                }
            });
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
        var coverType = $coverType.find('input:checked').val().toLowerCase();

        switch (coverType) {
            case 'c':
                $hospitalCoverWrapper.slideDown();
                $extrasCoverWrapper.slideDown();
                break;
            case 'h':
                $hospitalCoverWrapper.slideDown();
                $extrasCoverWrapper.slideUp();
                break;
            case 'e':
                $hospitalCoverWrapper.slideUp();
                $extrasCoverWrapper.slideDown();
                break;
            default:
                // Ignore - nothing to do
                break;
        }
    }

    function applySituationBasedCopy(customLimitedCopy) {
        customLimitedCopy = customLimitedCopy || false;

        var $hospitalText = $('.tieredHospitalCover .hospitalCover .title'),
            $extrasText = $('.tieredHospitalCover .extrasCover .title'),
            $helpText = $('.benefits-help');

        var $limitedBtn = $hospitalText.find('.hospitalCoverToggles').detach();

        var hospitalContent = '',
            hospitalDisabledContent = '',
            extrasContent = '',
            extrasDisabledContent = '',
            helpContent = '';

        var healthSitu = $healthSitu.find('input:checked').val(),
            situation = meerkat.modules.healthAboutYou.getSituation();

        $('.situation-wrapper').attr('class','situation-wrapper '+healthSitu);

        var coverType = $coverType.find('input:checked').val().toLowerCase();

        var age = getAge();

        switch(healthSitu) {
            case 'CSF':
                if(situation === 'SM') {
                    hospitalContent = meerkat.site.content.hospitalCompareSpecialA;
                    extrasContent = meerkat.site.content.extrasCompareSpecialA;
                } else {
                    if (age >= 40) {
                        hospitalContent = meerkat.site.content.hospitalFamilyOlder;
                        extrasContent = meerkat.site.content.extrasFamilyOlder;
                    } else {
                        hospitalContent = meerkat.site.content.hospitalFamilyYoung;
                        extrasContent = meerkat.site.content.extrasFamilyYoung;
                    }
                }

                if(_.indexOf(['SM','SF','C'],situation) >= 0) {
                    hospitalContent = hospitalContent.replace('growing', 'starting');
                    extrasContent = extrasContent.replace('growing', 'starting');
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
                var isSingleMale = situation === 'SM';
                var isSingleCouple = _.indexOf(['SM', 'SF', 'C'], situation) >= 0;
                var isFamOrSPF = _.indexOf(['F','SPF'], situation) >= 0;
                if (age >= 40) {
                    hospitalContent = meerkat.site.content.hospitalSettledFamilyOlder;
                    extrasContent = meerkat.site.content[isSingleCouple ? 'extrasSettledFamilyOlderSingleCouple' : 'extrasSettledFamilyOlder'];
                } else {
                    hospitalContent = meerkat.site.content.hospitalSettledFamilyYoung;
                    extrasContent = meerkat.site.content[isSingleCouple ? 'extrasSettledFamilyYoungSingleCouple' : 'extrasSettledFamilyYoung'];
                }
                if(isSingleMale) {
                    hospitalContent = hospitalContent.replace(/<p>(.)+<\/p>/, meerkat.site.content.hospitalCompareSpecialB);
                }
                if(isFamOrSPF) {
                    extrasContent = extrasContent.replace(/<p>(.)+<\/p>/, meerkat.site.content.extrasCompareSpecialB);
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
                if(customLimitedCopy === true) {
                    hospitalContent = meerkat.site.content.hospitalCompareSpecialA;
                    extrasContent = meerkat.site.content.extrasCompareSpecialA;
                    extrasDisabledContent = meerkat.site.content.extrasCompareSpecialA;
                } else {
                    hospitalContent = meerkat.site.content[isAltJourney() ? 'hospitalLimitedAllALT' : 'hospitalLimitedAll'];
                    extrasContent = meerkat.site.content.extrasLimitedAll;
                    extrasDisabledContent = meerkat.site.content.extrasLimitedAll;
                }
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

        $limitedBtn.insertAfter($hospitalText.find('h2'));
    }

    function activateBenefitPreSelections(isFromStart) {
        isFromStart = isFromStart || false;
        var familyType = $('.health-situation-healthCvr').val().toLowerCase();
        var situ = $healthSitu.find('input:checked').val().toLowerCase();
        var age = getAge();
        var isNewSituation = situ !== currentSituation || familyType !== currentFamilyType || age !== currentAge;
        if(isNewSituation) {
            currentFamilyType = familyType;
            currentSituation = situ;
            currentAge = age;
        }

        if(!isFromStart || (isFromStart && !isNewSituation)) {
            updateCoverLevel();
            toggleCoverType();
            setLimitedCover(false);
        } else {
            if(meerkat.site.isNewQuote === false) {
                // For loaded transactions we simply want to
                // preselect the the users original choices
                currentCover = $benefitsCoverType.val();
                updateCoverLevel();
                toggleCoverType();
                setLimitedCover(false);
                $allHospitalButtons.filter(':checked').change();
                $('.GeneralHealth_container .children').find('input[type="checkbox"]:checked').change();
            } else {
                // For NEW quotes we want to use preselections
                // based on user situation
                currentCover = 'customise';
                updateCoverLevel();
                unsetAllBenefitSelections();
                $coverType.find('#health_situation_coverType_C').prop('checked',true).change();

                if (currentAge < 40) {
                    if (_.indexOf(['n', 'lc'], currentSituation) >= 0) {
                        $benefitCheckbox.hospital.privateHosp.prop('checked', true).change();
                        $benefitCheckbox.extras.generalDental.prop('checked', true).change();
                    } else if (currentSituation === 'csf' && currentFamilyType === 'sm') {
                        $benefitCheckbox.hospital.privateHosp.prop('checked', true).change();
                        $benefitCheckbox.extras.generalDental.prop('checked', true).change();
                    } else if (currentSituation === 'csf' && _.indexOf(['sf', 'c', 'f', 'spf'], currentFamilyType) >= 0) {
                        $benefitCheckbox.hospital.privateHosp.prop('checked', true).change();
                        $benefitCheckbox.hospital.birthServices.prop('checked', true).change();
                        $benefitCheckbox.hospital.assistedReproduction.prop('checked', true).change();
                        $benefitCheckbox.extras.generalDental.prop('checked', true).change();
                    } else if (currentSituation === 'sf') {
                        $benefitCheckbox.hospital.privateHosp.prop('checked', true).change();
                        $benefitCheckbox.extras.generalDental.prop('checked', true).change();
                    } else if (currentSituation === 'atp') {
                        currentCover = 'limited';
                        updateCoverLevel();
                    } else if (currentSituation === 'shn') {
                        $benefitCheckbox.hospital.privateHosp.prop('checked', true).change();
                        $benefitCheckbox.extras.generalDental.prop('checked', true).change();
                    } else {
                        $benefitCheckbox.hospital.privateHosp.prop('checked', true).change();
                        $benefitCheckbox.extras.generalDental.prop('checked', true).change();
                    }
                } else {
                    if (_.indexOf(['n', 'lc'], currentSituation) >= 0) {
                        $benefitCheckbox.hospital.privateHosp.prop('checked', true).change();
                        $benefitCheckbox.hospital.heartSurgery.prop('checked', true).change();
                        $benefitCheckbox.extras.generalDental.prop('checked', true).change();
                        $benefitCheckbox.extras.optical.prop('checked', true).change();
                        $benefitCheckbox.extras.physiotherapy.prop('checked', true).change();
                    } else if (currentSituation === 'csf' && currentFamilyType === 'sm') {
                        $benefitCheckbox.hospital.privateHosp.prop('checked', true).change();
                        $benefitCheckbox.hospital.heartSurgery.prop('checked', true).change();
                        $benefitCheckbox.extras.generalDental.prop('checked', true).change();
                        $benefitCheckbox.extras.optical.prop('checked', true).change();
                        $benefitCheckbox.extras.physiotherapy.prop('checked', true).change();
                    } else if (currentSituation === 'csf' && _.indexOf(['sf', 'c', 'f', 'spf'], currentFamilyType) >= 0) {
                        $benefitCheckbox.hospital.privateHosp.prop('checked', true).change();
                        $benefitCheckbox.hospital.heartSurgery.prop('checked', true).change();
                        $benefitCheckbox.hospital.birthServices.prop('checked', true).change();
                        $benefitCheckbox.hospital.assistedReproduction.prop('checked', true).change();
                        $benefitCheckbox.extras.generalDental.prop('checked', true).change();
                        $benefitCheckbox.extras.optical.prop('checked', true).change();
                        $benefitCheckbox.extras.physiotherapy.prop('checked', true).change();
                    } else if (currentSituation === 'sf') {
                        $benefitCheckbox.hospital.privateHosp.prop('checked', true).change();
                        $benefitCheckbox.hospital.heartSurgery.prop('checked', true).change();
                        $benefitCheckbox.extras.generalDental.prop('checked', true).change();
                        $benefitCheckbox.extras.optical.prop('checked', true).change();
                        $benefitCheckbox.extras.physiotherapy.prop('checked', true).change();
                    } else if (currentSituation === 'atp') {
                        currentCover = 'limited';
                        updateCoverLevel();
                    } else if (currentSituation === 'shn') {
                        $benefitCheckbox.hospital.privateHosp.prop('checked', true).change();
                        $benefitCheckbox.hospital.heartSurgery.prop('checked', true).change();
                        $benefitCheckbox.extras.generalDental.prop('checked', true).change();
                        $benefitCheckbox.extras.optical.prop('checked', true).change();
                        $benefitCheckbox.extras.physiotherapy.prop('checked', true).change();
                    } else {
                        $benefitCheckbox.hospital.privateHosp.prop('checked', true).change();
                        $benefitCheckbox.extras.generalDental.prop('checked', true).change();
                    }
                }
            }

            setLimitedCover(true);

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

        if(previousCover === "limited" && currentCover !== "limited") {
            applySituationBasedCopy(true);
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
        currentCover = 'customise';
        previousCover = 'customise';

        $hospitalCoverToggles.on('click', function toggleHospitalCover() {
            var $item = $(this);
            currentCover = $item.data('category');

            // set the active  (not using $this here to addClass due to we have another sets of link for mobile...)
            updateCoverLevel();

            setLimitedCover(true);

            applyHospitalCoverTypeSelections();
        });
    }

    function updateCoverLevel() {
        $hospitalCoverToggles.removeClass('active').filter('[data-category="' + currentCover + '"]').addClass('active');
        $('#health_filterBar_coverLevel').val(currentCover); // select the new cover level
        $benefitsCoverType.val(currentCover);
    }

    /**
     * Updates page when limited cover selected. hideExtras is only provided
     * as TRUE when
     * @param hideExtras
     */
    function setLimitedCover(hideExtras) {
        hideExtras = hideExtras || false;
        if(currentCover === 'limited') {
            $hospitalCoverBenefits.slideUp();
            if(!isAltJourney()) {
                if (hideExtras === true) {
                    $('#health_situation_coverType_H').prop('checked', true).change();
                    $extrasCoverWrapper.slideUp();
                } else {
                    $extrasCoverBenefits.slideDown();
                }
            } else {
                $hospitalCoverTogglesWrapper.addClass('limited');
                $hospitalCoverTogglesWrapper.removeClass('customise');
            }
            $limitedCoverHidden.val('Y');
            $hospitalCoverIconsWrapper.toggleClass('hidden-xs',meerkat.modules.deviceMediaState.get() === 'xs');
        } else {
            $limitedCoverHidden.val('N');
            $hospitalCoverBenefits.slideDown();
            $extrasCoverBenefits.slideDown();
            if(isAltJourney()) {
                $hospitalCoverTogglesWrapper.addClass('customise');
                $hospitalCoverTogglesWrapper.removeClass('limited');
            }
            toggleCoverType();
            $hospitalCoverIconsWrapper.removeClass('hidden-xs');
        }
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
        $benefitsForm.find("input[type='checkbox'][name^='health_benefits']").prop('checked', false).attr('data-visible', "false");
        if(includeHidden === true){
            $hiddenFields.find(".benefit-item").val('');
        }
    }

    function populateBenefitsSelection(checkedBenefits) {
        resetBenefitsSelection(false);
        for (var i = 0; i < checkedBenefits.length; i++) {
            var path = checkedBenefits[i];
            $benefitsForm.find("input[name='health_benefits_benefitsExtras_" + path + "']").prop('checked', true).prop('disabled', false).attr('data-visible', "true");
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
        $('#benefitsForm').find("input[type='checkbox'][name^='health_benefits']").each(function (index, element) {
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

    function getAge() {
        var primary_age = meerkat.modules.age.returnAge($primary_dob.val(), true),
            partner_age = meerkat.modules.age.returnAge($partner_dob.val(), true);
        return partner_age > primary_age ? partner_age : primary_age;
    }

    function isAltJourney() {
        return ALT_JOURNEY_ACTIVE;
    }

    function toggleJourney(altActive) {
        altActive = altActive || false;
        ALT_JOURNEY_ACTIVE = altActive === true;
        $benefitsForm.toggleClass('altBenefitsJourney',ALT_JOURNEY_ACTIVE);
        setLimitedCover();
    }

    meerkat.modules.register('healthBenefitsStep', {
        init: init,
        events: events,
        toggleCoverType: toggleCoverType,
        enableFields: enableFields,
        disableFields: disableFields,
        updateHiddenFields: updateHiddenFields,
        getSelectedBenefits: getSelectedBenefits,
        populateBenefitsSelection: populateBenefitsSelection,
        getHospitalBenefitsModel: getHospitalBenefitsModel,
        getExtraBenefitsModel: getExtraBenefitsModel,
        flushHiddenBenefits : flushHiddenBenefits,
        applySituationBasedCopy : applySituationBasedCopy,
        activateBenefitPreSelections : activateBenefitPreSelections,
        toggleJourney : toggleJourney
    });

})(jQuery);