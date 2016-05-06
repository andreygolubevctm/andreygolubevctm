;(function($){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        $coverType,  //Stores the jQuery object for cover type select field in situation page
        $benefitsForm, //Stores the jQuery object for the main benefits form
        $hiddenFields,
        $hospitalCoverToggles,
        $hospitalCover,
        $allHospitalButtons,
        $defaultCover,
        $hasIconsDiv,
        changedByCallCentre = false,
        customiseDialogId = null,
        hospitalBenefits = [],
        extrasBenefits = [];

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
            $defaultCover = $('#health_benefits_covertype_customise');
            $benefitsForm = $('#benefitsForm');
            $hiddenFields = $('#mainform').find('.hiddenFields');

            $hospitalCover = $('.Hospital_container');
            $hospitalCoverToggles = $('.hospitalCoverToggles a'),
                $allHospitalButtons = $hospitalCover.find('input[type="checkbox"]'),
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

            // preselect hospital extras and hospital medium
            $('#health_situation_coverType_C').trigger('click');

            setupPage();
            eventSubscriptions();
        });
    }

    function eventSubscriptions() {

        $benefitsForm.find('.CTM-plus label').on('click', function () {
            showMoreBenefits();
        });

        $benefitsForm.find('.benefits-side-bar .btn-edit').on('click', function () {
            $coverType.val('C').change();
        });

        // align titles when breakpoint changes
        meerkat.messaging.subscribe(meerkat.modules.events.device.STATE_CHANGE, function breakpointChanged(states) {
            if (meerkat.modules.journeyEngine.getCurrentStep().navigationId === "benefits") {
                alignTitle();
            }
        });

        toggleBenefits();
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
        if (meerkat.modules.deviceMediaState.get() === 'xs') {
            if (!$('.hospitalCoverToggles.visible-xs a.benefit-category').hasClass('active')) {
                $('.hospitalCoverToggles.visible-xs a.benefit-category[data-category="medium"]').trigger('click');
            }
        } else {

            if (!$('.hospitalCoverToggles.hidden-xs a.benefit-category').hasClass('active')) {
                $('.hospitalCoverToggles.hidden-xs a.benefit-category[data-category="medium"]').trigger('click');
            }
        }
    }

    function toggleBenefits() {
        var $hospitalSection = $('.Hospital_container').closest('fieldset'),
            $extrasSection = $('.GeneralHealth_container .children').closest('fieldset');
        $coverType.find('input').on('click', function selectCoverType() {
            switch ($(this).val().toLowerCase()) {
                case 'c':
                    $hospitalSection.slideDown();
                    $extrasSection.slideDown();
                    setDefaultCover();
                    break;
                case 'h':
                    $hospitalSection.slideDown();
                    $extrasSection.slideUp();
                    setDefaultCover();

                    $extrasSection.find('input[type="checkbox"]').prop('checked', false);
                    break;
                case 'e':
                    $hospitalSection.slideUp();
                    $extrasSection.slideDown();
                    $hospitalCoverToggles.prop("checked", false);
                    $allHospitalButtons.prop('checked', false).prop('disabled', false);
                    break;
                default:
                    $hospitalSection.slideUp();
                    $extrasSection.slideUp();
                    $hospitalCoverToggles.prop("checked", false);
                    $allHospitalButtons.prop('checked', false).prop('disabled', false);
                    $extrasSection.find('input[type="checkbox"]').prop('checked', false);
                    break;
            }
        });
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

            $this.find('.category[class*="CTMNoIcon"]').each(function () {
                var newClass = $(this).attr('class').replace('CTMNoIcon', 'CTM');
                $(this).removeClass().addClass(newClass);
            });

            // fix positioning of label and help
            $this.find('.category[class*="CTM-"] label, .hasIcons .category[class*="HLTicon-"] label').each(function () {
                $el = $(this);
                var labelTxt = $("<span/>").addClass('iconLabel').append($.trim($el.text().replace('Need Help?', '')));
                var helpLnk = $el.find('a').detach();
                $el.empty().append(helpLnk).append("<br>").append(labelTxt);
            });

            // Move the subtitle
            $this.find('.subTitle').insertAfter($this.find('.hasIcons'));

            // Set benefits model
            hospitalBenefits = getBenefitsModelFromPage($benefitsForm.find('.hospitalCover'));
            extrasBenefits = getBenefitsModelFromPage($benefitsForm.find('.extrasCover'));
        });

        // For loading in, update benefits page layout. letting this default to '' for tiered benefits
        changeLayoutByCoverType($coverType.val());
    }

    function getBenefitsModelFromPage($container) {
        var benefits = [];
        $container.find('.short-list-item').each(function () {
            var benefit = {},
                $this = $(this);
            benefit.value = $this.find('input[type="checkbox"]').attr('id').replace('health_benefits_benefitsExtras_', '');
            benefit.label = $this.find('.iconLabel').text();
            benefit.helpId = $this.find('.help-icon').data('content').replace('helpid:', '');
            benefit.class = ($this.hasClass('medium') ? 'medium ' : '') + ($this.hasClass('basic') ? 'basic ' : '') + ($this.hasClass('customise') ? 'customise ' : '');
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
        var currentCover = 'customised',
            previousCover = 'customised',
            $hospitalBenefitsSection = $('.Hospital_container .children'),
            $coverType = $('#health_benefits_covertype'),
            $limitedCoverHidden = $hiddenFields.find("input[name='health_situation_accidentOnlyCover']");

        $hospitalCoverToggles.on('click', function toggleHospitalCover() {
            var $item = $(this);
            currentCover = $item.data('category');

            // set the active button
            $hospitalCoverToggles.removeClass('active');
            $item.addClass('active');

            // set the hidden field
            $coverType.val(currentCover);
            $limitedCoverHidden.val('');

            // uncheck all tickboxes
            $allHospitalButtons.prop('checked', false).prop('disabled', false);

            switch (currentCover) {
                case 'top':
                    $hospitalBenefitsSection.slideDown();
                    $allHospitalButtons.prop('checked', true);
                    break;
                case 'limited':
                    $hospitalBenefitsSection.slideUp(function () {
                        $(this).prop('checked', false);
                    });

                    $limitedCoverHidden.val('Y');
                    break;
                default:
                    $hospitalBenefitsSection.slideDown();
                    var $coverButtons = $hospitalCover.find('.' + currentCover + ' input[type="checkbox"]');
                    if (currentCover !== 'customised') {
                        $allHospitalButtons.not($coverButtons);
                    } else {
                        var classToSelect = previousCover === 'top' ? '' : '.' + previousCover;
                        $coverButtons = $hospitalCover.find(classToSelect + ' input[type="checkbox"], .customise input[type="checkbox"]');
                    }

                    // setup for customised options to be completed later
                    $coverButtons.each(function () {
                        $(this).prop('checked', true);
                    });
                    break;
            }

            // disable all buttons if customise is not selected
            if (currentCover !== 'customised') {
                $allHospitalButtons.prop('disabled', true).each(function(){
                    $btn = $(this);
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
        if ($hospitalCoverToggles.filter('.active').data('category') !== 'customised') {
            $allHospitalButtons.prop('disabled', true);
        }
    }

    function enableFields() {
        $allHospitalButtons.prop('disabled', false);
    }

    function alignTitle() {
        // only align the title if it is a combined cover and no in mobile breakpoint
        if ($coverType.val() !== 'C' || meerkat.modules.deviceMediaState.get() === 'xs') {
            $benefitsForm.find('.custom-col-lg .title').height('auto');
        } else {
            var targetHeight = $benefitsForm.find('.custom-col-sm .title').height() + 9; // other col's height plus margin
            $benefitsForm.find('.custom-col-lg .title').height(targetHeight);
        }
    }

    function showMoreBenefits() {
        $benefitsForm.find('.CTM-plus').fadeOut('fast');
        $benefitsForm.find('.subTitle').slideDown('fast');
        $benefitsForm.find('.noIcons').slideDown('fast', function () {
            alignSidebarHeight();
        });
    }

    function checkAndHideMoreBenefits() {
        // if any nonIcons benefits selected, do not hide
        if ($benefitsForm.find('.noIcons input:checked').length > 0) return;

        $benefitsForm.find('.subTitle').slideUp('fast');
        $benefitsForm.find('.noIcons').slideUp('fast');
        $benefitsForm.find('.CTM-plus').fadeIn('fast');
    }

    function changeLayoutByCoverType(coverType) {
        var updateSelectedBenefits = function(coverT) {
            if("HE".indexOf(coverT) >= 0) {
                $('.hospitalCoverToggles .benefit-category.active').trigger('click');
            }
        };
        switch (coverType) {
            case 'H':
                updateSelectedBenefits(coverType);
                $benefitsForm.find('.sidebarHospital').fadeOut('fast');
                $benefitsForm.find('.extrasCover').fadeOut('fast');
                $benefitsForm.find('.sidebarExtras').fadeIn('fast');
                $benefitsForm.find('.hospitalCover').removeClass('custom-col-sm').addClass('custom-col-lg').fadeIn('fast', function () {
                    movePageTitleToColumn();
                });
                break;
            case 'E':
                $benefitsForm.find('.sidebarExtras').fadeOut('fast');
                $benefitsForm.find('.hospitalCover').removeClass('custom-col-lg').addClass('custom-col-sm').fadeOut('fast');
                $benefitsForm.find('.sidebarHospital').fadeIn('fast');
                $benefitsForm.find('.extrasCover').fadeIn('fast', function () {
                    movePageTitleToColumn();
                });
                break;
            default:
                updateSelectedBenefits(coverType);
                $benefitsForm.find('.benefits-side-bar').fadeOut('fast');
                $benefitsForm.find('.hasShortlistableChildren').fadeIn('fast', function () {
                    $benefitsForm.find('fieldset > div').first().prepend($benefitsForm.find('.section h2'));
                });
                alignTitle();
        }
    }

    function movePageTitleToColumn() {
        $benefitsForm.find('.custom-col-lg').first().prepend($benefitsForm.find('h2'));
    }

    function updateCoverTypeByBenefitsSelected() {
        // after the re-design we only have two hidden fields for the old yes/no toggle, check these first
        var isHospitalCover = $hiddenFields.find('input[name="health_benefits_benefitsExtras_Hospital"]').val() === 'Y',
            isExtraCover = $hiddenFields.find('input[name="health_benefits_benefitsExtras_GeneralHealth"]').val() === 'Y';

        // In case the above hidden fields are empty, check children benefits as well
        isHospitalCover = isHospitalCover || $benefitsForm.find('.hospitalCover input:checked').length > 0;
        isExtraCover = isExtraCover || $benefitsForm.find('.extrasCover input:checked').length > 0;

        if (isHospitalCover && isExtraCover) {
            $coverType.val('C');
        } else if (isHospitalCover) {
            $coverType.val('H');
        } else if (isExtraCover) {
            $coverType.val('E');
        } else {
            $coverType.val('');
        }

        $coverType.change();
    }

    function alignSidebarHeight() {
        // no need to align if no sidebar is showing
        if ($coverType.val() === 'C' || $coverType.val() === '') return;

        var $hospitalMainCol = $benefitsForm.find('.hospitalCover'),
            $extrasMainCol = $benefitsForm.find('.extrasCover'),
            $hospitalSidebar = $benefitsForm.find('.sidebarHospital .sidebar-wrapper'),
            $extrasSidebar = $benefitsForm.find('.sidebarExtras .sidebar-wrapper');

        var hospitalMainColHeight = $hospitalMainCol.height() + 15, // plus bottom padding;
            extrasMainColHeight = $extrasMainCol.height() + 15; // plus bottom padding;

        // reset
        $hospitalSidebar.height('auto');
        $extrasSidebar.height('auto');

        if (hospitalMainColHeight > $extrasSidebar.height()) {
            $extrasSidebar.height(hospitalMainColHeight);
        }

        if (extrasMainColHeight > $hospitalSidebar.height()) {
            $hospitalSidebar.height(extrasMainColHeight);
        }
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

    function resetBenefitsSelection() {
        $benefitsForm.find("input[type='checkbox']").prop('checked', false);
        $hiddenFields.find(".benefit-item").val('');
    }

    function populateBenefitsSelection(checkedBenefits) {

        resetBenefitsSelection();

        for (var i = 0; i < checkedBenefits.length; i++) {
            var path = checkedBenefits[i];
            $hiddenFields.find("input[name='health_benefits_benefitsExtras_" + path + "']").val('Y');
            $benefitsForm.find("input[name='health_benefits_benefitsExtras_" + path + "']").prop('checked', true);
        }

        updateCoverTypeByBenefitsSelected();
    }


    // reset benefits for devs when use product title to search
    function resetBenefitsForProductTitleSearch() {
        if (meerkat.site.environment === 'localhost' || meerkat.site.environment === 'nxi' || meerkat.site.environment === 'nxs') {
            if ($.trim($('#health_productTitleSearch').val()) !== '') {
                resetBenefitsSelection();
            }
        }
    }

    function syncAccidentOnly() {
        var $limitedCoverHidden = $hiddenFields.find("input[name='health_situation_accidentOnlyCover']");

        if ($('#accidentCover').is(":checked")) {
            $limitedCoverHidden.val("Y");
        } else {
            $limitedCoverHidden.val("");
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
        $benefitsForm.find("a[data-category=customised]:visible").first().trigger('click');
        obj.btn.trigger('click');
    }

    meerkat.modules.register('healthBenefitsStep', {
        init: init,
        events: events,
        alignTitle: alignTitle,
        checkAndHideMoreBenefits: checkAndHideMoreBenefits,
        changeLayoutByCoverType: changeLayoutByCoverType,
        updateCoverTypeByBenefitsSelected: updateCoverTypeByBenefitsSelected,
        alignSidebarHeight: alignSidebarHeight,
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
        getExtraBenefitsModel: getExtraBenefitsModel
    });

})(jQuery);