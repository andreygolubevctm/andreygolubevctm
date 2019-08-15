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
        },
        moduleEvents = events.autocomplete;

	var baseURL = '';

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

	function setBaseURL(url){
        baseURL = url || '';
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
				url = '/ctm/spring/rest/address/street/get.json';
				params = {
					name: $component.attr('name'),
					remote: {
						beforeSend: function(jqXhr, settings) {
							autocompleteBeforeSend($component);
							settings.type = "GET";
							var $addressField = $('#' + addressFieldId + '_autofilllessSearch');
							var query = $addressField.val();

							settings.url = url + "?addressLine=" + decodeURI(query);
							settings.dataType = "json";
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
			} else if($component.attr('data-varname') == 'occupationSelectionList') {
				params = meerkat.modules.occupationSelector.getOccupationSelectorParams($component);
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
							if(addressObj.hasOwnProperty('text')) {
								addressObj.value = addressObj.text;
								addressObj.highlight = addressObj.text;
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
				};

				$element.bind('typeahead:selected', function catchEmptyValue(event, datum, name) {
					if (datum.hasOwnProperty('value') && datum.value === 'Type your address...') {
						var id = '';
						if (event.target && event.target.id) {
							var replacement = elasticSearch ? '_autofilllessSearch' : '_streetSearch';
							id = event.target.id.replace(replacement, '');
						}
						meerkat.messaging.publish(moduleEvents.CANT_FIND_ADDRESS, { fieldgroup: id });

					} else if (elasticSearch) {
						meerkat.messaging.publish(moduleEvents.ELASTIC_SEARCH_COMPLETE, {
							data: datum,
							dpid:	datum.dpId,
							addressFieldId:	addressFieldId
						});
						// Validate the element now the user has made a selection.
						// Deferred as this is now called before the elastic address binding to typeahead:selected
						_.defer(function() {
							$element.valid();
						});
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
		autocompleteComplete: autocompleteComplete,
        setTypeahead: setTypeahead,
        setBaseURL: setBaseURL
	});

})(jQuery);