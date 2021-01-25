;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            coverTypeChanged:       "COVERTYPE_CHANGED",
            categoryGroupChanged:   "HOSPITAL_CATEGORY_GROUP_CHANGED",
            situationChanged:       "SITUATION_CHANGED",
            manualBenefitSelection: "BENEFIT_MANUALLY_SELECTED"
        },
        coverType = null,
        situation = null,
        selectedCategory = null,
        defaultSelectedCategory = "SPECIFIC_COVER",
        $elements = null,
        categoryData = {
            SPECIFIC_COVER:             {
                title:  "Specific cover",
                H: "Looking for a product that is very specific to your needs and lifestyle. If you know exactly what you are looking for pick and choose your preferred cover options from the list below.",
                C: "Looking for a product that is very specific to your needs and lifestyle. If you know exactly what you are looking for pick and choose your preferred cover options from the list below."
            },
            NEW_TO_HEALTH_INSURANCE:    {
                title:  "New to health insurance",
                H: "First time to health insurance? Or just wanting cover that is an entry point into private hospital cover? This cover can give you more control, like less waiting time and being treated by a doctor of your choice. It can also help you at tax time.",
                C: "First time to health insurance? Or just wanting cover that is an entry point into private hospital cover? This cover can give you more control, like less waiting time and being treated by a doctor of your choice. It can also help you at tax time. There are also options to include basic extras that you think you’ll need such as Dental and Optical."
            },
            GROWING_FAMILY:             {
                title:  "Growing family",
                H: "Got a growing family? Hospital cover for services and treatment during pregnancy, birth, and following delivery. We've preselected the typical inclusions people choose for this category below.",
                C: "Got a growing family? Hospital cover for services and treatment during pregnancy, birth, and following delivery. Plus mid-level extras for you and the kids such as Dental and Optical. We've preselected the typical inclusions people choose for this category below.",
                hideWhenSituationIs: ["SM"]
            },
            ESTABLISHED_FAMILY:         {
                title:  "Established family",
                H: "Done with needing pregnancy cover? Move to good all-round cover options for you and your family as they grow from kids to teenagers. Cover that doesn’t include pregnancy and birth services.",
                C: "Done with needing pregnancy cover? Move to good all-round cover options for you and your family as they grow from kids to teenagers. Cover that doesn’t include pregnancy and birth services. Includes mid-level extras products to support you and growing kids such as dental, optical, physio, and remedial massage.",
                hideWhenSituationIs: ["SM", "SF", "C"]
            },
            PEACE_OF_MIND:              {
                title:  "Peace of mind",
                H: "Want something that is good for all-round everyday health cover? Accidents and a range of common procedures. Cover that doesn’t include pregnancy and birth services.",
                C: "Want something that is good for all-round everyday health cover? Accidents and a range of common procedures. Cover that doesn’t include pregnancy and birth services. Includes mid-level extras products to support you such as dental, optical, physio, and remedial massage.",
                hideWhenSituationIs: ["SPF", "F"]
            },
            COMPREHENSIVE_COVER:        {
                title:  "Comprehensive cover",
                H: "Empty nest? Looking for cover tailored to you and/or your partner as the occasional ailment might arise? Cover for more of the things you need such as joint replacement, heart treatment, etc.",
                C: "Empty nest? Looking for cover tailored to you and/or your partner as the occasional ailment might arise? Cover for more of the things you need such as joint replacement, heart treatment, etc. This is option selects Higher-level hospital cover excluding pregnancy."
            },
            REDUCE_TAX:                 {
                title:  "Reduce tax",
                H: "Wanting basic hospital cover to exempt yourself from the Medicare levy surcharge? This is the entry-level or basic level of Hospital cover.",
				C: "Wanting basic hospital cover to exempt yourself from the Medicare levy surcharge? This is the entry-level or basic level of Hospital cover."
            }
        };

    function init() {
        _.defer(function() {
            situation = meerkat.modules.healthSituation.getSituation();
            var tmpCoverType = meerkat.modules.healthBenefitsCoverType.getCoverType();
            coverType = tmpCoverType === false ? null : tmpCoverType;

            $elements = {
                wrapper:    $('#health_benefits_categorySelectHospital-container'),
                inputs:     $('input[name=health_benefits_categorySelectHospital]')
            };

            $elements.buttons =             $elements.wrapper.find('.health-benefits-categorySelectHospital');
            $elements.container =           $elements.wrapper.find('.categorySelect-copy-container');
            $elements.copy =                $elements.wrapper.find('.categorySelect-copy');

            $elements.specific =            $elements.inputs.filter('[value=SPECIFIC_COVER]').parent();
            $elements.newto =               $elements.inputs.filter('[value=NEW_TO_HEALTH_INSURANCE]').parent();
            $elements.growing =             $elements.inputs.filter('[value=GROWING_FAMILY]').parent();
            $elements.established =         $elements.inputs.filter('[value=ESTABLISHED_FAMILY]').parent();
            $elements.peace =               $elements.inputs.filter('[value=PEACE_OF_MIND]').parent();
            $elements.comprehensive =       $elements.inputs.filter('[value=COMPREHENSIVE_COVER]').parent();
            $elements.reduce =              $elements.inputs.filter('[value=REDUCE_TAX]').parent();

            $elements.specific.addClass('health-icon icon-health-quickselect-clinicalcat-specific-cover');
            $elements.newto.addClass('health-icon icon-health-quickselect-clinicalcat-new-to-health-insurance');
            $elements.growing.addClass('health-icon icon-health-quickselect-clinicalcat-growing-family');
            $elements.established.addClass('health-icon icon-health-quickselect-clinicalcat-established-family');
            $elements.peace.addClass('health-icon icon-health-quickselect-clinicalcat-peace-of-mind');
            $elements.comprehensive.addClass('health-icon icon-health-quickselect-clinicalcat-comprehensive-cover');
            $elements.reduce.addClass('health-icon icon-health-quickselect-clinicalcat-reduce-tax');

            $elements.buttons.find('label').each(function(){
                $(this).addClass("no-width col-xs-6 col-sm-4 col-md-3 col-lg-2");
            });

            eventSubscriptions();
            eventListeners();

            if(selectedCategory === null) {
                $elements.inputs.filter('[value=' +  defaultSelectedCategory + ']').prop('checked', true).change();
            }

            updateOptions();

            if(coverType !== null) {
                coverTypeToggled();
            }
        });
    }

    function eventSubscriptions() {
        meerkat.messaging.subscribe(moduleEvents.coverTypeChanged, function(payload){
            coverType = payload.coverType;
            coverTypeToggled();
        });
        meerkat.messaging.subscribe(moduleEvents.situationChanged, function(payload){
            situation = payload.situation;
            updateOptions();
        });
        meerkat.messaging.subscribe(moduleEvents.manualBenefitSelection, function(){
            if(_.indexOf(['C', 'H'], coverType) !== -1 && selectedCategory !== defaultSelectedCategory) {
                //setSelectedCategory(defaultSelectedCategory, true);
            }
        });
    }

    function eventListeners() {
        $elements.specific.add($elements.newto).add($elements.growing)
            .add($elements.established).add($elements.peace)
            .add($elements.comprehensive).add($elements.reduce)
            .on('click.toggleCopy change.toggleCopy', function(){
                setSelectedCategory($(this).find(':input').val());
        });
    }

    function coverTypeToggled() {
        if(_.indexOf(['C', 'H'], coverType) !== -1) {
            $elements.wrapper.fadeIn('fast');
        } else {
            $elements.wrapper.fadeOut('fast');
        }
    }

    function updateCategoryCopy() {
        if (selectedCategory !== null && _.has(categoryData, selectedCategory) && _.has(categoryData[selectedCategory], coverType)) {
            $elements.copy.find('h4').html(categoryData[selectedCategory].title);
            $elements.copy.find('p').html(categoryData[selectedCategory][coverType]);
            $elements.container.fadeIn('fast');
        } else {
            $elements.container.fadeOut('fast');
        }
    }

    function updateOptions() {
        Object.keys(categoryData).forEach(function(key,index) {
            var showAlways = !_.has(categoryData[key], 'hideWhenSituationIs');
            var hide = !showAlways && _.indexOf(categoryData[key]['hideWhenSituationIs'], situation) !== -1;
            var $input = $elements.inputs.filter('[value=' + key + ']');
            if($input.is(':checked') && hide) {
                $elements.inputs.filter('[value=' + key + ']').prop('checked', true).change();
            }
            $input.parent().toggleClass('hidden', hide);
        });
    }

    function unsetCategory() {
        if(_.indexOf([null, defaultSelectedCategory], selectedCategory) === -1) {
            $elements.inputs.filter('[value=' + defaultSelectedCategory + ']').prop('checked', true).change();
            selectedCategory = defaultSelectedCategory;
        }
    }

    function setSelectedCategory(category, silent) {
        silent = silent || false;
        selectedCategory = category;
        updateCategoryCopy();
        toggleClass();
        if(silent) {
            $elements.inputs.parent().removeClass('active');
            $elements.inputs.filter('[value=' + selectedCategory + ']').prop('checked', true).parent().addClass('active');
        } else {
            meerkat.messaging.publish(moduleEvents.categoryGroupChanged, {selectedCategory:selectedCategory});
        }
    }

    function getSelectedCategory() {
        return selectedCategory;
    }

    function toggleClass(){
        $('body').toggleClass('SPECIFIC_COVER', selectedCategory === "SPECIFIC_COVER");
    }

    meerkat.modules.register('healthBenefitsCategorySelectHospital', {
        init: init,
        events: moduleEvents,
        getSelectedCategory: getSelectedCategory
    });

})(jQuery);