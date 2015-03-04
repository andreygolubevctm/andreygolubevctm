;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
		autocomplete: {
			CANT_FIND_ADDRESS: 'EVENT_CANT_FIND_ADDRESS',
			ELASTIC_SEARCH_COMPLETE: 'ELASTIC_SEARCH_COMPLETE'
		}
	};

	var moduleEvents = events.autocomplete;

	var elasticSearch = false;

	function initAutoComplete() {
		meerkat.messaging.subscribe(meerkatEvents.splitTest.SPLIT_TEST_READY, function navbarFixed() {
			elasticSearch = meerkat.modules.splitTest.isActive(1001) ? true : false;
			setTypeahead(elasticSearch);
		});
	}

	function setTypeahead(elasticSearch) {
		var $typeAheads = $('input.typeahead');
		var params = null;
		$typeAheads.each(function eachTypeaheadElement() {
			var $component = $(this);
			if (elasticSearch) {
				var url = 'address/search.json';
				params = {
					name: $component.attr('name'),
					remote: {
						rateLimitWait: 100,
						beforeSend: function(jqXhr, settings) {
						autocompleteBeforeSend($component);
						jqXhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
						settings.type = "POST";
						settings.hasContent = true;
						settings.url = url;

						var $addressField = $('#quote_riskAddress_streetSearch');
						var query = $addressField.val();
						settings.data = $.param({ query: decodeURI(query) });
					},
					filter: function(parsedResponse) {
						autocompleteComplete($component);
						return parsedResponse;
					},
					url: url
					},
					limit: 150
				};
			} else {
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
			typeaheadParams.remote.url = $element.attr('id');
			typeaheadParams.remote.replace = addressSearch;

			// Two properties need to be received in the json: 'value' and 'highlight'
			typeaheadParams.valueKey = 'value';
			typeaheadParams.template = _.template('<p>{{= highlight }}</p>');

			if ($element.hasClass('typeahead-streetSearch')) {
				// If no results, inject a message.
				// Improve this later after typeahead 0.10 is released https://github.com/twitter/typeahead.js/issues/253
				typeaheadParams.remote.filter = function(parsedResponse) {
					autocompleteComplete($element);

					if (parsedResponse.length === 0) {
						parsedResponse.push({
							value: 'Type your address...',
							highlight: 'Can\'t find your address? <u>Click here.</u>'
						});
					} else if (elasticSearch) {
						$.each(parsedResponse, function(index, addressObj) {
							if(addressObj.hasOwnProperty('text') && addressObj.hasOwnProperty('payload')) {
								addressObj.value = addressObj.text;
								addressObj.highlight = addressObj.text;
								addressObj.dpId = addressObj.payload;
							}
						});
					}
					return parsedResponse;
				}

				$element.bind('typeahead:selected', function catchEmptyValue(event, datum, name) {
					if (datum.hasOwnProperty('value') && datum.value === 'Type your address...') {
						var id = '';
						if (event.target && event.target.id) {
							id = event.target.id.replace('_streetSearch', '');
						}

						meerkat.messaging.publish(moduleEvents.CANT_FIND_ADDRESS, { fieldgroup: id });
					} else if (elasticSearch) {
						meerkat.messaging.publish(moduleEvents.ELASTIC_SEARCH_COMPLETE, datum.dpId );
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
		events: events
	});

})(jQuery);