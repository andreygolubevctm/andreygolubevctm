;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            coverTypeChanged:             "COVERTYPE_CHANGED",
            categoryGroupChangedExtras:   "EXTRAS_CATEGORY_GROUP_CHANGED",
			categoryGroupChangedHospital: "HOSPITAL_CATEGORY_GROUP_CHANGED",
            manualBenefitSelection:       "BENEFIT_MANUALLY_SELECTED",
			hardResetBenefits:            "HARD_RESET_BENEFITS"
        },
        coverType = null,
        selectedCategory = null,
        defaultSelectedCategory = "SPECIFIC_COVER",
        $elements = null,
		copyMappings = {
			SPECIFIC_COVER:             {
				title:  "Specific cover",
				body:   "Looking for a product that is very specific to your needs and lifestyle. If you know exactly what you are looking for pick and choose your preferred cover options from the list below."
			},
			POPULAR:        {
				title:  "Most popular",
				body:   "Our most commonly selected extras, covering trips to the dentist, physio and optical services."
			},
			A_LITTLE_BIT_MORE:     {
				title:  "A few more",
				body:   "Next level up of extras. Cover that includes major dental, remedial messages, chiro as well as a wide range of benefits for you to claim back on."
			},
			COMPLETE_COVER: {
				title:  "Complete cover",
				body:   "Be prepared for any moment and get cover for everything."
			}
		};

    function init() {
        _.defer(function(){
            var tmpCoverType = meerkat.modules.healthBenefitsCoverType.getCoverType();
            coverType = tmpCoverType === false ? null : tmpCoverType;

            $elements = {
                wrapper:    $('#health_benefits_categorySelectExtras-container'),
                inputs:     $('input[name=health_benefits_categorySelectExtras]')
            };

            $elements.buttons = $elements.wrapper.find('.health-benefits-categorySelectExtras');
            $elements.container = $elements.wrapper.find('.categorySelect-copy-container');
            $elements.copy = $elements.wrapper.find('.categorySelect-copy');

            $elements.specific = $elements.inputs.filter('[value=SPECIFIC_COVER]').parent();
            $elements.popular = $elements.inputs.filter('[value=POPULAR]').parent();
            $elements.afewmore = $elements.inputs.filter('[value=A_LITTLE_BIT_MORE]').parent();
            $elements.complete = $elements.inputs.filter('[value=COMPLETE_COVER]').parent();

            $elements.specific.addClass('health-icon icon-health-quickselect-extras-specific-cover');
            $elements.popular.addClass('health-icon icon-health-quickselect-extras-popular');
            $elements.afewmore.addClass('health-icon icon-health-quickselect-extras-a-few-more');
            $elements.complete.addClass('health-icon icon-health-quickselect-extras-complete-cover');

            $elements.buttons.find('label').each(function(){
                $(this).addClass("no-width col-xs-6 col-sm-4 col-md-3 col-lg-2");
            });

            eventSubscriptions();
            eventListeners();

            if(selectedCategory === null) {
                $elements.inputs.filter('[value=' +  defaultSelectedCategory + ']').prop('checked', true).change();
            }

            if(coverType) {
                coverTypeToggled();
            }
        });
    }

    function eventSubscriptions() {
        meerkat.messaging.subscribe(moduleEvents.coverTypeChanged, function(payload){
            coverType = payload.coverType;
            coverTypeToggled();
        });
		meerkat.messaging.subscribe(moduleEvents.hardResetBenefits, unsetCategory);
		meerkat.messaging.subscribe(moduleEvents.categoryGroupChangedHospital, coverTypeToggled);
    }

    function eventListeners() {
        $elements.specific.add($elements.popular)
            .add($elements.afewmore).add($elements.complete)
            .on('click.toggleCategory change.toggleCategory', function(){
                setSelectedCategory($(this).find(':input').val());
        });
    }

    function coverTypeToggled() {
        var selectedCategory = meerkat.modules.healthBenefitsCategorySelectHospital.getSelectedCategory();
        selectedCategory = selectedCategory || "SPECIFIC_COVER";
		if(coverType === "E" || (_.indexOf(["C", "E"], coverType) !== -1 && selectedCategory === "SPECIFIC_COVER")) {
            $elements.wrapper.fadeIn('fast');
        } else {
			unsetCategory();
            $elements.wrapper.fadeOut('fast');
        }
    }

    function unsetCategory(silent) {
    	silent = silent || false;
        if(_.indexOf([null, defaultSelectedCategory], selectedCategory) === -1) {
            selectedCategory = defaultSelectedCategory;
            if(silent) {
                $elements.inputs.filter('[value=' + selectedCategory + ']').prop('checked', false).closest('label').removeClass('active');
				$elements.inputs.filter('[value=' + defaultSelectedCategory + ']').prop('checked', true).closest('label').addClass('active');
			} else {
				$elements.inputs.filter('[value=' + defaultSelectedCategory + ']').prop('checked', false).change();
            }
        }
    }

    function setSelectedCategory(category, silent) {
    	silent = silent || false;
        selectedCategory = category;
		updateCategoryCopy();
        if(silent) {
            $elements.inputs.parent().removeClass('active');
            $elements.inputs.filter('[value=' + selectedCategory + ']').prop('checked', true).parent().addClass('active');
        } else {
            meerkat.messaging.publish(moduleEvents.categoryGroupChangedExtras, {selectedCategory:selectedCategory});
        }
    }

    function getSelectedCategory() {
        return selectedCategory;
    }

	function updateCategoryCopy() {
		if(_.has(copyMappings, selectedCategory)) {
			$elements.copy.find('h4').html(copyMappings[selectedCategory].title);
			$elements.copy.find('p').html(copyMappings[selectedCategory].body);
			if(!$elements.container.is(":visible")) {
				$elements.container.fadeIn('fast');
			}
		} else {
			$elements.container.fadeOut('fast');
		}
	}

    meerkat.modules.register('healthBenefitsCategorySelectExtras', {
        init: init,
        events: moduleEvents,
        getSelectedCategory: getSelectedCategory,
		unsetCategory: unsetCategory
    });

})(jQuery);