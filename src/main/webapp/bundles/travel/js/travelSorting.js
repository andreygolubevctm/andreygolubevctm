/*
 This module supports the Sorting for travel results page.
 */

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		error = meerkat.logging.error,
		$sortElements,
		defaultSortStates = {
			'benefits.excess' : 'asc',
			'benefits.medical' : 'desc',
			'benefits.cxdfee' : 'desc',
			'benefits.luggage' : 'desc',
			'benefits.rentalVehicle' : 'desc',
			'price.premium' : 'asc'
		},
		initialised = false;


	//Sorting is a kind of filtering for now in the events
	var events = {
			travelSortings: {
				//CHANGED: 'TRAVEL_SORTING_CHANGED'
			}
		},
		moduleEvents = events.travelSorting;

	//
	// Refresh sorting
	//
	//Set from an element clicked
	function setSortFromTarget($elem) {

		//debug'[travelSortings]','[setSortFromTarget]',$elem);

		//var $elem = $(elem);
		var sortType = $elem.attr('data-sort-type');
		var sortDir = $elem.attr('data-sort-dir');

		//debug'[travelSortings]','[setSortFromTarget]',$elem.attr('data-sort-type'));
		//debug'[travelSortings]','[setSortFromTarget:after check]',sortType,sortDir,$elem);

		if (typeof sortType !== 'undefined' && typeof sortDir !== 'undefined') {

			//Update the direction on the element if it was already sorted this way.
			if ((sortType === Results.getSortBy()) && (sortDir === Results.getSortDir())) {
				//debug'[travelSorting]','Flipping sort direction');
				sortDir === 'asc' ? sortDir='desc' : sortDir='asc';
				$elem.attr('data-sort-dir',sortDir);
			}
			//Results.applyFiltersAndSorts(); //We don't filter on travel and this call was super expensive x10 magnitude.

			//Combined version call is better! Now returns a bool!
			//Set it, run it and check the return before setting classes
			var sortByResult = Results.sortBy(sortType, sortDir);
			if (sortByResult) { //Successful sorting
				//Clear active classes and Mark as current
				/**
				 * This helps utilise the existing bootstrap navbar 'active' styling
				 * by adding the class to the parent li instead of the item itself.
				 */
				$sortElements.parent('li').removeClass('active');
				$elem.parent('li').addClass('active');

				meerkat.modules.resultsTracking.setResultsEventMode('Refresh');
				meerkat.modules.travelResults.publishExtraTrackingEvents({products: [], recordRanking: 'N'});
			} else {
				error('[travelSorting]','The sortBy or sortDir could not be set',setSortByReturn,setSortDirReturn);
			}

		} else {
			error('[travelSorting]','No data on sorting element');
		}
	}


	function initSorting(flag) {
		if(!initialised || flag) {
			initialised = true;
            $sortElements = $('[data-sort-type]');

			//debug('[travelSorting]','initSorting now');

			//Results.view.moduleEvents.RESULTS_SORTED
			meerkat.messaging.subscribe(meerkatEvents.RESULTS_SORTED, function sortedCallback(obj) {
				meerkat.messaging.publish(meerkatEvents.WEBAPP_UNLOCK);
			});

			$sortElements.on('click', function sortingClickHandler(event) {

				//console.time('processing click');
				//console.profile('processing click');
				//We clicked this
				//console.time('setting event target');
				$clicked = $(event.target);
				if (!($clicked.is('a'))) {
					$clicked = $clicked.closest('a');
				}
				//console.timeEnd('setting event target');

				//console.time('check disabled and run actions');
				if (!($clicked.hasClass('disabled'))) {
					//Lock Sorting.
					meerkat.messaging.publish(meerkatEvents.WEBAPP_LOCK);

					//defer here allows it to be as responsive as possible to the click, since this is an expensive operation to actually sort animate things.
					_.defer(function deferredSortClickWrapper() {
						// check if resetState is enabled and that the clicked item isn't the currently clicked item
						if (!$clicked.parent().hasClass('active')) {
							resetSortDir($clicked);
						}
						setSortFromTarget($clicked);
					});
				}
				//console.profileEnd();
				//console.timeEnd('check disabled and run actions');
				//console.timeEnd('processing click');
			});

			// On application lockdown/unlock, disable/enable the dropdown
			meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, function lockSorting(obj) {
				$sortElements.addClass('inactive').addClass('disabled');
			});

			meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, function unlockSorting(obj) {
				$sortElements.removeClass('inactive').removeClass('disabled');
			});
		}
	}

	// Reset the sort dir everytime we click on a sortable column header
	function resetSortDir($elem) {
		var sortType = $elem.attr('data-sort-type'); // grab the currently clicked sort type
		$elem.attr('data-sort-dir', defaultSortStates[sortType]); // reset this element's default sort state
	}

	function init() {
		$(document).ready(function travelSortingInitDomready() {
			$sortElements = $('[data-sort-type]');

			//Just a test for the obvious
			if(typeof Results === 'undefined') {
				meerkat.logging.exception('[travelSorting]','No Results Object Found!');
			}
		});
	}

	function resetToDefaultSort() {
		var $priceSortEl = $("[data-sort-type='price.premium']");
		var sortBy = Results.getSortBy(),
			price = 'price.premium';

		if(sortBy != price || ($priceSortEl.attr('data-sort-dir') == 'desc' && sortBy == price)) {
			$priceSortEl.parent('li').siblings().removeClass('active').end().addClass('active').end().attr('data-sort-dir', 'asc');
			Results.setSortBy('price.premium');
			Results.setSortDir('asc');
		}

	}

	meerkat.modules.register('travelSorting', {
		init: init,
		initSorting: initSorting,
		events: events,
		resetToDefaultSort:resetToDefaultSort
	});

})(jQuery);