;(function ($, undefined) {

    var meerkat = window.meerkat,
        moduleEvents = {
            coverTypeChanged : 		  "COVERTYPE_CHANGED",
            hardResetBenefits: 		  "HARD_RESET_BENEFITS",
            sortBenefits:  			    "SORT_BENEFITS",
            updateBenefitCounters:	"UPDATE_BENEFIT_COUNTERS"
        },
        $elements;

    function init() {
        _.defer(function(){
            $elements = {
                unselectAllHospital:    $('#health_benefits_toggleAndJumpMenuHospital-container .untickAll'),
                unselectAllExtras:      $('#health_benefits_toggleAndJumpMenuExtras-container .untickAll'),
                jumpToExtras:           $('#health_benefits_toggleAndJumpMenuHospital-container .jumpTo > span'),
                jumpToHospital:         $('#health_benefits_toggleAndJumpMenuExtras-container .jumpTo > span'),
                extrasWrapper:          $('#Extras-wrapper'),
                hospitalWrapper:        $('#Hospital-wrapper'),
                extrasBenefits:         $('#Extras-wrapper .short-list-item').find(':input'),
                hospitalBenefits:       $('#Hospital-wrapper .short-list-item').find(':input')
            };

            eventSubscriptions();
            eventListeners();
        });
    }
    
    function eventSubscriptions() {
        meerkat.messaging.subscribe(moduleEvents.coverTypeChanged, function(payload) {
            $elements.jumpToHospital.parent().toggleClass("hidden", payload.coverType === "E");
            $elements.jumpToExtras.parent().toggleClass("hidden", payload.coverType === "H");
        });
		meerkat.messaging.subscribe(moduleEvents.hardResetBenefits, function(){
			unselectHospitalBenefits(true);
			unselectExtrasBenefits(true);
		});
    }

    function eventListeners() {
        $elements.unselectAllHospital.on("click.untickAll", function(){
			unselectHospitalBenefits();
        });
        $elements.unselectAllExtras.on("click.untickAll", function(){
            unselectExtrasBenefits();
        });
        $elements.jumpToExtras.on("click.jumpTo", function(){
            $('html, body').stop().animate({
                scrollTop: parseInt($elements.extrasWrapper.offset().top - 50)
            }, 1000);
        });
		$elements.jumpToHospital.on("click.jumpTo", function(){
			$('html, body').stop().animate({
				scrollTop: parseInt($elements.hospitalWrapper.find('.section-title:first').offset().top - 50)
			}, 1000);
		});
    }

	function unselectRows($list) {
		$list.filter(":checked").each(function(){
			var $that = $(this);
			$that.prop('checked', false).removeProp("manually-selected");
			var $row = $that.closest('.short-list-item');
			$row.removeClass('active').find('.benefit-categories .innertube').remove();
		});

		_.defer(function(){
			meerkat.messaging.publish(moduleEvents.sortBenefits, function() {
				meerkat.messaging.publish(moduleEvents.updateBenefitCounters);
			});
		});
	}

	function unselectHospitalBenefits(incCategory) {
		incCategory = incCategory || false;
		meerkat.modules.healthBenefitsQuickSelectHospital.resetQuickSelects();
		if(incCategory === true) {
			meerkat.modules.healthBenefitsCategorySelectHospital.unsetCategory(true);
		}
		unselectRows($elements.hospitalBenefits);
		meerkat.messaging.publish(moduleEvents.sortBenefits);
		meerkat.modules.benefitsModel.flushHospital();
	}

	function unselectExtrasBenefits(incCategory) {
		incCategory = incCategory || false;
		if(incCategory === true) {
			meerkat.modules.healthBenefitsCategorySelectExtras.unsetCategory(true);
		}
		unselectRows($elements.extrasBenefits);
		meerkat.messaging.publish(moduleEvents.sortBenefits);
		meerkat.modules.benefitsModel.flushExtras();
	}

    meerkat.modules.register('healthBenefitsToggleAndJumpMenu', {
        init: init,
        events: moduleEvents,
		unselectHospitalBenefits: unselectHospitalBenefits,
		unselectExtrasBenefits: unselectExtrasBenefits
    });

})(jQuery);