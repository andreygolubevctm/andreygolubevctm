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
        $limitedCoverHidden,
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
            $limitedCoverHidden = $hiddenFields.find("input[name='health_situation_accidentOnlyCover']");

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

            setupPage();
            eventSubscriptions();

            if($limitedCoverHidden.val() === 'Y') {
                var filter = meerkat.modules.deviceMediaState.get() === 'xs' ? '.limited' : '.btn-save';
                $hospitalCoverToggles.filter('[data-category=limited]' + filter).trigger('click');
            } else {
                $limitedCoverHidden.val('N');
            }
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

        switch ($coverType.find('input:checked').val().toLowerCase()) {
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
                $allHospitalButtons.prop('checked', false);
                break;
            default:
                $hospitalSection.slideUp();
                $extrasSection.slideUp();
                $hospitalCoverToggles.prop("checked", false);
                $allHospitalButtons.prop('checked', false);
                $extrasSection.find('input[type="checkbox"]').prop('checked', false);
                break;
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
            $hospitalBenefitsSection = $('.Hospital_container .children'),
            $coverType = $('#health_benefits_covertype');

        $hospitalCoverToggles.on('click', function toggleHospitalCover() {
            var $item = $(this);
            currentCover = $item.data('category');

            // set the active  (not using $this here to addClass due to we have another sets of link for mobile...)
            $hospitalCoverToggles.removeClass('active').filter('[data-category="' + currentCover + '"]').addClass('active');

            // set the hidden field
            $coverType.val(currentCover);
            $limitedCoverHidden.val('N');

            // uncheck all tickboxes
            $allHospitalButtons.prop('checked', false);

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
                    if (currentCover !== 'customise') {
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

            $hospitalCover.find('.coverExplanation.' + previousCover + 'Cover').addClass('hidden').end().find('.coverExplanation.' + currentCover + 'Cover').removeClass('hidden');
            previousCover = currentCover;
        });

        $allHospitalButtons.on('change', function onHospitalBenefitsChange() {
            $benefitsForm.find("a[data-category=customise]:visible").first().addClass('active');
            $coverType.val('customise');
        });
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
        $benefitsForm.find("input[type='checkbox'][name^='health_benefits']").prop('checked', false);
        if(includeHidden === true){
            $hiddenFields.find(".benefit-item").val('');
        }
    }

    function populateBenefitsSelection(checkedBenefits) {

        resetBenefitsSelection(false);

        for (var i = 0; i < checkedBenefits.length; i++) {
            var path = checkedBenefits[i];
            $benefitsForm.find("input[name='health_benefits_benefitsExtras_" + path + "']").prop('checked', true);
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

    function getLimitedCover() {
        return $limitedCoverHidden.val();
    }

    function showTabOneCheckboxes(reform) {
        var tab1Limited = reform.tab1.limited;
        var tab2Limited = reform.tab2.limited;

        //Scenario 5: Non Limited product
        if(!tab1Limited && !tab2Limited) {
            return false;
        }

        //Scenario 2: Transition product limited now but not in future
        if(tab1Limited && !tab2Limited) {
            return false;
        }
        
        //Scenario 3: Transition Product covered now limited in future
        if(!tab1Limited && tab2Limited) {
            return true;
        }
        
        //Scenario 4: Transition product limited now and limited in future
        if(tab1Limited && tab2Limited) {
            return true;
        }

        //Scenario 1: New product and it is limited
        if(tab1Limited) {
            return false;
        }

        //Default if no other criteria is met
        return true;
    }

    function showTabTwoCheckboxes(reform) {
        var tab1Limited = reform.tab1.limited;
        var tab2Limited = reform.tab2.limited;

        //Scenario 5: Non Limited product
        if(!tab1Limited && !tab2Limited) {
            return false;
        }

        //Scenario 2: Transition product limited now but not in future
        if(tab1Limited && !tab2Limited) {
            return true;
        }
        
        //Scenario 3: Transition Product covered now limited in future
        if(!tab1Limited && tab2Limited) {
            return false;
        }
        
        //Scenario 4: Transition product limited now and limited in future
        if(tab1Limited && tab2Limited) {
            return false;
        }

        //Default if no other criteria is met
        return true;
    }

    function getCoverType() {
        return $coverType.find('input:checked').val().toLowerCase();
    }

    meerkat.modules.register('healthBenefitsStep', {
        init: init,
        events: events,
        setDefaultCover: setDefaultCover,
        updateHiddenFields: updateHiddenFields,
        resetBenefitsSelection: resetBenefitsSelection,
        resetBenefitsForProductTitleSearch: resetBenefitsForProductTitleSearch,
        getSelectedBenefits: getSelectedBenefits,
        populateBenefitsSelection: populateBenefitsSelection,
        getHospitalBenefitsModel: getHospitalBenefitsModel,
        getExtraBenefitsModel: getExtraBenefitsModel,
        getLimitedCover: getLimitedCover,
        showTabOneCheckboxes: showTabOneCheckboxes,
        showTabTwoCheckboxes: showTabTwoCheckboxes,
        getCoverType: getCoverType
    });

})(jQuery);