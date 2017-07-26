/**
 * Brief explanation of the module and what it achieves. <example: Example pattern code for a meerkat module.>
 * Link to any applicable confluence docs: <example: http://confluence:8090/display/EBUS/Meerkat+Modules>
 */

;(function($, undefined){

	var meerkat = window.meerkat;

	var
		$coverType,
		$ownsProperty = $("input[name=home_occupancy_ownProperty]"),
		$chosenCoverTypeOption,
		warningDialogId = null,
		initialised = false;

	function initHomeCoverTypeWarning() {
		if(!initialised) {
			initialised = true;
			$coverType = $('#home_coverType');
			$chosenCoverTypeOption = $('#home_occupancy_coverTypeWarning_chosenOption');

			$ownsProperty.on("change.ownHome", function checkOwnership() {
				_.defer(validateSelections);
			});

			$coverType.on("change.cover", function checkOwnership() {
				_.defer(validateSelections);
			});

			// Validate only if both fields have values
			if ($coverType.val() && $("input[name=home_occupancy_ownProperty]:checked").val()) {
				_.defer(_.bind(validateSelections, this, true));
			}
		}
	}

	function validateSelections(proceedToOccupancy) {
		var isValid = true;
		var navigation = 'start';

		if (meerkat.modules.journeyEngine.getCurrentStep().navigationId === navigation && $("input[name=home_occupancy_ownProperty]:checked").val() === 'N'
			&& ($coverType.val() === 'Home & Contents Cover' || $coverType.val() === 'Home Cover Only')) {

			var homeLabel = "I own or am paying off the home",
				dialogTitle = "Oops, did you want to get contents only insurance?";

			if (meerkat.modules.deviceMediaState.get() === 'xs') {
				dialogTitle = "Oops, did you want contents only insurance?";
			}

			var buttons = [{
				label : "Switch to contents only",
				className: "btn-next contentsOnlyBtnWP",
				closeWindow: true,
				action: function() {
					$chosenCoverTypeOption.val('Switch to contents only');
					$coverType.val("Contents Cover Only");
					meerkat.modules.contentPopulation.render('.journeyEngineSlide:eq(0) .snapshot'); // re-render the first step
					meerkat.modules.contentPopulation.render('.journeyEngineSlide:eq(1) .snapshot'); // re-render the occupancy step
					$coverType.trigger('blur');
					validateSelections();
				}
			},{
				label : homeLabel,
				className: "btn-next ownBtnWP",
				closeWindow: true,
				action: function() {
					$('#home_occupancy_ownProperty_Y').prop('checked', true).change();
					$chosenCoverTypeOption.val("I own or am paying off the home");
				}
			}];

			if(meerkat.modules.dialogs.isDialogOpen(warningDialogId) === false) {
				warningDialogId = meerkat.modules.dialogs.show({
					title: dialogTitle,
					onOpen: function (modalId) {
						// update with the text within the cover type dropdown
						var coverTypeCopy = ($coverType.val() === "Home Cover Only" ? "Home" : "Home and Contents"),
							htmlContent = $('#cover-type-warning-template').html(),
							$modal = $('#' + modalId);
						htmlContent = htmlContent.replace(/\b(placeholder)\b/gi, coverTypeCopy);
						meerkat.modules.dialogs.changeContent(modalId, htmlContent); // update the content

						$modal.addClass('coverTypeWarningPopup'); // add class for css

						// tweak the sizing to fit the content
						$modal.find('.modal-body').outerHeight($('#' + modalId).find('.modal-body').outerHeight() - 20);
						$modal.find('.modal-footer').outerHeight($('#' + modalId).find('.modal-footer').outerHeight() + 20);
					},
					buttons: buttons
				});
			}

			isValid = false;
		}

		return isValid;
	}


	meerkat.modules.register('homeCoverTypeWarning', {
		initHomeCoverTypeWarning: initHomeCoverTypeWarning,
		validateSelections: validateSelections
	});

})(jQuery);