;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
		autocomplete: {
			CANT_FIND_ADDRESS: 'EVENT_CANT_FIND_ADDRESS',
			ELASTIC_SEARCH_COMPLETE: 'ELASTIC_SEARCH_COMPLETE',
			INIT: 'INIT'
		}
	};

	var moduleEvents = events.autocomplete;

	function initAutoComplete() {
		$(document).ready(function(){
			setTypeahead();
		});
	}

	/**
	 * Checks if the provided field is an elasticsearch lookup
	 * @param addressFieldId
	 * @returns {boolean}
	 * @private
	 */
	function _isElasticSearch(addressFieldId) {
		return $("#" + addressFieldId + "_elasticSearch").val() === "Y";
	}

	function setTypeahead() {
		var $typeAheads = $('input.typeahead'),
			params = null;

		$typeAheads.each(function eachTypeaheadElement() {
			var $component = $(this),
				fieldId = $component.attr("id"),
				fieldIdEnd = fieldId.match(/(_)[a-zA-Z]{1,}$/g),
				addressFieldId = fieldId.replace(fieldIdEnd, ""),
				elasticSearch = _isElasticSearch(addressFieldId),
				url;

			$component.data("addressfieldid", addressFieldId);

			if (elasticSearch) {
				url = 'address/search.json';
				params = {
					name: $component.attr('name'),
					remote: {
						beforeSend: function(jqXhr, settings) {
							autocompleteBeforeSend($component);
							jqXhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
							settings.type = "POST";
							settings.hasContent = true;
							settings.url = url;

							var $addressField = $('#' + addressFieldId + '_autofilllessSearch');
							var query = $addressField.val();
							settings.data = $.param({ query: decodeURI(query) });
						},
						filter: function(parsedResponse) {
							autocompleteComplete($component);
							return parsedResponse;
						},
						url: url,
						error: function(xhr, status) {
							// Throw a pop up error
							meerkat.modules.errorHandling.error({
								page: "autocomplete.js",
								errorLevel: "warning",
								title: "Address lookup failed",
								message: "<p>Sorry, we are having troubles connecting to our address servers.</p><p>Please manually enter your address.</p>",
								description: "Could not connect to the elastic search.json",
								data: xhr
							});
							// Tick non-std box.
							$('#' + addressFieldId + '_nonStd').trigger('click').prop('checked', true);
							autocompleteComplete($component);
						}
					},
					limit: 150
				};
			} else if($component.attr('data-varname') == 'countrySelectionList') {
				params = meerkat.modules.travelCountrySelector.getCountrySelectorParams($component);
			} else {
				url = $component.attr('data-source-url');
				params = {
					name: $component.attr('name'),
					remote: {
						beforeSend: function() {
							autocompleteBeforeSend($component);
						},
						filter: function(parsedResponse) {
							autocompleteComplete($component);
							return parsedResponse;
						},
						url: $component.attr('data-source-url')+'%QUERY'
					},
					limit: 150
				};
			}

			params = checkIfAddressSearch($component, params);

			// Apply the typeahead
			$component.typeahead(params);

			// Bootstrap checks
			if ($component.hasClass('input-lg')) {
				$component.prev('.tt-hint').addClass('hint-lg');
			}
			if ($component.hasClass('input-sm')) {
				$component.prev('.tt-hint').addClass('hint-sm');
			}

			// Check for specific class on the input element
			// and trigger a blur once an option is selected from the typeahead dropdown menu.
			if ($component.hasClass('blur-on-select')) {
				$component.bind('typeahead:selected', function blurOnSelect(event, datum, name) {
					// #CANTFIND#
					if (datum.hasOwnProperty('value') && datum.value === 'Type your address...') {
						return;
					}

					if (event && event.target && event.target.blur) {
						event.target.blur();
					}
				});
			}
		});
	}

	function autocompleteBeforeSend($component) {
		if ($component.hasClass('show-loading')) {
			meerkat.modules.loadingAnimation.showInside($component.parent('.twitter-typeahead'));
		}
	}

	function autocompleteComplete($component) {
		if ($component.hasClass('show-loading')) {
			meerkat.modules.loadingAnimation.hide($component.parent('.twitter-typeahead'));
		}
	}

	//
	// Check if the input has .typeahead-address
	// A custom handler will be triggered when firing remote requests.
	//
	function checkIfAddressSearch($element, typeaheadParams) {
		if ($element && $element.hasClass('typeahead-address')) {
			var addressFieldId = $element.data("addressfieldid"),
				elasticSearch = _isElasticSearch(addressFieldId);

			typeaheadParams.remote.url = $element.attr('id');
			typeaheadParams.remote.replace = addressSearch;

			// Two properties need to be received in the json: 'value' and 'highlight'
			typeaheadParams.valueKey = 'value';
			typeaheadParams.template = _.template('<p>{{= highlight }}</p>');

			if ($element.hasClass('typeahead-autofilllessSearch') || $element.hasClass('typeahead-streetSearch')) {
				// If no results, inject a message.
				// Improve this later after typeahead 0.10 is released https://github.com/twitter/typeahead.js/issues/253
				typeaheadParams.remote.filter = function(parsedResponse) {
					autocompleteComplete($element);

					if (elasticSearch) {
						$.each(parsedResponse, function(index, addressObj) {
							if(addressObj.hasOwnProperty('text') && addressObj.hasOwnProperty('payload')) {
								addressObj.value = addressObj.text;
								addressObj.highlight = addressObj.text;
								addressObj.dpId = addressObj.payload;
							}
						});
					}
					// Add this option to the parsed response, all the time.
					// Now gives the user the option to select it when there
					// are results but not the on they are looking for.
					parsedResponse.push({
						value: 'Type your address...',
						highlight: 'Can\'t find your address? <u>Click here.</u>'
					});
					return parsedResponse;
				}

				$element.bind('typeahead:selected', function catchEmptyValue(event, datum, name) {
					if (datum.hasOwnProperty('value') && datum.value === 'Type your address...') {
						var id = '';
						if (!elasticSearch) {
							if (event.target && event.target.id) {
								id = event.target.id.replace('_streetSearch', '');
							}
						}
						meerkat.messaging.publish(moduleEvents.CANT_FIND_ADDRESS, { fieldgroup: id });

					} else if (elasticSearch) {
						meerkat.messaging.publish(moduleEvents.ELASTIC_SEARCH_COMPLETE, {
							dpid:			datum.dpId,
							addressFieldId:	addressFieldId
						});
						// Validate the element now the user has made a selection.
						$element.valid();
					}
				});
			}
		}
		return typeaheadParams;
	}

	// Incoming 'url' is the ID of the input element
	function addressSearch(url, uriEncodedQuery) {
		var $element = $('#'+url);
		url = '';

		$element.trigger('getSearchURL');

		if ($element.data('source-url')) {
			url = $element.data('source-url');
		}

		return url;
	}

	meerkat.modules.register("autocomplete", {
		init: initAutoComplete,
		events: events,
		autocompleteBeforeSend: autocompleteBeforeSend,
		autocompleteComplete: autocompleteComplete
	});

})(jQuery);
/**
 * This module uses data attributes to populate empty content areas with html, text, values, AJAX results from a specific source.
 * It is initially developed to only function for CARAMS-12, and will be extended for CARAMS-7
 */
;(function ($, undefined) {

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
			contentPopulation: {}
		},
		moduleEvents = events.contentPopulation;

	/* Variables */


	/* main entrypoint for the module to run first */
	function init() {

	}

	/**
	 * Empty the values in the template. Needed to prevent ensure each refresh updates properly
	 * @param {String} container - Pass in a jQuery selector as the parent element wrapping the div template.
	 */
	function empty(container) {
		$('[data-source]', $(container)).each(function () {
			// it's possibly that we will want to reset a value/radio button/
			$(this).empty();
		});
	}

	/**
	 * Loop through each element with data-source attribute within the container
	 * Fill it with the content retrieved from the data-source
	 * Can be used to retrieve any type of content, just add more conditions.
	 * @param {String} container - Pass in a jQuery selector as the parent element wrapping the div template.
	 */
	function render(container) {

		$('[data-source]', $(container)).each(function () {
			var output = '',
				$el = $(this),
				$sourceElement = $($el.attr('data-source')),
				$alternateSourceElement = $($el.attr('data-alternate-source')); // used primarily with prefill data.

			// If the source element doesn't exist, continue
			if (!$sourceElement.length)
				return; // same as "continue" http://api.jquery.com/jquery.each/

			// setup variables
			sourceType = $sourceElement.get(0).tagName.toLowerCase(),
				dataType = $el.attr('data-type'),
				callback = $el.attr('data-callback');
			/**
			 * You can perform a callback function to create the output by adding: data-callback="meerkat.modules...."
			 * You can just let it handle it based on the elements tagName
			 * You can specify a data-type, and handle them differently e.g. radiogroup, list, JSON object etc (or create your own)
			 */
			if(callback) {
				/** To run a function. Can handle namespaced functions e.g. meerkat.modules... and global functions.
				 * Argument passed in to function is $sourceElement.
				 * If you wish to add another parameter,
				 * add it as a data attribute and include it in both .apply calls below as an additional array element.
				 **/
				try {
					var namespaces = callback.split('.');

					if(namespaces.length) {
						var func = namespaces.pop(),
						context = window;
						for(var i= 0; i < namespaces.length; i++) {
							context = context[namespaces[i]];
						}
						output = context[func].apply(context, [$sourceElement]);
					} else {
						output = callback.apply(window, [$sourceElement]);
					}
				} catch (e) {
					meerkat.modules.errorHandling.error({
						message:	"Unable to perform render Content Population Callback properly.",
						page:		"contentPopulation.js:render()",
						errorLevel:	"silent",
						description:"Unable to perform contentPopulation callback labelled: " + callback,
						data:		{"error": e.toString(), "sourceElement": $el.attr('data-source')}
					});
					output = '';
				}
			} else if (!dataType) {
				switch (sourceType) {
				case 'select':
					// to prevent a "please choose" from displaying.
					var $selected = $sourceElement.find('option:selected');
					if($selected.val() === '') {
						output = '';
					} else {
						// We generally want to see the options text content, rather than it's value.
						output = $selected.text() || '';
						// If there's an alternate source.
						if(output === '' && $alternateSourceElement.length) {
							$selected = $alternateSourceElement.find('option:selected');
							if($selected.val() === '') {
								output = '';
							} else {
								output = $selected.text() || '';
							}
						}
					}
					break;
				case 'input':
					output = $sourceElement.val() || $alternateSourceElement.val() || '';
					break;
				default:
					output = $sourceElement.html() || $alternateSourceElement.html() || '';
					break;
				}
			} else {
				var selectedParent;
				switch (dataType) {
					case 'checkboxgroup':
						selectedParent = $sourceElement.parent().find(':checked').next('label');
						if(selectedParent.length) {
							output = selectedParent.text() || '';
						}
					break;
					case 'radiogroup':
						selectedParent = $sourceElement.find(':checked').parent('label');
						if (selectedParent.length) {
							output = selectedParent.text() || '';
						}
						break;
					case 'list':
						// get it from a source ul, but text only
						// assumes the first span is the one with the text in it
						var $listElements = $sourceElement.find('li');
						if ($listElements.length > 0) {
							$listElements.each(function() {
								output += '<li>' + $(this).find('span:eq(0)').text() + '</li>';
							});
						} else {
							output += '<li>None selected</li>';
						}
						break;
					case 'optional':
						output = $sourceElement.val() || $alternateSourceElement.val() || '';
						// If we get even one output, we remove the no details element.
						if (output !== '') {
							$('.noDetailsEntered').remove();
						}
						break;
					case 'object':
						// get it from an object and do stuff
						break;
				}
			}

			// currently we only want to replace the elements html, potential to replace value, select options...? extend this with further data options.
			$el.html(output);
		});
	}

	meerkat.modules.register('contentPopulation', {
		init: init,
		events: events,
		render: render,
		empty: empty
		//here you can optionally expose functions for use on the 'meerkat.modules.example' object
	});

})(jQuery);
////////////////////////////////////////////////////////////
//// SIMPLE DIALOG                                      ////
////----------------------------------------------------////
//// This allows you to display a simple dialog modal   ////
//// window using bootstrap								////
////////////////////////////////////////////////////////////
/*

USAGE EXAMPLE: Call directly

		// Open the modal
		var modalId = meerkat.modules.dialogs.show({
			htmlContent: '<p>Hello!</p>',
			buttons: [{
				label: 'Close',
				className: 'btn-cancel',
				closeWindow: true
			}],
			onOpen: function(id) {
				// Switch content
				meerkat.modules.dialogs.changeContent(id, '<iframe src="ajax/html/example.jsp"></iframe>');
			}
		});

		// Close and destroy the modal
		meerkat.modules.dialogs.close(modalId);

*/

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		isXS;

	var windowCounter = 0,
		dialogHistory = [],
		openedDialogs = [],
		defaultSettings = {
			title: '',
			htmlContent: null,
			url: null,
			cacheUrl: false,
			buttons: [],
			className: '',
			leftBtn: {
				label: 'Back',
				icon: '',
				className: 'btn-sm btn-close-dialog',
				callback: null
			},
			rightBtn: {
				label: '',
				icon: '',
				className: '',
				callback: null
			},
			tabs: [],
			htmlHeaderContent: '',
			hashId: null,
			destroyOnClose: true,
			closeOnHashChange: false,
			openOnHashChange: true,
			fullHeight: false, // By default, a modal shorter than the viewport will be centred. Set to true to vertically fill the viewport.
			templates: {
				dialogWindow: '<div id="{{= id }}" class="modal" tabindex="-1" role="dialog" aria-labelledby="{{= id }}_title" aria-hidden="true"{{ if(fullHeight===true){ }} data-fullheight="true"{{ } }}>' +
						'<div class="modal-dialog {{= className }}">' +

							'<div class="modal-content">' +
								'<div class="modal-closebar">' +
								'	<a href="javascript:;" class="btn btn-close-dialog"><span class="icon icon-cross"></span></a>' +
								'</div>' +
								'<div class="navbar navbar-default xs-results-pagination visible-xs">' +
									'<div class="container">' +
										'<ul class="nav navbar-nav">' +
											'<li>' +
												'<button data-button="leftBtn" class="btn btn-back {{= leftBtn.className }}">{{= leftBtn.icon }} {{= leftBtn.label }}</button>' +
											'</li>' +
											'<li class="navbar-text modal-title-label">' +
											'	{{= title }}' +
											'</li>' +
											'{{ if(rightBtn.label != "" || rightBtn.icon != "") { }}' +
												'<li class="right">' +
													'<button data-button="rightBtn" class="btn btn-save {{= rightBtn.className }}">{{= rightBtn.label }} {{= rightBtn.icon }}</button>' +
												'</li>' +
											'{{ } }}' +
										'</ul>' +
									'</div>' +
								'</div>' +
								'{{ if(title != "" || tabs.length > 0 || htmlHeaderContent != "" ) { }}' +
								'<div class="modal-header">' +
									'{{ if (tabs.length > 0) { }}' +
										'<ul class="nav nav-tabs tab-count-{{= tabs.length }}">' +
											'{{ _.each(tabs, function(tab, iterator) { }}' +
												'<li><a href="javascript:;" data-target="{{= tab.targetSelector }}" title="{{= tab.xsTitle }}">{{= tab.title }}</a></li>' +
											'{{ }); }}' +
										'</ul>' +
									'{{ } else if(title != "" ){ }}' +
										'<h4 class="modal-title hidden-xs" id="{{= id }}_title">{{= title }}</h4>' +
									'{{ } else if(htmlHeaderContent != "") { }}' +
										'{{= htmlHeaderContent }}' +
									'{{ } }}' +
								'</div>' +
								'{{ } }}' +
								'<div class="modal-body">' +
									'{{= htmlContent }}' +
								'</div>' +
								'{{ if(typeof buttons !== "undefined" && buttons.length > 0 ){ }}' +
									'<div class="modal-footer {{ if(buttons.length > 1 ){ }} mustShow {{ } }}">' +
										'{{ _.each(buttons, function(button, iterator) { }}' +
											'<button data-index="{{= iterator }}" type="button" class="btn {{= button.className }} ">{{= button.label }}</button>' +
										'{{ }); }}' +
									'</div>' +
								'{{ } }}' +
							'</div>' +
						'</div>' +
					'</div>'
					},
			/*jshint +W112 */
			onOpen: function(dialogId) {},
			onClose: function(dialogId) {},
			onLoad: function(dialogId) {}
		}

	function show(instanceSettings){

		var settings = $.extend({}, defaultSettings, instanceSettings);
		isXS = meerkat.modules.deviceMediaState.get() === "xs" ? true : false;

		var id = "mkDialog_"+windowCounter;
		if(!_.isUndefined(settings.id)) {
			if(isDialogOpen(settings.id)) {
				close(settings.id);
			}
		} else {
			settings.id = id;
			windowCounter++;
		}

		if(settings.hashId != null){
			// append the dialogs hash id to the window hash.
			meerkat.modules.address.appendToHash(settings.hashId);
		}

		var htmlTemplate = _.template(settings.templates.dialogWindow);

		if(settings.url != null || settings.externalUrl != null) {
			// Load content from dynamic source, insert loading icon until content loads
			settings.htmlContent = meerkat.modules.loadingAnimation.getTemplate();
		}

		var htmlString = htmlTemplate(settings);
		$("#dynamic_dom").append(htmlString);

		var $modal = $('#'+settings.id);

		// Launch the Bootstrap modal. The backdrop setting determines if the backdrop is clickable (to close) or not.
		$modal.modal({
			show: true,
			backdrop: settings.buttons && settings.buttons.length > 0 ? 'static' : true,
			keyboard: false
		});

		// Stack those backdrops.
		$modal.css('z-index', parseInt($modal.eq(0).css('z-index')) + (openedDialogs.length*10));
		var $backdrop = $('.modal-backdrop');
		$backdrop.eq($backdrop.length-1).css('z-index', parseInt($backdrop.eq(0).css('z-index')) + (openedDialogs.length*10));

		// Wait for Bootstrap to tell us it has closed a modal, then run our own close functions.
		$modal.on('hidden.bs.modal', function (event) {
			if (typeof event.target === 'undefined') return;
			var $target = $(event.target);
			if ($target.length === 0 || $target.hasClass('modal') === false) return;

			// Run our close functions
			doClose($target.attr('id'));
		});

		// When changing tabs, resize the modal to accommodate the content.
		$modal.on('shown.bs.tab', function(event) {
			resizeDialog(settings.id);
		});

		$modal.find('button').on('click', function onModalButtonClick(eventObject) {
			var button = settings.buttons[$(eventObject.currentTarget).attr('data-index')];

			if(!_.isUndefined(button)) {
			// If this is a close button, tell Bootstrap to close the modal
			if(button.closeWindow === true){
				$(eventObject.currentTarget).closest('.modal').modal('hide');
			}

			// Run the callback
			if (typeof button.action === 'function') button.action(eventObject);
			}
		});

		// todo, shouldn't need to off the previous call... can't use settings.buttons as it can't be $.extend'ed
		$modal.find('.navbar-nav button').off().on('click', function onModalTitleButtonClick(eventObject) {
			var button = settings[$(eventObject.currentTarget).attr('data-button')];
			if(typeof button != 'undefined' && typeof button.callback == 'function')
				button.callback(eventObject);
		});

		if (settings.url != null) {
			meerkat.modules.comms.get({
				url: settings.url,
				cache: settings.cacheUrl,
				errorLevel: "warning",
				onSuccess: function dialogSuccess(result) {
					changeContent(settings.id, result);

					// Run the callback
					if (typeof settings.onLoad === 'function') settings.onLoad(settings.id);
				}
			});
		}

		if(settings.externalUrl != null) {
			var iframe = '<iframe class="displayNone" id="' + settings.id + '_iframe" width="100%" height="100%" frameborder="0" scrolling="no" allowtransparency="true" src="' + settings.externalUrl + '"></iframe>';
			appendContent(settings.id, iframe);

			$('#' + settings.id + '_iframe').on("load", function(){
				
				// calculate size of iframe content
				// console.log("scoll height", this.contentWindow.document.body.scrollHeight);
				//console.log("height", this.contentWindow.document.body.height);

				// show the iframe
				$(this).show();

				// remove the loading
				meerkat.modules.loadingAnimation.hide( $('#'+settings.id) );

			});
		}

		/**
		 * Had to add a slight delay before calculating heights as it seems the DOM is not
		 * always ready after the previous DOM manipulations (either 0 or incorrect height)
		 * see window.setTimout after this.
		 */
		window.setTimeout( function(){
			resizeDialog(settings.id);
		}, 0 );

		// Run the callback
		if (typeof settings.onOpen === 'function') settings.onOpen(settings.id);

		openedDialogs.push(settings);

		return settings.id;
	}

	// Tell Bootstrap to close this modal
	// Our follow-up close/destroy methods will run when we receive the hidden.bs.modal event
	function close( dialogId ){
		$('#' + dialogId).modal('hide');
	}

	function doClose(dialogId) {
		// If there are still other modals open we need to retain the modal-open class
		// Bootstrap removes the class so we need to add it back.
		if (openedDialogs.length > 1) {
			// Defer because Bootstrap's removeClass executes after our event
			_.defer(function() {
				// Double check
				if (openedDialogs.length > 0 && openedDialogs[0].id !== dialogId) {
					$(document.body).addClass('modal-open');
				}
			});
		}

		// Run the callback
		var settings = getSettings(dialogId);
		if (settings !== null && typeof settings.onClose === 'function') settings.onClose( dialogId );
		if(settings.destroyOnClose === true) {
			destroyDialog(dialogId);
		} else {
			meerkat.modules.address.removeFromHash(settings.hashId);
		}
	}

	function calculateLayout(eventObject){
		$("#dynamic_dom .modal").each(function resizeModalItem(index, element){
			resizeDialog($(element).attr('id'));
		});
	}

	function changeContent(dialogId, htmlContent, callback) {
		$('#' + dialogId + ' .modal-body').html(htmlContent);

		if (typeof callback === 'function') {
			callback();
		}

		calculateLayout();
	}

	function appendContent(dialogId, htmlContent) {
		$('#' + dialogId + ' .modal-body').append(htmlContent);
		calculateLayout();
	}

	function resizeDialog(dialogId) {
		isXS = meerkat.modules.deviceMediaState.get() === "xs" ? true : false;

		var $dialog = $("#" + dialogId);

		if ($dialog.find(".modal-header").outerHeight(true) === 0) {
			window.setTimeout( function(){
				resizeDialog(dialogId);
			}, 20);
		} else {
			var viewport_height,
				content_height,
				dialogTop,
				$modalContent = $dialog.find(".modal-content"),
				$modalBody = $dialog.find(".modal-body"),
				$modalDialog = $dialog.find(".modal-dialog");

			viewport_height = $(window).height();

			if (!isXS) {
				viewport_height -= 60; // top and bottom margin.
			}

			content_height = viewport_height;
			content_height -= $dialog.find(".modal-header").outerHeight(true);
			content_height -= $dialog.find(".modal-footer").outerHeight(true);
			content_height -= $dialog.find(".modal-closebar").outerHeight(true);

			// On XS, the modal fills the whole viewport.
			// Put the modals to the top of XS so the "X" close icon overlaps the navbar correctly.
			if (isXS) {
				$modalContent.css('height', viewport_height);
				$dialog.find(".modal-body").css('max-height', 'none').css('height', content_height);

				dialogTop = 0;
				$modalDialog.css('top', dialogTop);
			}
			else {
				// Set the max height for the modal overall, so it fits in the viewport
				$modalContent.css('max-height', viewport_height);

				// If specified, default the modal to vertically fill the viewport
				if ($dialog.attr('data-fullheight') === "true") {
					$modalContent.css('height', viewport_height);
					$modalBody.css('height', content_height);
				} else {
					// Reset the forced height applied when in XS
					$modalContent.css('height', 'auto');
					$modalBody.css('height', 'auto');
				}

				// Set the max height on the body of the modal so it is scrollable
				$dialog.find(".modal-body").css('max-height', content_height);

				// Position the modal vertically centred
				dialogTop = (viewport_height/2) - ($modalDialog.height()/2);

				if ($modalContent.height() < viewport_height ) {
					dialogTop = dialogTop/2;
				}

				$modalDialog.css('top', dialogTop);
			}

		}

	}

	function destroyDialog(dialogId) {
		if (!dialogId || dialogId.length === 0) return;

		var $dialog = $("#" + dialogId);
		$dialog.find('button').off().end().remove();

		var settings = getSettings(dialogId);

		if (settings != null) {
			if (settings.hashId != null) {
				meerkat.modules.address.removeFromHash(settings.hashId)

				var previousInstance = _.findWhere(dialogHistory, {hashId:settings.hashId});
				if(previousInstance == null) dialogHistory.push(settings);
			}

			openedDialogs.splice(settings.index, 1);
		}

	}

	function getSettings(dialogId){
		var index = getDialogSettingsIndex(dialogId);
		if(index !== null){
			openedDialogs[index].index = index;
			return openedDialogs[index];
		}
		return null;
	}

	function getDialogSettingsIndex(dialogId){
		for(var i=0;i<openedDialogs.length;i++){
			if(openedDialogs[i].id == dialogId) return i;
		}
		return null;
	}

	function isDialogOpen(dialogId) {
		return !_.isNull(getDialogSettingsIndex(dialogId));
	}

	// Initialise Dev helpers
	function initDialogs() {

		// Set up touch events on touch devices
		$(document).ready(function() {

			// Bind the default close button
			$(document).on('click', '.btn-close-dialog', function() {
				$(this).closest('.modal').modal('hide');
			});

			if (!Modernizr.touch) return;

			// Stop the background page being scrollable when a modal is open (doesn't work on mobiles really)
			$(document).on('touchmove', '.modal', function(e) {
				e.preventDefault();
			});
			// Allow the modal body to be scrollable
			$(document).on('touchmove', '.modal .modal-body', function(e) {
				e.stopPropagation();
			});
		});

		var self = this;

		meerkat.messaging.subscribe(meerkatEvents.dynamicContentLoading.PARSED_DIALOG, function dialogClicked( event ){

			var dialogInfoObject;

			var hashValue = event.element.attr('data-dialog-hash-id');
			var hashId = null;
			if(hashValue !== '') hashId = hashValue;

			if(event.contentType === 'url'){

				dialogInfoObject = {
					title: event.element.attr('data-title'),
					url: event.contentValue,
					cacheUrl: (event.element.attr('data-cache') ? true : false)
				};
			} else if(event.contentType === 'externalUrl'){
				
				dialogInfoObject = {
					title: event.element.attr('data-title'),
					externalUrl: event.contentValue
				};

			} else {

				dialogInfoObject = {
					title: $( event.contentValue ).attr('data-title'),
					htmlContent: event.contentValue
				};

			}

			var instanceSettings = $.extend({
					hashId: hashId,
					closeOnHashChange: true,
					className: event.element.attr('data-class')
				},
				dialogInfoObject
			);

			show(instanceSettings);

		});

		// Listen for window resizes to reposition and resize dialog windows.
		var lazyLayout = _.debounce(calculateLayout, 300);
		$(window).resize(lazyLayout);

		// Listen for hash changes and close any dialog which requested to be closed on hash change.
		meerkat.messaging.subscribe(meerkatEvents.ADDRESS_CHANGE, function dialogHashChange(event){
			// find windows which need to be closed.
			for(var i=openedDialogs.length-1;i>=0;i--){
				var dialog = openedDialogs[i];
				if(dialog.closeOnHashChange === true){
					if(_.indexOf( event.hashArray, dialog.hashId) == -1){
						self.close(dialog.id);
					}
				}
			}

			// find windows which need to be opened.
			for(var j=0; j<event.hashArray.length;j++){
				var windowOpen = _.findWhere(openedDialogs, {hashId:event.hashArray[j]});
				if(windowOpen == null){
					var previousInstance = _.findWhere(dialogHistory, {hashId:event.hashArray[j]});
					if(previousInstance != null) {
						if(previousInstance.openOnHashChange === true) {
							meerkat.modules.dialogs.show(previousInstance);
				}
			}
				}
			}

		}, window);

	}

	meerkat.modules.register('dialogs', {
		init: initDialogs,
		show: show,
		changeContent: changeContent,
		close: close,
		isDialogOpen: isDialogOpen,
		resizeDialog: resizeDialog
	});


})(jQuery);
;(function($, undefined){

	var meerkat = window.meerkat,
	meerkatEvents = meerkat.modules.events,
	moduleEvents = {
			health: {
				CHANGE_MAY_AFFECT_PREMIUM: 'CHANGE_MAY_AFFECT_PREMIUM'
			},
			WEBAPP_LOCK: 'WEBAPP_LOCK',
			WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
		},
	hasSeenResultsScreen = false,
	rates = null,
	steps = null,
	stateSubmitInProgress = false;

	function initJourneyEngine(){

		if(meerkat.site.pageAction === "confirmation"){

			meerkat.modules.journeyEngine.configure(null);

		}else{

			// Initialise the journey engine steps and bar
			initProgressBar(false);

			// Initialise the journey engine
			var startStepId = null;
			if (meerkat.site.isFromBrochureSite === true) {
				startStepId = steps.detailsStep.navigationId;
			}
			// Use the stage user was on when saving their quote
			else if (meerkat.site.journeyStage.length > 0 && meerkat.site.pageAction === 'amend') {
				// Do not allow the user to go past the results page on amend.
				if(meerkat.site.journeyStage === 'apply' || meerkat.site.journeyStage === 'payment'){
					startStepId = 'results';
				}else{
					startStepId = meerkat.site.journeyStage;
				}
			}

			meerkat.modules.journeyEngine.configure({
				startStepId: startStepId,
				steps: _.toArray(steps)
			});


			// Call initial supertag call
			var transaction_id = meerkat.modules.transactionId.get();

			meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
				method:'trackQuoteEvent',
				object: {
					action: 'Start',
					transactionID: parseInt(transaction_id, 10),
					simplesUser: meerkat.site.isCallCentreUser
				}
			});

			if(meerkat.site.isNewQuote === false){
					meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
						method:'trackQuoteEvent',
						object: {
							action: 'Retrieve',
							transactionID: transaction_id,
							simplesUser: meerkat.site.isCallCentreUser
						}
					});
				}

		}

	}

	function eventSubscriptions() {
		meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, function lockHealth(obj) {
			var isSameSource = (typeof obj !== 'undefined' && obj.source && obj.source === 'submitApplication');
			disableSubmitApplication(isSameSource);
		});

		meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, function unlockHealth(obj) {
			enableSubmitApplication();
		});

		$('#health_application-selection').delegate('.changeStateAndQuote', 'click', changeStateAndQuote);

	}

	function initProgressBar(render){

		setJourneyEngineSteps();
		configureProgressBar();
		if(render){
			meerkat.modules.journeyProgressBar.render(true);
		}
	}

	function setJourneyEngineSteps(){

		var startStep = {
			title: 'Your Details',
			navigationId: 'start',
			slideIndex:0,
			externalTracking:{
				method:'trackQuoteForms',
				object:meerkat.modules.health.getTrackingFieldsObject
			},
			onInitialise: function onStartInit(event){

				// Add event listeners.

				$('.health-situation-healthCvr').on('change',function() {
					healthChoices.setCover($(this).val());
				});

				$('.health-situation-location').on('change',function() {
					healthChoices.setLocation($(this).val());
				});

				if($('#health_situation_location').val() !== '') {
					healthChoices.setLocation($('#health_situation_location').val());
				}

				if($("#health_privacyoptin").val() === 'Y'){
					$(".slide-feature-emailquote").addClass("privacyOptinChecked");
				}

				// Don't fire the change event by default if amend mode and the user has selected items.
				if (meerkat.site.pageAction !== 'amend' && meerkat.site.pageAction !== 'start-again' && meerkat.modules.healthBenefits.getSelectedBenefits().length === 0) {
					if($('.health-situation-healthSitu').val() !== ''){
						$('.health-situation-healthSitu').change();
					}
				}
				

				// This on Start step instead of Details because Simples interacts with it
				var emailQuoteBtn = $(".slide-feature-emailquote");
				$(".health-contact-details-optin-group .checkbox").on("click", function(event){
					var $this = $("#health_privacyoptin");
					if( $this.val() === 'Y' ){
						emailQuoteBtn.addClass("privacyOptinChecked");
					} else {
						emailQuoteBtn.removeClass("privacyOptinChecked");
					}
				});

				if(meerkat.site.isCallCentreUser === true){
					// Handle pre-filled 
					toggleInboundOutbound();
					toggleDialogueInChatCallback();
					meerkat.modules.provider_testing.setApplicationDateCalendar();

					// Handle toggle inbound/outbound
					$('input[name=health_simples_contactType]').on('change', function() {
						toggleInboundOutbound();
					});

					$('.follow-up-call input:checkbox, .simples-privacycheck-statement input:checkbox').on('change', function() {
						toggleDialogueInChatCallback();
					});
				}

			}
		};

		var detailsStep = {
			title: 'Your Details',
			navigationId: 'details',
			slideIndex:1,
			tracking:{
				touchType:'H',
				touchComment: 'HLT detail',
				includeFormData:true
			},
			externalTracking:{
				method:'trackQuoteForms',
				object:meerkat.modules.health.getTrackingFieldsObject
			},
			onInitialise:function onDetailsInit(event){

				// Set initial state.
				healthCoverDetails.setHealthFunds(true);
				healthCoverDetails.setIncomeBase(true);

				// Add event listeners.

				$('#health_healthCover_dependants').on('change', function(){
					meerkat.modules.healthTiers.setTiers();
				});

				$('#health_healthCover-selection').find('.health_cover_details_rebate').on('change', function(){
					healthCoverDetails.setIncomeBase();
					healthChoices.dependants();
					meerkat.modules.healthTiers.setTiers();
				});

				if(meerkat.site.isCallCentreUser === true){
					$('#health_healthCover_incomeBase').find('input').on('change', function(){
						$('#health_healthCover_income').prop('selectedIndex',0);
						meerkat.modules.healthTiers.setTiers();
					});
				}

				$('#health_healthCover-selection').find(':input').on('change', function(event) {
					var $this = $(this);

					// Don't action on the DOB input fields; wait until it's serialised to the hidden field.
					if ($this.hasClass('dateinput-day') || $this.hasClass('dateinput-month') || $this.hasClass('dateinput-year')) return;

					healthCoverDetails.setHealthFunds();

					if(meerkat.site.isCallCentreUser === true){

						// Get rates and show LHC inline.
						loadRates(function(rates){

							$('.health_cover_details_rebate .fieldrow_legend').html('Overall LHC ' + rates.loading + '%');

							if(hasPartner()){
								$('#health_healthCover_primaryCover .fieldrow_legend').html('Individual LHC ' + rates.primaryLoading + '%, overall  LHC ' + rates.loading + '%');
								$('#health_healthCover_partnerCover .fieldrow_legend').html('Individual LHC ' + rates.partnerLoading + '%, overall  LHC ' + rates.loading + '%');
							} else {
								$('#health_healthCover_primaryCover .fieldrow_legend').html('Overall  LHC ' + rates.loading + '%');
							}

							meerkat.modules.healthTiers.setTiers();

						});
					}

				});

				if(meerkat.site.isCallCentreUser === true){
					// Handle pre-filled 
					toggleRebateDialogue();
					// Handle toggle rebate options
					$('input[name=health_healthCover_rebate]').on('change', function() {
						toggleRebateDialogue();
					});
				}

			},
			onBeforeLeave: function(event) {
				// Store the text of the income question - for reports and audits.
				var incomelabel = ($('#health_healthCover_income :selected').val().length > 0) ? $('#health_healthCover_income :selected').text() : '';
				$('#health_healthCover_incomelabel').val( incomelabel );
			}
		};


		var benefitsStep = {
			title: 'Your Cover',
			navigationId: 'benefits',
			slideIndex: 1,
			slideScrollTo: '#navbar-main',
			tracking: {
				touchType: 'H',
				touchComment: 'HLT benefi',
				includeFormData: true
			},
			externalTracking:{
				method:'trackQuoteForms',
				object:meerkat.modules.health.getTrackingFieldsObject
			},
			validation:{
				validate: false
			},
			onInitialise: function onResultsInit(event){
				meerkat.modules.healthResults.initPage();
			},
			onBeforeEnter:function enterBenefitsStep(event) {
				meerkat.modules.healthBenefits.close();
				meerkat.modules.navMenu.disable();
			},
			onAfterEnter: function(event) {
				//Because it has no idea where the #navbar-main is on mobile because it's hidden and position: fixed... we force it to the top.
				if (meerkat.modules.deviceMediaState.get() === 'xs'){
					meerkat.modules.utils.scrollPageTo('html',0,1);
				}
				// Hide any Simples dialogues
				if (meerkat.site.isCallCentreUser === true) {
					$('#journeyEngineSlidesContainer .journeyEngineSlide').eq(meerkat.modules.journeyEngine.getCurrentStepIndex()).find('.simples-dialogue').hide();
				}

				// Defer the open for next js cycle so that the navbar button is visible and we can read the dropdown's height
				if(event.isStartMode === false){
					_.defer(function() {
						meerkat.modules.healthBenefits.open('journey-mode');
					});
				}

				// Delay 1 sec to make sure we have the data bucket saved in to DB, then filter segment
				_.delay(function() {
				meerkat.modules.healthSegment.filterSegments();
				}, 1000);
			},
			onAfterLeave:function(event){
				var selectedBenefits = meerkat.modules.healthBenefits.getSelectedBenefits();
				meerkat.modules.healthResults.onBenefitsSelectionChange(selectedBenefits);
				meerkat.modules.navMenu.enable();
			}
		};
		var contactStep = {
				title: 'Your Contact Details',
				navigationId: 'contact',
				slideIndex: 2,
				tracking: {
					touchType: 'H',
					touchComment: 'HLT contac',
					includeFormData: true
				},
				externalTracking:{
					method:'trackQuoteForms',
					object:meerkat.modules.health.getTrackingFieldsObject
				},
				validation:{
					validate: true
				},
				onInitialise: function onContactInit(event){
				},
				onBeforeEnter:function enterContactStep(event) {
				},
				onAfterEnter: function enteredContactStep(event) {
					meerkat.modules.navMenu.enable();

				},
				onAfterLeave:function leaveContactStep(event){
					/*
					This is here because for some strange reason the benefits slide dropdown disables the tracking touch on the contact
					slide. Manually forcing it to run so that the contact details are saved into the session and subsequently to
					the transaction_details table.
					 */
					meerkat.messaging.publish(meerkat.modules.tracking.events.tracking.TOUCH, this);
				}
			};

		var resultsStep = {
			title: 'Your Results',
			navigationId: 'results',
			slideIndex: 3,
			validation: {
				validate: false,
				customValidation: function validateSelection(callback) {

					if(meerkat.site.isCallCentreUser === true){
						// Check mandatory dialog have been ticked
						var $_exacts = $('.resultsSlide').find('.simples-dialogue.mandatory:visible');
						if( $_exacts.length != $_exacts.find('input:checked').length ){
							meerkat.modules.dialogs.show({
								htmlContent: 'Please complete the mandatory dialogue prompts before applying.'
							});
							callback(false);
						}
					}

					if (meerkat.modules.healthResults.getSelectedProduct() === null) {
						callback(false);
					}
					
					callback(true);
				}
			},
			onInitialise: function onInitResults(event){

				meerkat.modules.healthMoreInfo.initMoreInfo();

			},
			onBeforeEnter:function enterResultsStep(event){

				if(event.isForward && meerkat.site.isCallCentreUser) {
					$('#journeyEngineSlidesContainer .journeyEngineSlide').eq(meerkat.modules.journeyEngine.getCurrentStepIndex()).find('.simples-dialogue').show();
				} else {
				// Reset selected product. (should not be inside a forward or backward condition because users can skip steps backwards)
				meerkat.modules.healthResults.resetSelectedProduct();
					}

				if(event.isForward && meerkat.site.isCallCentreUser) {
					$('#journeyEngineSlidesContainer .journeyEngineSlide').eq(meerkat.modules.journeyEngine.getCurrentStepIndex()).find('.simples-dialogue').show();
				}
			},
			onAfterEnter: function(event){

				if(event.isBackward === true){
					meerkat.modules.healthResults.onReturnToPage();
				}

				if(event.isForward === true){
					meerkat.modules.healthResults.get();
				}

				meerkat.modules.resultsHeaderBar.registerEventListeners();

			},
			onAfterLeave: function(event){
				meerkat.modules.healthResults.stopColumnWidthTracking();
				meerkat.modules.healthResults.recordPreviousBreakpoint();
				meerkat.modules.healthResults.toggleMarketingMessage(false);
				meerkat.modules.healthResults.toggleResultsLowNumberMessage(false);

				// Close the more info and/or modal
				meerkat.modules.healthMoreInfo.close();

				meerkat.modules.resultsHeaderBar.removeEventListeners();
			}
		};

		var applyStep = {
			title: 'Your Application',
			navigationId: 'apply',
			slideIndex: 4,
			tracking:{
				touchType:'A'
			},
			externalTracking:{
				method:'trackQuoteForms',
				object:meerkat.modules.health.getTrackingFieldsObject
			},
			onInitialise: function onInitApplyStep(event){

				healthApplicationDetails.init();

				// Listen to any input field which could change the premium. (on step 4 and 5)
				$(".changes-premium :input").on('change', function(event){
					meerkat.messaging.publish(moduleEvents.health.CHANGE_MAY_AFFECT_PREMIUM);
				});

				// Show/hide membership number and authorisation checkbox questions for previous funds.
				$('#health_previousfund_primary_fundName, #health_previousfund_partner_fundName').on('change', function(){
					healthCoverDetails.displayHealthFunds();
				});

				// Show/Hide simples messaging based on fund selection
				if(meerkat.site.isCallCentreUser === true){

					if( ($('#health_previousfund_primary_fundName').val() !== '' && $('#health_previousfund_primary_fundName').val() != 'NONE') || ($('#health_previousfund_partner_fundName').val() !== '' && $('#health_previousfund_partner_fundName').val() !== 'NONE') ){
						$(".simples-dialogue-15").first().show();
					}else{
						$(".simples-dialogue-15").first().hide();
					}

					$('#health_previousfund_primary_fundName, #health_previousfund_partner_fundName').on('change', function(){
						if( $(this).val() !== '' && $(this).val() !== 'NONE' ){
							$(".simples-dialogue-15").first().show();
						}else if( ($('#health_previousfund_primary_fundName').val() === '' || $('#health_previousfund_primary_fundName').val() == 'NONE') && ($('#health_previousfund_partner_fundName').val() === '' || $('#health_previousfund_partner_fundName').val() === 'NONE') ){
							$(".simples-dialogue-15").first().hide();
						}
					});
				}

				// Check state selection
				$('#health_application_address_postCode, #health_application_address_streetSearch, #health_application_address_suburb').on('change', function(){
					healthApplicationDetails.testStatesParity();
				});

				// Sync income tier value (which can be changed if you change the number of dependants you have).
				$('#health_application_dependants_income').on('change', function(){
					$('#mainform').find('.health_cover_details_income').val( $(this).val() );
				});

				// Perform checks and show/hide questions when the dependant's DOB changes
				$('.health_dependant_details .dateinput_container input.serialise').on('change', function(event){
					healthDependents.checkDependent( $(this).closest('.health_dependant_details').attr('data-id') );
					$(this).valid();
				});

				// Perform checks and show/hide questions when the fulltime radio button changes
				$('.health_dependant_details_fulltimeGroup input').on('change', function(event){
					healthDependents.checkDependent( $(this).closest('.health_dependant_details').attr('data-id') );
					$(this).parents('.health_dependant_details').find('.dateinput_container input.serialise').valid();
				});

				// Add/Remove dependants
				$('#health_application_dependants-selection').find(".remove-last-dependent").on("click", function(){
					healthDependents.dropDependent();
				});
				$('#health_application_dependants-selection').find(".add-new-dependent").on("click", function(){
					healthDependents.addDependent();
				});

				// initialise start date datepicker from payment step as it will be used by selected fund
				$("#health_payment_details_start_calendar")
					.datepicker({ clearBtn:false, format:"dd/mm/yyyy" })
					.on("changeDate", function updateStartCoverDateHiddenField(e) {
						// fill the hidden field with selected value
						$("#health_payment_details_start").val( e.format() );
						meerkat.messaging.publish(moduleEvents.health.CHANGE_MAY_AFFECT_PREMIUM);
					});

			},
			onBeforeEnter: function enterApplyStep(event){

				if(event.isForward === true){
					var selectedProduct = meerkat.modules.healthResults.getSelectedProduct();
					// Show warning if applicable
					if (typeof selectedProduct.warningAlert !== 'undefined' && selectedProduct.warningAlert !== '') {
						$("#health_application-warning").find(".fundWarning").show().html(selectedProduct.warningAlert);
					} else {
						$("#health_application-warning").find(".fundWarning").hide().empty();
					}
					this.tracking.touchComment =  selectedProduct.info.provider + ' ' + selectedProduct.info.des;
					this.tracking.productId = selectedProduct.productId.replace("PHIO-HEALTH-", "");

					// Load the selected product details.
					healthFunds.load(selectedProduct.info.provider);

					// Clear any previous validation errors on Apply or Payment
					var $slide = $('#journeyEngineSlidesContainer .journeyEngineSlide').slice(meerkat.modules.journeyEngine.getCurrentStepIndex() - 1);
					$slide.find('.error-field').remove();
					$slide.find('.has-error').removeClass('has-error');

					// Unset the Health Declaration checkbox (could be refactored to only uncheck if the fund changes)
					$('#health_declaration input:checked').prop('checked', false).change();

					// Update the state of the dependants object.
					healthDependents.setDependants();

					// Check okToCall optin - show if no phone numbers in questionset and NOT Simples
					if($('#health_contactDetails_contactNumber_mobile').val() === '' &&	$('#health_contactDetails_contactNumber_other').val() === '' &&	meerkat.site.isCallCentreUser === false) {
						$('#health_application_okToCall-group').show();
					}

					// Change min and max dates for start date picker based on current stored values from healthPaymentStep module which can change based on selected fund
					//var min = meerkat.modules.healthPaymentStep.getSetting("minStartDateOffset");
					//var max = meerkat.modules.healthPaymentStep.getSetting("maxStartDateOffset");
					//$("#health_payment_details_start_calendar").datepicker("setStartDate", "+" + min + "d").datepicker("setEndDate", "+" + max + "d");
					var min = meerkat.modules.healthPaymentStep.getSetting('minStartDate');
					var max = meerkat.modules.healthPaymentStep.getSetting('maxStartDate');
					$("#health_payment_details_start_calendar").datepicker('setStartDate', min).datepicker('setEndDate', max);

				}
			},
			onAfterEnter: function afterEnterApplyStep(event){
				// Need to call this after the form is visible because of the show/hiding of buttons based on visibility.
				healthDependents.updateDependentOptionsDOM();
			}
		};

		var paymentStep = {
			title: 'Your Payment',
			navigationId: 'payment',
			slideIndex: 5,
			tracking:{
				touchType:'H',
				touchComment: 'HLT paymnt',
				includeFormData:true
			},
			externalTracking:{
				method:'trackQuoteForms',
				object:meerkat.modules.health.getTrackingFieldsObject
			},
			onInitialise: function initPaymentStep(event){

				$("#joinDeclarationDialog_link").on('click',function(){
					var selectedProduct = meerkat.modules.healthResults.getSelectedProduct();
					meerkat.modules.dialogs.show({
						title: 'Declaration',
						url: "health_fund_info/"+selectedProduct.info.provider.toUpperCase()+"/declaration.html"
					});

					meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
						method:'trackOfferTerms',
						object:{
							productID:selectedProduct.productId
						}
					});

				});

				// Submit application button
				$("#submit_btn").on('click', function(event){
					var valid = meerkat.modules.journeyEngine.isCurrentStepValid();

					// Because validation is inline we can't see them inside privacy/compliance panels.
					if (meerkat.site.isCallCentreUser === true) {
						$('.agg_privacy').each(function() {
							var $this = $(this);
							$this.find('.error-count').remove();
							var $errors = $this.find('.error-field label');
							$this.children('button').after('<span class="error-count' + (($errors.length>0) ? ' error-field' : '') + '" style="margin-left:10px">' + $errors.length + ' validation errors in this panel.</span>');
						});
					}

					// Validation passed, submit the application.
					if (valid) {
						submitApplication();
					}
				});

			},
			onBeforeEnter: function enterPaymentStep(event){

				if(event.isForward === true){

					var selectedProduct = meerkat.modules.healthResults.getSelectedProduct();

					// Show discount text if applicable
					if (typeof selectedProduct.promo.discountText !== 'undefined' && selectedProduct.promo.discountText !== '') {
						$("#health_payment_details-selection").find(".definition").show().html(selectedProduct.promo.discountText);
					} else {
						$("#health_payment_details-selection").find(".definition").hide().empty();
					}

					// Show warning if applicable
					if (typeof selectedProduct.warningAlert !== 'undefined' && selectedProduct.warningAlert !== '') {
						$("#health_payment_details-selection").find(".fundWarning").show().html(selectedProduct.warningAlert);
					} else {
						$("#health_payment_details-selection").find(".fundWarning").hide().empty();
					}

					// Insert fund into checkbox label
					$('#mainform').find('.health_declaration span').text( selectedProduct.info.providerName  );

					// Pre-populate medicare fields from previous step (TODO we need some sort of name sync module)
					var $firstnameField = $("#health_payment_medicare_firstName");
					var $surnameField = $("#health_payment_medicare_surname");
					if($firstnameField.val() === '') $firstnameField.val($("#health_application_primary_firstname").val());
					if($surnameField.val() === '') $surnameField.val($("#health_application_primary_surname").val());

					var product = meerkat.modules.healthResults.getSelectedProduct();
					var mustShowList = ["GMHBA","Frank","Budget Direct","Bupa","HIF"];

					if( $('input[name=health_healthCover_rebate]:checked').val() == "N" && $.inArray(product.info.providerName, mustShowList) == -1) {
						$("#health_payment_medicare-selection").hide().attr("style", "display:none !important");
					} else {
						$("#health_payment_medicare-selection").removeAttr("style");
					}

				}
			}
		};

		steps = {
			startStep: startStep,
			detailsStep: detailsStep,
			benefitsStep: benefitsStep,
			contactStep: contactStep,
			resultsStep: resultsStep,
			applyStep: applyStep,
			paymentStep: paymentStep
		};
	}

	function configureProgressBar(){
		meerkat.modules.journeyProgressBar.configure([
			{
				label:'Your Situation',
				navigationId: steps.startStep.navigationId,
				matchAdditionalSteps:[steps.detailsStep.navigationId]
			},
			{
				label:'Your Cover',
				navigationId: steps.benefitsStep.navigationId
			},
			{
				label:'Your details',
				navigationId: steps.contactStep.navigationId
			},
			{
				label:'Your Results',
				navigationId: steps.resultsStep.navigationId
			},
			{
				label:'Your Application',
				navigationId: steps.applyStep.navigationId
			},
			{
				label:'Your Payment',
				navigationId: steps.paymentStep.navigationId
			}
		]);
	}

	function configureContactDetails(){

		var contactDetailsOptinField = $("#health_contactDetails_optin");

		// define fields here that are multiple (i.e. email field on contact details and on application step) so that they get prefilled
		// or fields that need to publish an event when their value gets changed so that another module can pick it up
		// the category names are generally arbitrary but some are used specifically and should use those types (email, name, potentially phone in the future)
		var contactDetailsFields = {
			name:[
				{ $field: $("#health_contactDetails_name") },
				{
					$field: $("#health_application_primary_firstname"),
					$otherField: $("#health_application_primary_surname")
				}
			],
			dob_primary:[
				{
					$field: $("#health_healthCover_primary_dob"), // this is a hidden field
					$fieldInput: $("#health_healthCover_primary_dob") // pointing at the same field as a trick to force change event on itself when forward populated
				},
				{
					$field: $("#health_application_primary_dob"), // this is a hidden field
					$fieldInput: $("#health_application_primary_dob") // pointing at the same field as a trick to force change event on itself when forward populated
				}
			],
			dob_secondary:[
				{
					$field: $("#health_healthCover_partner_dob"), // this is a hidden field
					$fieldInput: $("#health_healthCover_partner_dob") // pointing at the same field as a trick to force change event on itself when forward populated
				},
				{
					$field: $("#health_application_partner_dob"), // this is a hidden field
					$fieldInput: $("#health_application_partner_dob") // pointing at the same field as a trick to force change event on itself when forward populated
				}
			],
			email: [
				// email from details step
				{
					$field: $("#health_contactDetails_email"),
					$optInField: contactDetailsOptinField
				},
				// email from application step
				{
					$field: $("#health_application_email"),
					$optInField: $("#health_application_optInEmail")
				}
			],
			mobile: [
				// mobile from details step
				{
					$field: $("#health_contactDetails_contactNumber_mobile"),
					$fieldInput: $("#health_contactDetails_contactNumber_mobileinput"),
					$optInField: contactDetailsOptinField
				},
				// mobile from application step
				{
					$field: $("#health_application_mobile"),
					$fieldInput: $("#health_application_mobileinput")
				}
			],
			otherPhone: [
				// otherPhone from details step
				{
					$field: $("#health_contactDetails_contactNumber_other"),
					$fieldInput: $("#health_contactDetails_contactNumber_otherinput"),
					$optInField: contactDetailsOptinField
				},
				// otherPhone from application step
				{
					$field: $("#health_application_other"),
					$fieldInput: $("#health_application_otherinput")
				}
			],
			postcode: [
				// postcode from details step
				{ $field: $("#health_situation_postcode") },
				//postcode from application step
				{
					$field: $("#health_application_address_postCode"),
					$fieldInput: $("#health_application_address_postCode")
				}
			]
		};

		meerkat.modules.contactDetails.configure(contactDetailsFields);

	}

	// Use the situation value to determine if a partner is visible on the journey.
	function hasPartner(){
		var cover = $(':input[name="health_situation_healthCvr"]').val();
		if(cover == 'F' || cover == 'C'){
			return true;
		}else{
			return false;
		}
	}

	// Make the rates object available outside of this module.
	function getRates(){
		return rates;
	}

	// Make the rebate available publicly, and handle rates property being null.
	function getRebate() {
		if (rates != null && rates.rebate) {
			return rates.rebate;
		}
		else {
			return 0;
		}
	}

	// Set the rates object and hidden fields in the form so it is included in post data.
	function setRates(ratesObject){
		rates = ratesObject;
		$("#health_rebate").val((rates.rebate || ''));
		$("#health_rebateChangeover").val((rates.rebateChangeover || ''));
		$("#health_loading").val((rates.loading || ''));
		$("#health_primaryCAE").val((rates.primaryCAE || ''));
		$("#health_partnerCAE").val((rates.partnerCAE || ''));

		meerkat.modules.healthResults.setLhcApplicable(rates.loading);
	}

	// Load the rates object via ajax. Also validates currently filled in fields to ensure only valid attempts are made.
	function loadRates(callback){

		$healthCoverDetails = $('.health-cover_details');

		var postData = {
			dependants: $healthCoverDetails.find(':input[name="health_healthCover_dependants"]').val(),
			income:$healthCoverDetails.find(':input[name="health_healthCover_income"]').val(),
			rebate_choice:$healthCoverDetails.find('input[name="health_healthCover_rebate"]:checked').val(),
			primary_loading:$healthCoverDetails.find('input[name="health_healthCover_primary_healthCoverLoading"]:checked').val(),
			primary_current: $healthCoverDetails.find('input[name="health_healthCover_primary_cover"]:checked').val(),
			primary_loading_manual:$healthCoverDetails.find('.primary-lhc').val(),
			partner_loading:$healthCoverDetails.find('input[name="health_healthCover_partner_healthCoverLoading"]:checked').val(),
			partner_current:$healthCoverDetails.find('input[name="health_healthCover_partner_cover"]:checked').val(),
			partner_loading_manual:$healthCoverDetails.find('.partner-lhc').val(),
			cover:$(':input[name="health_situation_healthCvr"]').val()
		};

		if( $('#health_application_provider, #health_application_productId').val() === '' ) {

			// before application stage
			postData.primary_dob = $healthCoverDetails.find('input[name="health_healthCover_primary_dob"]').val();
			postData.partner_dob = $healthCoverDetails.find('input[name="health_healthCover_partner_dob"]').val();

		} else {

			// in application stage
			postData.primary_dob = $('#health_application_primary_dob').val();
			postData.partner_dob = $('#health_application_partner_dob').val();
			postData.primary_current = ( $('#clientFund').find(':selected').val() == 'NONE' )?'N':'Y';
			postData.partner_current = ( $('#partnerFund').find(':selected').val() == 'NONE' )?'N':'Y';

		}

		// Check if there is enough data to ask the server.
		var coverTypeHasPartner = hasPartner();
		if(postData.cover === '') return false;
		if (postData.rebate_choice === '') return false;
		if(postData.primary_dob === '') return false;
		if(coverTypeHasPartner && postData.partner_dob === '')  return false;

		if(returnAge(postData.primary_dob) < 0) return false;
		if(coverTypeHasPartner && returnAge(postData.partner_dob) < 0)  return false;
		if(postData.rebate_choice === "Y" && postData.income === "") return false;

		// check in valid date format
		var dateRegex = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/;

		if(!postData.primary_dob.match(dateRegex)) return false;
		if(coverTypeHasPartner && !postData.partner_dob.match(dateRegex))  return false;

		meerkat.modules.comms.post({
			url:"ajax/json/health_rebate.jsp",
			data: postData,
			cache:true,
			errorLevel: "warning",
			onSuccess:function onRatesSuccess(data){
				setRates(data);
				if(callback != null) callback(data);
			}
		});
	}

	function changeStateAndQuote(event) {
		event.preventDefault();

		var suburb = $('#health_application_address_suburbName').val();
		var postcode = $('#health_application_address_postCode').val();
		var state = $('#health_application_address_state').val();
		$('#health_situation_location').val([suburb, postcode, state].join(' '));
		$('#health_situation_suburb').val(suburb);
		$('#health_situation_postcode').val(postcode);
		$('#health_situation_state').val(state);
		healthChoices.setState(state);

		window.location = this.href;

		var handler = meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function changeStateAndQuoteStep( step ){
			meerkat.messaging.unsubscribe(meerkatEvents.journeyEngine.STEP_CHANGED, handler);
			meerkat.modules.healthResults.get();
		});

		//OLD CODE: Results.resubmitForNewResults();
	}

	// Build an object to be sent by SuperTag tracking.
	function getTrackingFieldsObject(){
		try{


		var state = $("#health_situation_state").val();
		var state2 = $("#health_application_address_state").val();
		// Set state to application state if provided and is different
		if( state2.length && state2 != state ) {
			state = state2;
		}

		var gender = null;
		var $gender = $('input[name=health_application_primary_gender]:checked');
		if( $gender ) {
			if( $gender.val() == "M" ) {
				gender = "Male";
			} else if( $gender.val() == "F" ) {
				gender = "Female";
			}
		}

		var yob = "";
		var yob_str = $("#health_healthCover_primary_dob").val();
		if( yob_str.length ) {
			yob = yob_str.split("/")[2];
		}

		var ok_to_call = $('input[name=health_contactDetails_call]', '#mainform').val() === "Y" ? "Y" : "N";
		var mkt_opt_in = $('input[name=health_application_optInEmail]:checked', '#mainform').val() === "Y" ? "Y" : "N";

		var email = $("#health_contactDetails_email").val();
		var email2 = $("#health_application_email").val();
		// Set email to application email if provided and is different
		if( email2.length > 0 ) {
			email = email2;
		}

		var transactionId = meerkat.modules.transactionId.get();

		var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
		var furtherest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();

		//@TODO @FIXME - In the review with Rebecca, Tim, Kevin, on 24th of Feb 2014, it's likely that this lookup table wont be required anymore, and we can pass through the name of the journey engine step directly.
		//Update 1: Looks like nobody really knows or considered which calls are required. Also, the current code is basically magical (not understood), so without further review of what they want, the original stages will be logged. Hence this mapping here is still required. The livechat stats will still report the exact journey step names instead. Eg. the below mappings could be replaced by 'start', 'details', 'benefits', 'results', 'apply', 'payment', 'confirmation'.
		var actionStep='';

		switch (current_step) {
			case 0:
				actionStep = "health situation";
				break;
			case 1:
				actionStep = 'health details';
				break;
			case 2:
				actionStep = 'health cover';
				break;
			case 3:
				actionStep = 'health cover contact';
				break;
			case 5:
				actionStep = 'health application';
				break;
			case 6:
				actionStep = 'health payment';
				break;
			case 7:
				actionStep = 'health confirmation';
				break;
		}

		var response =  {
			vertical:				'Health',
			actionStep:				actionStep,
			transactionID:			transactionId,
			quoteReferenceNumber:	transactionId,
			postCode:				null,
			state:					null,
			healthCoverType:		null,
			healthSituation:		null,
			gender:					null,
			yearOfBirth:			null,
			email:					null,
			emailID:				null,
			marketOptIn:			null,
			okToCall:				null,
			simplesUser:			meerkat.site.isCallCentreUser
		};

		// Push in values from 1st slide only when have been beyond it
		if(furtherest_step > meerkat.modules.journeyEngine.getStepIndex('start')) {
			$.extend(response, {
				postCode:				$("#health_application_address_postCode").val(),
				state:					state,
				healthCoverType:		$("#health_situation_healthCvr").val(),
				healthSituation:		$("#health_situation_healthSitu").val()
			});
		}

		// Push in values from 2nd slide only when have been beyond it
		if(furtherest_step > meerkat.modules.journeyEngine.getStepIndex('details')) {
			$.extend(response, {
				yearOfBirth:	yob,
				email:			email,
				marketOptIn:	mkt_opt_in,
				okToCall:		ok_to_call
			});
		}

		// Push in values from 2nd slide only when have been beyond it
		if(furtherest_step > meerkat.modules.journeyEngine.getStepIndex('apply')) {
			$.extend(response, {gender:gender});
		}

		return response;

		}catch(e){
			return false;
		}
	}


	function enableSubmitApplication() {
		// Enable button, hide spinner
		var $button = $('#submit_btn');
		$button.removeClass('disabled');
		meerkat.modules.loadingAnimation.hide($button);
	}

	function disableSubmitApplication(isSameSource) {
		// Disable button, show spinner
		var $button = $('#submit_btn');
		$button.addClass('disabled');
		if (isSameSource === true) {
			meerkat.modules.loadingAnimation.showAfter($button);
		}
	}

	function submitApplication() {

		if (stateSubmitInProgress === true) {
			alert('Your application is still being submitted. Please wait.');
			return;
		}
		stateSubmitInProgress = true;

		meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, { source: 'submitApplication' });

		try {
		var postData = meerkat.modules.journeyEngine.getFormData();

		// Disable fields must happen after the post data has been collected.
		meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, { source: 'submitApplication', disableFields:true });

		meerkat.modules.comms.post({
			url: "ajax/json/health_application.jsp",
			data: postData,
			cache: false,
			useDefaultErrorHandling:false,
			errorLevel: "silent",
			timeout: 250000, //10secs more than SOAP timeout
			onSuccess: function onSubmitSuccess(resultData) {

					meerkat.modules.leavePageWarning.disable();
					
					var redirectURL = "health_confirmation.jsp?action=confirmation&transactionId="+meerkat.modules.transactionId.get()+"&token=";
					var extraParameters = "";

					if (meerkat.site.utm_source !== '' && meerkat.site.utm_medium !== '' && meerkat.site.utm_campaign !== ''){
						extraParameters = "&utm_source=" + meerkat.site.utm_source + "&utm_medium=" + meerkat.site.utm_medium + "&utm_campaign=" + meerkat.site.utm_campaign
					}

				// Success
				if (resultData.result && resultData.result.success){
						window.location.replace( redirectURL + resultData.result.confirmationID + extraParameters );

				// Pending and not a call centre user (we want them to see the errors)
				} else if (resultData.result && resultData.result.pendingID && resultData.result.pendingID.length > 0 && (!resultData.result.callcentre || resultData.result.callcentre !== true) ) {
						window.location.replace( redirectURL + resultData.result.pendingID + extraParameters );

				// Handle errors
				} else {
					// Normally this shouldn't be reached because it should go via the onError handler thanks to the comms module detecting the error.
					meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, { source: 'submitApplication' });
					handleSubmittedApplicationErrors( resultData );
				}
			},
				onError: onSubmitApplicationError,
				onComplete: function onSubmitComplete() {
					stateSubmitInProgress = false;
			}
		});

	}
		catch(e) {
			stateSubmitInProgress = false;
			onSubmitApplicationError();
		}

	}

	function onSubmitApplicationError(jqXHR, textStatus, errorThrown, settings, data) {
		meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, { source: 'submitApplication' });
		stateSubmitInProgress = false;
		if(errorThrown == meerkat.modules.comms.getCheckAuthenticatedLabel()) {
			// Handling of this error is defined in comms module
		} else if (textStatus == 'Server generated error') {
			handleSubmittedApplicationErrors( errorThrown );
		} else {
			handleSubmittedApplicationErrors( data );
	}
	}

	function handleSubmittedApplicationErrors( resultData ){
		var error = resultData;
		if (resultData.hasOwnProperty("error") && typeof resultData.error == "object") {
			error = resultData.error;
		}


		var msg='';
		var validationFailure = false;
		try {
			// Handle errors return by provider
			if (resultData.result && resultData.result.errors) {
				var target = resultData.result.errors;
				if ($.isArray(target.error)) {
					target = target.error;
				}
				$.each(target, function(i, error) {
					msg += "<p>";
					msg += '[Code: '+error.code+'] ' + error.text;
					msg += "</p>";
				});
				if (msg === '') {
					msg = 'An unhandled error was received.';
				}
			// Handle internal SOAP error
			} else if (error && error.hasOwnProperty("type")) {
				switch(error.type) {
					case "validation":
						validationFailure = true;
						break;
					case "timeout":
						msg = "Fund application service timed out.";
						break;
					case "parsing":
						msg = "Error parsing the XML request - report issue to developers.";
						break;
					case "confirmed":
						msg = error.message;
						break;
					case "transaction":
						msg = error.message;
						break;
					case "submission":
						msg = error.message;
						break;
					default:
						msg ='['+error.code+'] ' + error.message + " (Please report to IT before continuing)";
						break;
				}
			// Handle unhandled error
			} else {
				msg='An unhandled error was received.';
			}
		} catch(e) {
			msg='Application unsuccessful. Failed to handle response: ' + e.message;
		}

		if(validationFailure) {
			meerkat.modules.serverSideValidationOutput.outputValidationErrors({
				validationErrors: error.errorDetails.validationErrors,
				startStage: 'payment'
				});
			if (typeof error.transactionId != 'undefined') {
				meerkat.modules.transactionId.set(error.transactionId);
			}
		} else {

			// Only show the real error to the Call Centre operator
			if (meerkat.site.isCallCentreUser === false) {
				msg = "Please contact us on <span class=\"callCentreHelpNumber\">"+meerkat.site.content.callCentreHelpNumberApplication+"</span> for assistance.";
			}
			meerkat.modules.errorHandling.error({
				message:		"<strong>Application failed:</strong><br/>" + msg,
				page:			"health.js",
				errorLevel: "warning",
				description:	"handleSubmittedApplicationErrors(). Submit failed: " + msg,
				data:			resultData
			});

			//call the custom fail handler for each fund
			if (healthFunds.applicationFailed) {
				healthFunds.applicationFailed();
			}
		}

	}

	// Hide/show simple dialogues when toggle inbound/outbound in simples journey
	function toggleInboundOutbound() {
		// Inbound
		if ($('#health_simples_contactType_inbound').is(':checked')) {
			$('.follow-up-call').addClass('hidden');
			$('.simples-privacycheck-statement, .new-quote-only').removeClass('hidden');
			$('.simples-privacycheck-statement input:checkbox').prop('disabled', false);
		}
		// Outbound
		else if ($('#health_simples_contactType_outbound').is(':checked')){
			$('.simples-privacycheck-statement, .new-quote-only, .follow-up-call').addClass('hidden');
		}
		// Follow up call
		else if ($('#health_simples_contactType_followup').is(':checked')){
			$('.simples-privacycheck-statement, .new-quote-only').addClass('hidden');
			$('.follow-up-call').removeClass('hidden');
			$('.follow-up-call input:checkbox').prop('disabled', false);
		}
		// Chat Callback
		else if ($('#health_simples_contactType_callback').is(':checked')){
			$('.simples-privacycheck-statement, .new-quote-only, .follow-up-call').removeClass('hidden');
			toggleDialogueInChatCallback();
	}
	}

	// Hide/show simple Rebate dialogue when toggle rebate options in simples journey
	function toggleRebateDialogue() {
		// apply rebate
		if ($('#health_healthCover_rebate_Y').is(':checked')) {
			$('.simples-dialogue-37').removeClass('hidden');
		}
		// no rebate
		else if ($('#health_healthCover_rebate_N').is(':checked')){
			$('.simples-dialogue-37').addClass('hidden');
		}
	}

	// Disable/enable follow up/New quote dialogue when the other checkbox ticked in Chat Callback sesction in simples
	function toggleDialogueInChatCallback() {
		var $followUpCallField = $('.follow-up-call input:checkbox');
		var $privacyCheckField = $('.simples-privacycheck-statement input:checkbox');

		if ($followUpCallField.is(':checked')) {
			$privacyCheckField.attr('checked', false);
			$privacyCheckField.prop('disabled', true);
			$('.simples-privacycheck-statement .error-field').hide();
		}else if ($privacyCheckField.is(':checked')) {
			$followUpCallField.attr('checked', false);
			$followUpCallField.prop('disabled',true);
			$('.follow-up-call .error-field').hide();
		}else{
			$privacyCheckField.prop('disabled', false);
			$followUpCallField.prop('disabled', false);
			$('.simples-privacycheck-statement .error-field').show();
			$('.follow-up-call .error-field').show();
		}
	}

	function initHealth() {

		var self = this;

		$(document).ready(function() {

			// Only init if health... obviously...
			if(meerkat.site.vertical !== "health") return false;

			// Init common stuff
			initJourneyEngine();

			// Only continue if not confirmation page.
			if(meerkat.site.pageAction === "confirmation") return false;

			// Online user, check if livechat is active and needs to show a button
			if(meerkat.site.isCallCentreUser === false){
				setInterval(function(){
					var content = $('#chat-health-insurance-sales').html();
					if(content === "" || content === "<span></span>"){
						$('#contact-panel').removeClass("hasButton");
					} else {
						$('#contact-panel').addClass("hasButton");
					}
				}, 5000);
			}

			eventSubscriptions();
			configureContactDetails();

			if (meerkat.site.pageAction === 'amend' || meerkat.site.pageAction === 'load' || meerkat.site.pageAction === 'start-again') {

				// If retrieving a quote and a product had been selected, inject the fund's application set.
				if (typeof healthFunds !== 'undefined' && healthFunds.checkIfNeedToInjectOnAmend) {
					healthFunds.checkIfNeedToInjectOnAmend(function onLoadedAmeded(){
						// Need to mark any populated field with a data attribute so it is picked up with by the journeyEngine.getFormData()
						// This is because values from forward steps will not be selected and will be lost when the quote is re-saved.
						meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
					});
				}else{
					meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
				}
			}

			$("#health_contactDetails_optin").on("click", function(){
				var optinVal = $(this).is(":checked") ? "Y" : "N";
				$('#health_privacyoptin').val(optinVal);
				$("#health_contactDetails_optInEmail").val(optinVal);
				$("#health_contactDetails_call").val(optinVal);
			});

			if ($('input[name="health_directApplication"]').val() === 'Y') {
				$('#health_application_productId').val( meerkat.site.loadProductId );
				$('#health_application_productTitle').val( meerkat.site.loadProductTitle );
			}

			healthDependents.init();

			if(meerkat.site.isCallCentreUser === true){
				meerkat.modules.simplesSnapshot.initSimplesSnapshot();
			}


		});

	}

	meerkat.modules.register("health", {
		init: initHealth,
		events: moduleEvents,
		initProgressBar: initProgressBar,
		getTrackingFieldsObject: getTrackingFieldsObject,
		getRates: getRates,
		getRebate: getRebate,
		loadRates: loadRates
	});

})(jQuery);
;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events;

	var moduleEvents = {};

	var isActive		=	false,
		fromMonth		=	null,
		disabledFunds	=	[];

	function getIsActive() {
		return isActive;
	}

	function getFromMonth() {
		return fromMonth;
	}

	function isFundDisabled(fund) {
		return _.indexOf(disabledFunds, fund) >= 0;
	}

	function init() {

		var self = this;

		$(document).ready(function() {

			var json = meerkat.site.alternatePricing;
			if(!_.isNull(json) && _.isObject(json) && !_.isEmpty(json)) {
				// A little sanity check
				if(json.hasOwnProperty("isActive") && json.hasOwnProperty("fromMonth") && json.hasOwnProperty("disabledFunds")) {
					isActive = json.isActive;
					fromMonth = json.fromMonth;
					disabledFunds = json.disabledFunds;
				}
			}

		});
	}

	meerkat.modules.register("healthAltPricing", {
		init: init,
		events: moduleEvents,
		getIsActive: getIsActive,
		getFromMonth: getFromMonth,
		isFundDisabled: isFundDisabled
	});

})(jQuery);
;(function($){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		$dropdown,  //Stores the jQuery object for this dropdown
		$component, //Stores the jQuery object for the component group
		mode,
		changedByCallCentre = false,
		isIE8;

	var events = {
			healthBenefits: {
				CHANGED: 'HEALTH_BENEFITS_CHANGED'
			}
		},
		moduleEvents = events.healthBenefits;

	var MODE_POPOVER = 'popover-mode'; // Triggered as pop over
	var MODE_JOURNEY = 'journey-mode'; // Triggered by journey engine step. Different buttons are shown and different events are triggered.


	function getProductCategory() {
		var hospital = $('#health_benefits_benefitsExtras_Hospital').is(':checked');
		var extras = $('#health_benefits_benefitsExtras_GeneralHealth').is(':checked');

		if (hospital > 0 && extras) {
			return 'Combined';
		} else if (hospital) {
			return 'Hospital';
		} else if (extras) {
			return 'GeneralHealth';
		} else {
			return 'None';
		}
	}

	function getBenefitsForSituation(situation, isReset, callback){

		//if callCentre user made change on benefits dropdown, do not prefill
		if(changedByCallCentre) return;

		if(situation === ""){
			populateHiddenFields([], isReset);
			if (typeof callback === 'function') {
				callback();
			}
			return;
		}

		meerkat.modules.comms.post({
			url:"ajax/csv/get_benefits.jsp",
			data: {
				situation: situation
			},
			errorLevel: "silent",
			cache:true,
			onSuccess:function onBenefitSuccess(data){
				defaultBenefits = data.split(',');
				populateHiddenFields(defaultBenefits, isReset);
				if (typeof callback === 'function') {
					callback();
			}
			}
		});

	}

	// The information submitted to the server is contained in hidden fields. The values are read from here before making the popover visible.
	function resetHiddenFields(){
		$("#mainform input[type='hidden'].benefit-item").val('');
	}

	function populateHiddenFields(checkedBenefits, isReset){

		if(isReset){
		resetHiddenFields();
		}

		for(var i=0;i<checkedBenefits.length;i++){
			var path = checkedBenefits[i];
			var element = $("#mainform input[name='health_benefits_benefitsExtras_"+path+"'].benefit-item").val('Y');
		}

	}

	// Populate and reset the checkboxes on the drop down to match the values from the hidden fields.
	function resetDisplayComponent(){
		$component.find(".benefits-list input[type='checkbox']").prop('checked', false);
		if (isIE8) $component.find(".benefits-list input[type='checkbox']").change();
	}

	function populateDisplayComponent(){

		resetDisplayComponent();

		// Get values from hidden fields and display them.//
		$( "#mainform input.benefit-item" ).each(function( index, element ) {
			var $element = $(element);
			if($element.val() == 'Y'){
				var key = $element.attr('name');
				$component.find(".benefits-list :input[name='"+key+"']").prop('checked', true);
				if (isIE8) $component.find(".benefits-list :input[name='"+key+"']").change();
			}
		});

		// Redraw bootstrap switches.
		$component.find('input.checkbox-switch').bootstrapSwitch('setState');

		// Set disabled/enabled states on checkboxes
		$component.find('input.hasChildren').each(function( index, element ) {
			updateEnableSectionState(element);
		});

	}

	// Control the enabled/disabled state of checkboxes from the top level on/off switches
	function onSectionChange(event) {
		
		// At least one top level checkbox must be selected:
		if($component.find(':input.hasChildren:checked').length === 0){
			$component.find('.btn-save').prop('disabled', true);
			$component.find('a.btn-save').addClass('disabled');
		}else{
			$component.find('.btn-save').prop('disabled', false);
			$component.find('a.btn-save').removeClass('disabled');
		}

		updateEnableSectionState($(this));

	}

	function updateEnableSectionState(element) {
		var $element = $(element),
			disabled = !$element.is(':checked'),
			$first = $element.parents('.short-list-item').first(),
			$childrenInputs = $first.find(".children :input");

		$childrenInputs.prop('disabled', disabled);

		if (disabled === true) {
			$first.addClass('disabled');
			$childrenInputs.prop('checked', false);
		} else {
			$first.removeClass('disabled');
		}

		if (isIE8) $childrenInputs.change();
	}

	// Get the selected benefits from the forms hidden fields (the source of truth! - not the checkboxes)
	function getSelectedBenefits(){
		
		var benefits = [];
		
		$( "#mainform input.benefit-item" ).each(function( index, element ) {
			var $element = $(element);
			if($element.val() == 'Y'){
				var key = $element.attr('data-skey');
				benefits.push(key);
			}
		});

		return benefits;

	}

	function saveBenefits(){

		resetHiddenFields();

		var selectedBenefits = [];

		$component.find(':input:checked').each(function( index, element ) {
			var $element = $("#mainform input[name='"+ $(element).attr('name')+"'].benefit-item");
			$element.val('Y');
			selectedBenefits.push($element.attr('data-skey'));
		});

		// when hospital is set to off in [Customise Cover] disable the hospital level drop down in [Filter Results]
		if(_.contains(selectedBenefits, 'Hospital')){
			$('#filter-tierHospital').removeClass('hidden');
		}else{
			$('#filter-tierHospital').addClass('hidden');
			$('#filters_tierHospital').val('');
			$('#health_filter_tierHospital').val('');
		}
		// when extra is set to off in [Customise Cover] disable the extra level drop down in [Filter Results]
		if(_.contains(selectedBenefits, 'GeneralHealth')){
			$('#filter-tierExtras').removeClass('hidden');
		}else{
			$('#filter-tierExtras').addClass('hidden');
			$('#filters_tierExtras').val('');
			$('#health_filter_tierExtras').val('');
		}

		return selectedBenefits;

	}

	// Save and close dropdown
	function saveSelection(){

		// Show the loading only on #benefits and #results because Simples can open it on earlier slides.
		var navigationId = '';
		if (meerkat.modules.journeyEngine.getCurrentStep()) navigationId = meerkat.modules.journeyEngine.getCurrentStep().navigationId;

		if (navigationId === 'results') {
			meerkat.modules.journeyEngine.loadingShow('getting your quotes', true);
		}
		
		close();
		
		// Defers are here for performance reasons on tablet/mobile.
		_.defer(function(){

			var selectedBenefits = saveBenefits();

			if (mode === MODE_JOURNEY) {
				meerkat.modules.journeyEngine.gotoPath("next"); //entering the results step will step up the selected benefits.
			}else{
				meerkat.messaging.publish(moduleEvents.CHANGED, selectedBenefits);
			}

			if(meerkat.site.isCallCentreUser === true){
				changedByCallCentre = true;
			}

		});

	}

	// Enable parent switch when disabled child checkbox is clicked.
	function enableParent(event){
		$target = $(event.currentTarget);
		if($target.find('input').prop('disabled') === true){
			$target.parents('.hasShortlistableChildren').first().find(".title").first().find(':input').prop('checked', true);
			$component.find('input.checkbox-switch').bootstrapSwitch('setState'); // Redraw bootstrap switches.
		}
	}

	// Rules and logic to decide which code to be sent to the ajax call to prefill the benefits
	function prefillBenefits(){
		var healthSitu = $('#health_situation_healthSitu').val(),// 3 digit code from step 1 health situation drop down.
			healthSituCvr = getHealthSituCvr();// 3 digit code calculated from other situations, e.g. Age, cover type

		if(healthSituCvr === '' || healthSitu === 'ATP'){// if only step 1 healthSitu has value or ATP is selected, reset the benefits and call ajax once
			getBenefitsForSituation(healthSitu, true);
		}else{
			getBenefitsForSituation(healthSitu, true, function(){// otherwise call ajax twice to get conbined benefits.
				getBenefitsForSituation(healthSituCvr, false);
			});
		}
	}

	// Get 3 digit code for health situation cover based on cover type and age bands
	// YOU = Young [16-30] Single/Couple
	// MID = Middle [31-55] Single/Couple
	// MAT = Mature [56-120] Single/Couple
	// FAM = Family and SP Family (all ages) 
	function getHealthSituCvr() {
		var cover = $('#health_situation_healthCvr').val(),
			primary_dob = $('#health_healthCover_primary_dob').val(),
			partner_dob = $('#health_healthCover_partner_dob').val(),
			primary_age = 0, partner_age = 0, ageAverage = 0,
			healthSituCvr = '';

		if(cover === 'F' || cover === 'SPF'){
			healthSituCvr = 'FAM';
		} else if((cover === 'S' || cover === 'SM' || cover === 'SF') && primary_dob !== '') {
			ageAverage = returnAge(primary_dob, true);
			healthSituCvr = getAgeBands(ageAverage);
		} else if(cover === 'C' && primary_dob !== '' && partner_dob !== '') {
			primary_age = returnAge(primary_dob),
			partner_age = returnAge(partner_dob);
			if ( 16 <= primary_age && primary_age <= 120 && 16 <= partner_age && partner_age <= 120 ){
				ageAverage = Math.floor( (primary_age + partner_age) / 2 );
				healthSituCvr = getAgeBands(ageAverage);
			}
		}

		return healthSituCvr;
	}

	// use age to calculate the Age Bands
	function getAgeBands(age){
		if(16 <= age && age <= 30){
			return 'YOU';
		}else if(31 <= age && age <= 55){
			return 'MID';
		}else if(56 <= age && age <= 120){
			return 'MAT';
		}else{
			return '';
		}
	}
	function resetBenefitsForProductTitleSearch() {
		if (meerkat.site.environment === 'localhost' || meerkat.site.environment === 'nxi' || meerkat.site.environment === 'nxs'){
			if ($('#health_productTitleSearch').val().trim() !== ''){
				resetHiddenFields();
				$("#mainform input[name='health_benefits_benefitsExtras_Hospital'].benefit-item").val('Y');
				$("#mainform input[name='health_benefits_benefitsExtras_GeneralHealth'].benefit-item").val('Y');
			}
		}
	}
	// Open the dropdown with code (public method). Specify a 'mode' of 'journey-mode' to apply different UI options.
	function open(modeParam) {

		// reset benefits for devs when use product title to search
		resetBenefitsForProductTitleSearch();
		mode = modeParam;

		// Open the menu on mobile too.
		meerkat.modules.navMenu.open();

		if($dropdown.hasClass('open') === false){
			$component.addClass(mode);
			$dropdown.find('.activator').dropdown('toggle');
		}
	}

	// Add event listeners when dropdown is opened.
	function afterOpen() {
		$component.find(':input.hasChildren').on('change.benefits', onSectionChange);
		$component.find('.btn-save').on('click.benefits', saveSelection);
		$component.find('.btn-cancel').on('click.benefits', close);
		$component.find(".categoriesCell .checkbox").on('click.benefits', enableParent);
	}

	// Close the drop down with code (public method).
	function close() {
		if ($dropdown.hasClass('open')) {

			if (isLocked()) {
				unlockBenefits();
				$dropdown.find('.activator').dropdown('toggle');
				lockBenefits();
			}
			else {
				$dropdown.find('.activator').dropdown('toggle');
			}

			//Also close the hamburger menu on mobile which contains the close.
			meerkat.modules.navMenu.close();
		}
	}

	// Remove event listeners and reset class state when dropdown is closed.
	function afterClose(){
		$component.find('input.hasChildren').off('change.benefits');
		$component.find('.btn-save').off('click.benefits');
		$component.find('.btn-cancel').off('click.benefits');
		$component.find(".categoriesCell .checkbox").off('click.benefits', enableParent);

		$component.removeClass('journey-mode');
		$component.removeClass('popover-mode');

		mode = null;
	}


	function init(){

		$(document).ready(function(){

			if (meerkat.site.vertical !== "health" || meerkat.site.pageAction === "confirmation") return false;

			// Store the jQuery objects
			$dropdown = $('#benefits-dropdown');
			$component = $('.benefits-component');

			isIE8 = meerkat.modules.performanceProfiling.isIE8();

			$dropdown.on('show.bs.dropdown', function () {
				if(mode === null) mode = MODE_POPOVER;
				afterOpen();
				populateDisplayComponent();
			});

			$dropdown.on('hide.bs.dropdown', function(event) {
				// TODO Rethink this to make it more generic and not hard-coded to prevent closure on step 2.
				// ?maybe connected to the toggle button being enabled/disabled?
				if(meerkat.modules.journeyEngine.getCurrentStepIndex() == 2) {
					// Prevent hidden.bs.dropdown from running
					event.preventDefault();

					// Re-apply the backdrop because we can't prevent Bootstrap from removing it
					meerkat.modules.dropdownInteractive.addBackdrop($dropdown);
				}
			});

			$dropdown.on('hidden.bs.dropdown', function () {
				afterClose();
			});

			meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function jeStepChange(step){
				if (step.navigationId === 'benefits') {
					return;
				}
				// Close dropdowns when changing steps
				meerkat.modules.healthBenefits.close();
			});

			$("[data-benefits-control='Y']").click(function(event){
				event.preventDefault();
				event.stopPropagation();
				open(MODE_POPOVER);
			});

			$('#health_situation_healthSitu')
			.add('#health_healthCover_primary_dob')
			.add('#health_healthCover_partner_dob')
			.add('#health_situation_healthCvr').on('change',function(event) {
				prefillBenefits();
			});

			// On application lockdown/unlock, disable/enable the dropdown
			meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, lockBenefits);
			meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, unlockBenefits);
		});
	}

	function isLocked() {
		return $dropdown.children('.activator').hasClass('disabled');
	}

	function lockBenefits() {
		$dropdown.children('.activator').addClass('inactive').addClass('disabled');
	}

	function unlockBenefits() {
		$dropdown.children('.activator').removeClass('inactive').removeClass('disabled');
	}

	meerkat.modules.register('healthBenefits', {
		init: init,
		events: events,
		open: open,
		close: close,
		getProductCategory: getProductCategory,
		getSelectedBenefits:getSelectedBenefits,
		getBenefitsForSituation:getBenefitsForSituation
	});

})(jQuery);

//
// Health Confirmation Module
//
;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var confirmationProduct = null;

	function init(){

		jQuery(document).ready(function($) {

			if (typeof meerkat.site === 'undefined') return;
			if (meerkat.site.pageAction !== "confirmation") return;

			meerkat.modules.health.initProgressBar(true);

			meerkat.modules.journeyProgressBar.setComplete();
			meerkat.modules.journeyProgressBar.disable();

			// Handle error display
			// 'results' is a global object added by slide_confirmation.tag
			if (result.hasOwnProperty('data') === false || result.data.status != 'OK' || result.data.product === '') {
				meerkat.modules.errorHandling.error({
					message: result.data.message,
					page: "healthConfirmation.js module",
					description: "Trying to load the confirmation page failed",
					data: null,
					errorLevel: "warning"
				});

			// Handle normal display
			} else {

				// prepare data
				confirmationProduct = $.extend({},result.data);
				confirmationProduct.mode = "lhcInc";

				// if confirmation has been loaded from the confirmations table in the db, confirmationProduct.product should exist
				if( confirmationProduct.product ){

					confirmationProduct.pending = false;
					confirmationProduct.product = $.parseJSON(confirmationProduct.product);
					if( confirmationProduct.product.price && _.isArray(confirmationProduct.product.price) ){
						confirmationProduct.product = confirmationProduct.product.price[0];
					}

					// merge the product info at the root of the object and clean up
					$.extend(confirmationProduct, confirmationProduct.product);
					delete confirmationProduct.product;

				// if confirmationProduct.product does not exist, it might be a pending order.
				// If the order has just been passed, this means we can find the product info in the session
				// this should have been made available on the page by health-layout:slide_confirmation.tag

				} else if( typeof sessionProduct === "object" ){

					if( sessionProduct.price && _.isArray(sessionProduct.price) ){
						sessionProduct = sessionProduct.price[0];
					}

					if(confirmationProduct.transID === sessionProduct.transactionId){
						// merge the product info at the root of the object and clean up
						$.extend(confirmationProduct, sessionProduct);
					} else {
						sessionProduct = undefined;
					}

					confirmationProduct.pending = true;
				} else {
					// otherwise, well we just won't display the info we could not find
					confirmationProduct.pending = true;
				}

				// prepare hospital and extras covers inclusions, exclusions and restrictions
				meerkat.modules.healthMoreInfo.setProduct(confirmationProduct);
				
				//Now prepare cover.
				meerkat.modules.healthMoreInfo.prepareCover();

				// prepare necessary frequency values
				if( confirmationProduct.frequency.length == 1) { // if found frequency is a letter code, translate it to full word
					confirmationProduct.frequency = meerkat.modules.healthResults.getFrequencyInWords(confirmationProduct.frequency);
				}
				confirmationProduct._selectedFrequency = confirmationProduct.frequency;

				fillTemplate();

				if(confirmationProduct.warningAlert === "" || confirmationProduct.warningAlert === undefined){
					meerkat.modules.healthMoreInfo.prepareExternalCopy(function confirmationExternalCopySuccess(){
						// Show warning if applicable
						if (typeof confirmationProduct.warningAlert !== 'undefined' && confirmationProduct.warningAlert !== '') {
							$("#health_confirmation-warning").find(".fundWarning").show().html(confirmationProduct.warningAlert);
						} else {
							$("#health_confirmation-warning").find(".fundWarning").hide().empty();
						}
					});
				}

				meerkat.modules.healthMoreInfo.applyEventListeners();

				meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
					method:'completedApplication',
					object:{
						productID: confirmationProduct.productId,
						vertical: meerkat.site.vertical,
						productBrandCode: confirmationProduct.info.provider,
						productName: confirmationProduct.info.productTitle,
						quoteReferenceNumber: confirmationProduct.transactionId,
						simplesUser: meerkat.site.isCallCentreUser,
						reedemedCouponID: $('.coupon-confirmation').data('couponId')
					}
				});

			}

		});

	}

	function fillTemplate(){

		var confirmationTemplate = $("#confirmation-template").html();
		var htmlTemplate = _.template(confirmationTemplate);
		var htmlString = htmlTemplate(confirmationProduct);
		$("#confirmation").html(htmlString);

		meerkat.messaging.subscribe(meerkatEvents.healthPriceComponent.INIT, function(selectedProduct){
			// inject the price and product summary
			meerkat.modules.healthPriceComponent.updateProductSummaryHeader(confirmationProduct, confirmationProduct.frequency, true);
			meerkat.modules.healthPriceComponent.updateProductSummaryDetails(confirmationProduct, confirmationProduct.startDate, false);
		});

		// if pending, it might not have the about fund info so let's get it
		if(confirmationProduct.about === ""){
			meerkat.modules.healthMoreInfo.prepareExternalCopy(function confirmationExternalCopySuccess(){
				$(".aboutFund").append(confirmationProduct.aboutFund).parents(".displayNone").first().removeClass("displayNone");
			});
		}

	}

	meerkat.modules.register('healthConfirmation', {
		init: init
	});

})(jQuery);
/*

	This module supports the Filters dropdown.
	It handles reading and saving of the values of filters contained within the dropdown.

	The dropdown can be manually triggered via:
		- meerkat.modules.healthFilters.open()
		- meerkat.modules.healthFilters.close()

	See also health:filters tag.

	When integrating a new filter:
		- If it needs a new type (data-filter-type) you will need to implement reading and setting in readFilterValues() and revertFilters()
		- In readFilterValues(), hook it up to read from Results object if necessary
		- In saveSelection(), make it apply its new value

*/
;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		$dropdown,  //Stores the jQuery object for this dropdown
		$component, //Stores the jQuery object for the component group
		$providerFilter, //Stores the jQuery object for the provider group
		filterValues = {},
		joinDelimiter = ',';

	var events = {
			healthFilters: {
				CHANGED: 'HEALTH_FILTERS_CHANGED'
			}
		},
		moduleEvents = events.healthFilters;



	//
	// Refresh and store filters' values
	//
	function updateFilters() {
		readFilterValues('value');
	}



	//
	// Read current values from filters
	//     - Set 'readOnlyFromFilters' to true to get the real value from the filter, otherwise it may read from e.g. Results object
	//
	function readFilterValues(propertyNameToStoreValue, readOnlyFromFilters) {
		var propName = propertyNameToStoreValue || 'value';

		$component.find('[data-filter-type]').each(function() {
			var $this = $(this),
				filterType = $this.attr('data-filter-type'),
				id = $this.attr('id'),
				value = '';

			if (typeof id === 'undefined') return;

			// SLIDERS
			if ('slider' === filterType) {
				$this.find('.slider-control').trigger('UPDATE');
				value = $this.find('.slider').val();
			}

			// RADIOS
			if ('radio' === filterType) {
				value = $this.find(':checked').val() || '';

				// Grab settings from Results and apply it to the filters
				// Otherwise we'll just use the value from the filter itself
				if (readOnlyFromFilters !== true) {

					if ('filter-frequency' === id) {
						try {
							value = Results.getFrequency();
						}
						catch(err) {}

						value = meerkat.modules.healthResults.getFrequencyInLetters(value) || 'A';
						$this.find('input[value="' + value + '"]').prop('checked', true).change();
					}

					else if ('filter-sort' === id) {
						try {
							value = Results.getSortBy();
						}
						catch(err) {}

						if (value.indexOf('price') > -1) {
							value = 'L';
						}
						else {
							value = 'B';
						}
						$this.find('input[value="' + value + '"]').prop('checked', true).change();
					}
				}
			}

			// SELECTS
			if ('select' === filterType) {
				value = $this.find(':selected').val() || '';

				if (readOnlyFromFilters !== true) {
					if ('filter-tierHospital' === id) {
						value = $('#health_filter_tierHospital').val();
						$this.find('select').val(value);
					}

					else if ('filter-tierExtras' === id) {
						value = $('#health_filter_tierExtras').val();
						$this.find('select').val(value);
					}
				}
			}

			// CHECKBOXES
			if ('checkbox' === filterType) {
				// A string of all checkbox values
				var values = [];

				if ('filter-provider' === id) {
					values = $this.find('[type=checkbox]:not(:checked)').map(function() {
						return this.value;
					});
				}
				else {
					values = $this.find('[type=checkbox]:checked').map(function() {
						return this.value;
					});
				}

				value = values.get().join(joinDelimiter);

				if (readOnlyFromFilters !== true) {
					if ('filter-provider' === id) {
						value = $('#health_filter_providerExclude').val();
						values = value.split(joinDelimiter);

						$this.find(':checkbox').each(function() {
							var $ele = $(this);
							if ($.inArray( $ele.attr('value'), values ) < 0) {
								$ele.prop('checked', true).change();
							}
							else {
								$ele.prop('checked', false).change();
							}
						});
					}
				}
			}

			// Store filter's value
			if (!filterValues.hasOwnProperty(id)) filterValues[id] = {};
			filterValues[id].type = filterType;
			filterValues[id][propName] = value;
		});

		//log('readFilterValues', filterValues);
	}



	//
	// Revert any changes to previous values
	//
	function revertSelections() {
		var value,
			filterId;

		for (filterId in filterValues) {
			if (filterValues.hasOwnProperty(filterId)) {
				value = filterValues[filterId].value;
				//log('Reverting ' + filterId + ' to ' + value);

				switch (filterValues[filterId].type) {
					case 'slider':
						$component.find('#' + filterId + ' .slider').val(value);
						break;

					case 'radio':
						if (value === '') {
							$component.find('#' + filterId + ' input').prop('checked', false).change();
						}
						else {
							$component.find('#' + filterId + ' input[value="' + value + '"]').prop('checked', true).change();
						}
						break;

					case 'select':
						$component.find('#' + filterId + ' select').val(value);
						break;

					//case 'checkbox':
						// Currently don't need to revert
						//break;
				}
			}
		}
	}


	//
	// Save and close dropdown
	//
	function saveSelection() {

		var numValidProviders = $providerFilter.find('[type=checkbox]:checked').length;

		if (numValidProviders < 1) {
			$providerFilter.find(':checkbox').addClass('has-error');
			if($providerFilter.find('.alert').length === 0){
				$providerFilter.prepend('<div id="health-filter-alert" class="alert alert-danger">Please select at least 1 brand to compare results</div>');
			}
			//scroll to the alert box
			window.location.href = "#health-filter-alert";
			return;
		} else {
			$providerFilter.find(':checkbox').removeClass('has-error');
			$providerFilter.find('.alert').remove();
		}

		// Close the dropdown before the activator gets disabled by Results events
		$component.addClass('is-saved');

		close();

		// Close the menu on mobile too.
		if (meerkat.modules.deviceMediaState.get() === 'xs') {
			meerkat.modules.navMenu.close();
		} else {
			$dropdown.closest('.navbar-collapse').removeClass('in');
		}

		// now defer to try and improve responsiveness on low performance devices.

		_.defer(function(){

			var valueOld,
				valueNew,
				filterId,
				needToFetchFromServer = false,
				filterChanges = {};


			// Collect the new (current) values from the filters (second argument 'true')
			readFilterValues('valueNew', true);

			// First check if we need to fetch from the server, or do everything client-side

			for (filterId in filterValues) {
				if (filterValues.hasOwnProperty(filterId)) {
					if (filterValues[filterId].value !== filterValues[filterId].valueNew) {
						if ($('#'+filterId).attr('data-filter-serverside')) {
							needToFetchFromServer = true;
							break;
						}
					}
				}
			}

			// Apply any new values
			for (filterId in filterValues) {
				if (filterValues.hasOwnProperty(filterId)) {
					valueOld = filterValues[filterId].value;
					valueNew = filterValues[filterId].valueNew;

					// Has the value changed?
					if (valueOld !== valueNew) {

						if ('filter-frequency' === filterId) {
							// Convert letter to word e.g. A to annually
							$('#health_filter_frequency').val(valueNew);
							valueNew = meerkat.modules.healthResults.getFrequencyInWords(valueNew) || 'monthly';

							// If not doing a server fetch, update the results view
							if (!needToFetchFromServer) {
								refreshView = true;
								if (filterValues.hasOwnProperty('filter-sort')) {
									// If sort is set to Price and has not changed, re-apply the sort
									if (filterValues['filter-sort'].value === 'L' && filterValues['filter-sort'].value === filterValues['filter-sort'].valueNew) {
										refreshSort = true;
									}
								}
								filterChanges['filter-frequency-change'] = valueNew;
							}
							Results.setFrequency(valueNew, false); // was true


						}

						else if ('filter-sort' === filterId) {
							var sortDir = 'asc';

							switch(valueNew) {
								case 'L':
									if (filterValues.hasOwnProperty('filter-frequency')) {
										valueNew = meerkat.modules.healthResults.getFrequencyInWords(filterValues['filter-frequency'].valueNew) || 'monthly';
										valueNew = 'price.' + valueNew;
										break;
									}
									valueNew = 'price.monthly';
									break;
								default:
									valueNew = 'benefitsSort';
							}


							Results.setSortBy(valueNew);
							Results.setSortDir(sortDir);

						}

						else if ('filter-tierHospital' === filterId) {
							$('#health_filter_tierHospital').val(valueNew);
						}

						else if ('filter-tierExtras' === filterId) {
							$('#health_filter_tierExtras').val(valueNew);
						}

						else if ('filter-provider' === filterId) {
							$('#health_filter_providerExclude').val(valueNew);
						}
					}
				}
			}


				meerkat.messaging.publish(moduleEvents.CHANGED,filterChanges);

				if (needToFetchFromServer) {
					_.defer(function(){
						meerkat.modules.journeyEngine.loadingShow('...updating your quotes...', true);
						// Had to use a 100ms delay instead of a defer in order to get the loader to appear on low performance devices.
						_.delay(function(){
							meerkat.modules.healthResults.get();
						},100);
					});
				}else{
					Results.applyFiltersAndSorts();
				}


		});


	}

	// Open the dropdown with code (public method).
	function open() {
		if ($dropdown.hasClass('open') === false) {
			$dropdown.find('.activator').dropdown('toggle');
		}
	}

	// Add event listeners when dropdown is opened.
	function afterOpen() {
		$component.find('.btn-save').on('click.filters', saveSelection);
		$component.find('.btn-cancel').on('click.filters', close);
	}

	// Close the drop down with code (public method).
	function close() {
		if ($dropdown.hasClass('open')) {
			$dropdown.find('.activator').dropdown('toggle');
		}
	}

	// Remove event listeners and reset values when dropdown is closed.
	function afterClose() {
		if ($component.hasClass('is-saved')) {
			$component.removeClass('is-saved');
		}
		else {
			revertSelections();
		}

		$component.find('.btn-save').off('click.filters');
		$component.find('.btn-cancel').off('click.filters');
		$component.find(':checkbox').removeClass('has-error');
		$component.find('.alert').remove();
	}

	function setBrandFilterActions(){
		// not restricted funds
		$(".selectNotRestrictedBrands").on("click", function selectNotRestrictedBrands(){
			$(".notRestrictedBrands [type=checkbox]:not(:checked)").prop('checked', true).change();
		});
		$(".unselectNotRestrictedBrands").on("click", function unselectNotRestrictedBrands(){
			$(".notRestrictedBrands [type=checkbox]:checked").prop('checked', false).change();
		});
		// restricted funds
		$(".selectRestrictedBrands").on("click", function selectRestrictedBrands(){
			$(".restrictedBrands [type=checkbox]:not(:checked)").prop('checked', true).change();
		});
		$(".unselectRestrictedBrands").on("click", function unselectRestrictedBrands(){
			$(".restrictedBrands [type=checkbox]:checked").prop('checked', false).change();
		});
	}

	function setUpFequency() {
		var frequencyValue = $('#health_filter_frequency').val();
		if (frequencyValue.length > 0) {
			$('#filter-fequency').find('input[value="' + frequencyValue + '"]').prop('checked', true);
			meerkat.modules.healthPriceRangeFilter.setUp();
		}
	}


	function initModule() {

		$(document).ready(function() {

			if (meerkat.site.vertical !== "health" || meerkat.site.pageAction === "confirmation") return false;

			// Store the jQuery objects
			$dropdown = $('#filters-dropdown');
			$component = $('.filters-component');
			$providerFilter = $('#filter-provider');

			$dropdown.on('show.bs.dropdown', function () {
				afterOpen();
				updateFilters();
			});

			$dropdown.on('hidden.bs.dropdown', function () {
				afterClose();
			});

			$providerFilter.find(':checkbox').on('change', function() {
				$(this).removeClass('has-error');
				$providerFilter.find('.alert').remove();
			});

			setBrandFilterActions();
			setUpFequency();

			// On application lockdown/unlock, disable/enable the dropdown
			meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, function lockFilters(obj) {
				close();
				$dropdown.children('.activator').addClass('inactive').addClass('disabled');
			});

			meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, function unlockFilters(obj) {
				$dropdown.children('.activator').removeClass('inactive').removeClass('disabled');
			});

		});
	}

	meerkat.modules.register('healthFilters', {
		init: initModule,
		events: events,
		open: open,
		close: close
	});

})(jQuery);

;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var events = {
            healthMoreInfo: {}
        },
        moduleEvents = events.healthMoreInfo;

    var $bridgingContainer = $('.bridgingContainer'),
        topPosition,
        htmlTemplate,
        product,
        modalId,
        isModalOpen = false,
        isBridgingPageOpen = false,
        $moreInfoElement;


    function initMoreInfo() {
        var options = {
            container: $bridgingContainer,
            updateTopPositionVariable: updateTopPositionVariable,
            modalOptions: {
                className: 'modal-breakpoint-wide modal-tight bridgingContainer',
                openOnHashChange: false,
                leftBtn: {
                    label: 'All Products',
                    icon: '<span class="icon icon-arrow-left"></span>',
                    callback: function (eventObject) {
                        $(eventObject.currentTarget).closest('.modal').modal('hide');
                    }
                }
            },
            runDisplayMethod: runDisplayMethod,
            onBeforeShowBridgingPage: null,
            onBeforeShowTemplate: onBeforeShowTemplate,
            onBeforeShowModal: onBeforeShowModal,
            onAfterShowModal: onAfterShowModal,
            onAfterShowTemplate: onAfterShowTemplate,
            onBeforeHideTemplate: null,
            onAfterHideTemplate: null,
            onClickApplyNow: onClickApplyNow,
            onBeforeApply: onBeforeApply,
            onApplySuccess: onApplySuccess,
            retrieveExternalCopy: retrieveExternalCopy,
            onBreakpointChangeCallback: onBreakpointChange
        };

        meerkat.modules.moreInfo.initMoreInfo(options);

        eventSubscriptions();
        applyEventListeners();
    }

    /**
     * Health specific event listeners
     */
    function applyEventListeners() {

        // Add dialog on "promo conditions" links
        $(document.body).on("click", ".dialogPop", function promoConditionsLinksClick() {

            meerkat.modules.dialogs.show({
                title: $(this).attr("title"),
                htmlContent: $(this).attr("data-content")
            });

        });

    }

    function onApplySuccess() {
        meerkat.modules.address.setHash('apply');
    }

    /**
     * If a different product is selected, ensure the join declaration is unticked
     */
    function onBeforeApply($this) {
        if (Results.getSelectedProduct() !== false && Results.getSelectedProduct().productId != $this.attr("data-productId")) {
            $('#health_declaration:checked').prop('checked', false).change();
        }
    }

    function onClickApplyNow(product, applyCallback) {

        // declared in ????
        healthFunds.load(product.info.provider, applyCallback);
        meerkat.modules.healthResults.setSelectedProduct(product);

        meerkat.modules.partnerTransfer.trackHandoverEvent({
            product: product,
            type: meerkat.site.isCallCentreUser ? "Simples" : "Online",
            quoteReferenceNumber: transaction_id,
            transactionID: transaction_id,
            productID: product.productId.replace("PHIO-HEALTH-", ""),
            productName: product.info.name,
            productBrandCode: product.info.FundCode,
            simplesUser: meerkat.site.isCallCentreUser
        }, false);

    }

    function onBreakpointChange() {
        meerkat.modules.moreInfo.updateTopPositionVariable();
    }

    function eventSubscriptions() {

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function bridgingPageEnterXsState() {
            if (meerkat.modules.moreInfo.isBridgingPageOpen()) {
                meerkat.modules.moreInfo.close();
            }
            // HLT currently unbinds then rebinds the event to btn-more-info?
        });

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function bridgingPageLeaveXsState() {
            if (meerkat.modules.moreInfo.isModalOpen()) {
                meerkat.modules.moreInfo.close();
            }
            // HLT currently unbinds then rebinds the event to btn-more-info?
        });

        meerkat.messaging.subscribe(moduleEvents.bridgingPage.SHOW, function (state) {
            adaptResultsPageHeight(state.isOpen);
        });
        meerkat.messaging.subscribe(moduleEvents.bridgingPage.HIDE, function (state) {
            adaptResultsPageHeight(state.isOpen);
        });

    }

    function onBeforeShowTemplate(jsonResult) {
        if (meerkat.site.emailBrochures.enabled) {
            // initialise send brochure email button functionality
            //TODO: Fix this so we can get moreInfoContainer
            initialiseBrochureEmailForm(product, moreInfoContainer, $('#resultsForm'));
            populateBrochureEmail();
        }

        // Insert next_info_all_funds
        $('.more-info-content .next-info-all').html($('.more-info-content .next-steps-all-funds-source').html());
    }

    /**
     * Handles how you want to display the bridging page based on your viewport/requirements
     */
    function runDisplayMethod(productId) {
        if (meerkat.modules.deviceMediaState.get() != 'xs') {
            meerkat.modules.moreInfo.showTemplate($bridgingContainer);
        } else {
            meerkat.modules.moreInfo.showModal();

        }
        meerkat.modules.address.appendToHash('moreinfo');
    }

    function onAfterShowTemplate() {
        // Set the correct phone number
        meerkat.modules.healthPhoneNumber.changePhoneNumber();

        // hide elements based on marketing segments
        meerkat.modules.healthSegment.hideBySegment();

        // Add to the hidden fields for later use in emails
        $('#health_fundData_hospitalPDF').val(product.promo.hospitalPDF !== undefined ? meerkat.site.urls.base + product.promo.hospitalPDF : "");
        $('#health_fundData_extrasPDF').val(product.promo.extrasPDF !== undefined ? meerkat.site.urls.base + product.promo.extrasPDF : "");
        $('#health_fundData_providerPhoneNumber').val(product.promo.providerPhoneNumber !== undefined ? product.promo.providerPhoneNumber : "");
    }

    function onAfterShowModal() {

    }

    function _requestTracking(product) {
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: 'trackProductView',
            object: {
                productID: product.productId,
                productBrandCode: product.info.providerName,
                productName: product.info.productTitle,
                simplesUser: meerkat.site.isCallCentreUser
            }
        });
    }
    function adaptResultsPageHeight(isOpen) {
        if (isOpen) {
            $(Results.settings.elements.page).css("overflow", "hidden").height($moreInfoElement.outerHeight());
        } else {
            $(Results.settings.elements.page).css("overflow", "visible").height("");
        }
    }

    function hide(target) {
        // unfade all headers
        $(Results.settings.elements.page).find(".result").removeClass("faded");

        // reset button to default one
        $('.btn-close-more-info').removeClass("btn-close-more-info").addClass("btn-more-info");

        target.slideUp(400, function hideMoreInfo() {
            target.html('').hide();
            isBridgingPageOpen = false;
            meerkat.messaging.publish(moduleEvents.bridgingPage.CHANGE, {isOpen: isBridgingPageOpen});
            meerkat.messaging.publish(moduleEvents.bridgingPage.HIDE, {isOpen: isBridgingPageOpen});
        });
    }

    function openModalClick(event) {
        var $this = $(this),
            productId = $this.attr("data-productId"),
            showApply = $this.hasClass('more-info-showapply');
        setProduct(Results.getResult("productId", productId), showApply);

        openModal();
    }

    function openModal() {
        prepareProduct(function moreInfoOpenModalSuccess() {

            var htmlString = "<form class='healthMoreInfoModel'>" + htmlTemplate(product) + "</form>";
            modalId = meerkat.modules.dialogs.show({
                htmlContent: htmlString,
                className: "modal-breakpoint-wide modal-tight",
                onOpen: function onOpen(id) {
                    if (meerkat.site.emailBrochures.enabled) {
                        initialiseBrochureEmailForm(product, $('#' + id), $('#' + id).find('.healthMoreInfoModel'));
                    }
                }
            });


            // Insert next_info_all_funds
            $('.more-info-content .next-info .next-info-all').html($('.more-info-content .next-steps-all-funds-source').html());

            // Move dual-pricing panel
            $('.more-info-content .moreInfoRightColumn > .dualPricing').insertAfter($('.more-info-content .moreInfoMainDetails'));

            isModalOpen = true;

            $(".more-info-content").show();

            // Set the correct phone number
            meerkat.modules.healthPhoneNumber.changePhoneNumber(true);

            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: 'trackProductView',
                object: {
                    productID: product.productId,
                    productBrandCode: product.info.providerName,
                    productName: product.info.productTitle,
                    simplesUser: meerkat.site.isCallCentreUser
                }
            });
        });
    }

    function initialiseBrochureEmailForm(product, parent, form) {
        var emailBrochuresElement = parent.find('.moreInfoEmailBrochures');
        emailBrochuresElement.show();
        meerkat.modules.emailBrochures.setup({
            emailInput: emailBrochuresElement.find('.sendBrochureEmailAddress'),
            submitButton: emailBrochuresElement.find('.btn-email-brochure'),
            form: form,
            marketing: emailBrochuresElement.find('.optInMarketing'),
            productData: [
                {name: "hospitalPDSUrl", value: product.promo.hospitalPDF},
                {name: "extrasPDSUrl", value: product.promo.extrasPDF},
                {name: "provider", value: product.info.provider},
                {name: "providerName", value: product.info.providerName},
                {name: "productName", value: product.info.productTitle},
                {name: "productId", value: product.productId},
                {name: "productCode", value: product.info.productCode},
                {name: "premium", value: product.premium[Results.settings.frequency].lhcfreetext},
                {name: "premiumText", value: product.premium[Results.settings.frequency].lhcfreepricing}
            ],
            product: product,
            identifier: "SEND_BROCHURES" + product.productId,
            emailResultsSuccessCallback: function onSendBrochuresCallback(result, settings) {
                if (result.success) {
                    parent.find('.formInput').hide();
                    parent.find('.moreInfoEmailBrochuresSuccess').show();
                    meerkat.modules.emailBrochures.tearDown(settings);
                    meerkat.modules.healthResults.setSelectedProduct(product);
                } else {
                    meerkat.modules.errorHandling.error({
                        errorLevel: 'warning',
                        message: 'Oops! Something seems to have gone wrong. Please try again by re-entering your email address or ' +
                        'alternatively contact our call centre on <span class=\"callCentreHelpNumber\">' + meerkat.site.content.callCentreHelpNumber + '</span> and they\'ll be able to assist you further.',
                        page: 'healthMoreInfo.js:onSendBrochuresCallback',
                        description: result.message,
                        data: product
                    });
                }
            }
        });
    }

    function closeModal() {
        $('#' + modalId).modal('hide');
        isModalOpen = false;
    }

    function openbridgingPageDropdown(event) {
        var $this = $(this);

        // fade all other headers
        $(Results.settings.elements.page).find(".result").addClass("faded");

        // reset all the close buttons (there should only be one) to default button
        $(".btn-close-more-info").removeClass("btn-close-more-info").addClass("btn-more-info");

        // unfade the header from the clicked button
        $this.parents(".result").removeClass("faded");

        // replace clicked button with close button
        $this.removeClass("btn-more-info").addClass("btn-close-more-info");

        var productId = $this.attr("data-productId"),
            showApply = $this.hasClass('more-info-showapply');

        setProduct(Results.getResult("productId", productId), showApply);

        // disable the fixed header
        meerkat.modules.resultsHeaderBar.disableAffixMode();

        // load, parse and show the bridging page
        show($moreInfoElement);

    }

    function closeBridgingPageDropdown(event) {
        hide($moreInfoElement);

        // re-enable the fixed header
        meerkat.modules.resultsHeaderBar.enableAffixMode();

        if (isModalOpen) {
            // hide the xs modal
            closeModal();
        }
    }

    function setProduct(productToParse, showApply) {
        product = productToParse;

        if (product !== false) {
            if (showApply === true) {
                product.showApply = true;
            } else {
                product.showApply = false;
            }
        }


        return product;
    }

    function getOpenProduct() {
        if (isBridgingPageOpen === false) return null;
        return product;
    }

    function prepareProduct(successCallback) {
        prepareCover();
        prepareExternalCopy(successCallback);
    }

    //
    // Sort out inclusions, restrictions and hospital/extras for this product if not done already
    //
    function prepareCover() {
        if (typeof product.hospitalCover === "undefined") {
            // Ensure this is a Hospital product before trying to use the benefits properties
            if (typeof product.hospital !== 'undefined' && typeof product.hospital.benefits !== 'undefined') {

                prepareCoverFeatures("hospital.benefits", "hospitalCover");

                coverSwitch(product.hospital.inclusions.publicHospital, "hospitalCover", "Public Hospital");
                coverSwitch(product.hospital.inclusions.privateHospital, "hospitalCover", "Private Hospital");
            }
        }

        if (typeof product.extrasCover === "undefined") {
            // Ensure this is a Extras product before trying to use the benefits properties
            if (typeof product.extras !== 'undefined' && typeof product.extras === 'object') {

                prepareCoverFeatures("extras", "extrasCover");

            }
        }
    }

    function prepareExternalCopy(successCallback) {

        // Default text in case an ajax error occurs
        product.aboutFund = '<p>Apologies. This information did not download successfully.</p>';
        product.whatHappensNext = '<p>Apologies. This information did not download successfully.</p>';
        product.warningAlert = '';

        // Get the "about fund", "what happens next" and warningAlert info
        $.when(
            meerkat.modules.comms.get({
                url: "health_fund_info/" + product.info.provider + "/about.html",
                cache: true,
                errorLevel: "silent",
                onSuccess: function aboutFundSuccess(result) {
                    product.aboutFund = result;
                }
            }),
            meerkat.modules.comms.get({
                url: "health_fund_info/" + product.info.provider + "/next_info.html",
                cache: true,
                errorLevel: "silent",
                onSuccess: function whatHappensNextSuccess(result) {
                    product.whatHappensNext = result;
                }
            }),
            meerkat.modules.comms.get({
                url: "health/quote/dualPrising/getFundWarning.json",
                data: {providerId: product.info.providerId},
                cache: true,
                errorLevel: "silent",
                onSuccess: function warningAlertSuccess(result) {
                    product.warningAlert = result.warningMessage;
                }
            })
        )
            .then(
            successCallback,
            successCallback //the 'fail' function, but we handle the ajax fails above.
        );

    }

    function prepareCoverFeatures(searchPath, target) {

        product[target] = {
            inclusions: [],
            restrictions: [],
            exclusions: []
        };

        var lookupKey;
        var name;
        _.each(Object.byString(product, searchPath), function eachBenefit(benefit, key) {

            lookupKey = searchPath + "." + key + ".covered";
            foundObject = _.findWhere(resultLabels, {"p": lookupKey});

            if (typeof foundObject !== "undefined") {
                name = foundObject.n;
                coverSwitch(benefit.covered, target, name);
            }

        });

    }

    function coverSwitch(cover, target, name) {
        switch (cover) {
            case 'Y':
                product[target].inclusions.push(name);
                break;
            case 'R':
                product[target].restrictions.push(name);
                break;
            case 'N':
                product[target].exclusions.push(name);
                break;
        }
    }

    function populateBrochureEmail() {
        var emailAddress = $('#health_contactDetails_email').val();
        if (emailAddress !== "") {
            $('#emailAddress').val(emailAddress).trigger('blur');
        }
    }

    function updateTopPositionVariable() {
        topPosition = $('.resultsHeadersBg').height();
    }
    meerkat.modules.register("healthMoreInfo", {
        initMoreInfo: initMoreInfo,
        events: events,
        setProduct: setProduct,
        prepareProduct: prepareProduct,
        prepareCover: prepareCover,
        prepareExternalCopy: prepareExternalCopy,
        getOpenProduct: getOpenProduct,
        close: closeBridgingPageDropdown,
        applyEventListeners: applyEventListeners
    });

})(jQuery);
/*
	More Info panel can be easily triggered by applying a class:

		<a href="javascript:;" class="more-info">More info</a>

	If you want the apply button to also display:

		<a href="javascript:;" class="more-info more-info-showapply">More info</a>

*/
;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events;

	var events = {
			healthMoreInfo: {
				bridgingPage: {
					CHANGE: "BRIDGINGPAGE_CHANGE", // only triggered when state chages from open to closed or closed to open
					SHOW: "BRIDGINGPAGE_SHOW", // trigger on every show (i.e. even when switching from product to product => show to show)
					HIDE: "BRIDGINGPAGE_HIDE" // triggers on close
				}
			}
		},
		moduleEvents = events.healthMoreInfo;

	var template,
		htmlTemplate,
		product,
		modalId,
		isModalOpen = false,
		isBridgingPageOpen = false,
		$moreInfoElement,
		headerBarHeight;

	var topPosition;
	function updatePosition() {
		topPosition = $('.resultsHeadersBg').height();
	}

	function initMoreInfo() {

		$moreInfoElement = $(".moreInfoDropdown");

		jQuery(document).ready(function($) {

			if(meerkat.site.vertical != "health" || meerkat.site.pageAction == "confirmation") return false;

			// prepare compiled template
			template = $("#more-info-template").html();
			if( typeof(template) != "undefined" ){

				htmlTemplate = _.template(template);

				applyEventListeners();

				eventSubscriptions();

			}

		});

	}

	function applyEventListeners(){

		// RESULTS PAGE LISTENERS
			if( typeof Results.settings !== "undefined" ){

				if( meerkat.modules.deviceMediaState.get() != 'xs' ){
					$(Results.settings.elements.page).on("click", ".btn-more-info", openbridgingPageDropdown);
				} else {
					$(Results.settings.elements.page).on("click", ".btn-more-info", openModalClick);
				}

				// close bridging page
				$(Results.settings.elements.page).on("click", ".btn-close-more-info", closeBridgingPageDropdown);

			}

			// Close any more info panels when fetching new results
			$(document).on("resultsFetchStart", function onResultsFetchStart() {
				meerkat.modules.healthMoreInfo.close();
			});

		// MORE INFO GENERAL STUFF
			// Apply button in bridging page
			$(document.body).on("click", ".btn-more-info-apply", function applyClick(){
				var $this = $(this);

				$this.addClass('inactive').addClass('disabled');
				meerkat.modules.loadingAnimation.showInside($this, true);

				_.defer(function deferApplyNow() {

					// If a different product is selected, ensure the join declaration is unticked
					if (Results.getSelectedProduct() !== false && Results.getSelectedProduct().productId != $this.attr("data-productId")) {
						$('#health_declaration:checked').prop('checked', false).change();
					}

					// Set selected product
					Results.setSelectedProduct( $this.attr("data-productId") );
					var product = Results.getSelectedProduct();
					if (product) {
						meerkat.modules.healthResults.setSelectedProduct(product);

						healthFunds.load(product.info.provider, applyCallback);

						var transaction_id = meerkat.modules.transactionId.get();
						var handoverType;
						if(meerkat.site.isCallCentreUser){
							handoverType = "Simples";
						}
						else {
							handoverType = "Online";
						}

						// NEW tracking call
						meerkat.modules.partnerTransfer.trackHandoverEvent({
							product:				product,
							type:					handoverType,
							quoteReferenceNumber:	transaction_id,
							transactionID:			transaction_id,
							productID:				product.productId.replace("PHIO-HEALTH-", ""),
							productName:			product.info.name,
							productBrandCode:		product.info.FundCode,
							simplesUser:			meerkat.site.isCallCentreUser
						}, false);
					}
					else {
						applyCallback(false);
					}

				});//defer

			});

			// Add dialog on "promo conditions" links
			$(document.body).on("click", ".dialogPop", function promoConditionsLinksClick(){

				meerkat.modules.dialogs.show({
					title: $(this).attr("title"),
					htmlContent: $(this).attr("data-content")
				});

			});

		// APPLICATION/PAYMENT PAGE LISTENERS
			$(document.body).on("click", ".more-info", function moreInfoLinkClick(event){
				setProduct( meerkat.modules.healthResults.getSelectedProduct() );
				openModal();
			});

	}

	function applyCallback(success) {
		_.delay(function deferApplyCallback() {
			$('.btn-more-info-apply').removeClass('inactive').removeClass('disabled');
			meerkat.modules.loadingAnimation.hide($('.btn-more-info-apply'));
		}, 1000);

		if (success === true) {
			// send to apply step
			meerkat.modules.address.setHash('apply');
		}
	}

	function eventSubscriptions(){

		//On ANY breakpoint change, update the position variable.
		meerkat.messaging.subscribe(meerkatEvents.device.STATE_CHANGE, function breakPointChange(data) {
			updatePosition();
		});

		// Close when results page changes
			$(document).on("resultPageChange", function(){
				if( isBridgingPageOpen ){
					closeBridgingPageDropdown();
				}
			});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function bridgingPageEnterXsState(){
			if( isBridgingPageOpen ){
				// close dropdown/tab styled bridging page in case it's open when entering the xs breakpoint
				closeBridgingPageDropdown();
			}

			$(Results.settings.elements.page).off("click", ".btn-more-info");
			$(Results.settings.elements.page).on("click", ".btn-more-info", openModalClick);
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function bridgingPageLeaveXsState(){

			if( isModalOpen ){
				// hide the xs modal
				closeModal();
			}

			$(Results.settings.elements.page).off("click", ".btn-more-info");
			$(Results.settings.elements.page).on("click", ".btn-more-info", openbridgingPageDropdown);
		});

		meerkat.messaging.subscribe( moduleEvents.bridgingPage.SHOW, function(state){ adaptResultsPageHeight(state.isOpen); });
		meerkat.messaging.subscribe( moduleEvents.bridgingPage.HIDE, function(state){ adaptResultsPageHeight(state.isOpen); });

	}

	function show( target ){

		// show loading animation
		target.html( meerkat.modules.loadingAnimation.getTemplate() ).show();

		prepareProduct( function moreInfoShowSuccess(){

			var htmlString = htmlTemplate(product);

			// fade out loading anim
			target.find(".spinner").fadeOut();

			// append content
			target.html(htmlString);
			if(meerkat.site.emailBrochures.enabled){
				// initialise send brochure email button functionality
				initialiseBrochureEmailForm(product, target, $('#resultsForm'));
				populateBrochureEmail();
			}

			// Insert next_info_all_funds
			$('.more-info-content .next-info-all').html( $('.more-info-content .next-steps-all-funds-source').html() );

			var animDuration = 400;
			var scrollToTopDuration = 250;
			var totalDuration = 0;

			if( isBridgingPageOpen ){
				target.find(".more-info-content").fadeIn(animDuration);
				totalDuration = animDuration;
			} else {
				meerkat.modules.utilities.scrollPageTo('.resultsHeadersBg', scrollToTopDuration, -$("#navbar-main").height(), function(){
					target.find(".more-info-content").slideDown(animDuration);
				});
				totalDuration = animDuration + scrollToTopDuration;
			}

			isBridgingPageOpen = true;

			_.delay(function(){
				meerkat.messaging.publish(moduleEvents.bridgingPage.SHOW, {isOpen:isBridgingPageOpen});
				if( !isBridgingPageOpen ){
					//after we are done animating set position from the global.
					updatePosition();
					target.css({'top': topPosition});
				}
			}, totalDuration);

			// Set the correct phone number
			meerkat.modules.healthPhoneNumber.changePhoneNumber();

			meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
				method:'trackProductView',
				object:{
					productID: product.productId,
					productBrandCode: product.info.providerName,
					productName: product.info.productTitle,
					simplesUser: meerkat.site.isCallCentreUser
				}
			});

			// Add to the hidden fields for later use in emails
			$('#health_fundData_hospitalPDF').val(product.promo.hospitalPDF !== undefined ? meerkat.site.urls.base+product.promo.hospitalPDF : "");
			$('#health_fundData_extrasPDF').val(product.promo.extrasPDF !== undefined ? meerkat.site.urls.base+product.promo.extrasPDF : "");
			$('#health_fundData_providerPhoneNumber').val(product.promo.providerPhoneNumber !== undefined ? product.promo.providerPhoneNumber : "");

		});

	}

	function adaptResultsPageHeight( isOpen ){
		if(isOpen){
			$(Results.settings.elements.page).css("overflow", "hidden").height( $moreInfoElement.outerHeight() );
		} else {
			$(Results.settings.elements.page).css("overflow", "visible").height("");
		}
	}

	function hide( target ){
		// unfade all headers
		$(Results.settings.elements.page).find(".result").removeClass("faded");

		// reset button to default one
		$('.btn-close-more-info').removeClass("btn-close-more-info").addClass("btn-more-info");

		target.slideUp(400, function hideMoreInfo(){
			target.html('').hide();
			isBridgingPageOpen = false;
			meerkat.messaging.publish(moduleEvents.bridgingPage.CHANGE, {isOpen:isBridgingPageOpen});
			meerkat.messaging.publish(moduleEvents.bridgingPage.HIDE, {isOpen:isBridgingPageOpen});
		});
	}

	function openModalClick( event ){
		var $this = $(this),
			productId = $this.attr("data-productId"),
			showApply = $this.hasClass('more-info-showapply');
		setProduct( Results.getResult("productId", productId), showApply );

		openModal();
	}

	function openModal(){
		prepareProduct( function moreInfoOpenModalSuccess(){

			var htmlString = "<form class='healthMoreInfoModel'>" + htmlTemplate(product) + "</form>";
			modalId = meerkat.modules.dialogs.show({
				htmlContent: htmlString,
				className: "modal-breakpoint-wide modal-tight",
				onOpen : function onOpen(id) {
					if(meerkat.site.emailBrochures.enabled){
						initialiseBrochureEmailForm(product, $('#'+id), $('#'+id).find('.healthMoreInfoModel'));
					}
				}
			});


			// Insert next_info_all_funds
			$('.more-info-content .next-info .next-info-all').html( $('.more-info-content .next-steps-all-funds-source').html() );

			// Move dual-pricing panel
			$('.more-info-content .moreInfoRightColumn > .dualPricing').insertAfter($('.more-info-content .moreInfoMainDetails'));

			isModalOpen = true;

			$(".more-info-content").show();

			// Set the correct phone number
			meerkat.modules.healthPhoneNumber.changePhoneNumber(true);

			meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
				method:'trackProductView',
				object:{
					productID: product.productId,
					productBrandCode: product.info.providerName,
					productName: product.info.productTitle,
					simplesUser: meerkat.site.isCallCentreUser
				}
			});
		});
	}

	function initialiseBrochureEmailForm(product, parent, form) {
		var emailBrochuresElement = parent.find('.moreInfoEmailBrochures');
		emailBrochuresElement.show();
		meerkat.modules.emailBrochures.setup({
				emailInput : emailBrochuresElement.find('.sendBrochureEmailAddress'),
				submitButton : emailBrochuresElement.find('.btn-email-brochure'),
				form : form,
				marketing : emailBrochuresElement.find('.optInMarketing'),
				productData : [
						{name:"hospitalPDSUrl",value: product.promo.hospitalPDF},
						{name:"extrasPDSUrl",value: product.promo.extrasPDF},
						{name:"provider",value: product.info.provider},
						{name:"providerName",value: product.info.providerName},
						{name:"productName",value: product.info.productTitle},
						{name:"productId",value: product.productId},
						{name:"productCode",value: product.info.productCode},
						{name:"premium",value: product.premium[Results.settings.frequency].lhcfreetext},
						{name:"premiumText",value: product.premium[Results.settings.frequency].lhcfreepricing}
				],
				product : product,
				identifier: "SEND_BROCHURES" + product.productId,
				emailResultsSuccessCallback : function onSendBrochuresCallback(result, settings) {
					if(result.success) {
						parent.find('.formInput').hide();
						parent.find('.moreInfoEmailBrochuresSuccess').show();
						meerkat.modules.emailBrochures.tearDown(settings);
						meerkat.modules.healthResults.setSelectedProduct(product);
					} else {
						meerkat.modules.errorHandling.error({
							errorLevel:		'warning',
							message:		'Oops! Something seems to have gone wrong. Please try again by re-entering your email address or ' +
											'alternatively contact our call centre on <span class=\"callCentreHelpNumber\">' + meerkat.site.content.callCentreHelpNumber +  '</span> and they\'ll be able to assist you further.',
							page:			'healthMoreInfo.js:onSendBrochuresCallback',
							description:	result.message,
							data:			product
						});
					}
				}
		});
	}

	function closeModal(){
		$('#'+modalId).modal('hide');
		isModalOpen = false;
	}

	function openbridgingPageDropdown(event){
		var $this = $(this);

		// fade all other headers
		$(Results.settings.elements.page).find(".result").addClass("faded");

		// reset all the close buttons (there should only be one) to default button
		$(".btn-close-more-info").removeClass("btn-close-more-info").addClass("btn-more-info");

		// unfade the header from the clicked button
		$this.parents(".result").removeClass("faded");

		// replace clicked button with close button
		$this.removeClass("btn-more-info").addClass("btn-close-more-info");

		var productId = $this.attr("data-productId"),
			showApply = $this.hasClass('more-info-showapply');

		setProduct( Results.getResult("productId", productId), showApply );

		// disable the fixed header
		meerkat.modules.resultsHeaderBar.disableAffixMode();

		// load, parse and show the bridging page
		show( $moreInfoElement );

	}

	function closeBridgingPageDropdown(event){
		hide($moreInfoElement);

		// re-enable the fixed header
		meerkat.modules.resultsHeaderBar.enableAffixMode();

		if (isModalOpen) {
			// hide the xs modal
			closeModal();
		}
	}

	function setProduct( productToParse, showApply ) {
		product = productToParse;

		if (product !== false) {
			if (showApply === true) {
				product.showApply = true;
			} else {
				product.showApply = false;
			}
		}


		return product;
	}

	function getOpenProduct(){
		if(isBridgingPageOpen === false) return null;
		return product;
	}

	function prepareProduct( successCallback ){
		prepareCover();
		prepareExternalCopy( successCallback );
	}

	//
	// Sort out inclusions, restrictions and hospital/extras for this product if not done already
	//
	function prepareCover() {
		if (typeof product.hospitalCover === "undefined") {
			// Ensure this is a Hospital product before trying to use the benefits properties
			if (typeof product.hospital !== 'undefined' && typeof product.hospital.benefits !== 'undefined') {

				prepareCoverFeatures( "hospital.benefits", "hospitalCover" );

				coverSwitch( product.hospital.inclusions.publicHospital, "hospitalCover", "Public Hospital");
				coverSwitch( product.hospital.inclusions.privateHospital, "hospitalCover", "Private Hospital");
			}
		}

		if (typeof product.extrasCover === "undefined") {
			// Ensure this is a Extras product before trying to use the benefits properties
			if (typeof product.extras !== 'undefined' && typeof product.extras === 'object') {

				prepareCoverFeatures( "extras", "extrasCover" );

			}
		}
	}

	function prepareExternalCopy( successCallback ){

		// Default text in case an ajax error occurs
		product.aboutFund = '<p>Apologies. This information did not download successfully.</p>';
		product.whatHappensNext = '<p>Apologies. This information did not download successfully.</p>';
		product.warningAlert = '';

		// Get the "about fund", "what happens next" and warningAlert info
		$.when(
			meerkat.modules.comms.get({
				url: "health_fund_info/"+ product.info.provider +"/about.html",
				cache: true,
				errorLevel: "silent",
				onSuccess: function aboutFundSuccess(result) {
					product.aboutFund = result;
				}
			}),
			meerkat.modules.comms.get({
				url: "health_fund_info/"+ product.info.provider +"/next_info.html",
				cache: true,
				errorLevel: "silent",
				onSuccess: function whatHappensNextSuccess(result) {
					product.whatHappensNext = result;
				}
			}),
			meerkat.modules.comms.get({
				url: "health/quote/dualPrising/getFundWarning.json",
				data: {providerId: product.info.providerId},
				cache: true,
				errorLevel: "silent",
				onSuccess: function warningAlertSuccess(result) {
					product.warningAlert = result.warningMessage;
				}
			})
		)
		.then(
			successCallback,
			successCallback //the 'fail' function, but we handle the ajax fails above.
		);

	}

	function prepareCoverFeatures( searchPath, target ){

		product[target] = {
			inclusions: [],
			restrictions: [],
			exclusions: []
		};

		var lookupKey;
		var name;
		_.each( Object.byString(product, searchPath), function eachBenefit(benefit, key) {

			lookupKey = searchPath + "." + key + ".covered";
			foundObject = _.findWhere( resultLabels, {"p": lookupKey} );

			if (typeof foundObject !== "undefined") {
				name = foundObject.n;
				coverSwitch( benefit.covered, target, name);
			}

		});

	}

	function coverSwitch( cover, target, name){
		switch( cover ){
			case 'Y':
				product[target].inclusions.push(name);
				break;
			case 'R':
				product[target].restrictions.push(name);
				break;
			case 'N':
				product[target].exclusions.push(name);
				break;
		}
	}

	function populateBrochureEmail () {
		var emailAddress = $('#health_contactDetails_email').val();
		if (emailAddress !== "") {
			$('#emailAddress').val(emailAddress).trigger('blur');
		}
	}

	//meerkat.modules.register("healthMoreInfoOLD", {
	//	initMoreInfo: initMoreInfo,
	//	events: events,
	//	setProduct: setProduct,
	//	prepareProduct: prepareProduct,
	//	prepareCover: prepareCover,
	//	prepareExternalCopy: prepareExternalCopy,
	//	getOpenProduct: getOpenProduct,
	//	close: closeBridgingPageDropdown,
	//	applyEventListeners: applyEventListeners
	//});

})(jQuery);
;(function($, undefined){

	var meerkat = window.meerkat;

	var moduleEvents = {
		POLICY_DATE_CHANGE: 'POLICY_DATE_CHANGE'
	};
	var $paymentDay,
	$policyDateHiddenField;

	function init() {

		$(document).ready(function(){
			$paymentDay = $('.health_payment_day');
			$policyDateHiddenField = $('.health_details-policyDate');
			$paymentDay.on('change', function paymentDayChange() {
				meerkat.messaging.publish(moduleEvents.POLICY_DATE_CHANGE,$(this).val());
			});

		});
	}

	// Reset the step
	function paymentDaysRenderEarliestDay($message , euroDate, daysMatch, exclusion) {
		if (typeof exclusion === "undefined") exclusion = 7;
		if (typeof daysMatch === "undefined" || daysMatch.length < 1) daysMatch = [ 1 ];

		var earliestDate = null;
		if (typeof euroDate === "undefined" || euroDate === "") {
			earliestDate = new Date();
		} else {
			earliestDate = meerkat.modules.utils.returnDate(euroDate);
		}

		// creating the base date from the exclusion
		earliestDate = new Date( earliestDate.getTime() + (exclusion * 24 * 60 * 60 * 1000));

		// Loop through 31 attempts to match the next date
		var i = 0;
		var foundMatch = false;
		while (i < 31 && !foundMatch) {
			earliestDate = new Date( earliestDate.getTime() + (1 * 24 * 60 * 60 * 1000));
			foundMatch = _.contains(daysMatch, earliestDate.getDate());
			i++;
		}
		$policyDateHiddenField.val(meerkat.modules.utils.returnDateValue(earliestDate));
		$message.text( 'Your payment will be deducted on: ' + healthFunds._getNiceDate(earliestDate) );

	}
	/*
	 * Updates the payment days to be the following month
	 * Param euroDate String in the format dd/MM/yyyy to count from
	 * Param exclusion a buffer (in days) from euroDate to start counting from
	 * Param excludeWeekend, true to exclude weekend from the buffer, false for otherwise
	 * Param isBank, true for bank payment, otherwise cc payment
	 */
	function populateFuturePaymentDays(euroDate, exclusion, excludeWeekend, isBank) {
		var startDate,
			minimumDate,
			childDateOriginal,
			childDateNew,
			$paymentDays;

		if (typeof euroDate === "undefined" || euroDate === "") {
			startDate = new Date(); // default to use today
		} else {
			startDate = meerkat.modules.utils.returnDate(euroDate);
			}

		if (typeof exclusion === "undefined") exclusion = 7; // default a week buffer
		if (typeof excludeWeekend === "undefined") excludeWeekend = false; // default not to exclude weekend
		if (typeof isBank === "undefined") isBank = true; // default as bank payment

		if (isBank) {
			$paymentDays = $('#health_payment_bank_paymentDay');
		} else {
			$paymentDays = $('#health_payment_credit_paymentDay');
			}

		minimumDate = new Date(startDate);
		if (excludeWeekend) {
			minimumDate = meerkat.modules.utils.calcWorkingDays(minimumDate, exclusion);
		} else {
			minimumDate.setDate(minimumDate.getDate() + exclusion);
		}
		
		$paymentDays.children().each(function playWithChildren () {
			if ($(this).val() !== '') {
				childDateOriginal = new Date($(this).val());
				childDateNew = compareAndAddMonth(childDateOriginal, minimumDate);
				$(this).val(meerkat.modules.utils.returnDateValue(childDateNew));
			}
		});
	}

	function compareAndAddMonth(oldDate, minDate) {
		if (oldDate < minDate){
			var newDate = new Date(oldDate.setMonth(oldDate.getMonth() +  1 ));
			return compareAndAddMonth(newDate, minDate)
		}else{
			return oldDate;
		}
	}

	meerkat.modules.register("healthPaymentDate", {
		init: init,
		events: moduleEvents,
		paymentDaysRenderEarliestDay: paymentDaysRenderEarliestDay,
		populateFuturePaymentDays: populateFuturePaymentDays
	});

})(jQuery);
/*

Process:
- Call the iFrame when the pre-criteria is completed (and validated)
- Call the security session key
- iFrame will respond back with the results
- Log the final result details to the external source

*/
;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
		healthPaymentGatewayNAB: {

		}
	},
	moduleEvents = events.healthPaymentGatewayNAB;

	var $cardNumber;
	var $cardName;
	var $crn;
	var $rescode;
	var $restext;
	var $expiryMonth;
	var $expiryYear;
	var $cardType;

	var timeout = false;

	var settings;


	function onMessage(e) {
		if (e.origin !== settings.origin){
			console.error("domain name mismatch");
			return;
		} else {
			// we are expecting the iframe to return a load success message
			// if we get it, we kill the timeout interval that would trigger he fail after a while
			if(typeof e.data === "string" && e.data === "page loaded"){
				clearTimeout(timeout);
			} else {
				onPaymentResponse(e.data);
			}
		}
	}

	function init() {
	}

	function setup(instanceSettings) {
		settings = instanceSettings;
		$cardNumber = $('#' + settings.name + '_nab_cardNumber');
		$cardName = $('#' + settings.name + '_nab_cardName');
		$crn = $('#' + settings.name + '_nab_crn');
		$rescode = $('#' + settings.name + '_nab_rescode');
		$restext = $('#' + settings.name + '_nab_restext');
		$expiryMonth = $('#' + settings.name + '_nab_expiryMonth');
		$expiryYear = $('#' + settings.name + '_nab_expiryYear');
		$cardType = $('#' + settings.name + '_nab_cardType');
		$('.gatewayProvider').text('NAB');
	}

	function onPaymentResponse(data) {
		var json = JSON.parse(data);
		if (validatePaymentResponse(json)) {
			meerkat.messaging.publish(meerkat.modules.events.paymentGateway.SUCCESS,json);
		} else {
			meerkat.messaging.publish(meerkat.modules.events.paymentGateway.FAIL,json);
		}
	}

	function validatePaymentResponse(response) {
		var valid = response && response.CRN && response.CRN !== '';
		valid = valid && response.rescode == "00";
		return valid;
	}

	function success(params) {
		$cardNumber.val(params.pan);
		$cardName.val(params.cardName);
		$crn.val(params.CRN);
		$rescode.val(params.rescode);
		$restext.val(params.restext);
		$expiryMonth.val(params.expMonth);
		$expiryYear.val(params.expYear);
		$cardType.val(params.cardType);
		return true;
	}

	function fail(params) {
		if(typeof params !== 'undefined') {
			$rescode.val(params.rescode);
			$restext.val(params.restext);
		}
		$cardNumber.val('');
		$cardName.val('');
		$crn.val('');
		$rescode.val('');
		$restext.val('');
		$expiryMonth.val('');
		$expiryYear.val('');
		$cardType.val('');
	}

	function onOpen(id) {

		clearTimeout(timeout);
		timeout = _.delay(function onOpenTimout() {
			meerkat.messaging.publish(meerkatEvents.paymentGateway.FAIL);
		}, 45000);

		// local alternative to bypass HAMBS' iframe for testing purposes
		//settings.hambsIframe.src = 'http://localhost:8080/ctm/external/hambs/mockPaymentGateway.html'; settings.hambsIframe.remote = 'http://localhost:8080';

		var iframe = '<iframe width="100%" height="390" frameBorder="0" src="'+ settings.src + 'external/hambs/nab_ctm_iframe.jsp?providerCode=' + settings.providerCode + '&b=' + settings.brandCode + '"></iframe>';
		meerkat.modules.dialogs.changeContent(id, iframe);

		if (window.addEventListener) {
			window.addEventListener("message", onMessage, false);
		} else if (window.attachEvent) { // IE8
			window.attachEvent("onmessage", onMessage);
		}

	}

	meerkat.modules.register("healthPaymentGatewayNAB", {
		init : init,
		success: success,
		fail: fail,
		onOpen : onOpen,
		setup : setup
	});

})(jQuery);
/*

Process:
- Call the iFrame when the pre-criteria is completed (and validated)
- Call the security session key
- iFrame will respond back with the results
- Log the final result details to the external source

*/
;(function($, undefined){

	var meerkat = window.meerkat;

	var $registered;
	var $number;
	var $type;
	var $expiry;
	var $name;

	var _type;

	var settings;

	var timeout = false;

	function init() {
	}

	function setup(instanceSettings) {
		settings = instanceSettings;
		$registered = $('#' + settings.name + '-registered');
		$number = $('#' + settings.name + '_number');
		$type = $('#' + settings.name + '_type');
		$expiry = $('#' + settings.name + '_expiry');
		$name = $('#' + settings.name + '_name');
		$('.gatewayProvider').text('Westpac');
	}

	function success(params) {
		if (!params || !params.number || !params.type || !params.expiry || !params.name) {
			meerkat.messaging.publish(meerkat.modules.events.paymentGateway.FAIL,'Registration response parameters invalid');
			return false;
		}
		$number.val(params.number); // Populate hidden fields with values returned by Westpac
		$type.val(params.type);
		$expiry.val(params.expiry);
		$name.val(params.name);
	}

	function fail(_msg) {
		$registered.val(''); // Reset hidden fields
		$number.val('');
		$type.val('');
		$expiry.val('');
		$name.val('');
	}

	function onOpen(id) {
		clearTimeout(timeout);
		timeout = setTimeout(function() {
			// Switch content to the iframe
			meerkat.modules.dialogs.changeContent(id, '<iframe width="100%" height="340" frameBorder="0" src="' + settings.src + '?transactionId=' + meerkat.modules.transactionId.get() +'"></iframe>');
		}, 1000);
	}

	meerkat.modules.register("healthPaymentGatewayWestpac", {
		success: success,
		fail: fail,
		onOpen : onOpen,
		init: init,
		setup : setup
	});

})(jQuery);
/*

Process:
- Call the iFrame when the pre-criteria is completed (and validated)
- Call the security session key
- iFrame will respond back with the results
- Log the final result details to the external source

*/
;(function($, undefined){

	var meerkat = window.meerkat,
		$maskedNumber = [],
		$token = [],
		$cardtype = [],
		modalId,
		modalContent = '',
		ajaxInProgress = false,
		launchTime = 0;


	function init() {
		$(document).ready(function initHealthPaymentIPP() {

			$('[data-provide="payment-ipp"]').each(function eachPaymentIPP() {
				var $this = $(this);

				$token = $this.find('.payment-ipp-tokenisation');

				$cardtype = $('#health_payment_credit_type');

				$maskedNumber = $this.find('.payment-ipp-maskedNumber');
				$maskedNumber.prop('readonly', true);
				$maskedNumber.css('cursor', 'pointer');
				$maskedNumber.on('click', function clickMaskedNumber() {
					launch();
				});
			});

		});
	}

	function show() {
		$('[data-provide="payment-ipp"]').removeClass('hidden');
	}

	function hide() {
		$('[data-provide="payment-ipp"]').addClass('hidden');
	}

	function launch() {
		//console.log('launch');

		// Check that the precursor is ok
		if ($maskedNumber.is(':visible') && isValid()) {
			openModal(modalContent);

			if (!isModalCreated()) {
				authorise();
			}
		}
	}

	function authorise() {
		//console.log('authorise');

		if (ajaxInProgress === true || isModalCreated()) {
			return false;
		}

		ajaxInProgress = true;
		$maskedNumber.val('Loading...');
		reset();

		meerkat.modules.comms.post({
			url: "ajax/json/ipp/ipp_payment.jsp?ts=" + (new Date().getTime()),
			dataType: 'json',
			cache: false,
			errorLevel: "silent",
			data:{
				transactionId:meerkat.modules.transactionId.get()
			},
			onSuccess: createModalContent,
			onError: function onIPPAuthError(obj, txt, errorThrown) {
				// Display an error message + log a normal error
				fail('IPP Token Session Request http');
			},
			onComplete: function onIPPAuthComplete() {
				ajaxInProgress = false;
			}
		});
	}

	function createModalContent(data) {
		//console.log('createModalContent');

		if (isModalCreated()) {
			return false;
		}

		if (!data || !data.result || data.result.success !== true) {
			fail('IPP Token Session Request fail');
			return;
		}

		// Create dialog content
		var _url = data.result.url + '?SessionId=' + data.result.refId + '&sst=' + data.result.sst
				+ '&cardType=' + cardType()
				+ '&registerError=false'
				+ '&resultPage=0';

		var _message = '<p class="message"></p>';

		htmlContent = _message + '<iframe width="100%" height="110" frameBorder="0" src="' + _url +'" tabindex="" id="cc-frame"></iframe>';
		meerkat.modules.dialogs.changeContent(modalId, htmlContent);
	}

	function openModal(htmlContent) {
		//console.log('openModal');

		launchTime = new Date().getTime();

		// If no content yet, use a loading animation
		if (typeof htmlContent === 'undefined' || htmlContent.length === 0) {
			htmlContent = meerkat.modules.loadingAnimation.getTemplate();
		}

		modalId = meerkat.modules.dialogs.show({
			htmlContent: htmlContent,
			title: 'Credit Card Number',
			buttons: [{
				label: "Cancel",
				className: 'btn-default',
				closeWindow:true
			}],
			onOpen: function(id) {
				meerkat.modules.tracking.recordSupertag('trackCustomPage', 'Payment gateway popup');
			},
			onClose: function() {
				fail('User closed process');
			}
		});

	}

	// Validate the credit card type
	function isValid() {
		return $cardtype.valid();
	}

	function fail(reason) {
		if ($token.val() === '') {
			// We need to make sure the JS tunnel de-activates this
			meerkat.modules.dialogs.changeContent(modalId, "<p>We're sorry but our system is down and we are unable to process your credit card details right now.</p><p>Continue with your application and we can collect your details after you join.</p>");
			//add the time the whole process lasted
			var failTime = ', ' + Math.round((new Date().getTime() - launchTime) / 1000) + ' seconds';
			//Add reasons: HLT-1111
			$token.val('fail, ' + reason + failTime );
			$maskedNumber.val('Try again or continue');
			modalContent = '';
		}
	}

	function isModalCreated() {
		if (modalContent === '') {
			return false;
		}
		else {
			return true;
		}
	}

	function reset() {
		$token.val('');
		$maskedNumber.val('');
		modalContent = '';
	}

	function cardType() {
		switch ($cardtype.find('option:selected').val())
		{
		case 'v':
			return 'Visa';
		case 'a':
			return 'Amex';
		case 'm':
			return 'Mastercard';
		case 'd':
			return 'Diners';
		default:
			return 'Unknown';
		}
	}

	function register(jsonData) {

		jsonData.transactionId = meerkat.modules.transactionId.get();

		meerkat.modules.comms.post({
			url: "ajax/json/ipp/ipp_log.jsp?ts=" + (new Date().getTime()),
			data: jsonData,
			dataType: 'json',
			cache: false,
			errorLevel: "silent",
			onSuccess: function onRegisterSuccess(data) {
				if (!data || !data.result || data.result.success !== true) {
					fail('IPP Token Log false');
					return
				}

				$token.val(jsonData.sessionid);
				$maskedNumber.val(jsonData.maskedcardno);
				modalContent = '';
				meerkat.modules.dialogs.close(modalId);
			},
			onError: function onRegisterError(obj, txt, errorThrown) {
				fail('IPP Token Log http');
			}
		});
	}



	meerkat.modules.register("healthPaymentIPP", {
		init: init,
		show: show,
		hide: hide,
		fail: fail,
		register: register
	});

})(jQuery);
;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events;

	var moduleEvents = {
			WEBAPP_LOCK: 'WEBAPP_LOCK',
			WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
		};

	var modalId;
	var $coverStartDate;
	var $paymentRadioGroup;
	var $premiumContainer;
	var $updatePremiumButtonContainer;
	var $paymentContainer;

	var $frequencySelect;
	var $priceCell;
	var $frequncyCell;
	var $lhcCell;

	var settings = {
		bank: [],
		credit: [],
		frequency: [],
		creditBankSupply: false,
		creditBankQuestions: false,
		minStartDateOffset: 0,
		maxStartDateOffset: 90,
		minStartDate: '',
		maxStartDate: ''
	};

	function init() {

		$(document).ready(function(){

			if(meerkat.site.vertical !== "health" || meerkat.site.pageAction === "confirmation") return false;

			// Fields
			$coverStateDate = $('#health_payment_details_start');
			$coverStateDateCalendar = $('#health_payment_details_start_calendar');
			$paymentRadioGroup = $("#health_payment_details_type");
			$frequencySelect = $("#health_payment_details_frequency");
			$bankAccountDetailsRadioGroup = $("#health_payment_details_claims");
			$sameBankAccountRadioGroup = $("#health_payment_bank_claims");

			// Containers
			$updatePremiumButtonContainer = $(".health-payment-details_update");
			$paymentContainer = $("#update-content");


			$premiumContainer = $(".health-payment-details_premium");
			$priceCell = $premiumContainer.find(".amount");
			$frequncyCell = $premiumContainer.find(".frequencyText");
			$lhcCell = $premiumContainer.find(".lhcText");


			// Add event listeners
			meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, function lockPaymentStep(obj) {
				var isSameSource = (typeof obj !== 'undefined' && obj.source && obj.source === 'healthPaymentStep');
				var disableFields = (typeof obj !== 'undefined' && obj.disableFields && obj.disableFields === true);
				disableUpdatePremium(isSameSource, disableFields);
			});

			meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, function unlockPaymentStep(obj) {
				enableUpdatePremium();
			});

			meerkat.messaging.subscribe(meerkatEvents.health.CHANGE_MAY_AFFECT_PREMIUM, resetState);

			meerkat.messaging.subscribe(meerkatEvents.healthResults.SELECTED_PRODUCT_RESET, function jeStepChange(step){
				resetState();
				resetSettings();
			});

			$paymentRadioGroup.find('input').on('change', updateFrequencySelectOptions);

			// validate coupon
			$('#update-premium').on('click', function(){
				meerkat.modules.coupon.validateCouponCode($('.coupon-code-field').val());
			});

			// reset state when change coupon code to bring update premium button back
			$('.coupon-code-field').on('change', resetState);

			// Update premium button
			$('#update-premium').on('click', updatePremium);

			$('#health_payment_credit_type').on('change', creditCardDetails.set);
			creditCardDetails.set();

			// show pay claims into bank account question (and supporting section).
			$bankAccountDetailsRadioGroup.find("input").on('click', toggleClaimsBankAccountQuestion);

			// show pay claims into bank account question (and supporting section).
			$sameBankAccountRadioGroup.find("input").on('click', toggleClaimsBankAccountQuestion);


			resetSettings();

			// Set Dom state
			$premiumContainer.hide();
			$updatePremiumButtonContainer.show();
			$paymentContainer.hide();

		});
	}

	// Reset the step
	function resetState(){

		$premiumContainer.hide();
		$updatePremiumButtonContainer.show();
		$paymentContainer.hide();
		$("#health_declaration-selection").hide();
		$("#confirm-step").hide();
		$(".simples-dialogue-31").hide();

		$('#update-premium').removeClass("hasAltPremium"); // TODO WORK OUT ALT PREMIUM STUFF

	}

	// Settings should be reset when the selected product changes.
	function resetSettings(){

		settings.bank = { 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true };
		settings.credit = { 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true };
		settings.frequency = { 'weekly':27, 'fortnightly':31, 'monthly':27, 'quarterly':27, 'halfyearly':27, 'annually':27 };
		settings.creditBankSupply = false;
		settings.creditBankQuestions = false;

		creditCardDetails.resetConfig();

		// Clear start date

		$("#health_payment_details_start").val('');

		// Clear payment method selection
		$paymentRadioGroup.find('input').prop('checked', false).change();
		$paymentRadioGroup.find('label').removeClass('active');

		// Clear frequency selection
		$frequencySelect.val('');

		// Clear bank account details selection
		$("#health_payment_details_claims input").prop('checked', false).change();
		$("#health_payment_details_claims input").find('label').removeClass('active');

		setCoverStartRange(0, 90);

	}

	//paymentSelectsHandler.bank => meerkat.modules.healthPaymentStep.overrideSettings('bank', xxx);
	//paymentSelectsHandler.credit => meerkat.modules.healthPaymentStep.overrideSettings('credit', xxx);
	//paymentSelectsHandler.frequency => meerkat.modules.healthPaymentStep.overrideSettings('frequency', xxx);
	//paymentSelectsHandler.creditBankSupply => meerkat.modules.healthPaymentStep.overrideSettings('creditBankSupply', xxx);
	//paymentSelectsHandler.creditBankQuestions => meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions', xxx);
	function overrideSettings(property, value){
		settings[property] = value;
	}

	function getSetting(property){
		return settings[property];
	}

	function getSelectedPaymentMethod(){
		return $paymentRadioGroup.find('input:checked').val();
	}

	function getSelectedFrequency(){
		return $frequencySelect.val();
	}

	function setCoverStartRange(min, max){
		settings.minStartDateOffset = min;
		settings.maxStartDateOffset = max;

		// Get today's date in UTC timezone
		var today = meerkat.modules.utils.getUTCToday(),
			start = 0,
			end = 0,
			hourAsMs = 60 * 60 * 1000;

		// Add 10 hours for QLD timezone
		today += (10 * hourAsMs);

		// Add the start day offset
		start = today;
		if (min > 0) {
			start += (min * 24 * hourAsMs);
		}

		// Calculate the end date
		end = today + (max * 24 * hourAsMs);

		today = new Date(start);
		settings.minStartDate = today.getUTCDate() + '/' + (today.getUTCMonth()+1) + '/' + today.getUTCFullYear();
		today = new Date(end);
		settings.maxStartDate = today.getUTCDate() + '/' + (today.getUTCMonth()+1) + '/' + today.getUTCFullYear();

		//console.log(settings.minStartDate, settings.maxStartDate);
	}

	// Show approved listings only, this can potentially change per fund
	function updateFrequencySelectOptions(){

		var paymentMethod = getSelectedPaymentMethod();
		var selectedFrequency = getSelectedFrequency();
		var product = meerkat.modules.healthResults.getSelectedProduct();

		var _html = '<option id="health_payment_details_frequency_" value="">Please choose...</option>';

		if(paymentMethod === '' || product === null){
			return false;
		}

		var method;

		if(paymentMethod === 'cc'){
			method = settings.credit;
		}else if(paymentMethod === 'ba'){
			method = settings.bank;
		}else{
			return false;
		}

		var premium = product.premium;

		if( method.weekly === true && premium.weekly.value > 0 ){
			_html += '<option id="health_payment_details_frequency_W" value="weekly">Weekly</option>';
		}

		if( method.fortnightly === true && premium.fortnightly.value > 0 ){
			_html += '<option id="health_payment_details_frequency_F" value="fortnightly">Fortnightly</option>';
		}

		if( method.monthly === true && premium.monthly.value > 0 ){
			_html += '<option id="health_payment_details_frequency_M" value="monthly">Monthly</option>';
		}

		if( method.quarterly === true && premium.quarterly.value > 0 ){
			_html += '<option id="health_payment_details_frequency_Q" value="quarterly">Quarterly</option>';
		}

		if( method.halfyearly === true && premium.halfyearly.value > 0 ){
			_html += '<option id="health_payment_details_frequency_H" value="halfyearly">Half-yearly</option>';
		}

		if( method.annually === true && premium.annually.value > 0){
			_html += '<option id="health_payment_details_frequency_A" value="annually">Annually</option>';
		}

		$frequencySelect.html( _html ).find('option[value='+ selectedFrequency +']').attr('selected', 'SELECTED');
	}



	// Update premium button
	function enableUpdatePremium() {
		// Enable button, hide spinner
		var $button = $('#update-premium');
		$button.removeClass('disabled');

		// Enable the other premium-related inputs
		// Ignore fields that were specifically disabled by funds' rules.
		var $paymentSection = $('#health_payment_details-selection');
		$paymentSection.find(':input').not('.disabled-by-fund').prop('disabled', false);
		$paymentSection.find('.select').not('.disabled-by-fund').removeClass('disabled');
		$paymentSection.find('.btn-group label').not('.disabled-by-fund').removeClass('disabled');

		// Non-inline datepicker
		//$('#health_payment_details_start').parent().addClass('input-group').find('.input-group-addon').removeClass('hidden');
		// Inline datepicker
		$('#health_payment_details_start').parent().find('.datepicker').children().css('visibility', 'visible');

		meerkat.modules.loadingAnimation.hide($button);
	}

	function disableUpdatePremium(isSameSource, disableFields) {
		// Disable button, show spinner
		var $button = $('#update-premium');
		$button.addClass('disabled');

		if(disableFields === true){
			// Disable the other premium-related inputs
			var $paymentSection = $('#health_payment_details-selection');
			$paymentSection.find(':input').prop('disabled', true);
			$paymentSection.find('.select').addClass('disabled');
			$paymentSection.find('.btn-group label').addClass('disabled');

			// Non-inline datepicker
			//$('#health_payment_details_start').parent().removeClass('input-group').find('.input-group-addon').addClass('hidden');
			// Inline datepicker
			$('#health_payment_details_start').parent().find('.datepicker').children().css('visibility', 'hidden');
		}

		if (isSameSource === true) {
			meerkat.modules.loadingAnimation.showAfter($button);
		}
	}

	// Calls the server for a new premium price based on current selections.
	function updatePremium() {

		if( meerkat.modules.journeyEngine.isCurrentStepValid() === false){
			return false;
		}
		// fire the tracking call
		var data = {
			actionStep: ' health application premium update'
		};
		meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
			method:	'trackQuoteForms',
			object:	data
		});

		meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, { source: 'healthPaymentStep', disableFields:true });

		// Defer so we don't lock up the browser
		_.defer(function() {
			meerkat.modules.healthResults.getProductData(function(data){

				if(data === null){

					// Sometimes the date selected by the user is not actually available, show message.
					var notAvailableHtml =
									'<p>Unfortunately this policy is not currently available. Please select another policy or call our Health Insurance Specialists on <span class=\"callCentreHelpNumber\">'+meerkat.site.content.callCentreHelpNumber+'</span> for assistance.</p>' +
									'<div class="col-sm-offset-4 col-xs-12 col-sm-4">' +
										'<a class="btn btn-next btn-block" id="select-another-product" href="javascript:;">Select Another Product</a>' +
										'<a class="btn btn-cta btn-block visible-xs" href="tel:'+meerkat.site.content.callCentreHelpNumber+'">Call Us Now</a>' +
									'</div>';

					modalId = meerkat.modules.dialogs.show({
						title: 'Policy not available',
						htmlContent: notAvailableHtml
					});

					$('#select-another-product').on('click', function(){
						meerkat.modules.dialogs.close(modalId);
						meerkat.modules.journeyEngine.gotoPath('results');
					});
				}else{

					if (_.isArray(data)) data = data[0];

					// Update selected product
					meerkat.modules.healthResults.setSelectedProduct(data, true);

					// Show premium, hide update premium button
					$premiumContainer.slideDown();
					$updatePremiumButtonContainer.hide();

					// Show payment input questions
					$paymentContainer.show();
					if(getSelectedPaymentMethod() === 'cc' ) {
						$('#health_payment_credit-selection').slideDown();
						$('#health_payment_bank-selection').hide();
					} else {
						$('#health_payment_bank-selection').slideDown();
						$('#health_payment_credit-selection').hide();
					}

					// Show declaration checkbox
					$("#health_declaration-selection").slideDown();

					toggleClaimsBankAccountQuestion();

					//re-set the days if required
					updatePaymentDayOptions();

					$("#confirm-step").show();
					$(".simples-dialogue-31").show();

					// TODO work out this: //Results._refreshSimplesTooltipContent($('#update-premium .premium'));
				}

				meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, { source: 'healthPaymentStep' });
			});
		});
	}

	// Check if details for the claims bank account needs to be shown
	function toggleClaimsBankAccountQuestion(){

		var _type = getSelectedPaymentMethod();

		if(_type == 'ba'){

			// Show sub question?
			if($bankAccountDetailsRadioGroup.find('input:checked').val() == 'Y' || (settings.creditBankQuestions === true && $bankAccountDetailsRadioGroup.is(':visible') === false)){
				toggleClaimsBankSubQuestion(true);
			}else{
				toggleClaimsBankSubQuestion(false);
			}

			// Show form?
			if($sameBankAccountRadioGroup.find("input:checked").val() == 'N'){
				toggleClaimsBankAccountForm(true);
			}else{
				toggleClaimsBankAccountForm(false);
			}

		}else if(_type == 'cc'){

			// Show sub question? (always no)
			toggleClaimsBankSubQuestion(false);

			// Show form?
			if($bankAccountDetailsRadioGroup.find("input:checked").val() == 'Y' || (settings.creditBankQuestions === true && $bankAccountDetailsRadioGroup.is(':visible') === false)){
				toggleClaimsBankAccountForm(true);
			}else{
				toggleClaimsBankAccountForm(false);
			}

		}

	}


	// What day would you like your payment deducted?
	function updatePaymentDayOptions() {

		var selected_bank_day = $("#health_payment_bank_day").val();
		var selected_credit_day = $("#health_payment_credit_day").val();

		$("#health_payment_bank_day").empty().append("<option id='health_payment_bank_day_' value='' >Please choose...</option>");
		$("#health_payment_credit_day").empty().append("<option id='health_payment_credit_day_' value='' >Please choose...</option>");

		var option_count;
		var selectedFrequency = getSelectedFrequency();
		if(selectedFrequency !== ''){
			option_count = settings.frequency[getSelectedFrequency()];
		}else{
			option_count = 27; // This is the known minimum
		}

		for(var i=1; i <= option_count; i++){
			$("#health_payment_bank_day").append("<option id='health_payment_bank_day_" + i + "' value='" + i + "'>" + i + "<" + "/option>");
			$("#health_payment_credit_day").append("<option id='health_payment_credit_day_" + i + "' value='" + i + "'>" + i + "<" + "/option>");
		}

		if( selected_bank_day ) {
			$("#health_payment_bank_day").val( selected_bank_day );
		}

		if( selected_credit_day ) {
			$("#health_payment_credit_day").val( selected_credit_day );
		}
	}

	// Render the claims details
	function toggleClaimsBankSubQuestion(show){
		if( show ) {
			$('.health_bank-details_claims_group').slideDown();
		} else {
			$('.health_bank-details_claims_group').slideUp();
		}
	}

	function toggleClaimsBankAccountForm(show){
		// Bank details form
		if( show ) {
			$('.health-bank_claim_details').slideDown();
		} else {
			$('.health-bank_claim_details').slideUp();
		}
	}


	meerkat.modules.register("healthPaymentStep", {
		init: init,
		events: moduleEvents,
		getSetting: getSetting,
		overrideSettings: overrideSettings,
		setCoverStartRange: setCoverStartRange,
		getSelectedFrequency: getSelectedFrequency,
		getSelectedPaymentMethod: getSelectedPaymentMethod
	});

})(jQuery);
;(function($, undefined){

	var meerkat = window.meerkat,
	meerkatEvents = meerkat.modules.events,
	moduleEvents = {},
	callCentreNumber = '.callCentreNumber',
	applicationSteps = ['apply','payment']; // Confirmation page is its own page and just uses the Application Number

	function init() {
		meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function jeStepChangeChangePhone(step){
			_.defer(function() {
				changePhoneNumber(false);
			});
		});
	}

	function changePhoneNumber (isModal) {
		var $callCentreFields = $(callCentreNumber),
		$callCentreHelpFields = $('.callCentreHelpNumber');

		var navigationId = meerkat.modules.address.getWindowHash().split("/")[0];
		if(isModal === true) {
			$callCentreFields = $(".more-info-content").find(callCentreNumber);
		}
		if (applicationSteps.indexOf(navigationId) > -1){
			$callCentreFields.text(meerkat.site.content.callCentreNumberApplication);
			$callCentreFields.closest('.callCentreNumberClick').attr("href", "tel:"+meerkat.site.content.callCentreNumberApplication); // Need to change mobile clicks
			$callCentreHelpFields.text(meerkat.site.content.callCentreHelpNumberApplication);
		}else{
			$callCentreFields.text(meerkat.site.content.callCentreNumber);
			$callCentreFields.closest('.callCentreNumberClick').attr("href", "tel:"+meerkat.site.content.callCentreNumber); // Need to change mobile clicks
			$callCentreHelpFields.text(meerkat.site.content.callCentreHelpNumber);
		}
	}

	meerkat.modules.register("healthPhoneNumber", {
		init: init,
		events: moduleEvents,
		changePhoneNumber: changePhoneNumber
	});

})(jQuery);
;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
			healthPriceComponent: {
				INIT: 'PRICE_COMPONENT_INITED'
			}
		},
		moduleEvents = events.healthPriceComponent;

	var logoPriceTemplate;

	var $policySummaryContainer;
	var $policySummaryTemplateHolder;
	var $policySummaryDetailsComponents;
	var $policySummaryDualPricing = [];

	var $displayedFrequency;
	var $startDateInput;



	function init(){

		jQuery(document).ready(function($) {

			if(meerkat.site.vertical !== "health") return false;

			logoPriceTemplate = $("#logo-price-template").html();

			$policySummaryContainer = $(".policySummaryContainer");
			$policySummaryTemplateHolder = $(".policySummaryTemplateHolder");
			$policySummaryDetailsComponents = $(".productSummaryDetails");
			$policySummaryDualPricing = $('.policySummary.dualPricing');

			if(meerkat.site.pageAction != "confirmation"){

				$displayedFrequency = $("#health_payment_details_frequency");
				$startDateInput = $("#health_payment_details_start");

				meerkat.messaging.subscribe(meerkatEvents.healthResults.SELECTED_PRODUCT_CHANGED, function(selectedProduct){
					// This should be called when the user selects a product on the results page.
					onProductPremiumChange(selectedProduct, false);
				});

				meerkat.messaging.subscribe(meerkatEvents.healthResults.PREMIUM_UPDATED, function(selectedProduct){
					// This should be called when the user updates their premium on the payment step.
					onProductPremiumChange(selectedProduct, true)
				});

				meerkat.messaging.subscribe(meerkatEvents.health.CHANGE_MAY_AFFECT_PREMIUM, function(selectedProduct){
					$policySummaryContainer.find(".policyPriceWarning").show();
				});

			}

			applyEventListeners();

			meerkat.messaging.publish(moduleEvents.INIT);

		});
	}

	function onProductPremiumChange(selectedProduct, showIncPrice){
		// Use the frequency selected on the payment step - if that is not set, refer to the results page frequency.
		var displayedFrequency = $displayedFrequency.val();
		if(displayedFrequency === "") displayedFrequency = Results.getFrequency();
		updateProductSummaryHeader(selectedProduct, displayedFrequency, showIncPrice);

		// Update product summary
		var startDateString = "Please confirm";
		if($startDateInput.val() !== ""){
			startDateString = $startDateInput.val();
		}

		updateProductSummaryDetails(selectedProduct, startDateString);
	}

	function updateProductSummaryHeader(product, frequency, showIncPrice){
		product._selectedFrequency = frequency;

		// Reset any settings for rendering
		if(showIncPrice){
			product.mode = 'lhcInc';
		}else{
			product.mode = '';
		}
		product.showAltPremium = false;

		var htmlTemplate = _.template(logoPriceTemplate);
		var htmlString = htmlTemplate(product);
		$policySummaryTemplateHolder.html(htmlString);

		$policySummaryDualPricing.find('.Premium').html(htmlString);

//		This is a deactivated split test as it is likely to be run again in the future
		// A/B testing price itemisation
//		if (meerkat.modules.splitTest.isActive(2)) {
//			var htmlTemplate_B = _.template($("#price-itemisation-template").html());
//			var htmlString_B = htmlTemplate_B(product);
//			$(".priceItemisationTemplateHolder").html(htmlString_B);
//		}

		$policySummaryContainer.find(".policyPriceWarning").hide();

		if ($policySummaryDualPricing.length > 0) {
			product.showAltPremium = true;
			htmlString = htmlTemplate(product);
			$policySummaryDualPricing.find('.altPremium').html(htmlString);
		}
	}

	function updateProductSummaryDetails(product, startDateString, displayMoreInfoLink){
		$policySummaryDetailsComponents.find(".name").text(product.info.providerName+" "+product.info.name);
		$policySummaryDetailsComponents.find(".startDate").text(startDateString);
		if (typeof product.hospital.inclusions !== 'undefined') {
			$policySummaryDetailsComponents.find(".excess").html(product.hospital.inclusions.excess);
			$policySummaryDetailsComponents.find(".excessWaivers").html(product.hospital.inclusions.waivers);
			$policySummaryDetailsComponents.find(".copayment").html(product.hospital.inclusions.copayment);
		}

		$policySummaryDetailsComponents.find(".footer").removeClass('hidden');
		$policySummaryDetailsComponents.find(".excess").parent().removeClass('hidden');
		$policySummaryDetailsComponents.find(".excessWaivers").parent().removeClass('hidden');
		$policySummaryDetailsComponents.find(".copayment").parent().removeClass('hidden');

		// hide more info link on request (i.e. confirmation page)
		if (typeof(displayMoreInfoLink) != "undefined" && displayMoreInfoLink === false) {
			$policySummaryDetailsComponents.find(".footer").addClass('hidden');
		}

		// hide some info if it's empty
		if (typeof product.hospital.inclusions === 'undefined' || product.hospital.inclusions.excess === "") {
			$policySummaryDetailsComponents.find(".excess").parent().addClass('hidden');
		}
		if (typeof product.hospital.inclusions === 'undefined' || product.hospital.inclusions.waivers === "") {
			$policySummaryDetailsComponents.find(".excessWaivers").parent().addClass('hidden');
		}
		if (typeof product.hospital.inclusions === 'undefined' || product.hospital.inclusions.copayment === "") {
			$policySummaryDetailsComponents.find(".copayment").parent().addClass('hidden');
		}

//		This is a deactivated split test as it is likely to be run again in the future
//		if (meerkat.modules.splitTest.isActive(2)) {
//			$policySummaryDetailsComponents.find(".companyLogo").attr('class', 'companyLogo hidden-sm'); //reset class
//			$policySummaryDetailsComponents.find(".companyLogo").addClass(product.info.provider);
//		}
	}

	function applyEventListeners() {
		$('.btn-show-how-calculated').on('click', function(){
			meerkat.modules.dialogs.show({
				title: 'Here is how your premium is calculated:',
				htmlContent: '<p>The BASE PREMIUM is the cost of a policy set by the health fund. This cost excludes any discounts or additional charges that are applied to the policy due to your age or income.</p><p>LHC LOADING is an initiative designed by the Federal Government to encourage people to take out private hospital cover earlier in life. If you&rsquo;re over the age of 31 and don&rsquo;t already have cover, you&rsquo;ll be required to pay a 2% Lifetime Health Cover loading for every year over the age of 30 that you were without hospital cover. The loading is applied to the BASE PREMIUM of the hospital component of your cover if applicable.<br/>For full information please go to: <a href="http://www.privatehealth.gov.au/healthinsurance/incentivessurcharges/lifetimehealthcover.htm" target="_blank">http://www.privatehealth.gov.au/healthinsurance/incentivessurcharges/lifetimehealthcover.htm</a></p><p>The AUSTRALIAN GOVERNMENT REBATE exists to provide financial assistance to those who need help with the cost of their health insurance premium. It is currently income-tested and tiered according to total income and the age of the oldest person covered by the policy. If you claim a rebate and find at the end of the financial year that it was incorrect for whatever reason, the Australian Tax Office will simply correct the amount either overpaid or owing to you after your tax return has been completed. There is no penalty for making a rebate claim that turns out to have been incorrect. The rebate is calculated against the BASE PREMIUM for both the hospital &amp; extras components of your cover.<br/>For full information please go to: <a href="https://www.ato.gov.au/Calculators-and-tools/Private-health-insurance-rebate-calculator/" target="_blank">https://www.ato.gov.au/Calculators-and-tools/Private-health-insurance-rebate-calculator/</a></p><p>PAYMENT DISCOUNTS can be offered by health funds for people who choose to pay by certain payment methods or pay their premiums upfront. These are applied to the total premium costs.</p>'
			});
		});
	}

	meerkat.modules.register('healthPriceComponent', {
		init: init,
		events: events,
		updateProductSummaryHeader: updateProductSummaryHeader,
		updateProductSummaryDetails: updateProductSummaryDetails
	});

})(jQuery);

/*

Handling changes to the price range coming back from the ajax

*/
;(function($, undefined) {

	var meerkat = window.meerkat,
	meerkatEvents = meerkat.modules.events,
	log = meerkat.logging.info,
	// default values
	defaultPremiumsRange = {
			fortnightly : {
				min : 1,
				max : 300
			},
			monthly : {
				min : 1,
				max : 560
			},
			yearly : {
				min : 1,
				max : 4000
			}
	};

	function init() {
		// When the frequency filter is modified, update the price slider to reflect
		$('#filter-frequency input').on('change', onUpdateFrequency);
		$(document).on("resultsDataReady", onUpdatePriceFilterRange);
	}

	function setUp() {
		var frequency = meerkat.modules.healthResults.getFrequencyInWords($('#health_filter_frequency').val());
		$('.health-filter-price .slider-control').trigger(meerkatEvents.sliders.EVENT_UPDATE_RANGE, getPremiumRange(frequency , false));
	}

	function onUpdateFrequency() {
		$('.health-filter-price .slider-control').trigger(meerkatEvents.sliders.EVENT_UPDATE_RANGE, getPremiumRange(getFrequency(), true));
	}

	function onUpdatePriceFilterRange() {
		$('.health-filter-price .slider-control').trigger(meerkatEvents.sliders.EVENT_UPDATE_RANGE, getPremiumRange(getFrequency(), false));
	}


	function getFrequency() {
		var frequency = meerkat.modules.healthResults.getFrequencyInWords($('#filter-frequency input:checked').val());
		if(!frequency) {
			frequency = Results.getFrequency();
		}
		return frequency;
	}

	function getPremiumRange(frequency , isUpdateFrequency) {
		var generalInfo = Results.getReturnedGeneral();

		if(!generalInfo || !generalInfo.premiumRange){
			premiumsRange = defaultPremiumsRange;
		} else {
			premiumsRange = generalInfo.premiumRange;
		}
		var range  = {};
		switch(frequency) {
		case 'fortnightly':
			if(premiumsRange.fortnightly.max <= 0) {
				premiumsRange.fortnightly.max = defaultPremiumsRange.fortnightly.max;
			}
			range = premiumsRange.fortnightly;
			break;
		case 'monthly':
			if(premiumsRange.monthly.max <= 0) {
				premiumsRange.monthly.max = defaultPremiumsRange.monthly.max;
			}
			range = premiumsRange.monthly;
			break;
		case 'annually':
			if(premiumsRange.yearly.max <= 0) {
				premiumsRange.yearly.max = defaultPremiumsRange.yearly.max;
			}
			range = premiumsRange.yearly;
			break;
		default:
			range = premiumsRange.monthly;
		}
		return [Number(range.min) , Number(range.max), isUpdateFrequency];
	}

	meerkat.modules.register("healthPriceRangeFilter", {
		init: init,
		setUp: setUp
	});

})(jQuery);
;(function($){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		$resultsLowNumberMessage,
		$component, //Stores the jQuery object for the component group
		selectedProduct = null,
		previousBreakpoint,
		best_price_count = 5,
		isLhcApplicable = 'N',
		premiumIncreaseContent = $('.healthPremiumIncreaseContent'),

		templates =  {
		premiumsPopOver :
				'{{ if(product.premium.hasOwnProperty(frequency)) { }}' +
				'<strong>Total Price including rebate and LHC: </strong><span class="highlighted">{{= product.premium[frequency].text }}</span><br/> ' +
				'<strong>Price including rebate but no LHC: </strong>{{=product.premium[frequency].lhcfreetext}}<br/> ' +
				'<strong>Price including LHC but no rebate: </strong>{{= product.premium[frequency].baseAndLHC }}<br/> ' +
				'<strong>Base price: </strong>{{= product.premium[frequency].base }}<br/> ' +
				'{{ } }}' +
				'<hr/> ' +
				'{{ if(product.premium.hasOwnProperty(\'fortnightly\')) { }}' +
				'<strong>Fortnightly (ex LHC): </strong>{{=product.premium.fortnightly.lhcfreetext}}<br/> ' +
				'{{ } }}' +
				'{{ if(product.premium.hasOwnProperty(\'monthly\')) { }}' +
				'<strong>Monthly (ex LHC): </strong>{{=product.premium.monthly.lhcfreetext}}<br/> ' +
				'{{ } }}' +
				'{{ if(product.premium.hasOwnProperty(\'annually\')) { }}' +
				'<strong>Annually (ex LHC): </strong>{{= product.premium.annually.lhcfreetext}}<br/> ' +
				'{{ } }}' +
				'<hr/> ' +
				'{{ if(product.hasOwnProperty(\'info\')) { }}' +
				'<strong>Name: </strong>{{=product.info.productTitle}}<br/> ' +
				'<strong>Product Code: </strong>{{=product.info.productCode}}<br/> ' +
				'<strong>Product ID: </strong>{{=product.productId}}<br/>' +
				'<strong>State: </strong>{{=product.info.State}}<br/> ' +
					'<strong>Membership Type: </strong>{{=product.info.Category}}' +
				'{{ } }}'
		},
		moduleEvents = {
			healthResults: {
				SELECTED_PRODUCT_CHANGED: 'SELECTED_PRODUCT_CHANGED',
				SELECTED_PRODUCT_RESET: 'SELECTED_PRODUCT_RESET',
				PREMIUM_UPDATED: 'PREMIUM_UPDATED'
			},
			WEBAPP_LOCK: 'WEBAPP_LOCK',
			WEBAPP_UNLOCK: 'WEBAPP_UNLOCK',
			RESULTS_ERROR: 'RESULTS_ERROR'
		};


	function initPage(){

		initResults();

		initCompare();

		Features.init();

		eventSubscriptions();

		breakpointTracking();

	}

	function onReturnToPage(){
		breakpointTracking();
		if(previousBreakpoint !== meerkat.modules.deviceMediaState.get()) {
			Results.view.calculateResultsContainerWidth();
			Features.clearSetHeights();
			Features.balanceVisibleRowsHeight();
		}
		Results.pagination.refresh();
	}

	function initResults(){
		$('.adjustFilters').on("click", function displayFiltersClicked(event) {
			event.preventDefault();
			event.stopPropagation();
			meerkat.modules.healthFilters.open();
		});

		$resultsLowNumberMessage = $(".resultsLowNumberMessage, .resultsMarketingMessages");

		var frequencyValue = $('#health_filter_frequency').val();
		frequencyValue = meerkat.modules.healthResults.getFrequencyInWords(frequencyValue) || 'monthly';



		try{

			// Init the main Results object
			Results.init({
				url: "ajax/json/health_quote_results.jsp",
				runShowResultsPage: false, // Don't let Results.view do it's normal thing.
				paths: {
					results: {
						list: "results.price",
						info: "results.info"
					},
					brand: "info.Name",
					productBrandCode: "info.providerName", // for tracking
					productId: "productId",
					productTitle: "info.productTitle",
					productName: "info.productTitle", // for tracking
					price: { // result object path to the price property
						annually: "premium.annually.lhcfreevalue",
						monthly: "premium.monthly.lhcfreevalue",
						fortnightly: "premium.fortnightly.lhcfreevalue"
					},
					availability: { // result object path to the price availability property (see corresponding availability.price)
						product: "available",
						price: {
							annually: "premium.annual.lhcfreevalue",
							monthly: "premium.monthly.lhcfreevalue",
							fortnightly: "premium.fortnightly.lhcfreevalue"
						}
					},
					benefitsSort: 'info.rank'
				},
				show: {
					// Apply Results availability filter (rule below)
					nonAvailablePrices: false
				},
				availability: {
					// This means the price has to be != 0 to display e.g. premium.annual.lhcfreevalue != 0
					price: ["notEquals", 0]
				},
				render: {
					templateEngine: '_',
					features:{
						mode:'populate',
						headers: false,
						numberOfXSColumns: 2
					},
					dockCompareBar:false
				},
				displayMode: "features",
				pagination: {
					mode: 'page',
					touchEnabled: Modernizr.touch
				},
				sort: {
					sortBy: "benefitsSort"
				},
				frequency: frequencyValue,
				animation: {
					results: {
						individual: {
							active: false
						},
						delay: 500,
						options: {
							easing: "swing", // animation easing type
							duration: 1000
						}
					},
					shuffle: {
						active: false,
						options: {
							easing: "swing" // animation easing type
						}
					},
					filter: {
						reposition: {
							options: {
								easing: "swing" // animation easing type
							}
						}
					}
				},
				elements: {
					features:{
						values: ".content",
						extras: ".children"
					}
				},
				dictionary:{
					valueMap:[
						{
							key:'Y',
							value: "<span class='icon-tick'></span>"
						},
						{
							key:'N',
							value: "<span class='icon-cross'></span>"
						},
						{
							key:'R',
							value: "Restricted"
						},
						{
							key:'-',
							value: "&nbsp;"
						}
					]
				},
				rankings: {
					triggers : ['RESULTS_DATA_READY'],
					callback : meerkat.modules.healthResults.rankingCallback,
					forceIdNumeric : true
				}
			});

		}catch(e){
			Results.onError('Sorry, an error occurred initialising page', 'results.tag', 'meerkat.modules.healthResults.initResults(); '+e.message, e);
		}
	}

	function initCompare(){

		// Init the comparison bar
		var compareSettings = {
			compareBarRenderer: ListModeCompareBarRenderer,
			elements: {
				button: ".compareBtn",
				bar: ".compareBar",
				boxes: ".compareBox"
			},
			dictionary:{
				compareLabel: 'Compare <span class="icon icon-arrow-right"></span>',
				clearBasketLabel: 'Clear Shortlist <span class="icon icon-arrow-right"></span>'
			}
		};

		Compare.init(compareSettings);

		$compareBasket = $(Compare.settings.elements.bar);

		$compareBasket.on("compareAdded", function(event, productId ){

			// Close the more info panel if open.
			if(meerkat.modules.healthMoreInfo.getOpenProduct() !== null && meerkat.modules.healthMoreInfo.getOpenProduct().productId !== productId){
				meerkat.modules.healthMoreInfo.close();
			}

			$compareBasket.addClass("active");
			$( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + "[data-productId=" + productId + "]" ).addClass('compared');

			if( Compare.view.resultsFiltered === false && (Compare.model.products.length === Compare.settings.maximum) ){
				$(".compareBtn").addClass("compareInActive"); // disable the button straight away as slow devices still let you tap it.
				_.delay(function(){
					compareResults();
				}, 250);

			}
		});

		$compareBasket.on("compareRemoved", function(event, productId){

			if( Compare.view.resultsFiltered && (Compare.model.products.length >= Compare.settings.minimum) ){
				compareResults();
			}
			$element = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + "[data-productId=" + productId + "]" );
			$element.removeClass('compared');
			$element.find(".compareCheckbox input").prop("checked", false);

			if(Compare.model.products.length === 0 ){
				$(".compareBar").removeClass("active");
				toggleMarketingMessage(false);
				toggleResultsLowNumberMessage(true);
			}
		});

		$compareBasket.on("compareNonAvailable", function(event){
			if( Compare.view.resultsFiltered ){
				resetCompare(); // was just unfilter
			}
		});

		// Prevent the user from adding too many items to the bucket.
		$compareBasket.on("compareBucketFull", function(event){
			$(".result .compareCheckbox :input").not(":checked").prop('disabled', true);
		});

		$compareBasket.on("compareBucketAvailable", function(event){
			$(".result .compareCheckbox :input").prop('disabled', false);
		});

		// Compare button clicked.
		$compareBasket.on("compareClick", function(event){
			if( !Compare.view.resultsFiltered ) {
				compareResults();

			} else {
				resetCompare();
			}
		});



	}

	function resetCompare(){
		$container = $(Results.settings.elements.container);
		// Do this stuff now (even though we don't have to) so low performing devices look good
		if(Results.settings.animation.filter.active){
			$container.find('.compared').removeClass('compared');
		}else{
			// Do even more stuff for lower performance devices look reasonable.
			$container.find('.compared').removeClass('compared notfiltered').addClass('filtered');
		}

		$container.find('.compareCheckbox input').prop("checked", false);
		$(".compareBtn").addClass("compareInActive");

		_.defer(function(){
			Compare.unfilterResults();
			_.defer(function(){
			Compare.reset();
		});
		});
	}

	function compareResults(){

		_.defer(function(){

			Compare.filterResults();

			_.defer(function(){

				toggleMarketingMessage(true, 5-Results.getFilteredResults().length);
				toggleResultsLowNumberMessage(false);

				_.delay(function(){

					// Expand hospital and extra sections
					if(Results.settings.render.features.expandRowsOnComparison){
						$(".featuresHeaders .featuresList > .section.expandable.collapsed > .content").trigger('click');

						// Expand selected items details.
						$(".featuresHeaders .featuresList > .selectionHolder > .children > .category.expandable.collapsed > .content").trigger('click');
					}

					// Close the more info panel if open.
					if(meerkat.modules.healthMoreInfo.getOpenProduct() !== null){
						meerkat.modules.healthMoreInfo.close();
					}

					// Publish tracking events.
					meerkat.messaging.publish(meerkatEvents.tracking.TOUCH, {
						touchType:'H',
						touchComment: 'ResCompare',
						simplesUser: meerkat.site.isCallCentreUser
					});

					var compareArray = [];
					var items = Results.getFilteredResults();
					for (var i = 0; i < items.length; i++)
					{
						var product = items[i];
						compareArray.push({productID : product.productId});
					}

					meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
						method:'trackQuoteComparison',
						object:{
							products: compareArray,
							simplesUser: meerkat.site.isCallCentreUser
						}
					});

				},Results.settings.animation.features.scroll.duration+100);
			});

		});
	}


	function updateBasketCount(){
		var items = Results.getFilteredResults().length;
		var label = items + ' product';
		if(items != 1) label = label+'s';
		$(".compareBar .productCount").text(label);
	}

	function eventSubscriptions(){

		$(Results.settings.elements.resultsContainer).on("featuresDisplayMode", function(){
			Features.buildHtml();
		});

		$(document).on("generalReturned", function(){
			var generalInfo = Results.getReturnedGeneral();
			if(generalInfo.pricesHaveChanged){
				meerkat.modules.dialogs.show({
					title: "Just a quick note",
					htmlContent: $('#quick-note').html(),
					buttons: [{
						label: "Show latest results",
						className: "btn btn-next",
						closeWindow: true
					}]
				});
				$("input[name='health_retrieve_savedResults']").val("N");
			}
		});

		$(document).on("resultsLoaded", onResultsLoaded);

		$(document).on("resultsReturned", function(){
			Compare.reset();
			meerkat.modules.utils.scrollPageTo($("header"));

			// Reset the feature header to match the new column content.
			$(".featuresHeaders .expandable.expanded").removeClass("expanded").addClass("collapsed");

			if (premiumIncreaseContent.length > 0){
				_.defer(function(){
					premiumIncreaseContent.click();
				});
			}

			// coupon logic, filter for user, then render banner
			meerkat.modules.coupon.loadCoupon('filter', null, function successCallBack(){
				meerkat.modules.coupon.renderCouponBanner();
		});
		});

		$(document).on("resultsDataReady", function(){
			updateBasketCount();
			if( meerkat.site.isCallCentreUser ){
				createPremiumsPopOver();
			}
		});

		$(document).on("resultsFetchStart", function onResultsFetchStart() {

			toggleMarketingMessage(false);
			toggleResultsLowNumberMessage(false);
			meerkat.modules.journeyEngine.loadingShow('getting your quotes');

			// Hide pagination
			$('header .slide-feature-pagination, header a[data-results-pagination-control]').addClass('hidden');
		});

		// If error occurs, go back in the journey
		meerkat.messaging.subscribe(moduleEvents.RESULTS_ERROR, function resultsError() {
			// Delayed to allow journey engine to unlock
			_.delay(function() {
				meerkat.modules.journeyEngine.gotoPath('previous');
			}, 1000);
		});

		$(document).on("resultsFetchFinish", function onResultsFetchFinish() {
			toggleResultsLowNumberMessage(true);

			_.defer(function() {
				// Show pagination
				$('header .slide-feature-pagination, header a[data-results-pagination-control]').removeClass('hidden');
				// Setup scroll
				Results.pagination.setupNativeScroll();
			});

			meerkat.modules.journeyEngine.loadingHide();

			if(!meerkat.site.isNewQuote && !Results.getSelectedProduct() && meerkat.site.isCallCentreUser) {
				Results.setSelectedProduct($('.health_application_details_productId').val() );
				var product = Results.getSelectedProduct();
				if (product) {
					meerkat.modules.healthResults.setSelectedProduct(product);
				}
			}

			// if online user load quote from brochures edm (with attached productId), compare it with returend result set, if it is in there, select it, and go to apply stage.
			if(($('input[name="health_directApplication"]').val() === 'Y')) {
				Results.setSelectedProduct( meerkat.site.loadProductId );
				var productMatched = Results.getSelectedProduct();
				if (productMatched) {
					meerkat.modules.healthResults.setSelectedProduct(productMatched);
					meerkat.modules.journeyEngine.gotoPath("next");
				}else{
					var productUpdated = Results.getResult("productTitle", meerkat.site.loadProductTitle);
					var htmlContent = "";

					if (productUpdated){
						meerkat.modules.healthResults.setSelectedProduct(productUpdated);
						htmlContent	=	"Thanks for visiting " + meerkat.site.content.brandDisplayName + ". Please note that for this particular product, " +
										"the price and/or features have changed since the last time you were comparing. If you need further assistance, " +
										"you can chat to one of our Health Insurance Specialists on <span class=\"callCentreHelpNumber\">" + meerkat.site.content.callCentreHelpNumber + "</span>, and they will be able to help you with your options.";
					}else{
						$('#health_application_productId').val(''); // reset selected productId to prevent it getting saved into transaction details.
						$('#health_application_productTitle').val(''); // reset selected productTitle to prevent it getting saved into transaction details.
						htmlContent	=	"Thanks for visiting " + meerkat.site.content.brandDisplayName + ". Unfortunately the product you're looking for is no longer available. " +
										"Please head to your results page to compare available policies or alternatively, " +
										"chat to one of our Health Insurance Specialists on <span class=\"callCentreHelpNumber\">" + meerkat.site.content.callCentreHelpNumber + "</span>, and they will be able to help you with your options.";
					}

					meerkat.modules.dialogs.show({
						title: "Just a quick note",
						htmlContent: htmlContent,
						buttons: [{
							label: "Show latest results",
							className: "btn btn-next",
							closeWindow: true
						}]
					});
				}

				// reset
					meerkat.site.loadProductId = '';
				meerkat.site.loadProductTitle = '';
				$('input[name="health_directApplication"]').val('');
				}

			// Results are hidden in the CSS so we don't see the scaffolding after #benefits
			$(Results.settings.elements.page).show();
		});

		$(document).on("populateFeaturesStart", function onPopulateFeaturesStart() {
			meerkat.modules.performanceProfiling.startTest('results');

		});

		$(Results.settings.elements.resultsContainer).on("populateFeaturesEnd", function onPopulateFeaturesEnd() {

			var time = meerkat.modules.performanceProfiling.endTest('results');

			var score;
			if(time < 800){
				score = meerkat.modules.performanceProfiling.PERFORMANCE.HIGH;
			}else if (time < 8000 && meerkat.modules.performanceProfiling.isIE8() === false){
				score = meerkat.modules.performanceProfiling.PERFORMANCE.MEDIUM;
			}else{
				score = meerkat.modules.performanceProfiling.PERFORMANCE.LOW;
			}

			Results.setPerformanceMode(score);

		});



		$(document).on("resultPageChange", function(event){

			var pageData = event.pageData;
			if(pageData.measurements === null) return false;

			var numberOfPages = pageData.measurements.numberOfPages;
			var items = Results.getFilteredResults().length;
			var columnsPerPage = pageData.measurements.columnsPerPage;
			var freeColumns = (columnsPerPage*numberOfPages)-items;
			var pageNumber = pageData.pageNumber;

			meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
				additionalData: {
					pageNumber: pageNumber,
					numberOfPages: numberOfPages
				},
				onAfterEventMode: 'Load'
			});

			if(freeColumns > 1 && numberOfPages === 1) {
				toggleResultsLowNumberMessage(true);
				toggleMarketingMessage(false);

			}else {
				toggleResultsLowNumberMessage(false);
				if(Compare.view.resultsFiltered === false) {

					if(pageNumber === pageData.measurements.numberOfPages && freeColumns > 2){
						toggleMarketingMessage(true, freeColumns);
						return true;
					}
					toggleMarketingMessage(false);
				}
			}

		});

		$(document).on("FeaturesRendered", function(){

			$(Features.target + " .expandable > " + Results.settings.elements.features.values).on("mouseenter", function(){
				var featureId = $(this).attr("data-featureId");
				var $hoverRow = $( Features.target + ' [data-featureId="' + featureId + '"]' );

				$hoverRow.addClass( Results.settings.elements.features.expandableHover.replace(/[#\.]/g, '') );
			})
			.on("mouseleave", function(){
				var featureId = $(this).attr("data-featureId");
				var $hoverRow = $( Features.target + ' [data-featureId="' + featureId + '"]' );

				$hoverRow.removeClass( Results.settings.elements.features.expandableHover.replace(/[#\.]/g, '') );
		});
		});

		// When the excess filter changes, fetch new results
		meerkat.messaging.subscribe(meerkatEvents.healthFilters.CHANGED, function onFilterChange(obj){
			resetCompare();

			if (obj && obj.hasOwnProperty('filter-frequency-change')) {
				meerkat.modules.resultsTracking.setResultsEventMode('Refresh'); // Only for events that dont cause a new TranId
	}
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function onHealthResultsXsEnterChange(){
			resetCompare();
		});

	}



	function breakpointTracking(){

		if( meerkat.modules.deviceMediaState.get() == "xs") {
			startColumnWidthTracking();
		}

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function resultsXsBreakpointEnter(){
			if( meerkat.modules.journeyEngine.getCurrentStep().navigationId === "results" ){
				startColumnWidthTracking();
			}
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function resultsXsBreakpointLeave(){
			stopColumnWidthTracking();
		});

	}

	function startColumnWidthTracking(){
		Results.view.startColumnWidthTracking( $(window), Results.settings.render.features.numberOfXSColumns, false );
	}

	function stopColumnWidthTracking(){
		Results.view.stopColumnWidthTracking();
	}

	function recordPreviousBreakpoint(){
		previousBreakpoint = meerkat.modules.deviceMediaState.get();
	}

	// Wrapper around results component, load results data
	function get(){
		// Load rates before loading the results data (hidden fields are populated when rates are loaded).
		meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, { source: 'healthLoadRates' });
		meerkat.modules.health.loadRates(function afterFetchRates(){
			meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, { source: 'healthLoadRates' });
			Results.get();
		});
	}

	// Get the selected product - a clone of the product object from the results component.
	function getSelectedProduct(){
		return selectedProduct;
	}

	function getSelectedProductPremium(frequency){
		var selectedProduct = getSelectedProduct();
		return selectedProduct.premium[frequency];
	}

	function getFrequencyInLetters(frequency){
		switch(frequency){
			case 'weekly':
				return 'W';
			case 'fortnightly':
				return 'F';
			case 'monthly':
				return 'M';
			case 'quarterly':
				return 'Q';
			case 'halfyearly':
				return 'H';
			case 'annually':
				return 'A';
			default:
				return false;
		}
	}

	function getFrequencyInWords(frequency){
		switch(frequency){
			case 'W':
				return 'weekly';
			case 'F':
				return 'fortnightly';
			case 'M':
				return 'monthly';
			case 'Q':
				return 'quarterly';
			case 'H':
				return 'halfyearly';
			case 'A':
				return 'annually';
			default:
				return false;
		}
	}

	function getNumberOfPeriodsForFrequency(frequency){
		switch(frequency){
			case 'weekly':
				return 52;
			case 'fortnightly':
				return 26;
			case 'quarterly':
				return 4;
			case 'halfyearly':
				return 2;
			case 'annually':
				return 1;
			default:
				return 12;
		}
	}

	function setSelectedProduct(product, premiumChangeEvent){

		selectedProduct = product;

		// Set hidden fields with selected product info.
		var $_main = $('#mainform');
		if(product === null){
			$_main.find('.health_application_details_provider').val("");
			$_main.find('.health_application_details_productId').val("");
			$_main.find('.health_application_details_productNumber').val("");
			$_main.find('.health_application_details_productTitle').val("");
			$_main.find('.health_application_details_providerName').val("");
		}else{
			$_main.find('.health_application_details_provider').val(selectedProduct.info.provider);
			$_main.find('.health_application_details_productId').val(selectedProduct.productId);
			$_main.find('.health_application_details_productNumber').val(selectedProduct.info.productCode);
			$_main.find('.health_application_details_productTitle').val(selectedProduct.info.productTitle);
			$_main.find('.health_application_details_providerName').val(selectedProduct.info.providerName);

			if(premiumChangeEvent === true){
				meerkat.messaging.publish(moduleEvents.healthResults.PREMIUM_UPDATED, selectedProduct);
			}else{
				meerkat.messaging.publish(moduleEvents.healthResults.SELECTED_PRODUCT_CHANGED, selectedProduct);
				$(Results.settings.elements.rows).removeClass("active");

				var $targetProduct = $(Results.settings.elements.rows + "[data-productid=" + selectedProduct.productId + "]");
				var targetPosition = $targetProduct.data('position') + 1;
				$targetProduct.addClass("active");
				Results.pagination.gotoPosition(targetPosition, true, false);
			}

			// update transaction details otherwise we will have to wait until people get to payment page
			meerkat.modules.writeQuote.write({
				health_application_provider: selectedProduct.info.provider,
				health_application_productId: selectedProduct.productId,
				health_application_productName: selectedProduct.info.productCode,
				health_application_productTitle: selectedProduct.info.productTitle
			}, false);

		}

	}

	function resetSelectedProduct(){
		// Need to reset the health fund setting.
		healthFunds.unload();

		// Reset selected product.
		setSelectedProduct(null);

		meerkat.messaging.publish(moduleEvents.healthResults.SELECTED_PRODUCT_RESET);
	}

	// Load an individual product from the results service call. (used to refresh premium info on the payment step)
	function getProductData(callback){
		meerkat.modules.health.loadRates(function afterFetchRates(data){
			if(data === null){

				// This has failed.
				callback(null);

			}else{

				var postData = meerkat.modules.journeyEngine.getFormData();

				// Override some form data to only return a single product.
				_.findWhere(postData, {name: "health_showAll"}).value = "N";
				_.findWhere(postData, {name: "health_onResultsPage"}).value = "N";
				_.findWhere(postData, {name: "health_incrementTransactionId"}).value = "N";

				// Dynamically add these fields because they are disabled when this method is called.
				postData.push({name: "health_payment_details_start", value:$("#health_payment_details_start").val()});
				postData.push({name: "health_payment_details_type", value:meerkat.modules.healthPaymentStep.getSelectedPaymentMethod()});
				postData.push({name: "health_payment_details_frequency", value:meerkat.modules.healthPaymentStep.getSelectedFrequency()});

				meerkat.modules.comms.post({
					url:"ajax/json/health_quote_results.jsp",
					data: postData,
					cache: false,
					errorLevel: "warning",
					onSuccess: function onGetProductSuccess(data){
						Results.model.updateTransactionIdFromResult(data);

						if (!data.results || !data.results.price || data.results.price.available === 'N') {
							callback(null);
						} else {
							callback(data.results.price);
						}

					},
					onError: function onGetProductError(data){
						callback(null);
					}
				});
			}

		});
	}


	// Change the results templates to promote features to the 'selected' features row.

	function onBenefitsSelectionChange(selectedBenefits, callback){

		// Reset the template first. Place the cloned elements back in the results template.

		$component.find('.featuresTemplateComponent .selectionHolder [data-skey]').each(function( index, elementA ) {

			var $element = $(elementA);
			var key = $element.attr('data-skey');
			var parentKey = $element.attr('data-par-skey');
			var elementIndex = Number($element.attr('data-index'));

			$parentFeatureList = $element.parents('.featuresTemplateComponent').first();

			if(elementIndex === 0){
				var $item = $parentFeatureList.find('div[data-skey="'+parentKey+'"].hasShortlistableChildren .children').first();
				if( $item.attr('data-skey') === key ){
					$item.after($element);
				} else {
					$item.prepend($element);
				}
			}else{
				var beforeIndex = elementIndex - 1;
				$parentFeatureList.find('.hasShortlistableChildren div[data-par-skey="'+parentKey+'"][data-index="'+beforeIndex+'"]').first().after($element);
			}

		});


		// Place the elements in their new position

		for(var i=0;i<selectedBenefits.length;i++){

			var key = selectedBenefits[i];
			/*jshint -W083 */
			$component.find('.featuresTemplateComponent div[data-skey="'+key+'"]').each(function( index, elementA ) {
				var $element = $(elementA);
				var parentKey = $element.attr('data-par-skey');
				if(parentKey != null){
					// Find the place where we will drop the element, create a clone if it doesn't exist.
					$parentFeatureList = $element.parents('.featuresTemplateComponent').first();
					$parentFeatureList.find('.selection_'+parentKey+' .children').first().append($element);
				}
			});
			/*jshint +W083 */

		}

		// Hide top level sections which were not shortlisted.

		$component.find('.featuresTemplateComponent > .section.hasShortlistableChildren').each(function( index, elementA ) {

			var $element = $(elementA);
			var key = $element.attr('data-skey');
			var $selectionElement = $component.find('.cell.selection_'+key);

			if(selectedBenefits.indexOf(key) === -1){

				$element.hide();
				$selectionElement.hide();

			}else{

				$element.show();

				var selectedCount = $component.find('.featuresHeaders .selection_'+key+'> .children > .cell').length;

				if(selectedCount === 0){

					$selectionElement.hide();

				}else{

					$selectionElement.show();

					var $linkedElement = $component.find('.featuresHeaders div[data-skey="'+key+'"]');
					var availableCount = selectedCount + $linkedElement.find('> .children > .cell').length;

					$selectionElement.find('.content .extraText .selectedCount').text(selectedCount);
					$selectionElement.find('.content .extraText .availableCount').text(availableCount);

				}
			}

		});

		// If on the results step, reload the results data. Can this be more generic?

		if(typeof callback === 'undefined'){
			if(meerkat.modules.journeyEngine.getCurrentStepIndex() === 3){
				get();
			}
		}else{
			callback();
		}

	}



	function onResultsLoaded() {

		if( meerkat.modules.deviceMediaState.get() == "xs") {
			startColumnWidthTracking();
		}

		updateBasketCount();

		// Listen to compare events
		try{
			// Compare checkboxes and top result
			$("#resultsPage .compare").unbind().on("click", function(){

				var $checkbox = $(this);
				var productId = $checkbox.parents( Results.settings.elements.rows ).attr("data-productId");
				var productObject = Results.getResult( "productId", productId );

				var product = {
					id: productId,
					object: productObject
				};

				if( $checkbox.is(":checked") ){
					Compare.add( product );
				} else {
					Compare.remove( productId );
				}

			});
		}catch(e){
			Results.onError('Sorry, an error occurred processing results', 'results.tag', 'FeaturesResults.setResultsActions(); '+e.message, e);
		}
		if( meerkat.site.isCallCentreUser ){
			createPremiumsPopOver();
		}
	}

	/*
	 * recreate the Simples tooltips over prices for Simples users
	 * when the results get loaded/reloaded
	 */
	function createPremiumsPopOver() {
			$('#resultsPage .price').each(function(){

				var $this = $(this);
				var productId = $this.parents( Results.settings.elements.rows ).attr("data-productId");
				var product = Results.getResultByProductId(productId);

			if(product.hasOwnProperty('premium')) {
			var htmlTemplate = _.template(templates.premiumsPopOver);

			var text = htmlTemplate({
				product : product,
				frequency : Results.getFrequency()
			});

				meerkat.modules.popovers.create({
					element: $this,
					contentValue: text,
					contentType: 'content',
					showEvent: 'mouseenter click',
					position: {
						my: 'top center',
						at: 'bottom center'
					},
					style: {
						classes: 'priceTooltips'
					}
				});
			} else {
				meerkat.modules.errorHandling.error({
					message:		'product does not have property premium',
					page:			'healthResults.js',
					description:	'createPremiumsPopOver()',
					errorLevel:		'silent',
					data:			product
			});
		}
		});
	}



	function toggleMarketingMessage(show, columns){
		var $marketingMessage = $(".resultsMarketingMessage");
		if(show){
			$marketingMessage.addClass('show').attr('data-columns', columns);
		}else{
			$marketingMessage.removeClass('show');
		}
	}


	function toggleResultsLowNumberMessage(show) {
		var freeColumns;
		if(show){
			var pageMeasurements = Results.pagination.calculatePageMeasurements();
			if(pageMeasurements == null) {
				show = false;
			} else {
				var items = Results.getFilteredResults().length;
				freeColumns = pageMeasurements.columnsPerPage-items;
				if(freeColumns < 2 || pageMeasurements.numberOfPages !== 1) {
					show = false;
				}
			}
		}

		if(show){
			$resultsLowNumberMessage.addClass('show');
			$resultsLowNumberMessage.attr('data-columns', freeColumns);
		}else{
			$resultsLowNumberMessage.removeClass('show');
		}
		return show;
	}

	function rankingCallback(product, position) {

		var data = {};
		var frequency = Results.getFrequency(); // eg monthly.yearly etc..
		var prodId = product.productId.replace('PHIO-HEALTH-', '');
		data["rank_productId" + position] = prodId;
		data["rank_price_actual" + position] = product.premium[frequency].value.toFixed(2);
		data["rank_price_shown" + position] = product.premium[frequency].lhcfreevalue.toFixed(2);
		data["rank_frequency" + position] = frequency;
		data["rank_lhc" + position] = product.premium[frequency].lhc;
		data["rank_rebate" + position] = product.premium[frequency].rebate;
		data["rank_discounted" + position] = product.premium[frequency].discounted;

		if( _.isNumber(best_price_count) && position < best_price_count ) {
			data["rank_provider" + position] = product.info.provider;
			data["rank_providerName" + position] = product.info.providerName;
			data["rank_productName" + position] = product.info.productTitle;
			data["rank_productCode" + position] = product.info.productCode;
			data["rank_premium" + position] = product.premium[Results.settings.frequency].lhcfreetext;
			data["rank_premiumText" + position] = product.premium[Results.settings.frequency].lhcfreepricing;
			}

		return data;
		}

	/**
	 * This function has been refactored into calling a core resultsTracking module.
	 * It has remained here so verticals can run their own unique calls.
	 */
	function publishExtraSuperTagEvents() {

		meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
			additionalData: {
				preferredExcess: getPreferredExcess(),
				paymentPlan: Results.getFrequency(),
				sortBy: (Results.getSortBy() === "benefitsSort" ? "Benefits" : "Lowest Price"),
				simplesUser: meerkat.site.isCallCentreUser,
				isLhcApplicable: isLhcApplicable
			},
			onAfterEventMode: 'Load'
		});
	}

	function getPreferredExcess() {
		var excess = null;
		switch($("#health_excess").val()) {
			case '1':
				excess = "0";
				break;
			case '2':
				excess = "1-250";
				break;
			case '3':
				excess = "251-500";
				break;
			default:
				excess = "ALL";
				break;
		}
		return excess;
			}

	function setLhcApplicable(lhcLoading){
		isLhcApplicable = lhcLoading > 0 ? 'Y' : 'N';
	}

	function init(){

		$component = $("#resultsPage");

		meerkat.messaging.subscribe(meerkatEvents.healthBenefits.CHANGED, onBenefitsSelectionChange);
		meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);
	}

	meerkat.modules.register('healthResults', {
		init: init,
		events: moduleEvents,
		initPage: initPage,
		onReturnToPage:onReturnToPage,
		get:get,
		getSelectedProduct:getSelectedProduct,
		setSelectedProduct:setSelectedProduct,
		resetSelectedProduct:resetSelectedProduct,
		getProductData:getProductData,
		getSelectedProductPremium:getSelectedProductPremium,
		getNumberOfPeriodsForFrequency:getNumberOfPeriodsForFrequency,
		getFrequencyInLetters: getFrequencyInLetters,
		getFrequencyInWords: getFrequencyInWords,
		stopColumnWidthTracking: stopColumnWidthTracking,
		toggleMarketingMessage:toggleMarketingMessage,
		toggleResultsLowNumberMessage:toggleResultsLowNumberMessage,
		onBenefitsSelectionChange:onBenefitsSelectionChange,
		recordPreviousBreakpoint:recordPreviousBreakpoint,
		rankingCallback: rankingCallback,
		publishExtraSuperTagEvents: publishExtraSuperTagEvents,
		setLhcApplicable: setLhcApplicable
	});

})(jQuery);

/**
* Description: Minimal, temporary file to detect affected Safari browsers and add a class to the body to remove -webkit-column-count = 2
* External documentation: http://itsupport.intranet:8080/browse/HLT-1548
*/

;(function($, undefined){

	function init(){

		jQuery(document).ready(function($) {
			if(meerkat.modules.performanceProfiling.isSafariAffectedByColumnCountBug()) {
				$('.benefits-component .benefits-list .children').css('-webkit-column-count', '1');
			}
		});

	}

	meerkat.modules.register("healthSafariColumnCountFix", {
		init: init
	});

})(jQuery);
;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		debug = meerkat.logging.debug,
		exception = meerkat.logging.exception;

	var currentSegments = false;

	function filterSegments() {		
		meerkat.modules.comms.get({
			url: 'segment/filter.json',
			cache: false,
			errorLevel: 'silent',
			dataType: 'json',
			useDefaultErrorHandling: false
		})
		.done(function onSuccess(json) {
			setCurrentSegments(json);
			hideBySegment();
		})
		.fail(function onError(obj, txt, errorThrown) {
			exception(txt + ': ' + errorThrown);
		});
	}

	function hideBySegment() {
		if (currentSegments.hasOwnProperty('segments') && currentSegments.segments.length > 0){
			_.each(currentSegments.segments, function(segment) {
				if (canHide(segment) === true) {
					$('.' + segment.classToHide).css("visibility", "hidden");
				}
			});
		}
	}

	function isSegmentsValid(segment) {
		if (!segment.hasOwnProperty('segmentId') || isNaN(segment.segmentId) || segment.segmentId <= 0) {
			debug("Segment is not valid");
			return false;
		}

		if (segment.hasOwnProperty('errors') && segment.errors.length > 0) {
			debug(segment.errors[0].message);
			return false;
		}

		return true;
	}

	function canHide(segment) {
		if (isSegmentsValid(segment) !== true) return false;
		if (!segment.hasOwnProperty('canHide') || segment.canHide !== true) return false;
		if (!segment.hasOwnProperty('classToHide') || segment.classToHide.length === 0 || !segment.classToHide.trim()) return false;
		return true;
	}

	function getCurrentSegments() {
		return currentSegments;
	}

	function setCurrentSegments(segments) {
		currentSegments = segments;
	}

	meerkat.modules.register("healthSegment", {
		filterSegments: filterSegments,
		hideBySegment: hideBySegment
	});

})(jQuery);
/*

Handling of the rebate tiers based off situation

*/
;(function($, undefined) {

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		rebateTiers = {
			single:{
				incomeBaseTier:90000,
				incomeTier1:{
					from:90001,
					to:105000
				},incomeTier2:{
					from:105001,
					to:140000
				},
				incomeTier3:140001
			},
			familyOrCouple:{
				incomeBaseTier:180000,
				incomeTier1:{
					from:180001,
					to:210000
				},
				incomeTier2:{
					from:210001,
					to:280000
				},
				incomeTier3:280001
			}
		},
		$dependants,
		$incomeMessage,
		$incomeBase,
		$income,
		$tier,
		$medicare;

	init =  function(){
		$dependants = $('#health_healthCover_dependants');
		$incomeMessage = $('#health_healthCover_incomeMessage');
		$incomeBase = $('#health_healthCover_incomeBase');
		$income = $('#health_healthCover_income');
		$tier = $('#health_healthCover_tier');
		$medicare = $('.health-medicare_details');
	};

	// Manages the descriptive titles of the tier drop-down
	setTiers =  function(initMode){

		// Set the dependants allowance and income message
		var _allowance = ($dependants.val() - 1);

		if( _allowance > 0 ){
			_allowance = _allowance * 1500;
			$incomeMessage.text('this includes an adjustment for your dependants');
		} else {
			_allowance = 0;
			$incomeMessage.text('');
		}

		//Set the tier type based on hierarchy of selection
		var _cover;
		if( $incomeBase.is(':visible') && $('#health_healthCover_incomeBase').find(':checked').length > 0 ) {
			_cover = $incomeBase.find(':checked').val();
		} else {
			_cover = healthChoices.returnCoverCode();
		}

		// Reset and then loop through all of the options
		$income.find('option').each( function() {
			//set default vars
			var $this = $(this);
			var _value = $this.val();
			var _text = '';

			// Calculate the Age Bonus
			if( meerkat.modules.health.getRates() === null){
				_ageBonus = 0;
			} else {
				_ageBonus = parseInt(meerkat.modules.health.getRates().ageBonus);
			}

			if(_cover === 'S' || _cover === 'SM' || _cover === 'SF' || _cover === ''){
				// Single tiers
				switch(_value) {
					case '0':
						_text = '$'+ formatMoney(rebateTiers.single.incomeBaseTier + _allowance) +' or less';
						break;
					case '1':
						_text = '$'+ formatMoney(rebateTiers.single.incomeTier1.from + _allowance) +' - $'+ formatMoney(rebateTiers.single.incomeTier1.to + _allowance);
						break;
					case '2':
						_text = '$'+ formatMoney(rebateTiers.single.incomeTier2.from + _allowance) +' - $'+ formatMoney(rebateTiers.single.incomeTier2.to + _allowance);
						break;
					case '3':
						_text = '$'+ formatMoney(rebateTiers.single.incomeTier3 + _allowance) + '+ (no rebate)';
						break;
				}
			} else {
				// Family tiers
				switch(_value) {
					case '0':
						_text = '$'+ formatMoney(rebateTiers.familyOrCouple.incomeBaseTier + _allowance) +' or less';
						break;
					case '1':
						_text = '$'+ formatMoney(rebateTiers.familyOrCouple.incomeTier1.from + _allowance) +' - $'+ formatMoney(rebateTiers.familyOrCouple.incomeTier1.to + _allowance);
						break;
					case '2':
						_text = '$'+ formatMoney(rebateTiers.familyOrCouple.incomeTier2.from + _allowance) +' - $'+ formatMoney(rebateTiers.familyOrCouple.incomeTier2.to + _allowance);
						break;
					case '3':
						_text = '$'+ formatMoney(rebateTiers.familyOrCouple.incomeTier3 + _allowance) + '+ (no rebate)';
						break;
					}
			}

			// Set Description
			if(_text !== ''){
				$this.text(_text);
			}

			// Hide these questions as they are not required
			if( healthCoverDetails.getRebateChoice() == 'N' || !healthCoverDetails.getRebateChoice() ) {
				if(initMode){
					$tier.hide();
				}else{
					$tier.slideUp();
				}

				$medicare.hide();
				meerkat.modules.form.clearInitialFieldsAttribute($medicare);
			} else {

				if(initMode){
					$tier.show();
				}else{
					$tier.slideDown();
				}

				$medicare.show();
			}
		});

	
	};

	meerkat.modules.register("healthTiers", {
		init: init,
		setTiers: setTiers
	});

})(jQuery);
;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var postData = {},
		elements = {
			applicationDate: $('.applicationDate'),
			applicationDateContainer: $('.applicationDateContainer'),
			productTitleSearchContainer: $('.productTitleSearchContainer'),
			productTitleSearch:$(".productTitleSearch")
		},
		selectedDate,
		moduleEvents = {
		};


	function changeApplicationDate() {

		selectedDate = $('#health_searchDate').val();
		var date = selectedDate.split('/');
		var newDate = date[2]+'-'+date[1]+'-'+date[0];
		postData.applicationDateOverrideValue = (selectedDate !== '' ? newDate + " 00:00:01" : null);

		meerkat.modules.comms.post({
			url:"ajax/write/setApplicationDate.jsp",
			data: postData,
			cache: false,
			errorLevel: "warning",
			onSuccess:function onApplicationUpdateSuccess(data){
				updateDisplay(data);
				toggleDisplay ();
			}
		});
	}

	function setApplicationDateCalendar() {
		meerkat.modules.comms.post({
			url:"ajax/load/getApplicationDate.jsp",
			cache: false,
			errorLevel: "warning",
			onSuccess:function onApplicationUpdateSuccess(dateResult){
				updateCalendar(dateResult);
			}
		});
	}
	function updateCalendar (dateResult) {
		if (dateResult !== null && dateResult !== ''){
			var date = new Date(dateResult.replace(/ [A]?EST/, ''));
			var newDate = meerkat.modules.utils.returnDateValueFormFormat(date);
			$('#health_searchDate').val(newDate);
		}
	}

	function updateDisplay (data) {
		elements.applicationDate.html(data);
	}
	function toggleDisplay () {
		if (elements.applicationDate.html() === ""){
			elements.applicationDateContainer.hide();
		}
		else {
			elements.applicationDateContainer.show();
		}
	}

	function toggleDisplayProductTitle () {
		if ($("#health_productTitleSearch").val() === ""){
			elements.productTitleSearchContainer.hide();
		}
		else {
			elements.productTitleSearch.html($("#health_productTitleSearch").val());
			elements.productTitleSearchContainer.show();
		}
	}
	/**
	 * Initialise
	 */
	function initApplicationDate(){

		jQuery(document).ready(function($) {
			if ($('.simples').length === 0){ // Dont want this set once the simples page loads for the first time
				setApplicationDateCalendar();
			}
			$('#health_searchDate').on('change',function() {
				changeApplicationDate();
			});
			toggleDisplay ();

			$('#health_productTitleSearch').on('change',function() {
				toggleDisplayProductTitle();
			});

		});
	}

	meerkat.modules.register("provider_testing", {
		init: initApplicationDate,
		events: moduleEvents,
		changeApplicationDate: changeApplicationDate,
		setApplicationDateCalendar: setApplicationDateCalendar
	});

})(jQuery);
/**
 * Brief explanation of the module and what it achieves. <example: Example pattern code for a meerkat module.>
 * Link to any applicable confluence docs: <example: http://confluence:8090/display/EBUS/Meerkat+Modules>
 */

;(function($, undefined){

	var meerkat = window.meerkat;

	var events = {
			simplesSnapshot: {
			}
		},
		$simplesSnapshot = $(".simplesSnapshot");
	var	elements = {
				journeyName:			'#health_contactDetails_name',
				journeySituation:		'#health_situation_healthCvr',
				journeyState:			'#health_situation_state',
				applicationState:		'#health_application_address_state',
				journeyPostCode:		'#health_situation_postcode',
				applicationPostCode:	'#health_application_address_postCode',
				applicationFirstName:	'#health_application_primary_firstname',
				applicationSurame:		'#health_application_primary_surname'
		};

	function applyEventListeners() {
		$(document).ready(function() {
			//Initial render for existing quotes
			renderSnapshot();

			$(	elements.journeyName +', '+
				elements.journeySituation +', '+
				elements.journeyState +', '+
				elements.applicationState +', '+
				elements.journeyPostCode +', '+
				elements.applicationPostCode +', '+
				elements.applicationFirstName +', '+
				elements.applicationSurame
				).on('change', function() {
				setTimeout(function() {
					renderSnapshot();
				}, 50);
			});
		});
	}

	function initSimplesSnapshot() {

		console.log("[Simples Snapshot] Initiated.");

		applyEventListeners();
	}

	/**
	 * Which icon to render depending on what the cover type is.
	 */
	function renderSnapshot() {
		if ($(elements.journeySituation +' option:selected').val() !== "" || $(elements.journeyState).val() !== "" || $(elements.journeyPostCode).val() !== "") { // These are compulsory so dont need to check for the others
			$simplesSnapshot.removeClass('hidden');
		}
		// Name
		if ($(elements.applicationFirstName).val() === '' && $(elements.applicationSurame).val() === ''){
			$('.snapshotApplicationFirstName, .snapshotApplicationSurname').hide();
			$('.snapshotJourneyName').show();
		}
		else {
			$('.snapshotApplicationFirstName, .snapshotApplicationSurname').show();
			$('.snapshotJourneyName').hide();
		}
		// State
		if ($(elements.applicationState).val() === ''){
			$('.snapshotApplicationState').hide();
			$('.snapshotJourneyState').show();
		}
		else {
			$('.snapshotApplicationState').show();
			$('.snapshotJourneyState').hide();
		}
		// Postcode
		if ($(elements.applicationPostcode).val() === ''){
			$('.snapshotApplicationPostcode').hide();
			$('.snapshotJourneyPostcode').show();
		}
		else {
			$('.snapshotApplicationPostcode').show();
			$('.snapshotJourneyPostcode').hide();
		}
		meerkat.modules.contentPopulation.render('#navbar-main .transactionIdContainer .simplesSnapshot');
	}

	meerkat.modules.register('simplesSnapshot', {
		initSimplesSnapshot: initSimplesSnapshot,
		events: events
	});

})(jQuery);
/* jshint -W058 *//* Missing closure */
/* jshint -W032 *//* Unnecessary semicolons */
/* jshint -W041 *//* Use '!==' to compare with '' */
/*

	All this code is legacy and needs to be reviewed at some point (turned into modules etc).
	The filename is prefixed with underscores to bring it to the top alphabetically for compilation.

*/

/* Utilities functions for health */

function returnAge(_dobString, round){
	var _now = new Date;
		_now.setHours(0,0,0);
	var _dob = returnDate(_dobString);
	var _years = _now.getFullYear() - _dob.getFullYear();

	if(_years < 1){
		return (_now - _dob) / (1000 * 60 * 60 * 24 * 365);
	};

	//leap year offset
	var _leapYears = _years - ( _now.getFullYear() % 4);
	_leapYears = (_leapYears - ( _leapYears % 4 )) /4;
	var _offset1 = ((_leapYears * 366) + ((_years - _leapYears) * 365)) / _years;
	var _offset2;

	//birthday offset - as it's always so close
	if(  (_dob.getMonth() == _now.getMonth()) && (_dob.getDate() > _now.getDate()) ){
		_offset2 = -0.005;
	} else {
		_offset2 = +0.005;
	};

	var _age = (_now - _dob) / (1000 * 60 * 60 * 24 * _offset1) + _offset2;
	if (round) {
		return Math.floor(_age);
	}
	else {
		return _age;
	}
};

function returnDate(_dateString){
	if(_dateString === '') return null;
	var dateComponents = _dateString.split('/');
	if(dateComponents.length < 3) return null;
	return new Date(dateComponents[2], dateComponents[1] - 1, dateComponents[0]);
};

/**
 * isLessThan31Or31AndBeforeJuly1() test whether the dob provided makes the user less than
 * 31 or is currently 31 but the current datea is before 1st July following their birthday.
 *
 * @param _dobString	String representation of a birthday (eg 24/02/1986)
 * @returns {Boolean}
 */
function isLessThan31Or31AndBeforeJuly1(_dobString) {
	if(_dobString === '') return false;
	var age = Math.floor(returnAge(_dobString));
	if( age < 31 ) {
		return false;
	} else if( age == 31 ){
		var dob = returnDate(_dobString);
		var birthday = returnDate(_dobString);
		birthday.setFullYear(dob.getFullYear() + 31);
		var now = new Date();
		if ( dob.getMonth() + 1 < 7 && (now.getMonth() + 1 >= 7 || now.getFullYear() > birthday.getFullYear()) ) {
			return true;
		} else if (dob.getMonth() + 1 >= 7 && now.getMonth() + 1 >= 7 && now.getFullYear() > birthday.getFullYear()) {
			return true;
		} else {
			return false;
		}
	} else if(age > 31){
		return true;
	} else {
		return false;
	}
}

//reset the radio object from a button container
function resetRadio($_obj, value){

	if($_obj.val() != value){
		$_obj.find('input').prop('checked', false);
		$_obj.find('label').removeClass('active');

		if(value != null){
			$_obj.find('input[value='+ value +']').prop('checked', 'checked');
			$_obj.find('input[value='+ value +']').parent().addClass("active");
		}
	}

};

//return a number with comma for thousands
function formatMoney(value){
	var parts = value.toString().split(".");
	parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	return parts.join(".");
}

/**
 * FATAL ERROR TAG
 */
var FatalErrorDialog = {
	display:function(sentParams){
		FatalErrorDialog.exec(sentParams);
	},
	init:function(){},
	exec:function(sentParams){

		var params = $.extend({
			errorLevel: "silent",
			message: "A fatal error has occurred.",
			page: "undefined.jsp",
			description: null,
			data: null
		}, sentParams);

		meerkat.modules.errorHandling.error(params);

	}
}


// Used in split_test.tag
var Track = {
	splitTest:function splitTesting(result, supertagName){
		meerkat.modules.tracking.recordSupertag('splitTesting',{
			version:result,
			splitTestName: supertagName
		});
	}
}

// from choices.tag
var healthChoices = {
	_cover : '',
	_situation : '',
	_state : '',
	_benefits : new Object,
	_performUpdate:false,

	initialise: function(cover, situation, benefits) {
		healthChoices.setCover(cover, true, true);
		var performUpdate = this._performUpdate;
		healthChoices.setSituation(situation, performUpdate);
	},

	hasSpouse : function() {
		switch(this._cover) {
			case 'C':
			case 'F':
				return true;
			default:
				return false;
		};
	},

	hasChildren : function() {
		switch(this._cover) {
			case 'F':
			case 'SPF':
				return true;
			default:
				return false;
		};
	},

	setCover : function(cover, ignore_rebate_reset, initMode) {
		ignore_rebate_reset = ignore_rebate_reset || false;
		initMode = initMode || false;

		healthChoices._cover = cover;

		if( !ignore_rebate_reset ) {
			healthChoices.resetRebateForm();
		}

		if(!healthChoices.hasSpouse()) {
			healthChoices.flushPartnerDetails();
			$('#partner-health-cover, #partner, .health-person-details-partner, #partnerFund').hide();
		} else {
			$('#partner-health-cover, #partner, .health-person-details-partner, #partnerFund').show();
		};

		//// See if Children should be on or off
		healthChoices.dependants(initMode);

		//// Set the auxillary data
		//Health.setRates();
		healthCoverDetails.displayHealthFunds();
		meerkat.modules.healthTiers.setTiers(initMode);
	},

	setSituation: function(situation, performUpdate) {
		if (performUpdate !== false)
			performUpdate = true;

		//// Change the message
		if (situation != healthChoices._situation) {
			healthChoices._situation = situation;
		};

		$('#health_benefits_healthSitu, #health_situation_healthSitu').val( situation );

	},

	isValidLocation : function( location ) {

		var search_match = new RegExp(/^((\s)*([^~,])+\s+)+\d{4}((\s)+(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)(\s)*)$/);

		value = $.trim(String(location));

		if( value != '' ) {
			if( value.match(search_match) ) {
				return true;
			}
		}

		return false;
	},

	setLocation : function(location) {
		if( healthChoices.isValidLocation(location) ) {
			var value = $.trim(String(location));
			var pieces = value.split(' ');
			var state = pieces.pop();
			var postcode = pieces.pop();
			var suburb = pieces.join(' ');

			$('#health_situation_state').val(state);
			$('#health_situation_postcode').val(postcode).trigger("change");
			$('#health_situation_suburb').val(suburb);

			healthChoices.setState(state);
		} else if (meerkat.site.isFromBrochureSite) {
			//Crappy input which doesn't get validated on brochureware quicklaunch should be cleared as they didn't get the opportunity to see results via typeahead on our side.
			//console.debug('valid loc:',healthChoices.isValidLocation(location),'| from brochure:',meerkat.site.isFromBrochureSite,'| action: clearing');
			$('#health_situation_location').val("");
		}
	},

	setState : function(state) {
		healthChoices._state = state;
	},

	setDob : function(value, $_obj) {
		if(value != ''){
			$_obj.val(value);
		};
	},

	dependants: function(initMode) {

		if( healthChoices.hasChildren() && $('.health_cover_details_rebate :checked').val() == 'Y' ) {
			// Show the dependants questions
			if(initMode === true){
				$('.health_cover_details_dependants').show();
			}else{
				$('.health_cover_details_dependants').slideDown();
			}
		} else {
			// Reset questions and hide
			if(initMode === true){
				$('.health_cover_details_dependants').hide();
			}else{
				$('#health_healthCover_dependants option:selected').prop("selected", false);
				$('#health_healthCover_income option:selected').prop("selected", false);
				$('.health_cover_details_dependants').slideUp();
			}
		}
	},

	//return readable values
	returnCover: function() {
		return $('#health_situation_healthCvr option:selected').text();
	},

	returnCoverCode: function() {
		return this._cover;
	},

	flushPartnerDetails : function() {
		$('#health_healthCover_partner_dob').val('').change();
		$('#partner-health-cover input[name="health_healthCover_partner_cover"]:checked').each(function(){
			$(this).checked = false;
		});
		resetRadio($('#health_healthCover_partnerCover'));
		$('#partner-health-cover input[name="health_healthCover_partner_healthCoverLoading"]:checked').each(function(){
			$(this).checked = false;
		});
		resetRadio($('#health-continuous-cover-partner'));
	},

	resetRebateForm : function() {
		$('#health_healthCover_health_cover_rebate input[name="health_healthCover_rebate"]:checked').each(function(){
			$(this).checked = false;
		});
		resetRadio($('#health_healthCover_health_cover_rebate'));
		$('#health_healthCover_dependants option').first().prop("selected", true);
		$('#health_healthCover_dependants option:selected').prop("selected", false);
		$('#health_healthCover_income option').first().prop("selected", true);
		$('#health_healthCover_income option:selected').prop("selected", false);
		$('#health_healthCover_incomelabel').val('');
		healthCoverDetails.setIncomeBase();
		healthChoices.dependants();
		meerkat.modules.healthTiers.setTiers();
		$('.health_cover_details_dependants').hide();
		$('#health_healthCover_tier').hide();
		$('#health_rebates_group').hide();
	}

}


var healthCoverDetails = {

	//// //RESOLVE: this object was quickly constructed from an anon. function, and can be cleaner

	getRebateChoice: function(){
		return $('#health_healthCover-selection').find('.health_cover_details_rebate :checked').val();
	},

	setIncomeBase: function(initMode){
		if((healthChoices._cover == 'S' || healthChoices._cover == 'SM' || healthChoices._cover == 'SF') && healthCoverDetails.getRebateChoice() == 'Y'){
			if(initMode){
				$('#health_healthCover-selection').find('.health_cover_details_incomeBasedOn').show();
			}else{
				$('#health_healthCover-selection').find('.health_cover_details_incomeBasedOn').slideDown();
			}
		} else {
			if(initMode){
				$('#health_healthCover-selection').find('.health_cover_details_incomeBasedOn').hide();
			}else{
				$('#health_healthCover-selection').find('.health_cover_details_incomeBasedOn').slideUp();
			}
		};
	},

	//// Previous funds, settings
	displayHealthFunds: function(){
		var $_previousFund = $('#mainform').find('.health-previous_fund');
		var $_primaryFund = $('#clientFund').find('select');
		var $_partnerFund = $('#partnerFund').find('select');

		if( $_primaryFund.val() != 'NONE' && $_primaryFund.val() != ''){
			$_previousFund.find('#clientMemberID').slideDown();
			$_previousFund.find('.membership').addClass('onA');
		} else {
			$_previousFund.find('#clientMemberID').slideUp();
			$_previousFund.find('.membership').removeClass('onA');
		}

		if( healthChoices.hasSpouse() && $_partnerFund.val() != 'NONE' && $_partnerFund.val() != ''){
			$_previousFund.find('#partnerMemberID').slideDown();
			$_previousFund.find('.membership').addClass('onB');
		} else {
			$_previousFund.find('#partnerMemberID').slideUp();
			$_previousFund.find('.membership').removeClass('onB');
		}
	},

	setHealthFunds: function(initMode){
		//// Quick variables
		var _primary = $('#health_healthCover_primaryCover').find(':checked').val();
		var _partner = $('#health_healthCover_partnerCover').find(':checked').val();
		var $_primaryFund = $('#clientFund').find('select');
		var $_partnerFund = $('#partnerFund').find('select');

		//// Primary Specific
		if( _primary == 'Y' ) {

			if( isLessThan31Or31AndBeforeJuly1($('#health_healthCover_primary_dob').val()) ) {
				if(initMode){
					$('#health-continuous-cover-primary').show();
				}else{
					$('#health-continuous-cover-primary').slideDown();
				}

			}else{
				if(initMode){
					$('#health-continuous-cover-primary').hide();
				}else{
					$('#health-continuous-cover-primary').slideUp();
				}

			}

		} else {
			if( _primary == 'N'){
				resetRadio($('#health-continuous-cover-primary'),'N');
			};
			if(initMode){
				$('#health-continuous-cover-primary').hide();
			}else{
				$('#health-continuous-cover-primary').slideUp();
			}

		};

		if( _primary == 'Y' && $_primaryFund.val() == 'NONE'){
			$_primaryFund.val('');
		} else if(_primary == 'N'){
			$_primaryFund.val('NONE');
		};

		//// Partner Specific
		if( _partner == 'Y' ) {

			if( isLessThan31Or31AndBeforeJuly1($('#health_healthCover_partner_dob').val()) ) {
				if(initMode){
					$('#health-continuous-cover-partner').show();
				}else{
					$('#health-continuous-cover-partner').slideDown();
				}

			}else{
				if(initMode){
					$('#health-continuous-cover-partner').hide();
				}else{
					$('#health-continuous-cover-partner').slideUp();
				}

			}
		} else {
			if( _partner == 'N'){
				resetRadio($('#health-continuous-cover-partner'),'N');
			};
			if(initMode){
				$('#health-continuous-cover-partner').hide();
			}else{
				$('#health-continuous-cover-partner').slideUp();
			}

		};

			if( _partner == 'Y' && $_partnerFund.val() == 'NONE'){
				$_partnerFund.val('');
			} else if(_partner == 'N'){
				$_partnerFund.val('NONE');
			};

		//// Adjust the questions further along
		healthCoverDetails.displayHealthFunds();
	},

	getAgeAsAtLastJuly1: function( dob )
	{
		var dob_pieces = dob.split("/");
		var year = Number(dob_pieces[2]);
		var month = Number(dob_pieces[1]) - 1;
		var day = Number(dob_pieces[0]);
		var today = new Date();
		var age = today.getFullYear() - year;
		if(6 < month || (6 == month && 1 < day))
		{
			age--;
		}

		return age;
	}
};

// FROM HEALTH_FUNDS.TAG
var healthFunds = {
	_fund: false,
	name: 'the fund',

	countFrom : {
		TODAY: 'today' , NOCOUNT: '' , EFFECTIVE_DATE: 'effectiveDate'
	},
	minType : {
		FROM_TODAY: 'today' , FROM_EFFECTIVE_DATE: 'effectiveDate'
	},

	// If retrieving a quote and a product had been selected, inject the fund's application set.
	// This is in case any custom form fields need access to the data bucket, because write_quote will erase the data when it's not present in the form.
	// A fund must implement the processOnAmendQuote property for this to occur.
	checkIfNeedToInjectOnAmend: function(callback) {
		if ($('#health_application_provider').val().length > 0) {
			var provider = $('#health_application_provider').val(),
				objname = 'healthFunds_' + provider;

			$(document.body).addClass('injectingFund');

			healthFunds.load(
				provider,
				function injectFundLoaded() {
					if (window[objname].processOnAmendQuote && window[objname].processOnAmendQuote === true) {
						window[objname].set();
						window[objname].unset();
					}

					$(document.body).removeClass('injectingFund');

					callback();
				},
				false
			);

		}else{
			callback();
		}
	},

	// Create the 'child' method over-ride
	load: function(fund, callback, performProcess) {

		if (fund == '' || !fund) {
			healthFunds.loadFailed('Empty or false');
			return false;
		};

		if (performProcess !== false) performProcess = true;

		// Load separate health fund JS
		if (typeof window['healthFunds_' + fund] === 'undefined' || window['healthFunds_' + fund] == false) {
			var returnval = true;

			var data = {
				transactionId:meerkat.modules.transactionId.get()
			};

			$.ajax({
				url: 'common/js/health/healthFunds_'+fund+'.jsp',
				dataType: 'script',
				data:data,
				async: true,
				timeout: 30000,
				cache: false,
				beforeSend : function(xhr,setting) {
					var url = setting.url;
					var label = "uncache";
					url = url.replace("?_=","?" + label + "=");
					url = url.replace("&_=","&" + label + "=");
					setting.url = url;
				},
				success: function() {
					// Process
					if (performProcess) {
						healthFunds.process(fund);
					}
					// Callback
					if (typeof callback === 'function') {
						callback(true);
					}
				},
				error: function(obj,txt){
					healthFunds.loadFailed(fund, txt);

					if (typeof callback === 'function') {
						callback(false);
					}
				}
			});

			return false; //waiting
		}

		// If same fund then don't need to re-apply the rules
		if (fund != healthFunds._fund && performProcess) {
			healthFunds.process(fund);
		};

		// Success callback
		if (typeof callback === 'function') {
			callback(true);
		}

		return true;
	},

	process: function(fund) {

		// set the main object's function calls to the specific provider
		var O_method = window['healthFunds_' + fund];

		healthFunds.set = O_method.set;
		healthFunds.unset = O_method.unset;

		// action the provider
		$('body').addClass(fund);

		healthFunds.set();
		healthFunds._fund = fund;

	},

	loadFailed: function(fund, errorTxt) {
		FatalErrorDialog.exec({
			message:		"Unable to load the fund's application questions",
			page:			"health:health_funds.tag",
			description:	"healthFunds.update(). Unable to load fund questions for: " + fund,
			data:			errorTxt
		});
	},

	// Remove the main provider piece
	unload: function(){
		if(healthFunds._fund !== false){
			healthFunds.unset();
			$('body').removeClass( healthFunds._fund );
			healthFunds._fund = false;
			healthFunds.set = function(){};
			healthFunds.unset = function(){};
		}
	},

	// Fund customisation setting, used via the fund 'child' object
	set: function(){
	},

	// Unpicking the fund customisation settings, used via the fund 'child' object
	unset: function(){
	},

	// Additional sub-functions to help render application questions

	applicationFailed: function(){
		return false;
	},

	_memberIdRequired: function(required){
		if(required) {
			$('#clientMemberID').find('input').rules('add', 'required');
			$('#partnerMemberID').find('input').rules('add', 'required');
		} else {
			$('#clientMemberID').find('input').rules('remove', 'required');
			$('#partnerMemberID').find('input').rules('remove', 'required');
		}
	},

	_dependants: function(message){
		if(message !== false){
			// SET and ADD the dependant definition
			healthFunds.$_dependantDefinition = $('#mainform').find('.health-dependants').find('.definition');
			healthFunds.HTML_dependantDefinition = healthFunds.$_dependantDefinition.html();
			healthFunds.$_dependantDefinition.html(message);
		} else {
			healthFunds.$_dependantDefinition.html( healthFunds.HTML_dependantDefinition );
			healthFunds.$_dependantDefinition = undefined;
			healthFunds.HTML_dependantDefinition = undefined;
		};
	},

	_previousfund_authority: function(message) {
		if(message !== false){
			// SET and ADD the authority 'label'
			healthFunds.$_authority = $('.health_previous_fund_authority label span');
			healthFunds.$_authorityText = healthFunds.$_authority.eq(0).text();
			healthFunds.$_authority.text( meerkat.modules.healthResults.getSelectedProduct().info.providerName );
			$('.health_previous_fund_authority').removeClass('hidden');
		}
		else if (typeof healthFunds.$_authority !== 'undefined') {
			healthFunds.$_authority.text( healthFunds.$_authorityText );
			healthFunds.$_authority = undefined;
			healthFunds.$_authorityText = undefined;
			$('.health_previous_fund_authority').addClass('hidden');
		};
	},

	_partner_authority: function(display) {
		if (display === true) {
			$('.health_person-details_authority_group').removeClass('hidden');
		} else {
			$('.health_person-details_authority_group').addClass('hidden');
		}
	},

	_reset: function() {
		healthApplicationDetails.hideHowToSendInfo();
		healthFunds._partner_authority(false);
		healthFunds._memberIdRequired(true);
		healthDependents.resetConfig();
	},

	// Create payment day options on the fly - min and max are in + days from the selected date;
	//NOTE: max - min cannot be a negative number
	_paymentDays: function( effectiveDateString ){
		// main check for real value
		if( effectiveDateString == ''){
			return false;
		};
		var effectiveDate = returnDate(effectiveDateString)
		var today = new Date();

		var _baseDate = null;
		if(healthFunds._payments.countFrom == healthFunds.countFrom.TODAY ) {
			_baseDate = today;
		} else {
			_baseDate = effectiveDate;
		}
		var _count = 0;

		var _days = 0;
		var _limit = healthFunds._payments.max;
		if(healthFunds._payments.minType == healthFunds.minType.FROM_TODAY ) {
			var difference = Math.round((effectiveDate-today)/(1000*60*60*24));
			if(difference < healthFunds._payments.min) {
				_days = healthFunds._payments.min - difference;
			}
		} else {
			_days = healthFunds._payments.min;
			_limit -= healthFunds._payments.min;
		}



		var _html = '<option value="">Please choose...</option>';

		// The loop to create the payment days
		var continueCounting = true;
		while (_count < _limit) {
			var _date = new Date( _baseDate.getTime() + (_days * 24 * 60 * 60 * 1000));
			var _day = _date.getDay();
			// up to certain payment day
			if( typeof(healthFunds._payments.maxDay) != 'undefined' && healthFunds._payments.maxDay < _date.getDate() ){
				_days++;
				// Parse out the weekends
			} else if( !healthFunds._payments.weekends && ( _day == 0 || _day == 6 ) ){
				_days++;
			} else {
				var _dayString = meerkat.modules.numberUtils.leadingZero( _date.getDate() );
				var _monthString = meerkat.modules.numberUtils.leadingZero( _date.getMonth() + 1 );
				_html += '<option value="'+ _date.getFullYear() +'-'+ _monthString +'-'+ _dayString +'">'+ healthFunds._getNiceDate(_date) +'</option>';
				_days++;
				_count++;
			};
		};

		// Return the html
		return _html;
	},

	// Creates the earliest date based on any of the matching days (not including an exclusion date)
	_earliestDays: function(euroDate, a_Match, _exclusion){
			if( !$.isArray(a_Match) || euroDate == '' ){
				return false;
			};
			// creating the base date from the exclusion
			var _now = returnDate(euroDate);
			// 2014-03-05 Leto: Why is this hardcoded when it's also a function argument?
			_exclusion = 7;
			var _date = new Date( _now.getTime() + (_exclusion * 24 * 60 * 60 * 1000));
			var _html = '<option value="">No date has been selected for you</option>';
			// Loop through 31 attempts to match the next date
			for (var i=0; i < 31; i++) {
				/*var*/ _date = new Date( _date.getTime() + (1 * 24 * 60 * 60 * 1000));
				// Loop through the selected days and attempt a match
				for(a=0; a < a_Match.length; a++) {
					if(a_Match[a] == _date.getDate() ){
						var _dayString = meerkat.modules.numberUtils.leadingZero( _date.getDate() );
						var _monthString = meerkat.modules.numberUtils.leadingZero( _date.getMonth() + 1 );
						/*var*/ _html = '<option value="'+ _date.getFullYear() +'-'+ _monthString +'-'+ _dayString +'" selected="selected">'+ healthFunds._getNiceDate(_date) +'</option>';
						i = 99;
						break;
					};
				};
			};
			return _html;
	},

	// Renders the payment days text
	_paymentDaysRender: function($_object,_html){
		if(_html === false){
			healthFunds._payments = { 'min':0, 'max':5, 'weekends':false };
			_html = '<option value="">Please choose...</option>';
		};
		$_object.html(_html);
		$_object.parent().siblings('p').text( 'Your payment will be deducted on: ' + $_object.find('option').first().text() );
		$('.health-bank_details-policyDay, .health-credit-card_details-policyDay').html(_html);
	},


	_getDayOfWeek: function( dateObj ) {
		var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
		return  days[dateObj.getDay()];
	},

	_getMonth: function( dateObj ) {
		var months = ["January","February","March","April","May","June","July","August","September","October","November","December"];
		return  months[dateObj.getMonth()];
	},

	_getNiceDate : function( dateObj ) {
		var day = dateObj.getDate();
		var year = dateObj.getFullYear();
		return healthFunds._getDayOfWeek(dateObj) + ", " + day + " " + healthFunds._getMonth(dateObj) + " " + year;
	}
};

// END FROM HEALTH_FUNDS.TAG


// FROM APPLICATION_DETAILS.TAG
var healthApplicationDetails = {
	preloadedValue: $("#contactPointValue").val(),
	periods: 1,

	init: function(){
		postalMatchHandler.init('health_application');
	},

	showHowToSendInfo: function(providerName, required) {
		var contactPointGroup = $('#health_application_contactPoint-group');
		var contactPoint = contactPointGroup.find('.control-label span');
		var contactPointText = contactPoint.text();
		contactPoint.text( providerName);
		if (required) {
			contactPointGroup.find('input').rules('add', {required:true, messages:{required:'Please choose how you would like ' + providerName + ' to contact you'}});
		}
		else {
			contactPointGroup.find('input').rules('remove', 'required');
		}
		contactPointGroup.removeClass('hidden');
	},
	hideHowToSendInfo: function() {
		var contactPointGroup = $('#health_application_contactPoint-group');
		contactPointGroup.addClass('hidden');
	},
	addOption: function(labelText, formValue) {
		var el = $('#health_application_contactPoint');

		el.append('<label class="btn btn-form-inverse"><input id="health_application_contactPoint_' + formValue + '" type="radio" data-msg-required="Please choose " value="' + formValue + '" name="health_application_contactPoint">' + labelText + '</label>');

		if (el.find('input:checked').length == 0 && this.preloadedValue == formValue) {
			$('#health_application_contactPoint_' + formValue).prop('checked', true);
		}
	},
	removeLastOption: function() {
		var el = $('#health_application_contactPoint');
		el.find('label').last().remove();
	},
	testStatesParity : function() {
		var element = $('#health_application_address_state');
		if( element.val() != $('#health_situation_state').val() ){

			var suburb = $('#health_application_address_suburbName').val();
			var postcode = $('#health_application_address_postCode').val();
			var state = $('#health_application_address_state').val();
			if( suburb.length && suburb.indexOf('Please select') < 0 && postcode.length == 4 && state.length ) {
				$('#health_application_address_postCode').addClass('error');
				return false;
			}
		}
		return true;
	}
};
// END FROM APPLICATION_DETAILS.TAG

// from dependants.tag
var healthDependents = {

	_dependents: 0,
	_limit: 12,
	maxAge: 25,

	init: function()
	{
		healthDependents.resetConfig();
	},

	resetConfig: function(){

		healthDependents.config = {
			'fulltime': false,
			'school':true,
			'schoolMin':22,
			'schoolMax':24,
			'schoolID':false,
			'schoolIDMandatory':false,
			'schoolDate':false,
			'schoolDateMandatory':false,
			'defacto':false,
			'defactoMin':21,
			'defactoMax':24
		};

		healthDependents.maxAge = 25;
	},

	setDependants: function()
	{
		var _dependants = $('#mainform').find('.health_cover_details_dependants').find('select').val();
		if( healthCoverDetails.getRebateChoice() == 'Y' && !isNaN(_dependants)) {
			healthDependents._dependents = _dependants;
		} else {
			healthDependents._dependents = 1;
		}

		if( healthChoices.hasChildren() ) {
			$('#health_application_dependants-selection').show();
		} else {
			$('#health_application_dependants-selection').hide();
			return;
		}

		healthDependents.updateDependentOptionsDOM();

		$('#health_application_dependants-selection').find('.health_dependant_details').each( function(){
			var index = parseInt( $(this).attr('data-id') );
			if( index > healthDependents._dependents )
			{
				$(this).hide();
			}
			else
			{
				$(this).show();
			};

			healthDependents.checkDependent( index );
		});
	},
	addDependent: function()
	{
		if( healthDependents._dependents < healthDependents._limit )
		{
			healthDependents._dependents++;
			var $_obj = $('#health_application_dependants_dependant' + healthDependents._dependents);

			// Reset values
			$_obj.find('input[type=text], select').val('');
			resetRadio($_obj.find('.health_dependant_details_maritalincomestatus'),'');

			// Reset validation
			$_obj.find('.error-field label').remove();
			$_obj.find('.has-error, .has-success').removeClass('has-error').removeClass('has-success');

			$_obj.show();
			healthDependents.updateDependentOptionsDOM();
			healthDependents.hasChanged();

			$('html').animate({
				scrollTop: $_obj.offset().top -50
			}, 250);
		}
	},
	dropDependent: function()
	{
		if( healthDependents._dependents > 0 )
		{
			$('#health_application_dependants_dependant' + healthDependents._dependents).find("input[type=text]").each(function(){
				$(this).val("");
			});
			$('#health_application_dependants_dependant' + healthDependents._dependents).find("input[type=radio]:checked").each(function(){
				this.checked = false;
			});
			$('#health_application_dependants_dependant' + healthDependents._dependents).find("select").each(function(){
				$(this).removeAttr("selected");
			});
			$('#health_application_dependants_dependant' + healthDependents._dependents).hide();
			healthDependents._dependents--;
			healthDependents.updateDependentOptionsDOM();
			healthDependents.hasChanged();

			if(healthDependents._dependents > 0){
				$_obj = $('#health_application_dependants_dependant' + healthDependents._dependents)
			}else{
				$_obj = $('#health_application_dependants-selection');
			}

			$('html').animate({
				scrollTop: $_obj.offset().top -50
			}, 250);
		}
	},
	updateDependentOptionsDOM: function()
	{
		if( healthDependents._dependents <= 0 ) {
			// hide all remove dependant buttons
			$("#health_application_dependants-selection").find(".remove-last-dependent").hide();

			$('#health_application_dependants_threshold').slideDown();
			//$("#health_application_dependants_dependantrequired").val("").addClass("validate");
		} else if( !$("#dependents_list_options").find(".remove-last-dependent").is(":visible") ) {
			$('#health_application_dependants_threshold').slideUp();

			// Show ONLY the last remove dependant button
			$("#health_application_dependants-selection").find(".remove-last-dependent").hide(); // 1st, hide all.
			$("#health_application_dependants-selection .health_dependant_details:visible:last").find(".remove-last-dependent").show();


			//$("#health_application_dependants_dependantrequired").val("ignoreme").removeClass("validate");
		};

		if( healthDependents._dependents >= healthDependents._limit ) {
			$("#health-dependants").find(".add-new-dependent").hide();
		} else if( $("#health-dependants").find(".add-new-dependent").not(":visible") ) {
			$("#health-dependants").find(".add-new-dependent").show();
		};
	},
	checkDependent: function(e)
	{
		var index = e;
		if( isNaN(e) && typeof e == 'object' ) {
			index = e.data;
		};
		// Create an age check mechanism
		var dob = $('#health_application_dependants_dependant' + index + '_dob').val();
		var age;

		if( !dob.length){
			age = 0;
		} else {
			age = healthDependents.getAge(dob);
			if( isNaN(age) ){
				return false;
			}
		}

		// Check the individual questions
		healthDependents.addFulltime(index, age);
		healthDependents.addSchool(index, age);
		healthDependents.addDefacto(index, age);
	},

	getAge: function( dob )
	{
		var dob_pieces = dob.split("/");
		var year = Number(dob_pieces[2]);
		var month = Number(dob_pieces[1]) - 1;
		var day = Number(dob_pieces[0]);
		var today = new Date();
		var age = today.getFullYear() - year;
		if(today.getMonth() < month || (today.getMonth() == month && today.getDate() < day))
		{
			age--;
		}

		return age;
	},

	addFulltime: function(index, age){
		if( healthDependents.config.fulltime !== true ){
			$('#health_application_dependants-selection').find('.health_dependant_details_fulltimeGroup').hide();
			// reset validation of dob to original
			$('#health_application_dependants-selection').find('#health_application_dependants_dependant' + index + '_dob').rules('remove', 'validateFulltime');
			$('#health_application_dependants-selection').find('#health_application_dependants_dependant' + index + '_dob').rules('add', 'limitDependentAgeToUnder25');
			return false;
		}

		if( (age >= healthDependents.config.schoolMin) && (age <= healthDependents.config.schoolMax) ){
			$('#health_application_dependants-selection').find('.dependant'+ index).find('.health_dependant_details_fulltimeGroup').show();
		} else {
			$('#health_application_dependants-selection').find('.dependant'+ index).find('.health_dependant_details_fulltimeGroup').hide();
		}

		// change validation method for dob field if fulltime is enabled
		$('#health_application_dependants-selection').find('#health_application_dependants_dependant' + index + '_dob').rules('remove', 'limitDependentAgeToUnder25');
		$('#health_application_dependants-selection').find('#health_application_dependants_dependant' + index + '_dob').rules('add', 'validateFulltime');
		
	},

	addSchool: function(index, age){
		if( healthDependents.config.school === false ){
			$('#health_application_dependants-selection').find('.health_dependant_details_schoolGroup, .health_dependant_details_schoolIDGroup, .health_dependant_details_schoolDateGroup').hide();
			return false;
		};
		if( (age >= healthDependents.config.schoolMin) && (age <= healthDependents.config.schoolMax) 
			&& (healthDependents.config.fulltime !== true || $('#health_application_dependants_dependant' + index + '_fulltime_Y').is(':checked')) )
		{
			$('#health_application_dependants-selection').find('.dependant'+ index).find('.health_dependant_details_schoolGroup, .health_dependant_details_schoolIDGroup, .health_dependant_details_schoolDateGroup').show();
			// Show/hide ID number field, with optional validation
			if( healthDependents.config.schoolID === false ) {
				$('#health_application_dependants-selection').find('.dependant'+ index).find('.health_dependant_details_schoolIDGroup').hide();
			}
			else {
				if (this.config.schoolIDMandatory === true) {
					$('#health_application_dependants-selection').find('#health_application_dependants_dependant' + index + '_schoolID').rules('add', {required:true, messages:{required:'Please enter dependant '+index+'\'s student ID'}});
				}
				else {
					$('#health_application_dependants-selection').find('#health_application_dependants_dependant' + index + '_schoolID').rules('remove', 'required');
				}
			};
			// Show/hide date study commenced field, with optional validation
			if (this.config.schoolDate !== true) {
				$('#health_application_dependants-selection').find('.dependant'+ index).find('.health_dependant_details_schoolDateGroup').hide();
			}
			else {
				if (this.config.schoolDateMandatory === true) {
					$('#health_application_dependants-selection').find('#health_application_dependants_dependant' + index + '_schoolDate').rules('add', {required:true, messages:{required:'Please enter date that dependant '+index+' commenced study'}});
				}
				else {
					$('#health_application_dependants-selection').find('#health_application_dependants_dependant' + index + '_schoolDate').rules('remove', 'required');
				}
			};
		} else {
			$('#health_application_dependants-selection').find('.dependant'+ index).find('.health_dependant_details_schoolGroup, .health_dependant_details_schoolIDGroup, .health_dependant_details_schoolDateGroup').hide();
		};
	},

	addDefacto: function(index, age){
		if( healthDependents.config.defacto === false ){
			return false;
		};
		if( (age >= healthDependents.config.defactoMin) && (age <= healthDependents.config.defactoMax) ){
			$('#health_application_dependants-selection').find('.dependant'+ index).find('.health_dependant_details_maritalincomestatus').show();
		} else {
			$('#health_application_dependants-selection').find('.dependant'+ index).find('.health_dependant_details_maritalincomestatus').hide();
		};
	},

	hasChanged: function( ){
		var $_obj = $('#health_application_dependants-selection').find('.health-dependants-tier');
		if(healthCoverDetails.getRebateChoice() == 'N' ) {
			$_obj.slideUp();
		} else if( healthDependents._dependents > 0 ){
			// Call the summary panel error message
			//healthPolicyDetails.error();

			// Refresh/Call the Dependants and rebate tiers
			$('#health_healthCover_dependants').val( healthDependents._dependents ).trigger('change');

			// Change the income questions
			var $_original = $('#health_healthCover_tier');
			$_obj.find('select').html( $_original.find('select').html() );
			$_obj.find('#health_application_dependants_incomeMessage').text( $_original.find('span').text() );
			if( $_obj.is(':hidden') ){
				$_obj.slideDown();
			};
		} else {
			$_obj.slideUp();
		};
	}
};

//Validation for defacto messages
$.validator.addMethod("defactoConfirmation",
	function(value, element) {

		if( $(element).parent().find(':checked').val() == 'Y' ){
			return true; //Passes
		} else {
			return false; //Fails
		};

	}
);


//Validation for defacto messages
$.validator.addMethod("validateMinDependants",
	function(value, element) {
		return !$("#${name}_threshold").is(":visible");
	}
);


//DOB validation message
$.validator.addMethod("limitDependentAgeToUnder25",
	function(value, element) {
		var getAge = returnAge(value);
		if( getAge >= healthDependents.maxAge ) {
			// Change the element message on the fly
			$(element).rules("add", { messages: { 'limitDependentAgeToUnder25':'Your child cannot be added to the policy as they are aged ' + healthDependents.maxAge + ' years or older. You can still arrange cover for this dependant by applying for a separate singles policy or please contact us if you require assistance.' } } );
			return false;
		};
		return true;
	}
);

//If fulltime student toggle is enabled, use this validator instead of the above one
$.validator.addMethod("validateFulltime",
	function(value, element) {
		var fullTime = $(element).parents('.health_dependant_details').find('.health_dependant_details_fulltimeGroup input[type=radio]:checked').val();
		var getAge = returnAge(value);
		var suffix = healthDependents.config.schoolMin == 21 ? 'st' : healthDependents.config.schoolMin == 22 ? 'nd' : healthDependents.config.schoolMin == 23 ? 'rd' : 'th';
		if (getAge >= healthDependents.maxAge){
			$(element).rules("add", { messages: { 'validateFulltime':'Dependants over ' + healthDependents.maxAge +' are considered adult dependants and can still be covered by applying for a separate singles policy' } } );
			return false;
		} else if( fullTime === 'N' && getAge >= healthDependents.config.schoolMin ) {
			$(element).rules("add", { messages: { 'validateFulltime':'This policy provides cover for children until their ' + healthDependents.config.schoolMin + suffix + ' birthday' } } );
			return false;
		}
		return true;
	}
);

// end from dependants.tag

// from credit_card_details.tag
creditCardDetails = {

	resetConfig: function(){
		creditCardDetails.config = { 'visa':true, 'mc':true, 'amex':true, 'diners':false };
	},

	render: function(){
		var $_obj = $('#health_payment_credit_type');
		var $_icons = $('#health_payment_credit-selection .cards');
		$_icons.children().hide();

		var _html = '<option id="health_payment_credit_type_" value="">Please choose...</option>';
		var _selected = $_obj.find(':selected').val();


		if( creditCardDetails.config.visa === true ){
			_html += '<option id="health_payment_credit_type_v" value="v">Visa</option>';
			$_icons.find('.visa').show();
		};

		if( creditCardDetails.config.mc === true ){
			_html += '<option id="health_payment_credit_type_m" value="m">Mastercard</option>';
			$_icons.find('.mastercard').show();
		};

		if( creditCardDetails.config.amex === true ){
			_html += '<option id="health_payment_credit_type_a" value="a">AMEX</option>';
			$_icons.find('.amex').show();
		};

		if( creditCardDetails.config.diners === true ){
			_html += '<option id="health_payment_credit_type_d" value="d">Diners Club</option>';
			$_icons.find('.diners').show();
		};

		$_obj.html( _html ).find('option[value='+ _selected +']').attr('selected', 'selected');
		return;
	},

	set: function(){
		creditCardDetails.$_obj = $('#health_payment_credit_number');
		creditCardDetails.$_objCCV = $('#health_payment_credit_ccv');
		var _type = creditCardDetails._getType();

		field_credit_card_validation.set(_type, creditCardDetails.$_obj, creditCardDetails.$_objCCV);
	},

	_getType: function(){
		return $('#health_payment_credit_type').find(':selected').val();
	}
};
// end from credit_card_details.tag