/*

	This module supports the Filters dropdown.
	It handles reading and saving of the values of filters contained within the dropdown.

	The dropdown can be manually triggered via:
		- meerkat.modules.homeloanFilters.open()
		- meerkat.modules.homeloanFilters.close()

	See also homeloan:filters tag.

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
		$modal,  //Stores the jQuery object for the modal activator
		$component, //Stores the jQuery object for the component group
		filterValues = {},
		joinDelimiter = ',',
		modalId = false,
		filterHtml,
		$filtersContainer,
		isIE8 = false;

	var events = {
			homeloanFilters: {
				CHANGED: 'HOMELOAN_FILTERS_CHANGED'
			}
		},
		moduleEvents = events.homeloanFilters;



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

			// RADIOS
			if ('radio' === filterType) {
				value = $this.find(':checked').val() || '';

				if (readOnlyFromFilters !== true) {
					if(id == 'filter-interest-rate-type') {
						$('#homeloan_filter_loanDetails_interestRate_P').prop('checked', $('#homeloan_loanDetails_interestRate_P').is(':checked'));
						$('#homeloan_filter_loanDetails_interestRate_I').prop('checked', $('#homeloan_loanDetails_interestRate_I').is(':checked'));
						$('input[name=homeloan_filter_loanDetails_interestRate]:checked').change();
						value = $('input[name=homeloan_filter_loanDetails_interestRate]:checked').val();
					}
					else if (id == 'filter-repaymentFrequency') {
						$('#homeloan_filter_results_repaymentFrequency_weekly').prop('checked', $('#homeloan_results_frequency_weekly').val() === 'Y');
						$('#homeloan_filter_results_repaymentFrequency_fortnightly').prop('checked', $('#homeloan_results_frequency_fortnightly').val() === 'Y');
						$('#homeloan_filter_results_repaymentFrequency_monthly').prop('checked', $('#homeloan_results_frequency_monthly').val() === 'Y');
						$('input[name=homeloan_filter_results_repaymentFrequency]:checked').change();
						value = $('input[name=homeloan_filter_results_repaymentFrequency]:checked').val();
					}
				}
			}

			// SELECTS
			if ('select' === filterType) {
				value = $this.find(':selected').val() || '';

				if (readOnlyFromFilters !== true) {
					if(id == 'filter-loan-term') {
						value = $('#homeloan_results_loanTerm').val();
					}
				}
			}

			// CHECKBOXES
			if ('checkbox' === filterType) {

				// A string of all checkbox values
				if (readOnlyFromFilters !== true) {
					if(id == 'filter-loan-type') {
						$('#homeloan_filter_loanDetails_productFixed').prop('checked', $('#homeloan_loanDetails_productFixed').prop('checked')).change();
						$('#homeloan_filter_loanDetails_productVariable').prop('checked', $('#homeloan_loanDetails_productVariable').prop('checked')).change();
						$('#homeloan_filter_loanDetails_productLineOfCredit').prop('checked', $('#homeloan_loanDetails_productLineOfCredit').val() === 'Y').change();
						$('#homeloan_filter_loanDetails_productLowIntroductoryRate').prop('checked', $('#homeloan_loanDetails_productLowIntroductoryRate').val() === 'Y').change();
					} else if(id == 'filter-fees') {
						$('#homeloan_filter_fees_noApplication').prop('checked', $('#homeloan_fees_noApplication').val() === 'Y').change();
						$('#homeloan_filter_fees_noOngoing').prop('checked', $('#homeloan_fees_noOngoing').val() === 'Y').change();
					} else if(id == 'filter-features') {
						$('#homeloan_filter_features_redraw').prop('checked', $('#homeloan_features_redraw').val() === 'Y').change();
						$('#homeloan_filter_features_offset').prop('checked', $('#homeloan_features_offset').val() === 'Y').change();
						$('#homeloan_filter_features_bpay').prop('checked', $('#homeloan_features_bpay').val() === 'Y').change();
						$('#homeloan_filter_features_onlineBanking').prop('checked', $('#homeloan_features_onlineBanking').val() === 'Y').change();
						$('#homeloan_filter_features_extraRepayments').prop('checked', $('#homeloan_features_extraRepayments').val() === 'Y').change();
					}
				}

				var values = [];
				values = $this.find('[type=checkbox]:checked').map(function() {
					return this.value;
				});

				value = values.get().join(joinDelimiter);
			}

			// TEXT
			if ('text' === filterType) {
				if (readOnlyFromFilters !== true) {
					if(id == 'filter-loan-amount') {
						value = $('#homeloan_loanDetails_loanAmountentry').val();
						$this.find('input[type=text]').val(value);
					}
				} else {
					value = $this.find('input[type=text]').val();
				}

			}

			// Store filter's value
			if (!filterValues.hasOwnProperty(id)) filterValues[id] = {};
			filterValues[id].type = filterType;
			filterValues[id][propName] = value;
		});

		log('readFilterValues', (readOnlyFromFilters === true ? 'readOnlyFromFilters' : '!readOnlyFromFilters'), _.extend({}, filterValues));
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

					case 'text':
						$component.find('#' + filterId + ' input').val(value);
						break;

					case 'checkbox':
						$component.find('#' + filterId + ' input[type=checkbox]').prop('checked', false);
						if(value.length) {
							var values = value.split(',');
							for(var i = 0; i < values.length; i++) {

								switch(filterId) {
								case 'filter-loan-type':
									$('#homeloan_filter_loanDetails_product'+values[i]).prop('checked', true);
									break;
								case 'filter-features':
									$('#homeloan_filter_features_'+values[i]).prop('checked', true);
								break;
								case 'filter-fees':
									$('#homeloan_filter_fees_'+values[i]).prop('checked', true);
									break;
								}

							}
						}
						break;
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
						var selected, j;
						switch(filterId) {
							case 'filter-loan-amount':
								// blur to set the amount in the hidden input and show the $.00
								var $field = $('#homeloan_loanDetails_loanAmountentry');
									$field.val(valueNew);
								// test this once the new currency thing is in NXI
								$('#homeloan_loanDetails_loanAmount').val($field.asNumber());
							break;
							case 'filter-loan-term':
								$('#homeloan_results_loanTerm').val(valueNew);
								break;
							case 'filter-interest-rate-type':
								$('input[name=homeloan_loanDetails_interestRate]').prop('checked', false).change();
								$('#homeloan_loanDetails_interestRate_'+valueNew).prop('checked', true).change();
								break;
							case 'filter-repaymentFrequency':
								$('input[id^=homeloan_results_frequency_]').val('');
								$('#homeloan_results_frequency_'+valueNew).val('Y');
								if(valueNew !== "") {
									Results.setFrequency(valueNew, false);
								}
								break;
							case 'filter-fees':
							case 'filter-features':
								var prefix = filterId == 'filter-fees' ? 'fees' : 'features';
								clearCheckboxes($('input[id^=homeloan_'+prefix+']'));
								selected = valueNew.split(joinDelimiter);
								if(selected.length) {
									for(j = 0; j < selected.length; j++) {
										$('#homeloan_'+prefix+'_'+selected[j]).val('Y');
									}
								}
								break;
							case 'filter-loan-type':
								clearCheckboxes($('input[id^=homeloan_loanDetails_product]'));
								selected = valueNew.split(joinDelimiter);
								if(selected.length) {
									for(j = 0; j < selected.length; j++) {
										var $el = $('#homeloan_loanDetails_product'+selected[j]);
										if($el.attr('type') == 'checkbox') {
											$el.prop('checked', true);
										} else {
											$el.val('Y');
										}
									}
								}
							break;
						}

					}
				}
			}

			close();

			meerkat.messaging.publish(moduleEvents.CHANGED);

			if (needToFetchFromServer) {
				_.defer(function(){
					meerkat.modules.journeyEngine.loadingShow('...updating your quotes...', true);

					// Had to use a 100ms delay instead of a defer in order to get the loader to appear on low performance devices.
					_.delay(function() {
						meerkat.modules.homeloanResults.get();
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
		$component = $('.filters-component');
		$component.on('click.filters', '.btn-save', saveSelection)
		.on('click.filters', '.btn-cancel', close);
		$('#homeloan_filter_loanDetails_loanAmount').each(meerkat.modules.currencyField.initSingleCurrencyField);

		// Requirement for IE8 checkboxes
		if (isIE8) {
			$component.on('change.checkedForIE', '.checkbox input, .compareCheckbox input', function applyCheckboxClicks() {
				var $this = $(this);
				if($this.is(':checked')) {
					$this.addClass('checked');
				}
				else {
					$this.removeClass('checked');
				}
			});
			$component.find('.checkbox input').change();

			meerkat.modules.ie8SelectMenuAutoExpand.bindEvents($component, '#homeloan_filter_results_loanTerm');

		}
	}

	// Close the drop down with code (public method).
	function close() {
		if ($dropdown.hasClass('open')) {
			$dropdown.find('.activator').dropdown('toggle');
		}
		if(modalId !== false) {
			meerkat.modules.navMenu.close();
			meerkat.modules.dialogs.close(modalId);
		}
	}

	function clearCheckboxes($el) {
		$el.each(function() {
			var $self = $(this);
			if($self.attr('type') == 'checkbox') {
				$self.prop('checked', false);
			} else {
				$self.val('');
			}
		});
	}

	// Remove event listeners and reset values when dropdown is closed.
	function afterClose() {
		if ($component.hasClass('is-saved')) {
			$component.removeClass('is-saved');
		}
		else {
			revertSelections();
		}

		// Disable modal
		modalId = false;
		meerkat.modules.navMenu.close();

		$component.off('click.filters', '.btn-save');
		$component.off('click.filters', '.btn-cancel');
		$component.find(':checkbox').removeClass('has-error');
		$component.find('.alert').remove();
	}


	function initFilters() {

		$(document).ready(function() {

			if (meerkat.site.vertical !== "homeloan" || meerkat.site.pageAction === "confirmation") {
				return false;
			}

			isIE8 = meerkat.modules.performanceProfiling.isIE8();

			eventSubscriptions();
			applyEventListeners();

		});
	}

	function eventSubscriptions() {
		// Store the jQuery objects
		$dropdown = $('#filters-dropdown');
		$modal = $('#filters-modal');
		$filtersContainer = $('#filters-container');

		var $e = $('#filters-template');
		if ($e.length > 0) {
			templateCallback = _.template($e.html());
			filterHtml = templateCallback();
		}

		if(meerkat.modules.deviceMediaState.get() !== 'xs') {
			$filtersContainer.empty().html(filterHtml);
		}

		$dropdown.on('show.bs.dropdown', function () {
			afterOpen();
			updateFilters();
		}).on('hidden.bs.dropdown', function () {
			afterClose();
		});

		$modal.on('click', function(e) {
			e.preventDefault();
			var options = {
					htmlContent: filterHtml,
					hashId: 'filters',
					closeOnHashChange: true,
					leftBtn: {
						label: 'Back',
						icon: '',
						className: 'btn-sm btn-close-dialog',
						callback: afterClose // fix this
					},
					rightBtn: {
						label: 'Save Changes',
						icon: '',
						className: 'btn-sm',
						callback: saveSelection
					},
					onOpen: function() {
						afterOpen();
						$component.find('.btn-cancel, .btn-save').addClass('hidden');
						updateFilters();
					}
				};
			modalId = meerkat.modules.dialogs.show(options);
		});
	}

	function applyEventListeners() {
		// On application lockdown/unlock, disable/enable the dropdown
		meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, function lockFilters(obj) {
			close();
			$dropdown.children('.activator').addClass('inactive').addClass('disabled');
		});

		meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, function unlockFilters(obj) {
			$dropdown.children('.activator').removeClass('inactive').removeClass('disabled');
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function filtersEnterXsState() {
			if ($dropdown.hasClass('open')) {
				meerkat.modules.homeloanFilters.close();
				meerkat.modules.navMenu.close();
			}
			// Clear the dropdown version of the filters (so there aren't duplicate DOM IDs etc)
			$filtersContainer.empty();
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function filtersLeaveXsState() {
			if (modalId !== false) {
				meerkat.modules.homeloanFilters.close();
			}
			//Re-populate the dropdown version of the filters
			$filtersContainer.empty().html(filterHtml);
		});
	}

	meerkat.modules.register('homeloanFilters', {
		initFilters: initFilters,
		events: events,
		open: open,
		close: close
	});

})(jQuery);
