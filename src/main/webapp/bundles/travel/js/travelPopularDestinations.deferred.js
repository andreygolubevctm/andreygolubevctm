;(function ($, undefined) {

	var meerkat = window.meerkat,
	meerkatEvents = meerkat.modules.events;

	var events = {
		travelPopularDestinations: {}
	};

	var $elements = {
			destinationsfs : null,
			travelDestinations : null,
			destinationsPopover : null,
			destinationsList : null,
			fromTravelDates : null
	};

	function initTravelPopularDestinations() {
		eventSubscriptions();

		$elements.destinationsfs = $('#destinationsfs');
		$elements.travelDestinations = $('#travel_destinations');
		$elements.destinationsPopover = $('#destinations-popover');
		$elements.destinationsList = $('#destinations-list');
		$elements.fromTravelDates = $('#travel_dates_fromDateInputD, #travel_dates_fromDateInputM, #travel_dates_fromDateInputY');

		$elements.travelDestinations.qtip({
			content: {
				text: $elements.destinationsPopover,
				button: 'Close'
			},
			show: 'click',
			hide: 'unfocus',
			position: {
				my: 'top left',
				at: 'bottom left'
			},
			style: {
				classes: 'qtip-bootstrap travelDestinationPopover',
				tip: {
					width: 14,
					height: 12,
					mimic: 'center'
				}
			},
			events: {
				render: function (event, api) {
					$elements.destinationsPopover.removeClass('hide');
					applyTravelDestinationClickListener();
					applyTravelDestinationDisplayListeners(api);
				}
			}
		});

		eventListeners();
	}

	function eventSubscriptions() {
		meerkat.messaging.subscribe(meerkatEvents.selectTags.SELECTED_TAG_REMOVED, function onSelectedTagRemove(isoCode) {
			toggleSelectedIcon(isoCode, false);
		});

		meerkat.messaging.subscribe(meerkatEvents.selectTags.SELECTED_TAG_ADDED, function onSelectedTagAdd(isoCode) {
			toggleSelectedIcon(isoCode, true);
		});
	}

	function eventListeners() {
		$elements.destinationsfs.find('ul.selected-tags').on('DOMSubtreeModified', function () {
			if (typeof $elements.travelDestinations.qtip === 'function' && typeof $elements.travelDestinations.qtip().reposition === 'function') {
				$elements.travelDestinations.qtip().reposition();
			}
		});
	}

	function toggleSelectedIcon(isoCode, state) {
		$('#destinations-list').find('a.destination-item').filter(function filterByIsoCode() {
			return $(this).data('country').isoCode === isoCode;
		}).toggleClass('active', state);
	}



	function applyTravelDestinationDisplayListeners(api) {
		$elements.travelDestinations.on('keyup', function (e) {
			hidePopover(e, api);
		});

		$elements.fromTravelDates.on('focus', function (e) {
			hidePopover(e, api);
		});
	}

	function hidePopover(e, api) {
		e.preventDefault();
		if (api.elements.tooltip.is(':visible')) {
			api.toggle(false);
		}
	}

	function applyTravelDestinationClickListener() {
		$elements.destinationsList.find('a.destination-item').on('click', function onTravelDestinationClick() {
			var $this = $(this),
			country = $this.data('country');

			if ($this.hasClass('active')) {
				// Remove country from selected-tags list
				$elements.destinationsfs.find('.selected-tag').filter(function filterByIsoCode() {
					return country.isoCode === $(this).data('value');
				}).find('button').trigger('click');
			} else {
				$elements.travelDestinations.trigger('typeahead:selected', country);
			}
			$this.toggleClass('active');
		});
	}

	meerkat.modules.register("travelPopularDestinations", {
		init: initTravelPopularDestinations,
		events: events
	});

})(jQuery);
