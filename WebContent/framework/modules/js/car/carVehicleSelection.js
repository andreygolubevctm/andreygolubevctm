/**
 * Description: External documentation:
 */

(function($, undefined) {

	var meerkat =window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var moduleEvents = {
			car : {
				VEHICLE_CHANGED : 'VEHICLE_CHANGED',
				DROPDOWN_CHANGED : 'DROPDOWN_CHANGED'
			}
	}, steps = null;

	var elements = {
			makes:				"#quote_vehicle_make",
			makeDes:			"#quote_vehicle_makeDes",
			makesRow:			"#quote_vehicle_makeRow",
			models:				"#quote_vehicle_model",
			modelDes:			"#quote_vehicle_modelDes",
			modelsRow:			"#quote_vehicle_modelRow",
			years:				"#quote_vehicle_year",
			registrationYear:	"#quote_vehicle_registrationYear",
			yearsRow:			"#quote_vehicle_yearRow",
			bodies:				"#quote_vehicle_body",
			bodiesDes:			"#quote_vehicle_bodyDes",
			bodiesRow:			"#quote_vehicle_bodyRow",
			transmissions:		"#quote_vehicle_trans",
			transmissionsRow:	"#quote_vehicle_transRow",
			fuels:				"#quote_vehicle_fuel",
			fuelsRow:			"#quote_vehicle_fuelRow",
			types:				"#quote_vehicle_redbookCode",
			typesRow:			"#quote_vehicle_redbookCodeRow",
			marketValue:		"#quote_vehicle_marketValue",
			variant:			"#quote_vehicle_variant"
	};


	/*-- Re-used HTML snippets --*/
	var snippets = {
			pleaseChooseOptionHTML:		"Please choose...",
			resetOptionHTML:			"&nbsp;",
			notFoundOptionHTML:			"No match for above choices",
			errorInOptionHTML:			"Error finding "
	};

	var	vehicleSelect =	{};
	var RETRY_LIMIT =	3;
	var tryCount =		1;

	var defaults = {};
	var selectorOrder = ['makes','models','years','bodies','transmissions','fuels','types'];
	var selectorData = {};

	var activeSelector = false;

	var ajaxInProgress = false;

	var useSessionDefaults = true;

	var radioButtonFields = ['types'];

	var isSplitTestFlag = false;

	var ajaxRequest = false;

	function abortGetVehicleData() {
		if(ajaxRequest !== false) {
			ajaxRequest.abort();
			enableResetActiveAndEnablePreviousSelectors();
		}
	}

	function getVehicleData( type ) {

		if( ajaxInProgress === false ) {

			activeSelector = type;
			var $element = $(elements[type]);
			var $loadingIconElement = $element;
			if(!$loadingIconElement.closest('.form-group').hasClass('hidden')) {
				meerkat.modules.loadingAnimation.showAfter($loadingIconElement);
			} else {
				$loadingIconElement = $loadingIconElement.closest('.form-group').prev().find('select');
				meerkat.modules.loadingAnimation.showAfter($loadingIconElement);
			}

			var data = {};
			// Ensure data contains all selections from previous fields
			for(var i=0; i<_.indexOf(selectorOrder, type); i++) {
				var previousType = selectorOrder[i];
				if(_.indexOf(selectorOrder, type) > _.indexOf(selectorOrder, 'bodies') && previousType == 'bodies') {
					data.body = $(elements[previousType]).val();
				} else {
					data[previousType.substring(0, previousType.length - 1)] = $(elements[previousType]).val();
				}
			}

			// Flush out the selector which is to be populated
			stripValidationStyles($element);
			if(isSplitTest() && isRadioButtonField(type)) {
				$element.empty();
			} else {
			$element.attr('selectedIndex', 0);
			$element.empty().append(
				$('<option/>',{
					value:''
				}).append(snippets.resetOptionHTML)
			);
			}

			// Prevent previous selectors from being active until response received
			enableDisablePreviousSelectors(type, true);

			ajaxInProgress = true;

			_.defer(function() {
				ajaxRequest = meerkat.modules.comms.get({
					url: "rest/car/" + type + "/list.json",
					data: data,
					cache: true,
					useDefaultErrorHandling: false,
					numberOfAttempts: 3,
					errorLevel: "fatal",
					onSuccess: function onSubmitSuccess(resultData) {
						ajaxRequest = false;
						populateSelectorData(type, resultData);
						renderVehicleSelectorData(type);
						return true;
					},
					onError: onGetVehicleSelectorDataError,
					onComplete: function onSubmitComplete() {
						ajaxRequest = false;
						ajaxInProgress = false;
						meerkat.modules.loadingAnimation.hide($loadingIconElement);
						checkAndNotifyOfVehicleChange();
						disableFutureSelectors(type);
						return true;
					}
				});
			});
		}
	}

	function onGetVehicleSelectorDataError(jqXHR, textStatus, errorThrown, settings, resultData) {
		ajaxRequest = false;
		ajaxInProgress = false;
		meerkat.modules.loadingAnimation.hide($(elements[activeSelector]));
		var previous = getPreviousSelector(activeSelector);
		if(previous !== false) {
			var $e = $(elements[previous]);
			$e.find('option:selected').prop('selected', false);
		}
		// Re-enable the previous selectors
		enableDisablePreviousSelectors(activeSelector, false);
		$(elements[activeSelector]).empty().append(
			$('<option/>',{
				text:snippets.errorInOptionHTML + activeSelector,
				value:''
			})
		).prop('disabled', false).blur();
		meerkat.modules.errorHandling.error({
			message:		"Sorry, we cannot seem to retrieve a list of " + activeSelector + " for your vehicles at this time. Please come back to us later and try again.",
			page:			"vehicleSelection.js:getVehicleSelectorData()",
			errorLevel:		"warning",
			description:	"Failed to retrieve a list of " + activeSelector + ": " + errorThrown,
			data: resultData
		});

		return false;
	}

	// populateSelectorData() populates the selectorData object with data received from
	// an ajax request. Only updates from the current selector forward.
	function populateSelectorData(type, response) {
		flushSelectorData(type);
		for(var i=_.indexOf(selectorOrder, type); i<selectorOrder.length; i++) {
			if(response.hasOwnProperty(selectorOrder[i]) && selectorData.hasOwnProperty(selectorOrder[i])) {
				selectorData[selectorOrder[i]] = response[selectorOrder[i]];
			}
		}
	}

	// flushSelectorData() clears are vehicle data for all sectors after the current one
	function flushSelectorData(type) {
		var start = _.isUndefined(type) ? 0 : _.indexOf(selectorOrder, type);
		for(var i=start; i<selectorOrder.length; i++) {
			selectorData[selectorOrder[i]] = {};
		}
	}

	// renderVehicleSelectorData() renders the current selector (type) from content in selectorData.
	// Will continue to render subsequent selectors if [a] data is available or [b] the current selector
	// on has one option (it is auto-selected)
	function renderVehicleSelectorData(type) {

		if(selectorData.hasOwnProperty(type)){

			activeSelector = type;

			var autoSelect = false;

			var isIosXS = meerkat.modules.performanceProfiling.isIos() && meerkat.modules.deviceMediaState.get() == 'xs';

			if(selectorData[type] && _.isArray(selectorData[type])) {

				var selected = null;
				if(useSessionDefaults === true && defaults.hasOwnProperty(type) && defaults[type] !== '') {
					selected = defaults[type];
				}

				autoSelect = selectorData[type].length === 1;

				$selector = $(elements[type]);

				$selector.empty();

				var options = [];

				if(!isSplitTest() || (isSplitTest() && !isRadioButtonField(type))) {
				options.push(
					$('<option/>',{
						text:snippets.pleaseChooseOptionHTML,
						value:''
					})
				);
				}

				var hasPopularModels = false;
				if(type == "models" && selectorData[type][0].hasOwnProperty('isTopModel') && selectorData[type][0].isTopModel === true) {
					hasPopularModels = true;
				}

				if(type == 'makes' || hasPopularModels) {
					var label = type.charAt(0).toUpperCase() + type.slice(1);
					options.push(
						$('<optgroup/>',{label:"Top " + label})
					);
					options.push(
						$('<optgroup/>',{label:"All " + label})
					);
				} else if((!isSplitTest() || (isSplitTest() && !isRadioButtonField(type))) && isIosXS && autoSelect !== true) {
					options.push(
						$('<optgroup/>',{label:(type.charAt(0).toUpperCase() + type.slice(1))})
					);
				}

				for(var i in selectorData[type]){
					if(selectorData[type].hasOwnProperty(i)) {
						if(typeof selectorData[type][i] === 'function')
							continue;
						var item = selectorData[type][i];
						var option = null;
						if(isSplitTest() && isRadioButtonField(type)) {
							var radio_name = 'quote_vehicle_redbookCode';
							option = $('<div/>', {
										'class': "radioCustom"
									}).append(
											$('<input/>', {
												'type': "radio",
												'id': radio_name + '_' + item.code,
												'name': radio_name,
												'value': item.code,
												'required': "required",
												'data-autosave': "true",
												'data-msg-required': "Please select a vehicle type"
											})
										).append(
											$('<label/>', {
												'for': radio_name + '_' + item.code,
												'text': item.label
											})
										);

						} else {
							option = $('<option/>',{
							text:item.label,
							value:item.code
						});
						}

						if( selected !== true && (autoSelect === true || (!_.isNull(selected) && selected == item.code)) ) {
							if(isSplitTest() && isRadioButtonField(type)) {
								option.find('input').prop('checked', true);
							} else {
							option.prop('selected', true);
							}
							selected = true;
						}

						if(type == 'makes' || (type == "models" && hasPopularModels)) {
							if(item[hasPopularModels ? 'isTopModel' : 'isTopMake'] === true) {
								option.appendTo(options[1], options[2]);
							} else {
								options[2].append(option);
							}
						} else {
							if((!isSplitTest() || (isSplitTest() && !isRadioButtonField(type))) && isIosXS && autoSelect !== true) {
								options[1].append(option);
							} else {
								options.push(option);
							}
						}
					}
				}

				// Append all the options to the selector
				for(var o=0; o<options.length; o++) {
					$selector.append(options[o]);
				}

				// Add listener to selector if is radio group
				if(isSplitTest() && isRadioButtonField(type)) {
					addChangeListenerToRadioGroup($selector, type);
				}

				// Enable the selector and make it visible
				$selector.prop("disabled", false);
				if(!$selector.is(':visible')) {
					$(elements[type + 'Row']).removeClass('hidden');
				}

				if(type === 'makes') {
				disableFutureSelectors(type);
				}

				stripValidationStyles($selector);

				// If auto-selected then trigger blur to give it the valid styling
				if(autoSelect === true || !_.isNull(selected)) {
					addValidationStyles($selector);
					$selector.blur();
				}

				// Re-enable the previous selectors - don't think to move this to the
				// on-complete as there's a race condition that will enable them
				enableDisablePreviousSelectors(type, false);

				// Determine whether to render any subsequent selectors
				var next = getNextSelector(type);
				meerkat.messaging.publish(moduleEvents.car.DROPDOWN_CHANGED);
				if(next !== false) {
					// Next selector has data so render it
					if(_.isArray(selectorData[next]) && !_.isEmpty(selectorData[next])) {
						renderVehicleSelectorData(next);
					// Selector auto-selected so get data for next selector
					} else if(autoSelect === true) {
						ajaxInProgress = false;
						getVehicleData(next);
					}
				}

			// No matches results found
			} else {
				if(isSplitTest() && isRadioButtonField(type)) {
					$(elements[activeSelector + 'Row']).addClass('hidden');
					$(elements[activeSelector]).empty();
				} else {
				$(elements[activeSelector]).empty().append(
					$('<option/>',{
						text:snippets.notFoundOptionHTML,
						value:''
					})
				);
			}
		}
	}
	}

	function getPreviousSelector(current) {
		var prev = _.indexOf(selectorOrder, current) - 1;
		if(selectorOrder.hasOwnProperty(prev)) {
			return selectorOrder[prev];
		}

		return false;
	}

	function getNextSelector(current) {
		var next = _.indexOf(selectorOrder, current) + 1;
		if(selectorOrder.hasOwnProperty(next)) {
			return selectorOrder[next];
		}

		return false;
	}

	function emptyElement($element) {
		$element.empty();
	}

	function disableFutureSelectors(current) {
		var indexOfActiveSelector = _.indexOf(selectorOrder, current);
		if(indexOfActiveSelector > -1 ) {
			for(var i=0; i<selectorOrder.length; i++) {
				if(elements.hasOwnProperty(selectorOrder[i])) {
					var $e = $(elements[selectorOrder[i]]);
					if(i > indexOfActiveSelector) {
						if(isSplitTest() && isRadioButtonField(selectorOrder[i])) {
							$(elements[selectorOrder[i] + 'Row']).addClass('hidden');
							$e.empty();
						} else {
							$e.attr('selectedIndex', 0);
							$e.empty().append(
								$('<option/>',{
									value:''
								}).append(snippets.resetOptionHTML)
							);
							if(i >= 3) {
								$e.closest('.fieldrow').addClass('hidden');
							}
						}
					stripValidationStyles($e);
						$e.prop("disabled", true);
						if(indexOfActiveSelector === 1) {
							$(elements.marketValue).val('');
							$(elements.variant).val('');
							$(elements.modelDes).val('');
							$(elements.registrationYear).val('');
				}
			}
		}
	}
	}
	}

	function enableDisablePreviousSelectors(current, disabled) {
		disabled = disabled || false;
		for(var i=0; i<=_.indexOf(selectorOrder, current); i++) {
			$(elements[selectorOrder[i]]).prop('disabled', disabled);
		}
	}

	function enableResetActiveAndEnablePreviousSelectors() {
		activeSelector = getPreviousSelector(activeSelector);
		$el = $(elements[activeSelector]);
		stripValidationStyles($el);
		$el.prop('selectedIndex', 0);
		enableDisablePreviousSelectors(activeSelector, false);
	}

	function hardResetSelectors() {
		activeSelector = selectorOrder[0];
		var $el = $(elements[activeSelector]);
		$el.prop('selectedIndex', 0);
		stripValidationStyles($el);
		disableFutureSelectors(activeSelector);
		_.defer(function(){
			meerkat.messaging.publish(meerkatEvents.carSnapshot.RENDER_CAR_SNAPSHOT);
		});
	}

	function selectionChanged(data) {
		useSessionDefaults = false;
		var next = getNextSelector(data.field);
		var invalid = _.isEmpty($(elements[data.field]).val());
		if(invalid === true) {
			stripValidationStyles($(elements[data.field]));
			disableFutureSelectors(data.field);
		}
		// Attempt to populate hidden fields
		var make = getDataForCode('makes', $(elements.makes).val());
		if(make !== false) {
			$(elements.makeDes).val(make.label);
		} else {
			$("span[data-source='#quote_vehicle_make']").text('');
		}
		var model = getDataForCode('models', $(elements.models).val());
		if(model !== false) $(elements.modelDes).val(model.label);
		var year = getDataForCode('years', $(elements.years).val());
		if(year !== false) $(elements.registrationYear).val(year.code);
			// Attempt to populate the next field
		if(invalid === false && next !== false) {
			disableFutureSelectors(next);
			getVehicleData(next);
		}

		if(data.field === 'types') {
			var $element = $(elements.types);
			if(
				(isSplitTest() && $element.find('input:checked'))
				||
				(!isSplitTest() && !_.isEmpty($element.val()))
			) {
				addValidationStyles($element);
			checkAndNotifyOfVehicleChange();
		}
		}
		meerkat.messaging.publish(moduleEvents.car.DROPDOWN_CHANGED);
	}

	function addChangeListeners() {
		for(var i=0; i<selectorOrder.length; i++) {
			if(selectorOrder.hasOwnProperty(i)) {
				if(isSplitTest() && isRadioButtonField(selectorOrder[i])){
					addChangeListenerToRadioGroup($(elements[selectorOrder[i]]), selectorOrder[i]);
				} else {
					$(elements[selectorOrder[i]]).off().on("change", _.bind(selectionChanged, this, {field:selectorOrder[i]}));
			}
		}
	}
	}

	function addChangeListenerToRadioGroup($element, type) {
		$element.find("input[type=radio]").off().on("change", _.bind(selectionChanged, this, {field:type}));
	}

	function stripValidationStyles(element) {
		element.removeClass('has-success has-error');
		element.closest('.form-group').find('.row-content').removeClass('has-success has-error')
		.end().find('.error-field').remove();
	}

	function addValidationStyles(element) {
		element.addClass('has-success');
		element.closest('.form-group').find('.row-content').addClass('has-success');
	}

	function getDataForCode(type, code) {
		if(!_.isEmpty(code)) {
			for(var i=0; i<selectorData[type].length; i++) {
				if(code == selectorData[type][i].code) {
					return selectorData[type][i];
				}
			}
		}
		return false;
	}

	function checkAndNotifyOfVehicleChange() {
		var vehicle = isSplitTest() ? $(elements.types).find("input:checked") : $(elements.types);
		var rbc = vehicle ? vehicle.val() : null;
		if(!_.isEmpty(rbc)){

			// Set hidden field values
			var make = getDataForCode('makes', $(elements.makes).val());
			if(make !== false) $(elements.makeDes).val(make.label);

			var model = getDataForCode('models', $(elements.models).val());
			if(model !== false) $(elements.modelDes).val(model.label);

			var year = getDataForCode('years', $(elements.years).val());
			if(year !== false) $(elements.registrationYear).val(year.code);

			var type = getDataForCode('types', rbc);
			if(type !== false) {
				$(elements.marketValue).val(type.marketValue);
				$(elements.variant).val(type.label);
			}

			if(isSplitTest()) {
				_.defer(function(){
			meerkat.messaging.publish(moduleEvents.car.VEHICLE_CHANGED);
				});
			} else {
				meerkat.messaging.publish(moduleEvents.car.VEHICLE_CHANGED);
			}
		}
	}

	function prepareSelectors(selectionDefaults, callback) {

		useSessionDefaults = true; // important, must be set to ensure preselection (is reset on change)

		flushSelectorData();

		defaults = _.extend({}, selectionDefaults);
		selectorData = _.extend({}, selectionDefaults.data);

		addChangeListeners();

		renderVehicleSelectorData('makes');

		checkAndNotifyOfVehicleChange();

		if(!isSplitTest() && meerkat.modules.performanceProfiling.isIE8()) {
			$(document).on('focus', '#quote_vehicle_redbookCode', function() {
				var el = $(this);
				el.data('width', el.width());
				el.width('auto');
				el.data('width-auto', $(this).width());
				// if "auto" width < start width, set to start width, otherwise set to new width
				if(el.data('width-auto') < el.data('width')) {
					el.width(el.data('width'));
				} else {
					el.width(el.data('width-auto')+15);
				}
			}).on('blur', '#quote_vehicle_redbookCode', function() {
				var el = $(this);
				el.width(el.data('width'));
				// make it reset
			});
		}

		if(_.isFunction(callback)) {
			callback();
		}
	}

	function initCarVehicleSelection() {

		var self = this;

		meerkat.messaging.subscribe(meerkatEvents.regoLookup.REGO_LOOKUP_FORM_IN_USE, hardResetSelectors);
		meerkat.messaging.subscribe(meerkatEvents.regoLookup.REGO_LOOKUP_STARTED, abortGetVehicleData);
		meerkat.messaging.subscribe(meerkatEvents.regoLookup.REGO_LOOKUP_COMPLETE, prepareSelectors);

		$(document).ready(function() {

			// Only init if health... obviously...
			if (meerkat.site.vertical !== "car")
				return false;

			isSplitTestFlag = meerkat.modules.splitTest.isActive(8);
			for(var i=0; i<selectorOrder.length; i++) {
				$(elements[selectorOrder[i]]).attr('tabindex', i + 1);
			}

			prepareSelectors(meerkat.site.vehicleSelectionDefaults);
		});

	}

	function isRadioButtonField(type) {
		return _.indexOf(radioButtonFields, type) > -1;
	}

	function isSplitTest() {
		return isSplitTestFlag;
	}

	meerkat.modules.register("carVehicleSelection", {
		init : initCarVehicleSelection,
		events : moduleEvents,
		isSplitTest : isSplitTest
	});

})(jQuery);