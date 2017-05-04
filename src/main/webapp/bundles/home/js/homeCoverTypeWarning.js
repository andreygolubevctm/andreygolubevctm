/**
 * Brief explanation of the module and what it achieves. <example: Example pattern code for a meerkat module.>
 * Link to any applicable confluence docs: <example: http://confluence:8090/display/EBUS/Meerkat+Modules>
 */

;(function($, undefined){

	var meerkat = window.meerkat,
			isLandlord,
			$coverType,
			type,
			input,
			$chosenCoverTypeOption,
			warningDialogId = null,
			initialised = false;

	function initHomeCoverTypeWarning() {
		isLandlord =  meerkat.site.isLandlord;
		type = isLandlord ? 'landlord' : 'occupancy';
		input = 'input[name=home_occupancy_ownProperty]';

		if(!initialised) {
			initialised = true;
			$coverType = $('#home_coverType');
			$chosenCoverTypeOption = $('#home_occupancy_coverTypeWarning_chosenOption');

			$(input).on("change.ownHome", function checkOwnership() {
				_.defer(validateSelections);
			});

			$coverType.on("change.cover", function checkOwnership() {
				_.defer(validateSelections);
			});

			// Validate only if both fields have values
			if ($coverType.val() && $(input + ":checked").val()) {
				_.defer(_.bind(validateSelections, this, true));
			}
		}
	}

	function resetValues() {
		isLandlord = meerkat.site.isLandlord;
		type = isLandlord ? 'landlord' : 'occupancy';
	}

	function validateSelections(proceedToOccupancy) {
		if (isLandlord !== meerkat.site.isLandlord) {
			resetValues();
		}

		var isValid = true,
				navigation = 'start';

		var typeInfo = {
			occupancy: {
				dialogTitle: "Oops, did you want to get contents only insurance?",
				dialogTitleXS: "Oops, did you want contents only insurance?",
				buttons: ["Switch to contents only", "I own or am paying off the home"]
			},
			landlord: {
				dialogTitle: "Oops, are you renting your current property?",
				dialogTitleXS: "Oops, are you renting your current property?",
				buttons: ["Switch to contents only", "I am the landlord"]
			}
		};

		if (meerkat.modules.journeyEngine.getCurrentStep().navigationId === navigation && $(input + ":checked").val() === 'N'
			&& ($coverType.val() === 'Home & Contents Cover' || $coverType.val() === 'Home Cover Only')) {

			var buttons = [{
				label : typeInfo[type].buttons[0],
				className: "btn-next contentsOnlyBtnWP",
				closeWindow: true,
				action: function() {
					$chosenCoverTypeOption.val(typeInfo[type].buttons[0]);
					$coverType.val("Contents Cover Only");
					meerkat.modules.contentPopulation.render('.journeyEngineSlide:eq(0) .snapshot'); // re-render the first step
					meerkat.modules.contentPopulation.render('.journeyEngineSlide:eq(1) .snapshot'); // re-render the occupancy step
					$coverType.trigger('blur');
					validateSelections();
				}
			},{
				label : typeInfo[type].buttons[1],
				className: "btn-next ownBtnWP",
				closeWindow: true,
				action: function() {
					$('#home_occupancy_ownProperty_Y').prop('checked', true).change();
					$chosenCoverTypeOption.val(typeInfo[type].buttons[1]);
				}
			}];

			if(meerkat.modules.dialogs.isDialogOpen(warningDialogId) === false) {
				warningDialogId = meerkat.modules.dialogs.show({
					title: (meerkat.modules.deviceMediaState.get() === 'xs') ? typeInfo[type].dialogTitleXS : typeInfo[type].dialogTitle,
					onOpen: function (modalId) {
						// update with the text within the cover type dropdown
						var coverTypeCopy = ($coverType.val() === "Home Cover Only" ? "Home" : "Home and Contents"),
							htmlContent = (type === 'occupancy' ? $('#cover-type-warning-template').html() : $('#cover-type-warning-template-landlord').html()),
							$modal = $('#' + modalId);
						htmlContent = htmlContent.replace(/\b(placeholder)\b/gi, coverTypeCopy);
						meerkat.modules.dialogs.changeContent(modalId, htmlContent); // update the content

						$modal.addClass('coverTypeWarningPopup'); // add class for css

						// tweak the sizing to fit the content
						$modal.find('.modal-body').outerHeight($modal.find('.modal-body').outerHeight() - 20);
						$modal.find('.modal-footer').outerHeight($modal.find('.modal-footer').outerHeight() + 20);
					},
					buttons: buttons
				});
			}

			isValid = false;
		}

		// Go to occupancy only if its valid and first time into journey
		if(isValid && proceedToOccupancy) {
			_.defer(_.bind(meerkat.modules.journeyEngine.gotoPath, this, "occupancy"));
		}

		return isValid;
	}


	meerkat.modules.register('homeCoverTypeWarning', {
		initHomeCoverTypeWarning: initHomeCoverTypeWarning,
		validateSelections: validateSelections
	});

})(jQuery);
