/**
 * Description: External documentation:
 */

(function($, undefined) {

	var meerkat =window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var moduleEvents = {}, steps = null;

	var elements = {
			toggle:		"#quote_drivers_youngToggleArea",
			labels:		"#quote_drivers_youngDriverRow .row-content",
			restrict:	"#quote_options_driverOption",
			reg_dob:	"#quote_drivers_regular_dob",
			yng_dob:	"#quote_drivers_young_dob",
			age_row:	"#quote_restricted_ageRow"
	};

	var driverOptions = {};
	var driverOptionsOrder = ['0','3','H','7','A','D'];

	var selectorHTML = null;

	var sessionCamStep = null;

	function updateRestrictAgeSelector() {

		var ageRegular = meerkat.modules.utils.returnAge($(elements.reg_dob).val(), true);
		var ageYoungest = meerkat.modules.utils.returnAge($(elements.yng_dob).val(), true);

		var age = Math.min(ageRegular,ageYoungest);

		if (age <= 20) {
			$(elements.age_row).slideUp();
		}
		else if (age <= 24) {
			$(elements.age_row).slideDown();
			updateSelector(['H']);
		}
		else if (age <= 29) {
			$(elements.age_row).slideDown();
			updateSelector(['H','7']);
		}
		else if (age <= 39) {
			$(elements.age_row).slideDown();
			updateSelector(['H','7','A']);
		}
		else {
			$(elements.age_row).slideDown();
			updateSelector(['H','7','A','D']);
		}
	}

	function updateSelector(opts) {
		var $selector = $(elements.restrict);
		var selected = $selector.val();
		$selector.empty();
		for(var i=0; i<driverOptionsOrder.length; i++) {
			var key = driverOptionsOrder[i];
			if(driverOptions.hasOwnProperty(key)) {
				if(key === '0' || key === '3' || _.indexOf(opts, key) >= 0) {
					var $option = driverOptions[key].clone();
					if(key === selected) {
						$option.prop("selected", true);
					}
					$selector.append($option);
				}
			}
		}
	}

	function captureOptions() {
		/* This is happening as IE11 doesn't respect the hidden class to hide
		 * options not applicable so we now need to add/remove them dynamically.
		 * As the value/label comes from the backend we'll simply scrape for
		 * later reuse.
		 */
		var $e = $(elements.restrict);
		$e.find('option').each(function(){
			var $that = $(this);
			var key = _.isEmpty($that.val()) ? 0 : $that.val();
			driverOptions[key] = $that.clone();
			driverOptions[key].prop('selected', false);
		});
	}

	function isYoungDriverSelected() {

		var $e = $(elements.labels).find("input:checked");

		if(!_.isEmpty($e)) {
			return $e.val() === 'Y';
		}

		return false;
	}

	function toggleVisibleContent(updateVirtualPage) {

		updateVirtualPage = updateVirtualPage || false;

		var $e = $(elements.labels).find("input:checked");

		if(!_.isEmpty($e)) {
			if(isYoungDriverSelected()) {
				$(elements.toggle).slideDown('fast', function() {
					if(updateVirtualPage) {
						var sessionCamStep = getSessionCamStep();
						sessionCamStep.navigationId += "-youngdriver";
						meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);
					}
				});
			} else {
				$(elements.toggle).slideUp('fast', function(){
					var $that = $(this);
					$that.find(':text').val('');
					$that.find(':radio').prop('checked',false).change();
					$(elements.yng_dob).val('').change();
					$that.find('.has-success').removeClass('has-success');
					$that.find('.has-error').removeClass('has-error');
					$that.find('.error-field').remove();

					if(updateVirtualPage) {
						meerkat.modules.sessionCamHelper.updateVirtualPage(getSessionCamStep());
					}
				});
			}
		}
	}

	function initCarYoungDrivers() {

		var self = this;

		// Tell sessionCamHelper to ignore step updates for this step as handled inhouse (aka in this module)
		meerkat.modules.sessionCamHelper.addStepToIgnoreList("details");

		// When hitting this step ensure the correct virtual page is set
		meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function youngDriverStepOnStepChange(event) {
			if(event.navigationId == "details") {
				// Allow for standard step change stuff to finish
				_.defer(_.bind(toggleVisibleContent, this, true));
			}
		});

		// Only init if CAR... obviously...
		if (meerkat.site.vertical !== "car")
			return false;

		$(elements.labels + " label input").on("click", function(e){
			// Allow for input value to be updated
			_.defer(_.bind(toggleVisibleContent, this, true));
		});

		$(elements.reg_dob + "," + elements.yng_dob).on("change", updateRestrictAgeSelector);

		captureOptions();

		toggleVisibleContent();
		// Need to allow time for the currentStep to be populated
		setTimeout(function(){
			if(meerkat.modules.journeyEngine.getCurrentStep().navigationId == "details") {
				var sessionCamStep = getSessionCamStep();
				if(isYoungDriverSelected()) {
					sessionCamStep.navigationId += "-youngdriver";
				}
				meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);
			}
		},250);

		updateRestrictAgeSelector();

	}

	function getSessionCamStep() {
		if(sessionCamStep === null) {
			sessionCamStep = meerkat.modules.journeyEngine.getCurrentStep();
		}
		return _.extend({}, sessionCamStep); // prevent external override
	}

	meerkat.modules.register("carYoungDrivers", {
		initCarYoungDrivers : initCarYoungDrivers,
		events : moduleEvents,
		getSessionCamStep : getSessionCamStep
	});

})(jQuery);