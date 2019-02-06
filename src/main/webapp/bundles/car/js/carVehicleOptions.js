/**
 * Description: External documentation:
 */

(function($, undefined) {

	var meerkat =window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var moduleEvents = {
			car : {
				VEHICLE_CHANGED : 'VEHICLE_CHANGED'
			},
			carVehicleOptions : {
				UPDATED_VEHICLE_DATA : 'UPDATED_VEHICLE_DATA'
			}
	};

	var elements = {
			factory : {
				radio:			"#quote_vehicle_factoryOptionsRadioBtns",
				yn:				"#quote_vehicle_factoryOptions",
				button:			"#quote_vehicle_factoryOptionsButton",
				template:		"#quote-factoryoptions-template",
				checkboxes:		"#quote_vehicle_factoryOptionsDialog .quote-factory-options",
				inputs:			"#quote_vehicle_options_inputs_container .factory:first",
				saveditems:		"#quote_vehicle_factoryOptionsSelections .added-items ul"
			},
			accessories : {
				radio:			"#quote_vehicle_accessoriesRadioBtns",
				yn:				"#quote_vehicle_accessories",
				button:			"#quote_vehicle_accessoriesButton",
				template:		"#quote-nonstandard-accessories-template",
				inputs:			"#quote_vehicle_options_inputs_container .accessories:first",
				wrapper :		"#quote_vehicle_accessoriesDialog .quote-optional-accessories-listed",
				type :			"#quote_vehicle_accessoriesDialog .ac-type",
				included :		"#quote_vehicle_accessoriesDialog .ac-included",
				price :			"#quote_vehicle_accessoriesDialog .ac-price",
				add :			"#quote_vehicle_accessoriesDialog .ac-add",
				clear :			"#quote_vehicle_accessoriesDialog .ac-clear",
				addeditems :	"#quote_vehicle_accessoriesDialog .quote-optional-accessories-listed .added-items ul",
				saveditems:		"#quote_vehicle_accessoriesSelections .added-items ul"
			},
			redbook:			"#quote_vehicle_redbookCode"

	};

	elements.accessories.wrapper = "#quote_vehicle_accessoriesDialog .quote-optional-accessories-listed";

	var isIE8 = false;

	var modals = {factory:{},accessories:{}};

	var vehicleOptionsData = {};
	var vehicleNonStandardAccessories = [];

	var optionPreselections = {};

	var savedSelections = {
			factory:		[],
			accessories:	[]
	};

	var isFirstLoad = true;

	var ajaxInProgress = false;

	var sessionCamStep = null;

	function getVehicleData(callback) {

		if( ajaxInProgress === false ) {

			var $element = $(elements.factory.button);

			meerkat.modules.loadingAnimation.showAfter($element);

			var data = {redbookCode:$(elements.redbook).val()};

			ajaxInProgress = true;

			meerkat.modules.comms.get({
				url: "rest/car/vehicleAccessories/list.json",
				data: data,
				cache: true,
				useDefaultErrorHandling: false,
				numberOfAttempts: 3,
				errorLevel: "fatal",
				onSuccess: function onSubmitSuccess(resultData) {
					vehicleOptionsData = resultData;
					sanitiseVehicleOptionsData();
					meerkat.messaging.publish(moduleEvents.carVehicleOptions.UPDATED_VEHICLE_DATA, vehicleOptionsData);
					toggleFactoryOptionsFieldSet();
					if(_.isFunction(callback)) {
						callback();
					}
				},
				onError: onGetVehicleDataError,
				onComplete: function onSubmitComplete() {
					ajaxInProgress = false;
					meerkat.modules.loadingAnimation.hide($element);
				}
			});
		}
	}

	function onGetVehicleDataError(jqXHR, textStatus, errorThrown, settings, resultData) {
		meerkat.modules.errorHandling.error({
			message:		"Sorry, we cannot seem to retrieve a list of accessories for your vehicles at this time. Please come back to us later and try again.",
			page:			"carVehicleOptions.js:getVehicleData()",
			errorLevel:		"warning",
			description:	"Failed to retrieve a list of accessories for RedBook Code: " + errorThrown,
			data:			resultData
		});
	}

	function sanitiseVehicleOptionsData() {
		var list = ['alarm','immobiliser','options','standard'];
		if(!_.isObject(vehicleOptionsData)) {
			vehicleOptionsData = {};
		}
		for(var i=0; i<list.length; i++) {
			if(!vehicleOptionsData.hasOwnProperty(list[i]) || !_.isArray(vehicleOptionsData[list[i]])) {
				vehicleOptionsData[list[i]] = [];
			}
		}
	}

	function renderFactoryModal() {
		// Pass in the list of included items as string of html LI's
		var optionalAccessories = generateFactoryOptionsHTML(vehicleOptionsData.options);
		var standardAccessories = generateStandardAccessoriesHTML(vehicleOptionsData.standard);

		var templateAccessories = _.template($(elements.factory.template).html());

		var htmlContent = templateAccessories({
				optionalAccessories: optionalAccessories,
				standardAccessories: standardAccessories
		});

		modals.factory = meerkat.modules.dialogs.show({
			title : $(this).attr('title'),
			htmlContent : htmlContent,
			hashId : 'factory-options',
			tabs : [{
				title:'Add Factory/Dealer Options',
				xsTitle:'Factory/Dealer Options',
				targetSelector:'.quote-factory-options'
			},{
				title: 'View Included Standard Accessories',
				xsTitle: 'Standard Accessories',
				targetSelector: '.quote-standard-accessories'
			}],
			buttons: [{
				label: 'Save Changes',
				className: 'btn-save',
				action: _.bind(saveCurrentForm, this, {type:'factory'})
			}],
			rightBtn: {
				label: 'Save Changes',
				className: 'btn-sm btn-save',
				callback: _.bind(saveCurrentForm, this, {type:'factory'})
			},
			closeOnHashChange: true,
			openOnHashChange: false,
			onClose : function(){
				meerkat.modules.sessionCamHelper.updateVirtualPage(getSessionCamStep());
				toggleButtonStates({type:'factory'});
			},
			onOpen : function(dialogId) {

				// Toggle select options form depending on whether content is available
				if(_.isArray(vehicleOptionsData.options) && vehicleOptionsData.options.length){
					$('.quote-factory-options .no-items-found').addClass('hidden');
				} else {
					$('.quote-factory-options .items-found').addClass('hidden');
				}

				// Toggle included accessories list depending on whether content is available
				if(_.isArray(vehicleOptionsData.standard) && vehicleOptionsData.standard.length){
					$('.quote-standard-accessories .no-items-found').addClass('hidden');
				} else {
					$('.quote-standard-accessories .items-found').addClass('hidden');
				}

				$('#' + dialogId).on('click', '.nav-tabs a', function(e) {
					e.preventDefault();
					e.stopPropagation();

					var sessionCamStep = getSessionCamStep();
					sessionCamStep.navigationId += "-FactoryDealerOptions-" + $(this).attr('data-target').split("-")[2];
					meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);

					$(this).tab('show');
					$('#' + dialogId + ' .modal-title-label').html($(this).attr('title'));
				});
				$('.nav-tabs a:first').click();

				if (isIE8) {
					_.defer(function(){
						$(function() {
							$('html.lt-ie9 form#quote_vehicle_factoryOptionsDialogForm').on('change.checkedForIE', '.checkbox input, .compareCheckbox input', function applyCheckboxClicks() {
								var $this = $(this);
								if($this.is(':checked')) {
									$this.addClass('checked');
								}
								else {
									$this.removeClass('checked');
								}
							});

							$('html.lt-ie9 form#quote_vehicle_factoryOptionsDialogForm .checkbox input').change();
						});
					});
				}

				$('#' + dialogId + ' .btn-save').attr('data-analytics','nav button');
			}
		});

		return false;
	}

	function renderAccessoriesModal() {
		// Pass in the list of included items as string of html LI's
		var standardAccessories = generateStandardAccessoriesHTML(vehicleOptionsData.standard);
		var selectedAccessories = generateSelectedAccessoriesHTML();

		var templateAccessories = _.template($(elements.accessories.template).html());

		var accessories = optionPreselections.accessories.accs;
		var savedAccessories = $(elements.accessories.saveditems).children();
		var selectedIndexes = [];
		var selectedPrices = [];

		$.each(savedAccessories, function(index, savedAccessory) {
			savedAccessory = $(this);
			var itemIndex = savedAccessory.attr('itemIndex');
			var itemPrice = savedAccessory.attr('itemPrice');
			selectedIndexes.push(parseInt(itemIndex));
			selectedPrices.push(itemPrice);
		});

		var htmlContent = templateAccessories({
				standardAccessories: standardAccessories,
				vehicleNonStandardAccessories: vehicleNonStandardAccessories
		});

		var optionalTargetSelector = '.quote-optional-accessories-listed';
		var standardTargetSelector = '.quote-standard-accessories';

		modals.accessories = meerkat.modules.dialogs.show({
				title : $(this).attr('title'),
				htmlContent : htmlContent,
				hashId : 'accessories',
				tabs : [{
					title:'Add Non-Standard Accessories',
					xsTitle:'Non-Standard Accessories',
					targetSelector: optionalTargetSelector
				},{
					title: 'View Included Standard Accessories',
					xsTitle: 'Standard Accessories',
					targetSelector: standardTargetSelector
				}],
				buttons: [{
					label: 'Save Changes',
					className: 'btn-save',
					action: _.bind(saveCurrentForm, this, {type:'accessories'})
				}],
				rightBtn: {
					label: 'Save Changes',
					className: 'btn-sm btn-save',
					callback: _.bind(saveCurrentForm, this, {type:'accessories'})
				},
				closeOnHashChange: true,
				openOnHashChange: false,
				onClose : function(){
					meerkat.modules.sessionCamHelper.updateVirtualPage(getSessionCamStep());
					toggleButtonStates({type:'accessories'});
				},
				onOpen : function(dialogId) {

					// Steal the injection div and add it to the header.
					var $injectBlock = $('#injectIntoHeader');
					$injectBlock.remove();
					$('.modal-header').append($injectBlock);
					$('#quote_vehicle_accessoriesDialog').parent().css({'padding-top': '5px'});

					// Toggle add accessories form depending on whether content is available
					if(_.isArray(vehicleNonStandardAccessories) && vehicleNonStandardAccessories.length){
						$('.quote-optional-accessories-listed .no-items-found').addClass('hidden');
					} else {
						$('.quote-optional-accessories-listed .items-found').addClass('hidden');
					}

					// Toggle included accessories list depending on whether content is available
					if(_.isArray(vehicleOptionsData.standard) && vehicleOptionsData.standard.length){
						$('.quote-standard-accessories .no-items-found').addClass('hidden');
					} else {
						$('.quote-standard-accessories .items-found').addClass('hidden');
					}

					$('#' + dialogId).on('click', '.nav-tabs a', function(e) {
						if ($(this).attr('data-target') == standardTargetSelector) {
							$injectBlock.hide();
						} else {
							$injectBlock.show();
						}
						e.preventDefault();
						e.stopPropagation();

						var sessionCamStep = getSessionCamStep();
						sessionCamStep.navigationId += "-NonStandardAccessories-" + $(this).attr('data-target').split("-")[1];
						meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);

						$(this).tab('show');
						$('#' + dialogId + ' .modal-title-label').html($(this).attr('title'));
					});
					$('.nav-tabs a:first').click();
					onAccessoriesFormRendered();

					$('#' + dialogId + ' .btn-save').attr('data-analytics','nav button');
				}
		});

		return false;
	}

	function onAccessoriesFormRendered() {

		$('.nonStandardAccessoryCheckbox').on('change', function(){
			var $rowCheckbox = $(this).find(":input").first(),
				itemIndex = $rowCheckbox.attr('itemIndex'),
				$relatedPriceSelect = $('select[itemIndex="'+itemIndex+'"]');

			// Add or remove the disabled property on the dropdown based on checked status.
			if ($rowCheckbox.prop('checked')) {
				$relatedPriceSelect.prop('disabled', false);
			} else {
				$relatedPriceSelect.prop('disabled', true);
				$relatedPriceSelect.val('');
			}
		});

		// Watch the dropdowns to remove any errors that may have been added previously, or add an error if the user selects nothing.
		$('.nonStandardAccessorySelect').on('change', function() {
			var selectBox = $(this);
			if (selectBox.val() === '') {
				selectBox.parent().addClass('has-error');
			} else {
				selectBox.parent().removeClass('has-error');
			}
			});

		// Add events etc to previously saved selections (lost through template rendering)
		for(var i=0; i<savedSelections.accessories.length; i++) {
			var item = savedSelections.accessories[i];
			var $parent = $(elements.accessories.addeditems);
			var $li = $parent.find('li.added-item-' + item.position).first();
			$li.data('info', item);
			$li.find('a:first').on('click', _.bind(onRemoveAccessoriesItem, this, item));
		}

		meerkat.modules.checkboxIE8.support();
	}

	function getAddedAccessoryItemHTML(item) {

		// Append to selected list
		return $("<li/>")
		.addClass('added-item-' + item.position)
		.data("info", item)
		.append(
			$("<span/>").append(item.label)
		)
		.append(
			$("<a/>",{
				title:"remove accessory"
			}).addClass("icon-cross")
			.on('click', _.bind(onRemoveAccessoriesItem, this, item))
		);
	}

	function onRemoveAccessoriesItem(item) {

		// remove added element from selected view
		$(elements.accessories.addeditems).find('.added-item-' + item.position).remove();

		// Add back to selector
		$(elements.accessories.type).find('option').each(function(){
			if(parseInt($(this).val(), 10) > item.position) {
				$(this).before(
					$('<option/>',{
						text:	item.label,
						value:	item.position + "_" + item.code
					})
				);
				return false;
			}
		});
	}

	function generateFactoryOptionsHTML(data) {
		var output = $('<ul/>');
		for(var i=0; i<data.length; i++) {
			var obj = data[i];
			var id = 'tmp_fact_' + i + '_chk';
			var name = 'tmp_quote_opts_opt' + ("00" + i).slice(-3);
			var chkbox = $('<input/>',{
					type:	'checkbox',
					name:	name,
					id:		id,
					value:	obj.code
			});
			if(_.indexOf(savedSelections.factory, id) !== -1) {
				chkbox.attr('checked', true);
			}
			output.append(
				$('<li/>').append(
					$('<div/>').addClass('checkbox')
					.append(chkbox)
					.append(
						$('<label/>').attr('for', id)
						.append(cleanText(obj.label))
					)
				)
			);
		}

		return output.html();
	}

	function generateAccessoryOptionsHTML(data) {
		var output = $('<select/>');
		var options = [];
		options.push(
			$('<option/>',{
					text:	"please choose...",
					value:	""
			})
		);

		function isInSavedSelections(code) {
			for(var s=0; s<savedSelections.accessories.length; s++) {
				if(code == savedSelections.accessories[s].code) {
					return true;
				}
			}
			return false;
		}

		for(var i=0; i<data.length; i++) {
			var obj = data[i];

			var option = $('<option/>',{
					text:	obj.label,
					value:	("0" + i).slice(-2) + "_" + String(obj.code).replace("/", "/ ")
					/* Replace above is for IE8 which break option with trailing fwd-slash */
			});

			if(!isInSavedSelections(obj.code)) {
				options.push( option );
			}
		}
		for(var j=0; j<options.length; j++) {
			output.append(options[j]);
		}

		return output.html();
	}

	function generateStandardAccessoriesHTML(data) {
		var output = $('<ul/>');
		for(var i=0; i<data.length; i++) {
			var obj = data[i];
			output.append(
				$('<li/>',{text:cleanText(obj.label)})
			);
		}

		return output.html();
	}

	function generateSelectedAccessoriesHTML() {
		var output = $('<ul/>');
		for(var i=0; i<savedSelections.accessories.length; i++) {
			output.append(
				getAddedAccessoryItemHTML(savedSelections.accessories[i])
			);
		}
		return output.html();
	}

	function getAccessoryByCode(code) {
		for(var i=0; i<vehicleNonStandardAccessories.length; i++) {
			if(vehicleNonStandardAccessories[i].code === code) {
				return vehicleNonStandardAccessories[i];
			}
		}

		return false;
	}

	function getFactoryOptionByIndex(index) {
		if(vehicleOptionsData.options.hasOwnProperty(index)) {
			return vehicleOptionsData.options[index];
		}

		return false;
	}

	function getFactoryOptionByCode(code) {
		for(var i=0; i<vehicleOptionsData.options.length; i++) {
			if(code === vehicleOptionsData.options[i].code) {
				return vehicleOptionsData.options[i];
			}
		}

		return false;
	}

	function renderPreselections() {
		// Flush any existing elements
		$(elements.factory.inputs).empty();
		$(elements.factory.saveditems).empty();
		$(elements.accessories.inputs).empty();
		$(elements.accessories.saveditems).empty();

		var factory = optionPreselections.factory;
		var accessories = optionPreselections.accessories;

		if(!_.isUndefined(factory) && !_.isEmpty(factory)) {
			// Populate savedSelections.factory
			for(var i in factory.opts) {
				if(factory.opts.hasOwnProperty(i)) {
					var pos = String(parseInt(i.substring(3), 10));
					var name = "tmp_fact_" + pos + "_chk";
					var fItem = getFactoryOptionByIndex(pos);
					fItem.position = ("00" + pos).slice(-3);

					if(fItem !== false) {
						savedSelections.factory.push("tmp_fact_" + pos + "_chk");
						$(elements.factory.inputs).append(
							getInputHTML({
								id:		name.slice(4),
								name:	"quote_opts_opt" + ("00" + pos).slice(-3),
								value:	fItem.code
							})
						);

						// Append item to list view in the main form
						renderExistingSelectionToMainForm({
							type: 'factory',
							item: fItem
						});
					}
				}
			}
		}

		if(!_.isUndefined(accessories) && !_.isEmpty(accessories)) {
			// Populate savedSelections.accessories
			for(var j in accessories.accs) {
				if(accessories.accs.hasOwnProperty(j)) {
					var aItem = accessories.accs[j];
					var itemInfo = getAccessoryByCode(aItem.sel);
					var obj = {
							included:	aItem.inc === 'Y' ,
							position: parseInt(j.substring(3), 10),
							price: aItem.hasOwnProperty("prc") ? String(aItem.prc) : '0',
							code: aItem.sel,
							label: itemInfo.label
					};
					savedSelections.accessories.push(obj);
					addSavedAccessoryHTML(obj);
				}
			}
		}

		toggleButtonStates({type:'factory'});
		toggleButtonStates({type:'accessories'});
	}

	function onRemoveSavedItem(item) {

		$(".saved-item-" + item.type + '-' + item.position).remove();

		if(item.type == 'factory') {
			for(var i = 0; i < savedSelections.factory.length; i++) {
				if(savedSelections.factory[i] == 'tmp_fact_' + parseInt(item.position, 10) + '_chk') {
					savedSelections.factory.splice(i, 1);
				}
			}

			if(_.isEmpty(savedSelections.factory)) {
				toggleButtonStates({type:'factory'});
			}
		} else {
			for(var j = 0; j < savedSelections.accessories.length; j++) {
				if(savedSelections.accessories[j].code == item.code) {
					savedSelections.accessories.splice(j, 1);
				}
			}

			if(_.isEmpty(savedSelections.accessories)) {
				toggleButtonStates({type:'accessories'});
			}
		}
	}

	function getSavedAccessoryItemHTML(item) {
		// Append to selected list
		var $li = $("<li/>")
		.addClass('saved-item-' + item.type + '-' + item.position)
		.attr("itemIndex", item.position)
		.append(
			$("<span/>").append(item.label)
		)
		.append(
			$("<a/>",{
				title:"remove " + (item.type == "factory" ? "factory option" : "accessory")
			}).addClass("icon-cross")
			.on('click', _.bind(onRemoveSavedItem, this, item))
		);

		return $li;
	}

	function renderExistingSelectionToMainForm(data) {
		var item = {
				type: data.type,
				position: '',
				label: '',
				price: null,
				code: '',
				item: null
		};

		if(data.type == 'accessories') {
			item.position = data.item.position;
			item.label = data.item.label;
			item.code = data.item.code;
			item.item = data.item;
			$(elements.accessories.saveditems).append(
				getSavedAccessoryItemHTML(item)
			);
		} else {
			item.position = data.item.position;
			item.label = data.item.label;
			item.code = data.item.code;
			item.item = data.item;
			$(elements.factory.saveditems).append(
				getSavedAccessoryItemHTML(item)
			);
		}
	}

	function onVehicleChanged() {

		if(isFirstLoad === false) {
			// When preload or load quote we dont want to lose preselections
			savedSelections.factory = [];
			savedSelections.accessories= [];
			savedSelections.accessories= [];
			$(elements.factory.inputs).empty();
			$(elements.factory.saveditems).empty();
			$(elements.accessories.inputs).empty();
			$(elements.accessories.saveditems).empty();
			toggleButtonStates({type:'factory'});
			toggleButtonStates({type:'accessories'});
			getVehicleData();
		} else {
			isFirstLoad = false;
			getVehicleData(renderPreselections);
		}
	}

	function saveCurrentForm(data) {


		if(data.type == 'accessories') {
			var accessoriesToSave = [];
			var validationPasses = true;
			// Get all the selected items, validate then and create the accessory object.
			$('.nonStandardAccessoryCheckbox input:checked').each(function () {
				// We need to use this element as a jQuery object.
				var checkedBox = $(this);
				var itemIndex = checkedBox.attr('itemIndex');
				var labelText = checkedBox.siblings().text();
				var $relatedPriceSelect = $('select[itemIndex="' + itemIndex + '"]');
				var itemPrice = $relatedPriceSelect.val();

				// If there is no price validation fails
				if (itemPrice === '') {
					validationPasses = false;
					// Add an error to this row.
					$relatedPriceSelect.parent().addClass('has-error');
				} else {
					$relatedPriceSelect.parent().removeClass('has-error');
				}

				var accessory = {
					position: itemIndex,
					label: labelText,
					code: checkedBox.val(),
					included: $relatedPriceSelect.val() == '0' ? true : false,
					price: itemPrice
				};
				// Add them to an array to save all at once, once we know that they all validate.
				accessoriesToSave.push(accessory);
			});

			if (validationPasses) {
				savedSelections[data.type] = [];
				$(elements[data.type].inputs).empty();
				$(elements[data.type].saveditems).empty();
				_.each(accessoriesToSave, function(accessory) {
					savedSelections.accessories.push(accessory);
					addSavedAccessoryHTML(accessory);
				});
				meerkat.modules.dialogs.close(modals[data.type]);
		} else {
				$('.has-error select').first().focus();
			}
		} else {
			savedSelections[data.type] = [];
			$(elements[data.type].inputs).empty();
			$(elements[data.type].saveditems).empty();

			$(elements[data.type].checkboxes).find(':checked').each(function(i, el){
				var that = $(this);

				// Push item to savedSelections object
				savedSelections.factory.push(that.attr('id'));
				var name = that.attr('name').slice(4);
				var id = that.attr('id').slice(4);
				var index = id.split("_")[1];
				var fItem = getFactoryOptionByIndex(index);
				fItem.position = ("0" + index).slice(-2);

				$(elements.factory.inputs).append(
					getInputHTML({
						id:		id,
						name:	name,
						value:	that.val()
					}).addClass('saved-item-factory-' + ("0" + fItem.position).slice(-2))
				);

				// Append item to list view in the main form
				renderExistingSelectionToMainForm({
					type: 'factory',
					item: fItem
				});
			});

		meerkat.modules.dialogs.close(modals[data.type]);
	}

	}

	function addSavedAccessoryHTML(item) {

		// Append item to the saved inputs list
		$(elements.accessories.inputs).append(
			getInputHTML({
				name: 'quote_accs_acc' + item.position + '_sel',
				id: 'acc_' + item.position + '_chk',
				value: item.code
			}).addClass('saved-item-accessories-' + ("0" + item.position).slice(-2))
		)
		.append(
			getInputHTML({
				name: 'quote_accs_acc' + item.position + '_inc',
				value: item.included === true ? 'Y' : 'N'
			}).addClass('saved-item-accessories-' + ("0" + item.position).slice(-2))
		);

		// Append item to list view in the main form
		renderExistingSelectionToMainForm({
			type: 'accessories',
			item: item
		});
	}

	function getInputHTML(props) {
		var obj = {type:'hidden'};
		_.extend(obj, props);
		return $('<input/>',obj);
	}

	function toggleFactoryOptionsFieldSet() {

		// Show/Hide the factory options button if no data available
		if(_.isArray(vehicleOptionsData.options) && vehicleOptionsData.options.length) {
			$('#quote_vehicle_factoryOptionsFieldSet').removeClass("hidden");
		} else {
			$('#quote_vehicle_factoryOptionsFieldSet').addClass("hidden");
		}
	}

	function toggleButtonStates(data) {

		var hasDefault = $(elements[data.type].radio + " input:radio").is(':checked');

		if(_.isEmpty(savedSelections[data.type])) {
			// Set the radio YES/NO group to NO
			$(elements[data.type].button).css({display:'none'});
			$(elements[data.type].radio).css({display:'block'});
			$(elements[data.type].radio + " input:radio").prop('checked', false).change();
			if(hasDefault === true) {
				$(elements[data.type].radio + " input:radio:last").prop('checked', true).change();
				$(elements[data.type].yn).val('N');
			}
		} else {
			// Set the radio YES/NO group to YES
			$(elements[data.type].radio + " input:radio").prop('checked', false);
				$(elements[data.type].radio + " input:radio:first").prop('checked', true).change();
				$(elements[data.type].yn).val('Y');
			$(elements[data.type].radio).css({display:'none'});
			$(elements[data.type].button).css({display:'block'});
		}
	}

	function cleanText(text) {
		return $('<div />').html(text).text();
	}

	function onYesNoButtonClicked(data, event) {
		event.preventDefault();
		event.stopPropagation();
		data.callback();
	}

	function initCarVehicleOptions() {

		var self = this;

		$(document).ready(function() {

			// Only init if CAR... obviously...
			if (meerkat.site.vertical !== "car")
				return false;

			isIE8 = meerkat.modules.performanceProfiling.isIE8();

			meerkat.messaging.subscribe(meerkatEvents.car.VEHICLE_CHANGED, onVehicleChanged);

			// Populate with list of non-standard accessories
			vehicleNonStandardAccessories = [];
			if(
				_.isObject(meerkat.site.nonStandardAccessoriesList) &&
				meerkat.site.nonStandardAccessoriesList.hasOwnProperty("items") &&
				_.isArray(meerkat.site.nonStandardAccessoriesList.items)
			) {
			vehicleNonStandardAccessories = meerkat.site.nonStandardAccessoriesList.items;
			}

			// Pull in any option/accessory preselections
			_.extend(optionPreselections, meerkat.site.userOptionPreselections);

			var list = ['factory','accessories'];
			for(var i=0; i<list.length; i++) {
				var label = list[i];
				var val = $(elements[label].yn).val();

				if(_.isEmpty(val) && !_.isEmpty(optionPreselections[label])) {
					$(elements[label].yn).val('Y');
					val = 'Y';
				}

				if(!_.isEmpty(val)) {
					$(elements[label].radio + " input:radio").prop('checked', false).change();
					$(elements[label].radio + " input:radio[value='" + val + "']").prop('checked', true).change();
				}
			}

			$(elements.factory.radio + " label:first").on("click", _.bind(onYesNoButtonClicked, this, {type:'factory',callback:renderFactoryModal}));
			$(elements.accessories.radio + " label:first").on("click", _.bind(onYesNoButtonClicked, this, {type:'accessories',callback:renderAccessoriesModal}));

			$(elements.factory.radio + " label:last").on("click", function(){
				$(elements.factory.yn).val('N');
			});
			$(elements.accessories.radio + " label:last").on("click", function(){
				$(elements.accessories.yn).val('N');
			});

			$(elements.factory.button).on("click", renderFactoryModal);
			$(elements.accessories.button).on("click", renderAccessoriesModal);

		});

	}

	function getSessionCamStep() {
		if(sessionCamStep === null) {
			sessionCamStep = meerkat.modules.journeyEngine.getCurrentStep();
		}
		return _.extend({}, sessionCamStep); // prevent external override
	}

	meerkat.modules.register("carVehicleOptions", {
		init : initCarVehicleOptions,
		events : moduleEvents,
		onVehicleChanged : onVehicleChanged
	});

})(jQuery);