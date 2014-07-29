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
				wrapper :		"#quote_vehicle_accessoriesDialog .quote-optional-accessories",
				type :			"#quote_vehicle_accessoriesDialog .ac-type",
				included :		"#quote_vehicle_accessoriesDialog .ac-included",
				price :			"#quote_vehicle_accessoriesDialog .ac-price",
				add :			"#quote_vehicle_accessoriesDialog .ac-add",
				clear :			"#quote_vehicle_accessoriesDialog .ac-clear",
				addeditems :	"#quote_vehicle_accessoriesDialog .quote-optional-accessories .added-items ul",
				saveditems:		"#quote_vehicle_accessoriesSelections .added-items ul"
			},
			redbook:			"#quote_vehicle_redbookCode"
	};

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

	function getVehicleData(callback) {

		if( ajaxInProgress === false ) {

			var $element = $(elements.factory.button);

			meerkat.modules.loadingAnimation.showAfter($element);

			var data = {redbookCode:$(elements.redbook).val()};

			ajaxInProgress = true;

			meerkat.modules.comms.get({
				url: "ajax/json/car_vehicle_options.jsp",
				data: data,
				cache: true,
				useDefaultErrorHandling: false,
				numberOfAttempts: 3,
				errorLevel: "fatal",
				onSuccess: function onSubmitSuccess(resultData) {
					vehicleOptionsData = resultData;
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
			title : $(this).prop('title'),
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
			onClose : _.bind(toggleButtonStates, this, {type:'factory'}),
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
					$(this).tab('show');
					$('#' + dialogId + ' .modal-title-label').html($(this).prop('title'));
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
			}
		});

		return false;
	}

	function renderAccessoriesModal() {
		// Pass in the list of included items as string of html LI's
		var optionalAccessories = generateAccessoryOptionsHTML(vehicleNonStandardAccessories);
		var standardAccessories = generateStandardAccessoriesHTML(vehicleOptionsData.standard);
		var selectedAccessories = generateSelectedAccessoriesHTML();

		var templateAccessories = _.template($(elements.accessories.template).html());

		var htmlContent = templateAccessories({
				optionalAccessories: optionalAccessories,
				standardAccessories: standardAccessories,
				selectedAccessories: selectedAccessories
		});

		modals.accessories = meerkat.modules.dialogs.show({
				title : $(this).prop('title'),
				htmlContent : htmlContent,
				hashId : 'accessories',
				tabs : [{
					title:'Add Non-Standard Accessories',
					xsTitle:'Non-Standard Accessories',
					targetSelector:'.quote-optional-accessories'
				},{
					title: 'View Included Standard Accessories',
					xsTitle: 'Standard Accessories',
					targetSelector: '.quote-standard-accessories'
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
				onClose : _.bind(toggleButtonStates, this, {type:'accessories'}),
				onOpen : function(dialogId) {

					// Toggle add accessories form depending on whether content is available
					if(_.isArray(vehicleNonStandardAccessories) && vehicleNonStandardAccessories.length){
						$('.quote-optional-accessories .no-items-found').addClass('hidden');
					} else {
						$('.quote-optional-accessories .items-found').addClass('hidden');
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
						$(this).tab('show');
						$('#' + dialogId + ' .modal-title-label').html($(this).prop('title'));
					});
					$('.nav-tabs a:first').click();
					onAccessoriesFormRendered();
				}
		});

		return false;
	}

	function onAccessoriesFormRendered() {

		$(elements.accessories.add).find('button:first').on('click', onAddAccessoriesItem);
		$(elements.accessories.clear).find('button:first').on('click', onClearAccessoriesForm);

		// Add on change event for Y/N buttons
		$(elements.accessories.included).find('label.btn').off().on('click', function(){
			$(this).change();
			if($(this).find('input:first').val() == 'N') {
				_.defer(function(){ /* For IE8 - ensure above change is completed */
					$(elements.accessories.included).hide();
					$(elements.accessories.price).show();
				});
			} else {
				$(elements.accessories.price).hide();
			}

			/* Ensure the defer above is completed before showing fields otherwise IE8 flashes weirdly */
			_.defer(function(){
				$(elements.accessories.add + "," + elements.accessories.clear).show();
			});
		});

		// Add events etc to previously saved selections (lost through template rendering)
		for(var i=0; i<savedSelections.accessories.length; i++) {
			var item = savedSelections.accessories[i];
			var $parent = $(elements.accessories.addeditems);
			var $li = $parent.find('li.added-item-' + item.position).first();
			$li.data('info', item);
			$li.find('a:first').on('click', _.bind(onRemoveAccessoriesItem, this, item));
		}
	}

	function onClearAccessoriesForm() {

		$(elements.accessories.price + "," + elements.accessories.add + "," + elements.accessories.clear).hide();
		$(elements.accessories.included).show();

		$type = $(elements.accessories.type);
		$included = $(elements.accessories.included);
		$price = $(elements.accessories.price);

		$included.find('.active').removeClass('active')
			.end().find('input:checked').prop('checked', false).change()
			.end().find('.error-field').empty()
			.end().removeClass('has-error');
		$type.find('select:first').prop('selectedIndex', 0)
			.end().find('option').prop('selected', false)
			.end().removeClass('has-error')
			.end().find('.error-field').empty();
		$price.removeClass('has-error')
			.find('.error-field').empty()
			.end().find('input').val('');
	}

	function onAddAccessoriesItem() {
		var validated = validateAddAccessoriesForm();
		if(validated !== false){

			// Remove from selector
			$(elements.accessories.type).find('option').each(function(){
				if($(this).val().indexOf(validated.position) === 0) {
					$(this).remove();
				}
			});

			$(elements.accessories.addeditems).append(
				getAddedAccessoryItemHTML(validated)
			);


			onClearAccessoriesForm();
		}
	}

	function getAddedAccessoryItemHTML(item) {

		// Append to selected list
		return $("<li/>")
		.addClass('added-item-' + item.position)
		.data("info", item)
		.append(
			$("<span/>").append(item.info.label)
		)
		.append(
			$("<a/>",{
				title:"remove accessory"
			}).addClass("icon-cross")
			.on('click', _.bind(onRemoveAccessoriesItem, this, item))
		)
		.append(
			$("<span/>").append(item.price === false ? "included" : "$" + item.price)
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
						text:	item.info.label,
						value:	item.position + "_" + item.info.code
					})
				);
				return false;
			}
		});
	}

	function validateAddAccessoriesForm() {

		var item = $(elements.accessories.type).find('option:selected');
		var included = $(elements.accessories.included + ' .active').find('input');
		var price = $(elements.accessories.price).find('input').val();

		var item_valid = !_.isEmpty(item) && !_.isEmpty(item.val());
		var inc_valid = !_.isEmpty(included) && !_.isEmpty(included.val());
		var price_valid = !_.isEmpty(price) && !isNaN(price) && price > 0;

		$type = $(elements.accessories.type);
		if(item_valid === false) {
			$type.addClass('has-error');
			$type.find('.error-field').empty().append('Select an accessory');
		} else {
			$type.removeClass('has-error');
			$type.find('.error-field').empty();
		}

		$included = $(elements.accessories.included);
		if(inc_valid === false) {
			$included.addClass('has-error');
			$included.find('.error-field').empty().append('Is included in purchase price?');
		} else {
			$included.removeClass('has-error');
			$included.find('.error-field').empty();
		}

		$price = $(elements.accessories.price);
		if(price_valid === false) {
			$price.addClass('has-error');
			$price.find('.error-field').empty().append('Enter the accessory purchase price');
		} else {
			$price.removeClass('has-error');
			$included.find('.error-field').empty();
		}

		if(item_valid === true && inc_valid === true) {

			var temp = item.val();
			item = temp.substring(3).replace(/^\s+|\s+$/gm,''); /* Removes trailing white space (ie8 fwd-slash fix) */
			position = String(temp.substring(0,2));
			included = included.val() == 'Y';
			price = price === '' || isNaN(price) ? false : price;
			if(included === true || price !== false) {

				// Locate the accessories details
				var accObj = false;
				for(var i=0; i<vehicleNonStandardAccessories.length; i++) {
					if(vehicleNonStandardAccessories[i].code == item) {
						accObj = {
							position : position,
							included : included,
							price : price,
							info : vehicleNonStandardAccessories[i]
						};

						i = vehicleNonStandardAccessories.length + 1;
					}
				}

				if(accObj !== false) {

					if(included === false) {
						var min = Math.ceil(accObj.info.standard * (accObj.info.min / 100));
						var max = Math.floor(accObj.info.standard * (accObj.info.max / 100));

						if(Number(price) < min || Number(price) > max) {
							$price.addClass('has-error');
							$price.find('.error-field').empty().append('Please enter a value between $' + min + ' and $' + max);
							return false;
						}
					}

					// finally return the accessory
					return accObj;
				}
			}
		}

		return false;
	}

	function generateFactoryOptionsHTML(data) {
		var output = $('<ul/>');
		for(var i=0; i<data.length; i++) {
			var obj = data[i];
			var id = 'tmp_fact_' + i + '_chk';
			var name = 'tmp_quote_opts_opt' + ("0" + i).slice(-2);
			var chkbox = $('<input/>',{
					type:	'checkbox',
					name:	name,
					id:		id,
					value:	obj.code
			});
			if(_.indexOf(savedSelections.factory, id) !== -1) {
				chkbox.prop('checked', true);
				//chkbox.addClass('checked');
			}
			output.append(
				$('<li/>').append(
					$('<div/>').addClass('checkbox')
					.append(chkbox)
					.append(
						$('<label/>').prop('for', id)
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
				if(code == savedSelections.accessories[s].info.code) {
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
					fItem.position = ("0" + pos).slice(-2);

					if(fItem !== false) {
						savedSelections.factory.push("tmp_fact_" + pos + "_chk");
						$(elements.factory.inputs).append(
							getInputHTML({
								id:		name.slice(4),
								name:	"quote_opts_opt" + ("0" + pos).slice(-2),
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
					var obj = {
							included:	aItem.inc === 'Y' ,
							position:	j.substring(3),
							price:		aItem.hasOwnProperty("prc") ? String(aItem.prc) : false,
							info:		getAccessoryByCode(aItem.sel)
					}
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
				if(savedSelections.accessories[j].info.code == item.code) {
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
		.addClass('saved-item-' + item.type + '-' + ("0" + item.position).slice(-2))
		.data("info", item)
		.append(
			$("<span/>").append(item.label)
		)
		.append(
			$("<a/>",{
				title:"remove " + (item.type == "factory" ? "factory option" : "accessory")
			}).addClass("icon-cross")
			.on('click', _.bind(onRemoveSavedItem, this, item))
		);

		if(!_.isNull(item.price)) {
			$li.append(
				$("<span/>").append(item.price === false ? "included" : "$" + item.price)
			);
		}

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
			item.label = data.item.info.label;
			item.price = data.item.price;
			item.code = data.item.info.code;
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

		// Save the checked form fields to an object
		savedSelections[data.type] = [];
		$(elements[data.type].inputs).empty();
		$(elements[data.type].saveditems).empty();

		if(data.type == 'accessories') {
			$(elements[data.type].addeditems).find('li').each(function(i, el){
				var aItem = $(this).data('info');

				// Push item to saveSelections object
				savedSelections.accessories.push(aItem);

				// Add required form inputs
				addSavedAccessoryHTML(aItem);
			});
		} else {
			$(elements[data.type].checkboxes).find(':checked').each(function(i, el){
				var that = $(this);

				// Push item to savedSelections object
				savedSelections.factory.push(that.prop('id'));
				var name = that.prop('name').slice(4);
				var id = that.prop('id').slice(4);
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
		}

		meerkat.modules.dialogs.close(modals[data.type]);
	}

	function addSavedAccessoryHTML(item) {

		// Append item to the saved inputs list
		$(elements.accessories.inputs).append(
			getInputHTML({
				name: 'quote_accs_acc' + item.position + '_sel',
				id: 'acc_' + item.position + '_chk',
				value: item.info.code
			}).addClass('saved-item-accessories-' + ("0" + item.position).slice(-2))
		)
		.append(
			getInputHTML({
				name: 'quote_accs_acc' + item.position + '_inc',
				value: item.included === true ? 'Y' : 'N'
			}).addClass('saved-item-accessories-' + ("0" + item.position).slice(-2))
		);

		if(item.included === false) {
			$(elements.accessories.inputs).append(
				getInputHTML({
					name: 'quote_accs_acc' + item.position + '_prc',
					value: item.price
				}).addClass('saved-item-accessories-' + ("0" + item.position).slice(-2))
			);
		}

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
			if(hasDefault === true) {
				$(elements[data.type].radio + " input:radio:first").prop('checked', true).change();
				$(elements[data.type].yn).val('Y');
			}
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

			var list = ['factory','accessories'];
			for(var i=0; i<list.length; i++) {
				var label = list[i];
				var val = $(elements[label].yn).val();
				if(!_.isEmpty(val)) {
					$(elements[label].radio + " input:radio").prop('checked', false).change();
					$(elements[label].radio + " input:radio[value=" + val + "]").prop('checked', true).change();
				}
			}

			// Populate with list of non-standard accessories
			vehicleNonStandardAccessories = meerkat.site.nonStandardAccessoriesList.items;

			// Pull in any option/accessory preselections
			_.extend(optionPreselections, userOptionPreselections);

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

	meerkat.modules.register("carVehicleOptions", {
		init : initCarVehicleOptions,
		events : moduleEvents,
		onVehicleChanged : onVehicleChanged
	});

})(jQuery);