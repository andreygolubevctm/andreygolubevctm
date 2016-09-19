;(function($){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        $benefitsCoverType,
        $benefitsForm, //Stores the jQuery object for the main benefits form
        $hiddenFields,
        $hospitalCoverToggles,
        $hospitalCover,
        $allHospitalButtons,
        $defaultCover,
        $hasIconsDiv,
        customiseDialogId = null,
        hospitalBenefits = [],
        extrasBenefits = [];

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

        $coverType.find('input').on('change', toggleBenefits);
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

    function setDefaultCover() {
        healthSitu = $('.health-situation-healthSitu input:checked').val();

        if (meerkat.modules.deviceMediaState.get() === 'xs') {
            if (!$('.hospitalCoverToggles.visible-xs a.benefit-category').hasClass('active')) {
                if(healthSitu === 'ATP') {
                    $('#health_situation_coverType_H').trigger('click');
                    $('.hospitalCoverToggles.visible-xs a.benefit-category[data-category="limited"]').trigger('click');
                } else {
                    $('.hospitalCoverToggles.visible-xs a.benefit-category[data-category="customise"]').trigger('click');
                }
            } else if ($('.hospitalCoverToggles.visible-xs a.benefit-category[data-category="limited"]').hasClass('active')) {
                    $('#health_situation_coverType_H').trigger('click');
            }
        } else {
            if (!$('.hospitalCoverToggles.hidden-xs a.benefit-category').hasClass('active')) {
                if(healthSitu === 'ATP') {
                    $('#health_situation_coverType_H').trigger('click');
                    $('.hospitalCoverToggles.hidden-xs a.benefit-category[data-category="limited"]').trigger('click');
                } else {
                    $('.hospitalCoverToggles.hidden-xs a.benefit-category[data-category="customise"]').trigger('click');
                }
            } else if ($('.hospitalCoverToggles.hidden-xs a.benefit-category[data-category="limited"]').hasClass('active')) {
                    $('#health_situation_coverType_H').trigger('click');
            }
        }
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

    function resetDefaultCover() {
        $('.hospitalCoverToggles.' + (meerkat.modules.deviceMediaState.get() === 'xs' ? 'visible-xs' : 'hidden-xs') + ' a.benefit-category.active').trigger('click');
    }

    function toggleBenefits() {
        // TODO Temporarily re-enabling until toggle buttons are in
        //var $hospitalSection = $('.Hospital-wrapper'),
        //     $extrasSection = $('.GeneralHealth-wrapper'),
        var $hospitalSection = $('.Hospital_container').closest('fieldset'),
            $extrasSection = $('.GeneralHealth_container .children').closest('fieldset');
            $hospitalText = $('.tieredHospitalCover .hospitalCover .title'),
            $extrasText = $('.tieredHospitalCover .extrasCover .title'),
            $helpText = $('.benefits-help');

            hospitalContent = '';
            hospitalDisabledContent = '';
            extrasContent = '';
            extrasDisabledContent = '';
            helpContent = '';

            healthCvr = $('#health_situation_healthCvr').val();
            healthSitu = $('.health-situation-healthSitu input:checked').val();
            healthSituText = $('.health-situation-healthSitu input:checked').parent().text();

            primary_dob = $('#health_healthCover_primary_dob').val();
            age = meerkat.modules.age.returnAge(primary_dob, true);

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
                extrasDisabledContent = meerkat.site.content.extrasLimitedDisabled;
                helpContent = meerkat.site.content.hospitalLimitedHelp;

        }

        switch (coverType) {
            case 'c':
                $hospitalSection.slideDown();
                $extrasSection.slideDown();
                setDefaultCover();
                break;
            case 'h':
                $hospitalSection.slideDown();
                $extrasSection.slideUp();
                resetDefaultCover();

                extrasContent = extrasDisabledContent;
                break;
            case 'e':
                $hospitalSection.slideUp();
                $extrasSection.slideDown();
                resetDefaultCover();

                hospitalContent = hospitalDisabledContent;
                break;
            default:
                $hospitalSection.slideUp();
                $extrasSection.slideUp();
                $hospitalCoverToggles.prop("checked", false);
                $allHospitalButtons.prop('checked', false).prop('disabled', false);
                $extrasSection.find('input[type="checkbox"]').prop('checked', false);
                break;
        }

        $hospitalText.html(hospitalContent);
        $extrasText.html(extrasContent);
        $helpText.html(helpContent);
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

        // For preload
        toggleBenefits();
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
        var currentCover = 'customise',
            previousCover = 'customise',
            // TODO Temporarily re-enabling until toggle buttons are in
            //$hospitalBenefitsSection = $('.Hospital-wrapper'),
            //$extrasBenefitSection = $('.GeneralHealth-wrapper'),
            $hospitalBenefitsSection = $('.Hospital_container .children'),
            $extrasBenefitsSection = $('.GeneralHealth_container .children').closest('fieldset'),
            $benefitsCoverType = $('#health_benefits_covertype'),
            $limitedCoverHidden = $hiddenFields.find("input[name='health_situation_accidentOnlyCover']");

        $hospitalCoverToggles.on('click', function toggleHospitalCover() {
            var $item = $(this);
            currentCover = $item.data('category');

            var healthCvr = $('.health-situation-healthCvr').val();
            var healthSitu = $('.health-situation-healthSitu input:checked').val();
            var primary_dob = $('#health_healthCover_primary_dob').val();
            var age = meerkat.modules.age.returnAge(primary_dob, true);

            // set the active  (not using $this here to addClass due to we have another sets of link for mobile...)
            $hospitalCoverToggles.removeClass('active').filter('[data-category="' + currentCover + '"]').addClass('active');

            // set the hidden field
            $benefitsCoverType.val(currentCover);
            $limitedCoverHidden.val('N');

            // uncheck all tickboxes
            $allHospitalButtons.prop('disabled', false).prop('checked', false);
            $extrasSection = $('.GeneralHealth_container .children').find('input[type="checkbox"]');
            $extrasSection.prop('disabled', false).prop('checked', false);

            if(healthSitu !== 'ATP') {
                 $('.HLTicon-general-dental').addClass('customise');
            }

            $('.HLTicon-birth-related, .HLTicon-assisted-reproduction, .HLTicon-heart-surgery, .HLTicon-optical, .HLTicon-physiotherapy').removeClass('customise');

            // New to health Insurance
            if(healthSitu ==='N' && age >= 40) {
                $('.HLTicon-heart-surgery, .HLTicon-optical, .HLTicon-physiotherapy').addClass('customise');
            }

            // Want to Compare
            if(healthSitu ==='LC' && age >= 40) {
                $('.HLTicon-heart-surgery, .HLTicon-optical, .HLTicon-physiotherapy').addClass('customise');
            }

            // Single Male Starting a Family
            if(healthSitu ==='CSF' && healthCvr === 'SM' && age >= 40) {
                $('.HLTicon-heart-surgery, .HLTicon-optical, .HLTicon-physiotherapy').addClass('customise');
            }

            // Single Female Starting a Family
            if(healthSitu ==='CSF' && healthCvr === 'SF') {
                $('.HLTicon-birth-related, .HLTicon-assisted-reproduction').addClass('customise');
                if(age >= 40) {
                    $('.HLTicon-heart-surgery, .HLTicon-optical, .HLTicon-physiotherapy').addClass('customise');
                }
            }

            // Settled Family
            if(healthSitu === 'SF' && age >= 40) {
                $('.HLTicon-heart-surgery, .HLTicon-optical, .HLTicon-physiotherapy').addClass('customise');
            }

            // Specific Health Need
            if(healthSitu === 'SHN' && age >= 40) {
                $('.HLTicon-heart-surgery, .HLTicon-optical, .HLTicon-physiotherapy').addClass('customise');
            }

            switch (currentCover) {
                case 'top':
                    $hospitalBenefitsSection.slideDown();
                    $allHospitalButtons.prop('checked', true);
                    break;
                case 'limited':
                    $hospitalBenefitsSection.slideUp(function () {
                        $(this).prop('checked', false);
                    });
                    $extrasBenefitsSection.slideUp();

                    $limitedCoverHidden.val('');
                    break;
                default:
                    $hospitalBenefitsSection.slideDown();

                    var $hospitalCoverButtons = $hospitalCover.find('.' + currentCover + ' input[type="checkbox"]');
                    var $extrasCoverButtons = $extrasCover.find('.' + currentCover + ' input[type="checkbox"]');
                    $allHospitalButtons.not($hospitalCoverButtons);

                    // setup for customised options to be completed later
                    $hospitalCoverButtons.each(function () {
                        $(this).prop('checked', true);
                    });
                    if(_.indexOf(['e','c'], $coverType.find('input:checked').val().toLowerCase()) >= 0) {
                        $extrasCoverButtons.each(function () {
                            $(this).prop('checked', true);
                        });
                    }
                    break;
            }

            // disable all buttons if customise is not selected
            if (currentCover !== 'customise') {
                $allHospitalButtons.prop('disabled', true).each(function(){
                    var $btn = $(this);
                    $btn.parent().on('click.customisingTHCover', _.bind(customiseCover, $btn));
                });
            } else {
                $allHospitalButtons.each(function(){
                    $(this).parent().off('click.customisingTHCover');
                });
            }

            $hospitalCover.find('.coverExplanation.' + previousCover + 'Cover').addClass('hidden').end().find('.coverExplanation.' + currentCover + 'Cover').removeClass('hidden');
            previousCover = currentCover;
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


    // reset benefits for devs when use product title to search
    function resetBenefitsForProductTitleSearch() {
        if (meerkat.site.environment === 'localhost' || meerkat.site.environment === 'nxi' || meerkat.site.environment === 'nxs' || meerkat.site.environment === 'nxq') {
            if ($.trim($('#health_productTitleSearch').val()) !== '') {
                resetBenefitsSelection(true);
                $('#health_situation_coverType_C').trigger('click');
                $('.hospitalCoverToggles a.benefit-category.active').removeClass("active");
                setDefaultCover();
            }
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
        toggleBenefits: toggleBenefits,
        setDefaultCover: setDefaultCover,
        enableFields: enableFields,
        disableFields: disableFields,
        updateHiddenFields: updateHiddenFields,
        resetBenefitsSelection: resetBenefitsSelection,
        resetBenefitsForProductTitleSearch: resetBenefitsForProductTitleSearch,
        getSelectedBenefits: getSelectedBenefits,
        syncAccidentOnly: syncAccidentOnly,
        populateBenefitsSelection: populateBenefitsSelection,
        getHospitalBenefitsModel: getHospitalBenefitsModel,
        getExtraBenefitsModel: getExtraBenefitsModel,
        flushHiddenBenefits : flushHiddenBenefits
    });

})(jQuery);