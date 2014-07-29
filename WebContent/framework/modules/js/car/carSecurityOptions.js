/**
 * Description: External documentation:
 */

(function($, undefined) {

	var meerkat =window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var moduleEvents = {
			carVehicleOptions : {
				UPDATED_VEHICLE_DATA : 'UPDATED_VEHICLE_DATA'
			}
	}, steps = null;

	var elements = {
			selector:			"#securityOptionRow .select:first, #securityOptionRow .fieldrow_legend:first",
			selectorParent:		"#securityOptionRow .row-content",
			visibleRow:			"#securityOptionRow",
			hiddenRow:			"#securityOptionHiddenRow"
	};

	var initial_load = true;

	var selectorHTML = null;

	function onUpdatedVehicleData(data) {

		var security = 'N';
		var has_alarm = !_.isEmpty(data.alarm);
		var has_immob = !_.isEmpty(data.immobiliser);

		if(has_alarm && has_immob) {
			security = 'B';
		} else if(has_alarm) {
			security = 'A';
		} else if(has_immob) {
			security = "I";
		}

		if(security !== 'N') {
			$(elements.selectorParent).empty();
			$(elements.visibleRow).hide();
			$(elements.hiddenRow).empty()
			.append(
				$("<input/>",{
					type:	"hidden",
					name:	"quote_vehicle_securityOption",
					id:		"quote_vehicle_securityOption",
					value:	security
				})
			)
			.append(
				$("<input/>",{
					type:	"hidden",
					name:	"quote_vehicle_securityOptionCheck",
					id:		"quote_vehicle_securityOptionCheck",
					value:	"Y"
				})
			).show();
		} else {
			$(elements.hiddenRow).empty();
			selectorHTML.find('option:selected').removeAttr('selected');
			selectorHTML.find('select:first').attr('selectedIndex', 0);
			$(elements.selectorParent).empty().append(selectorHTML);
			if(initial_load === true) {
				initial_load = false;
				var securityOption = meerkat.site.vehicleSelectionDefaults.securityOption;
				if(!_.isEmpty(securityOption)) {
					$(elements.selector).find('option').each(function(){
						var $that = $(this);
						if($that.val() == securityOption) {
							$that.prop('selected', true);
						}
					});
				}
			}
			$(elements.visibleRow).show();
		}
	}

	function initCarSecurityOptions() {

		var self = this;

		$(document).ready(function() {

			// Only init if CAR... obviously...
			if (meerkat.site.vertical !== "car")
				return false;

			meerkat.messaging.subscribe(meerkatEvents.carVehicleOptions.UPDATED_VEHICLE_DATA, onUpdatedVehicleData);

			selectorHTML = $(elements.selector).clone();
			selectorHTML.find('option:selected').removeAttr('selected');
			selectorHTML.find('select:first').attr('selectedIndex', 0);
			$(elements.selector).remove();
		});

	}

	meerkat.modules.register("carSecurityOptions", {
		init : initCarSecurityOptions,
		events : moduleEvents,
		onUpdatedVehicleData : onUpdatedVehicleData
	});

})(jQuery);