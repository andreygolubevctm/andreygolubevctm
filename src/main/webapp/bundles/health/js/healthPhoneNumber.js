;(function($, undefined){

	var meerkat = window.meerkat,
	meerkatEvents = meerkat.modules.events,
	moduleInitialised = false,
	callCentreNumber = '.callCentreNumber',
	applicationSteps = ['apply','payment'], // Confirmation page is its own page and just uses the Application Number
	$callCentreFields = null,
	$callCentreHelpFields = null,
	$callCentreHelpDefaultContainers = null,
	$callCentreHelpCustomContainers = null;

	var moduleEvents = {
		healthSituation: {
			CHANGED: 'HEALTH_SITUATION_CHANGED'
		}
	};

	function init() {
		$(document).ready(function(){
			$callCentreFields = $(callCentreNumber);
			$callCentreHelpFields = $('.callCentreHelpNumber');
			$callCentreHelpDefaultContainers = $('.callCentreHelp').find('.default-content'),
			$callCentreHelpCustomContainers = $('.callCentreHelp').find('.custom-content');
			moduleInitialised = true;
		});
		eventSubscriptions();
	}

	function eventSubscriptions() {
		meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function jeStepChangeChangePhone(step){
			_.defer(function() {
				changePhoneNumber(false);
			});
		});
		/* Listener for then situation is changed and call centre help content
		   needs to be updated */
		meerkat.messaging.subscribe(meerkatEvents.healthSituation.CHANGED, onSituationChanged);
	}

	function changePhoneNumber (isModal) {
		var navigationId = meerkat.modules.address.getWindowHash().split("/")[0];
		if(isModal === true) {
			$callCentreFields = $(".more-info-content").find(callCentreNumber);
		}
		$callCentreFields.text(meerkat.site.content.callCentreNumber);
		$callCentreFields.closest('.callCentreNumberClick').attr("href", "tel:"+meerkat.site.content.callCentreNumber); // Need to change mobile clicks
		$callCentreHelpFields.text(meerkat.site.content.callCentreHelpNumber);
	}

	/**
	 * Handle when situation is update and retrieve the correct content from content
	 * control. If newCopy is never set then the default content will be shown.
	 * @param situ
     */
	function onSituationChanged(situ) {
		var newCopy = null;
		// Sanitise the situ to match content control keys
		if(!_.isEmpty(situ) && _.isObject(situ) && _.has(situ,'familyType') && _.has(situ,'lookingTo')) {
			var sanitisedSitu = null;
			if(_.indexOf(['N','SHN'], situ.lookingTo) > -1) {
				sanitisedSitu = situ.lookingTo;
			} else {
				var isFamily = _.indexOf(['SPF','F','ESP','EF'], situ.familyType) > -1;
				if(_.indexOf(['CSF','SF'],situ.lookingTo) > -1) {  // This is/was used to track what the user wanted health insurance for eg start a family, save money for tax purposes
					sanitisedSitu = situ.lookingTo + "_" + (!isFamily ? 'S' : 'F');
				}
			}
			if(!_.isNull(sanitisedSitu)) {
				// Ajax call to retrieve
				meerkat.modules.comms.get({
					url: 'spring/content/getsupplementaryvalue.json',
					data: {
						vertical: 'HEALTH',
						key: 'healthSidebarCallCentreHelp',
						supp: sanitisedSitu
					},
					cache: true,
					dataType: 'json',
					useDefaultErrorHandling: false,
					errorLevel: 'silent',
					timeout: 5000,
					onSuccess: function onSubmitSuccess(resultData) {
						if(_.isObject(resultData) && _.has(resultData,'supplementaryValue')) {
							newCopy = resultData.supplementaryValue;
						}
					},
					onComplete: function () {
						updateCallCentreHelpCopy(newCopy);
					}
				});
			} else {
				updateCallCentreHelpCopy(newCopy);
			}
		} else {
			updateCallCentreHelpCopy(newCopy);
		}
	}

	/**
	 * Show/Hide the default/custom content containers and if applicable
	 * update the content in the custom container.
	 * @param copy
     */
	function updateCallCentreHelpCopy(copy) {
		var updateCallCentreHelpCopyCallback = function(){
			var showCustom = !_.isEmpty(copy);
			if(showCustom) {
				$callCentreHelpCustomContainers.find('.dynamic').empty().append(copy);
			}
			$callCentreHelpDefaultContainers.toggle(!showCustom);
			$callCentreHelpCustomContainers.toggle(showCustom);
		};
		_.delay(updateCallCentreHelpCopyCallback,(!moduleInitialised ? 500 : 0));
	}

	meerkat.modules.register("healthPhoneNumber", {
		init: init,
		events: moduleEvents,
		changePhoneNumber: changePhoneNumber
	});

})(jQuery);