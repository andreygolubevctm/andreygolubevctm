;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            hospitalCategoryGroup:  "HOSPITAL_CATEGORY_GROUP_CHANGED",
            extrasCategoryGroup:    "EXTRAS_CATEGORY_GROUP_CHANGED",
            manualBenefitSelection: "BENEFIT_MANUALLY_SELECTED",
            triggerBenefitsLoading : "BENEFITS_LOADING",
            sortBenefits:  "SORT_BENEFITS",
            updateBenefitCounters: "UPDATE_BENEFIT_COUNTERS"
        },
        $elements = null;

    function init() {
        _.defer(function(){
            $elements = {
                hospitalBenefits:   $('#benefitsForm .Hospital-wrapper').find('.short-list-item'),
                extrasBenefits:     $('#benefitsForm .Extras-wrapper').find('.short-list-item'),
                artworkContainers:   $('#benefitsForm .Hospital-wrapper').find('.categorySelect-copy-container').add($('#benefitsForm .Hospital-wrapper').find('.categorySelect-copy-container'))
            };

            eventSubscriptions();
            eventListeners();
        });
    }

    function eventSubscriptions() {
        meerkat.messaging.subscribe(moduleEvents.extrasCategoryGroup, function(payload) {
            meerkat.messaging.publish(moduleEvents.triggerBenefitsLoading);
            updateArtwork(payload.selectedCategory);
            updateBenefits(payload.selectedCategory, true);
            meerkat.messaging.publish(moduleEvents.updateBenefitCounters);
        });
        meerkat.messaging.subscribe(moduleEvents.hospitalCategoryGroup, function(payload) {
            meerkat.messaging.publish(moduleEvents.triggerBenefitsLoading);
            updateArtwork(payload.selectedCategory);
            updateBenefits(payload.selectedCategory, false);
            meerkat.modules.benefits.setHospitalType(payload.selectedCategory === "REDUCE_TAX" ? "limited" : "customise");
            $('body').toggleClass("limited", payload.selectedCategory === "REDUCE_TAX");
            meerkat.messaging.publish(moduleEvents.updateBenefitCounters);
        });
    }

    function eventListeners() {
        $elements.hospitalBenefits.add($elements.extrasBenefits).find('label:first').on('click.manualBenefitSelection', function(){
            var $row = $(this).closest(".short-list-item");
            var groups = [];
            var groupsStr = $row.attr("data-groups");
            if(!_.isEmpty(groupsStr)) {
                groups = groupsStr.split(",");
            }
            _.defer(function(){
                var checked = $row.find(":input").is(":checked");
                $row.toggleClass('active', checked);
                if(!checked) {
					var $categoryLabelContainer = $row.find('.benefit-categories .innertube');
                    if($categoryLabelContainer) {
                        $categoryLabelContainer.remove();
                    }
                }
                meerkat.messaging.publish(moduleEvents.manualBenefitSelection, {row:$row, groups:groups, checked:checked});
            });
        });
    }

    function updateBenefits(category, extrasOnly) {
        extrasOnly = extrasOnly || false;
        var $benefitElements = $elements.extrasBenefits;
        if(!extrasOnly) {
            $benefitElements = $benefitElements.add($elements.hospitalBenefits);
        }
        $benefitElements.each(function() {
            var $that = $(this);
            var groupsStr = $that.attr('data-groups');
            if(groupsStr && !_.isEmpty(groupsStr)) {
                var groups = groupsStr.split(',');
                var isActive = _.indexOf(groups, category) !== -1;
                $that.find(':input').prop('checked', isActive).trigger('change.randomEventLabel');
                $that.toggleClass("active", isActive);
            }
        });
        meerkat.modules.benefits.updateModelFromForm();
        meerkat.messaging.publish(moduleEvents.sortBenefits);
    }

    function updateArtwork(category) {
        var list = ["ESTABLISHED_FAMILY", "GROWING_FAMILY"];
        _.each(list, function(item) {
            $elements.artworkContainers.toggleClass(item, category === item);
        });
    }

    meerkat.modules.register('healthBenefitsCategorySelectCommon', {
        init: init,
        events: moduleEvents
    });

})(jQuery);