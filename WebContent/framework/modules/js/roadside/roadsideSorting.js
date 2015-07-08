/*
 This module supports the Sorting for roadside results page.
 Travel, Utilities, Roadside use the same logic but copied and pasted.
 */

;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        error = meerkat.logging.error,
        $sortElements,
        defaultSortStates = {
            'price.premium': 'asc',
            'info.roadCall': 'desc',
            'info.keyService': 'desc'
        },
        sortByMethods = {
            'price.premium': null, // will default to Results.model.defaultSortMethod. Cannot specify here as Results.model is undefined when this file is parsed.
            'info.roadCall': null,
            'info.keyService': null
        }


    //Sorting is a kind of filtering for now in the events
    var events = {
            roadsideSorting: {
                CHANGED: 'ROADSIDE_SORTING_CHANGED'
            }
        },
        moduleEvents = events.roadsideSorting;

    //Set from an element clicked
    function setSortFromTarget($elem) {

        var sortType = $elem.attr('data-sort-type');
        var sortDir = $elem.attr('data-sort-dir');

        if (typeof sortType !== 'undefined' && typeof sortDir !== 'undefined') {

            //Update the direction on the element if it was already sorted this way.
            if ((sortType === Results.getSortBy()) && (sortDir === Results.getSortDir())) {

                sortDir = sortDir === 'asc' ? 'desc' : 'asc';
                $elem.attr('data-sort-dir', sortDir);
            }

            //Combined version call is better! Now returns a bool!
            //Set it, run it and check the return before setting classes
            Results.setSortByMethod(sortByMethods[sortType]);
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
                meerkat.modules.roadsideResults.publishExtraSuperTagEvents({products: [], recordRanking: 'N'});
            } else {
                error('[roadsideSorting]', 'The sortBy or sortDir could not be set', setSortByReturn, setSortDirReturn);
            }

        } else {
            error('[roadsideSorting]', 'No data on sorting element');
            meerkat.messaging.publish(meerkatEvents.WEBAPP_UNLOCK);
        }
    }


    function initSorting() {

        meerkat.messaging.subscribe(meerkatEvents.RESULTS_SORTED, function sortedCallback(obj) {
            meerkat.messaging.publish(meerkatEvents.WEBAPP_UNLOCK);
        });

        $sortElements.on('click', function sortingClickHandler(event) {

            //We clicked this
            var $clicked = $(event.target);
            if (!($clicked.is('a'))) {
                $clicked = $clicked.closest('a');
            }

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
        });

        // On application lockdown/unlock, disable/enable the dropdown
        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, function lockSorting(obj) {
            $sortElements.addClass('inactive disabled');
        });

        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, function unlockSorting(obj) {
            $sortElements.removeClass('inactive disabled');
        });
    }

    // Reset the sort dir everytime we click on a sortable column header
    function resetSortDir($elem) {
        var sortType = $elem.attr('data-sort-type'); // grab the currently clicked sort type
        $elem.attr('data-sort-dir', defaultSortStates[sortType]); // reset this element's default sort state
    }

    function init() {
        $(document).ready(function roadsideSortingInitDomready() {
            $sortElements = $('[data-sort-type]');
        });
    }

    function resetToDefaultSort() {
        var $priceSortEl = $("[data-sort-type='price.premium']");
        var sortBy = Results.getSortBy(),
            price = 'price.premium';

        if (sortBy != price || ($priceSortEl.attr('data-sort-dir') == 'desc' && sortBy == price)) {
            $priceSortEl.parent('li').siblings().removeClass('active').end().addClass('active').end().attr('data-sort-dir', 'desc');
            Results.setSortBy('price.premium');
            Results.setSortDir('desc');
        }

    }

    meerkat.modules.register('roadsideSorting', {
        init: init,
        initSorting: initSorting,
        events: events,
        resetToDefaultSort: resetToDefaultSort
    });

})(jQuery);