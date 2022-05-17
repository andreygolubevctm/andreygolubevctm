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
        clinicalBenefits = [],
        extrasBenefits = [],
        ambulanceAccidentCoverItems = [],
        $boneMusicleJointCheckbox,
        $earNoseThroatCheckbox,
        $backSurgeryCheckbox,
        $birthServicesCheckbox;

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
            $birthServicesCheckbox = $('#health_benefits_benefitsExtras_Obstetric');
            $boneMusicleJointCheckbox = $('#health_benefits_benefitsExtras_BoneMuscleJointRecon');
            $earNoseThroatCheckbox = $('#health_benefits_benefitsExtras_ENT');
            $backSurgeryCheckbox = $('#health_benefits_benefitsExtras_BackSurgery');

            $hospitalCover = $('.Hospital_container');
            $hospitalCoverToggles = $('.hospitalCoverToggles a');
            $allHospitalButtons = $hospitalCover.find('input[type="checkbox"]');
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
            benefitClarificationToggle();

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
        benefitClarificationToggleEvents();

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

		$(document).on('click', 'a[data-clearall-type]', function clearAllSelectedBenefits() {
		    var $that = $(this);
			var type = $that.attr("data-clearall-type");
			$that.closest('.hasShortlistableChildren').find(':input:checked').filter('[data-type=' + (type === 'hospital' ? type : 'extras') + ']').prop('checked', false).change();
			if(type === 'hospital') {
			    _.defer(function(){
					$('#clinicalCategoriesContent').find(':input:checked').prop('checked', false).change().closest('.short-list-item').removeClass('active');
                    meerkat.modules.healthClinicalCategories.toggleCTMBenefitLabels(true);
                });
			}
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
            clinicalBenefits = getClinicalBenefitsModelFromPage();
            extrasBenefits = getBenefitsModelFromPage($benefitsForm.find('.extrasCover'));
            ambulanceAccidentCoverItems = getAmbulanceAccidentCoverModelFromPage($benefitsForm.find('.ambulanceAccidentCover_container'));
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
            benefit.dataGroup =  $this.find('input[type="checkbox"]').attr('data-group');
            // apparently IE8 doesn't support obj.class as a new property
            benefit['class'] = ($this.hasClass('medium') ? 'medium ' : '') + ($this.hasClass('basic') ? 'basic ' : '') + ($this.hasClass('customise') ? 'customise ' : '');
            benefits.push(benefit);
        });
        return benefits;
    }

    function getClinicalBenefitsModelFromPage() {
        var benefits = [];
        $('#clinicalCategoriesContent').find('.short-list-item').each(function () {
            var benefit = {},
                $this = $(this);
            benefit.value = $this.find('input[type="checkbox"]').attr('id').replace('health_benefits_benefitsExtras_', '');
            benefit.label = $this.find('.benefit-title.hidden-xs').text();
            benefit.helpId = $this.find('.benefit-caption').attr('data-help-id');
            benefit.dataGroups =  $this.attr('data-groups');
            benefits.push(benefit);
        });
        return benefits;
    }

	function getAmbulanceAccidentCoverModelFromPage($container) {
		var ambulanceAccidentCoverItems = [];
		$container.find('.short-list-item').each(function () {
			var item = {},
				$this = $(this);
			item.value = $this.find('input[type="checkbox"]').attr('id').replace('health_ambulanceAccidentCover_', '');
			item.label = $this.find('.iconLabel').text() || $.trim($this.find('label')[0].firstChild.nodeValue);
			var hasHelpIcon = $this.find('.help-icon').length > 0;
			item.helpId = !hasHelpIcon ? '' : $this.find('.help-icon').data('content').replace('helpid:', '');
			ambulanceAccidentCoverItems.push(item);
		});
		return ambulanceAccidentCoverItems;
	}

    function getHospitalBenefitsModel(){
        return hospitalBenefits;
    }

    function getClinicalBenefitsModel(){
        return clinicalBenefits;
    }

    function getExtraBenefitsModel(){
        return extrasBenefits;
    }

	function getAmbulanceAccidentCoverModel(){
		return ambulanceAccidentCoverItems;
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
                        meerkat.modules.healthClinicalCategories.setAccidentOnlyCover(true);
                        $hospitalCover.find('a[data-clearall-type]').addClass('hidden');
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

                    meerkat.modules.healthClinicalCategories.setAccidentOnlyCover(false);
					$hospitalCover.find('a[data-clearall-type]').removeClass('hidden');

                    break;
            }

            $hospitalCover.find('.coverExplanation.' + previousCover + 'Cover').addClass('hidden').end().find('.coverExplanation.' + currentCover + 'Cover').removeClass('hidden');
            previousCover = currentCover;
        });

        $allHospitalButtons.on('change', function onHospitalBenefitsChange() {
            $benefitsForm.find("a[data-category=customise]:visible").first().addClass('active');
            // if a hospital benefit is checked, change cover type to 'customise'
            if ($(this).is(':checked')) {
                $coverType.val('customise');
            }
        });
    }

    function benefitClarificationToggleEvents() {
        $boneMusicleJointCheckbox.on('click', function toggleJointMuscleScript() {
            var $item = $(this);
            $('.simples-dialogue-173').toggleClass('hidden', !$item.is(":checked"));
        });

        $earNoseThroatCheckbox.on('click', function toggleENTScript() {
            var $item = $(this);
            $('.simples-dialogue-174').toggleClass('hidden', !$item.is(":checked"));
        });

        $backSurgeryCheckbox.on('click', function toggleBackSurgeryScript() {
            var $item = $(this);
            $('.simples-dialogue-175').toggleClass('hidden', !$item.is(":checked"));
        });

        $birthServicesCheckbox.on('click', function togglePregnancyScript() {
            var $item = $(this);
            $('.simples-dialogue-176').toggleClass('hidden', !$item.is(":checked"));
        });
    }

    function benefitClarificationToggle() {
        $('.simples-dialogue-173').toggleClass('hidden', !$boneMusicleJointCheckbox.is(":checked"));
        $('.simples-dialogue-174').toggleClass('hidden', !$earNoseThroatCheckbox.is(":checked"));
        $('.simples-dialogue-175').toggleClass('hidden', !$backSurgeryCheckbox.is(":checked"));
        $('.simples-dialogue-176').toggleClass('hidden', !$birthServicesCheckbox.is(":checked"));
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
        $benefitsForm.find("input[type='checkbox'][name^='health_benefits']").each(function(){
            var $that = $(this);
            var isClinicalCategory = !_.isUndefined($that.attr("data-benefit-code"));
            var manualSelection = !_.isUndefined($that.prop('manually-selected')) && $that.prop('manually-selected');
            if(!manualSelection) {
                $that.prop("checked", false).change();
                $that.attr('data-visible', "false");
                if(isClinicalCategory) {
                    $that.closest(".categoriesCell_v2").removeClass("active");
                }
            }
        });
        if(includeHidden === true){
            $hiddenFields.find(".benefit-item").val('');
        }
    }

	function resetAmbulanceAccidentCoverSelection() {
		$benefitsForm.find("input[type='checkbox'][name^='health_ambulanceAccidentCover']").prop('checked', false);
	}

    function populateBenefitsSelection(checkedBenefits) {
        resetBenefitsSelection(false);

        for (var i = 0; i < checkedBenefits.length; i++) {
            var path = checkedBenefits[i];
            $benefitsForm.find("input[name='health_benefits_benefitsExtras_" + path + "']").prop('checked', true).attr('data-visible', "true").change();
        }
    }

	function populateAmbulanceAccidentCoverSelection(checkedAmbulanceAccidentCover) {

		resetAmbulanceAccidentCoverSelection();

		for (var i = 0; i < checkedAmbulanceAccidentCover.length; i++) {
			var path = checkedAmbulanceAccidentCover[i];
			$benefitsForm.find("input[name='health_ambulanceAccidentCover_" + path + "']").prop('checked', true);
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

    function getSelectedClinicalBenefits() {
        var clinicalBenefits = [];

        $('#benefitsForm .clinical-category').find("input[type='checkbox'][name^='health_benefits']").each(function (index, element) {
            var $element = $(element);
            if ($element.is(':checked')) {
                var key = $element.attr('name').replace('health_benefits_benefitsExtras_', '');
                clinicalBenefits.push(key);
            }
        });

        return clinicalBenefits;

    }

    function getFilteredClinicalBenefits() {
        var clinicalFilteredBenefits = [];

        $('.benefits-list.benefitsClinical').find("input[type='checkbox'][name='health_filterBar_benefitsClinical']").each(function (index, element) {
            var $element = $(element);
            if ($element.is(':checked')) {
                var key = $element.attr('id').replace('health_filterBar_benefits_', '');
                clinicalFilteredBenefits.push(key);
            }
        });

        return clinicalFilteredBenefits;
    }

	// Get the selected benefits from the forms hidden fields (the source of truth! - not the checkboxes)
	function getAmbulanceAccidentCover() {

		var ambulanceAccidentCoverItems = [];

		// other benefits
		$('#benefitsForm').find("input[type='checkbox'][name^='health_ambulanceAccidentCover']").each(function (index, element) {
			var $element = $(element);
			if ($element.is(':checked')) {
				var key = $element.attr('name').replace('health_ambulanceAccidentCover_', '');
				ambulanceAccidentCoverItems.push(key);
			}
		});

		return ambulanceAccidentCoverItems;

	}

	function isAmbulanceSelected() {
    	var cover = getAmbulanceAccidentCover();
    	return _.indexOf(cover, 'ambulance') !== -1;
	}

	function isAccidentSelected() {
		var cover = getAmbulanceAccidentCover();
		return _.indexOf(cover, 'accident') !== -1;
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
	    resetAmbulanceAccidentCoverSelection: resetAmbulanceAccidentCoverSelection,
        resetBenefitsForProductTitleSearch: resetBenefitsForProductTitleSearch,
        getSelectedBenefits: getSelectedBenefits,
        getSelectedClinicalBenefits: getSelectedClinicalBenefits,
        getFilteredClinicalBenefits: getFilteredClinicalBenefits,
	    getAmbulanceAccidentCover: getAmbulanceAccidentCover,
        populateBenefitsSelection: populateBenefitsSelection,
	    populateAmbulanceAccidentCoverSelection: populateAmbulanceAccidentCoverSelection,
        getHospitalBenefitsModel: getHospitalBenefitsModel,
        getClinicalBenefitsModel: getClinicalBenefitsModel,
        getExtraBenefitsModel: getExtraBenefitsModel,
	    getAmbulanceAccidentCoverModel: getAmbulanceAccidentCoverModel,
	    isAmbulanceSelected: isAmbulanceSelected,
	    isAccidentSelected: isAccidentSelected,
        getLimitedCover: getLimitedCover,
        showTabOneCheckboxes: showTabOneCheckboxes,
        showTabTwoCheckboxes: showTabTwoCheckboxes,
        getCoverType: getCoverType
    });

})(jQuery);