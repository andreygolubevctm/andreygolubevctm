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
			
			
	var data = {
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

	function initHomeCoverTypeWarning() {
		isLandlord =  meerkat.site.isLandlord;
		type = isLandlord ? 'landlord' : 'occupancy';
		input = 'input[name=home_occupancy_ownProperty]';

		if(!initialised) {
			initialised = true;
			$coverType = $('#home_coverType');
			$chosenCoverTypeOption = $('#home_occupancy_coverTypeWarning_chosenOption');
			_changeHandlers();

			// Validate only if both fields have values
			if ($coverType.val() && $(input + ":checked").val()) {
				_.defer(_.bind(validateSelections, this, true));
			}
		}
	}
	
	function _changeHandlers() {
		$(input).on('change.ownHome', function checkOwnership() {
			_.defer(validateSelections);
		});

		$coverType.on('change.cover', function checkOwnership() {
			_.defer(validateSelections);
		});

		$(input).on('change', function tenantChecked() {
			if ($(this).val() === "N" && meerkat.site.isLandlord) {
				_.defer(initTenantModal);
			}
		});
	}
	
	function initTenantModal() {
		if(!meerkat.modules.dialogs.isDialogOpen(warningDialogId)) {
			warningDialogId = meerkat.modules.dialogs.show({
				title: (meerkat.modules.deviceMediaState.get() === 'xs') ? data[type].dialogTitleXS : data[type].dialogTitle,
				onOpen: function (modalId) {
					var $modal = $('#' + modalId);
					$modal.addClass('coverTypeWarningPopup');
					htmlContent = $('#cover-type-warning-template-landlord').html();
					meerkat.modules.dialogs.changeContent(modalId, htmlContent); 
					$modal.find('.modal-body').outerHeight($modal.find('.modal-body').outerHeight() - 20);
					$modal.find('.modal-footer').outerHeight($modal.find('.modal-footer').outerHeight() + 20);
				},
				buttons: [{
					label: data[type].buttons[0],
					className: 'btn-next contentsOnlyBtnWP',
					closeWindow: true,
					action: function() {
						meerkat.site.isLandlord = false;
						meerkat.modules.home.toggleLandlords();
						$chosenCoverTypeOption.val(data[type].buttons[0]);
						$coverType.val("Contents Cover Only");
						$('.notLandlord #home_occupancy_ownProperty_N').prop('checked', true).change();
					}
				},
				{
					label: data[type].buttons[1],
					className: 'btn-next ownBtnWP',
					closeWindow: true,
					action: function() {
						$('#home_occupancy_ownProperty_Y').prop('checked', true).change();
						$chosenCoverTypeOption.val(data[type].buttons[1]);
					}
				}]
			});
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
				
		if (meerkat.modules.journeyEngine.getCurrentStep().navigationId === navigation && $(input + ":checked").val() === 'N'
			&& !isLandlord && ($coverType.val() === 'Home & Contents Cover' || $coverType.val() === 'Home Cover Only')) {

			var buttons = [{
				label : data[type].buttons[0],
				className: "btn-next contentsOnlyBtnWP",
				closeWindow: true,
				action: function() {
					$chosenCoverTypeOption.val(data[type].buttons[0]);
					$coverType.val("Contents Cover Only");
					meerkat.modules.contentPopulation.render('.journeyEngineSlide:eq(0) .snapshot'); // re-render the first step
					meerkat.modules.contentPopulation.render('.journeyEngineSlide:eq(1) .snapshot'); // re-render the occupancy step
					$coverType.trigger('blur');
					validateSelections();
				}
			},{
				label : data[type].buttons[1],
				className: "btn-next ownBtnWP",
				closeWindow: true,
				action: function() {
					$('#home_occupancy_ownProperty_Y').prop('checked', true).change();
					$chosenCoverTypeOption.val(data[type].buttons[1]);
				}
			}];

			if(meerkat.modules.dialogs.isDialogOpen(warningDialogId) === false) {
				warningDialogId = meerkat.modules.dialogs.show({
					title: (meerkat.modules.deviceMediaState.get() === 'xs') ? data[type].dialogTitleXS : data[type].dialogTitle,
					onOpen: function (modalId) {
						// update with the text within the cover type dropdown
						var coverTypeCopy = ($coverType.val() === "Home Cover Only" ? "Home" : "Home and Contents"),
							htmlContent = $('#cover-type-warning-template').html(),
							$modal = $('#' + modalId);
						htmlContent = htmlContent.replace(/\b(placeholder)\b/gi, coverTypeCopy);
						meerkat.modules.dialogs.changeContent(modalId, htmlContent); 

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

        // Go to occupancy only if its valid and first time into journey and
		// if the coverType and ownProperty params are present
        if(isValid && proceedToOccupancy && meerkat.site.brochureValues.coverType && meerkat.site.brochureValues.ownProperty) {
          _.defer(_.bind(meerkat.modules.journeyEngine.gotoPath, this, "occupancy"));
        }

		return isValid;
	}


	meerkat.modules.register('homeCoverTypeWarning', {
		initHomeCoverTypeWarning: initHomeCoverTypeWarning,
		validateSelections: validateSelections
	});

})(jQuery);
