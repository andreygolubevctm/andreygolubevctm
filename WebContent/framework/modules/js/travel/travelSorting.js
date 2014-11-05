/*
	This module supports the Sorting for travel results page.
*/

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		error = meerkat.logging.error,
		exception = meerkat.logging.exception,
		$sortElements,
		activeSortBy,
		activeSortDir;
		//$sortbarChildren,
		//$sortbarParent,


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
			var sortByResult = Results.sortBy(sortType,sortDir);
			if (sortByResult) { //Successful sorting
				//Clear actives and Mark as current
				//$sortElements.removeClass('active'); //we don't rely on the clicked anchor for this since active classes are on li's in bootstrap navbars.
				$sortElements.parent('li').removeClass('active'); //this helps utilise the existing bootstrap navbar 'active' styling by adding the class to the parent li instead of the item itself.
				//$elem.addClass('active');
				$elem.parent('li').addClass('active');

				trackQuoteList(sortType+ "-" + sortDir);
			} else {
				error('[travelSorting]','The sortBy or sortDir could not be set',setSortByReturn,setSortDirReturn);
			}

		} else {
			error('[travelSorting]','No data on sorting element');
		}
	}


	function initSorting() {

		//debug('[travelSorting]','initSorting now');

		//Sync down the results defaults.
		//meerkat.messaging.subscribe(meerkatEvents.RESULTS_DATA_READY, function getSortingData(obj) {
			//debug('[travelSorting]','RESULTS_DATA_READY','was heard - getting the sort data now');
		//});
		
		//Results.view.moduleEvents.RESULTS_SORTED
		meerkat.messaging.subscribe(meerkatEvents.RESULTS_SORTED, function sortedCallback(obj) {
			//debug('[travelSorting]','RESULTS_SORTED','Was heard');
			meerkat.messaging.publish(meerkatEvents.WEBAPP_UNLOCK);
		});

		$sortElements.on('click', function sortingClickHandler(event){
			
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
				_.defer(function deferredSortClickWrapper(){
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
			//debug('[travelSorting]','WEBAPP_LOCK','Was heard');
		});

		meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, function unlockSorting(obj) {
			$sortElements.removeClass('inactive').removeClass('disabled');
			//debug('[travelSorting]','WEBAPP_UNLOCK','Was heard');
		});

		// Call initial supertag call
		//var transaction_id = meerkat.modules.transactionId.get();

		// Supertag
		//if(meerkat.site.isNewQuote === false){ //only the subsequent re-sort events?
		//	meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
		//		method:'trackQuoteEvent',
		//		object: {
		//			action: 'Sorting',
		//			transactionID: transaction_id
		//		}
		//	});
		//}
		
	}

	function trackQuoteList(sortBy) {
		var data = {
				vertical: meerkat.site.vertical,
				actionStep: meerkat.site.vertical + ' results',
				event: 'Refresh',
				verticalFilter: $("input[name=travel_policyType]:checked").val() == 'S' ? 'Single Trip' : 'Multi Trip',
				sortBy: sortBy
		};

		meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
			method:	'trackQuoteList',
			object:	data
		});
	}

	function init() {
		$(document).ready(function travelSortingInitDomready() {
			//debug'[travelSorting]','Domready now');
			// Store the jQuery objects
			//$sortbarParent = $('.sortbar-parent');
			//$sortbarChildren = $('.sortbar-children');
			$sortElements = $('[data-sort-type]');
			////console.debug($sortElements);

			//Just a test for the obvious
			if(typeof Results === 'undefined') {
				meerkat.logging.exception('[travelSorting]','No Results Object Found!')
			} else {
				return;
			}
		});
	}

	meerkat.modules.register('travelSorting', {
		init: init,
		initSorting: initSorting,
		events: events
	});

})(jQuery);