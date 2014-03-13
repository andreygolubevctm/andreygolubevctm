/*

	CLASS-BASED FEATURES:
		blur-on-select

		show-loading

*/
;(function($, undefined){

	var meerkat = window.meerkat;

	var moduleEvents = {
			CANT_FIND_ADDRESS: 'EVENT_CANT_FIND_ADDRESS'
		};



	function initialiseAutoCompleteFields() {
		// Start typeahead
		var $typeAheads = $('input.typeahead');
		$typeAheads.each(function eachTypeaheadElement() {
			var $component = $(this);

			var params = {
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
					if (datum.hasOwnProperty('value') && datum.value === 'Type your address...') return;

					if (event && event.target && event.target.blur) {
						//console.log('blurOnSelect', datum);
						event.target.blur();
					}
				});
			}
		});
		// End typeahead
	}



	function autocompleteBeforeSend($component) {
		//console.log('autocompleteBeforeSend');

		if ($component.hasClass('show-loading')) {
			meerkat.modules.loadingAnimation.showInside($component.parent('.twitter-typeahead'));
		}
	}

	function autocompleteComplete($component) {
		//console.log('autocompleteComplete');

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
			typeaheadParams.remote.url = $element.attr('id');
			typeaheadParams.remote.replace = addressSearch;

			// Two properties need to be received in the json: 'value' and 'highlight'
			typeaheadParams.valueKey = 'value';
			typeaheadParams.template = _.template('<p><%= highlight %></p>');

			if ($element.hasClass('typeahead-streetSearch')) {
				// If no results, inject a message.
				// Improve this later after typeahead 0.10 is released https://github.com/twitter/typeahead.js/issues/253
				typeaheadParams.remote.filter = function(parsedResponse) {
					autocompleteComplete($element);

					if (parsedResponse.length === 0) {
						parsedResponse.push({
							value: 'Type your address...', // #CANTFIND#
							highlight: 'Can\'t find your address? <u>Click here.</u>'
						});
					}
					return parsedResponse;
				}

				$element.bind('typeahead:selected', function catchEmptyValue(event, datum, name) {
					//console.log('catchEmptyValue', datum, datum.value.length);
					//console.log(event);

					// #CANTFIND#
					if (datum.hasOwnProperty('value') && datum.value === 'Type your address...') {
						//console.log('Publish', EVENT_CANT_FIND_ADDRESS);

						var id = '';
						if (event.target && event.target.id) {
							id = event.target.id.replace('_streetSearch', '');
						}

						meerkat.messaging.publish(moduleEvents.CANT_FIND_ADDRESS, { fieldgroup: id });
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
		init: initialiseAutoCompleteFields,
		events: moduleEvents
	});

})(jQuery);