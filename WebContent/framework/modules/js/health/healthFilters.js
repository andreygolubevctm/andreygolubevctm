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

						switch(value) {
							case 'fortnightly':
								value = 'F';
								break;
							case 'monthly':
								value = 'M';
								break;
							//case 'annually':
							default:
								value = 'A';
								break;
						}
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
						$this.val(value);
					}

					else if ('filter-tierExtras' === id) {
						value = $('#health_filter_tierExtras').val();
						$this.val(value);
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
		
		// Close the dropdown before the activator gets disabled by Results events
		$component.addClass('is-saved');

		close();

		// Close the menu on mobile too.
		if (meerkat.modules.deviceMediaState.get() === 'xs') {
			meerkat.modules.navbar.close();
		} else {
			$dropdown.closest('.navbar-collapse').removeClass('in');
		}

		// now defer to try and improve responsiveness on low performance devices.

		_.defer(function(){

			var valueOld,
			valueNew,
			filterId,
			needToFetchFromServer = false;


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
			
				
				meerkat.messaging.publish(moduleEvents.CHANGED);

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


	function initModule() {

		$(document).ready(function() {

			if (meerkat.site.vertical !== "health" || VerticalSettings.pageAction === "confirmation") return false;

			// Store the jQuery objects
			$dropdown = $('#filters-dropdown');
			$component = $('.filters-component');

			$dropdown.on('show.bs.dropdown', function () {
				afterOpen();
				updateFilters();
			});

			$dropdown.on('hidden.bs.dropdown', function () {
				afterClose();
			});

			setBrandFilterActions();

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
