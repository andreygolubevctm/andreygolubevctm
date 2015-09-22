/*
 This module supports the Sorting for utilities results page.
 */

;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        error = meerkat.logging.error,
        $sortElements,
        defaultSortStates = {
            'contractPeriodValue': 'asc',
            'totalDiscountValue': 'desc',
            'yearlySavingsValue': 'desc'
        },
        sortByMethods = {
            'contractPeriodValue': sortContracts, // custom defined function as callback
            'totalDiscountValue': sortDiscounts, // custom defined function as callback
            'yearlySavingsValue': null // will default to Results.model.defaultSortMethod. Cannot specify here as Results.model is undefined when this file is parsed.
        }


    //Sorting is a kind of filtering for now in the events
    var events = {
            utilitiesSortings: {
                CHANGED: 'UTILITIES_SORTING_CHANGED'
            }
        },
        performanceScore;

    //Set from an element clicked
    function setSortFromTarget($elem) {

        meerkat.modules.performanceProfiling.startTest('utilitiesSorting');
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
                meerkat.modules.utilitiesResults.publishExtraSuperTagEvents({products: [], recordRanking: 'N'});
            } else {
                error('[utilitiesSorting]', 'The sortBy or sortDir could not be set', setSortByReturn, setSortDirReturn);
            }

        } else {
            error('[utilitiesSorting]', 'No data on sorting element');
        }
    }


    function initSorting() {

        meerkat.messaging.subscribe(meerkatEvents.RESULTS_SORTED, function sortedCallback(obj) {
            meerkat.messaging.publish(meerkatEvents.WEBAPP_UNLOCK);

            var time = meerkat.modules.performanceProfiling.endTest('utilitiesSorting');
            var score;
            if (time < 1200) { //~1050 animation time
                score = meerkat.modules.performanceProfiling.PERFORMANCE.HIGH;
            } else if (time < 1500 && meerkat.modules.performanceProfiling.isIE8() === false) {
                score = meerkat.modules.performanceProfiling.PERFORMANCE.MEDIUM;
            } else {
                score = meerkat.modules.performanceProfiling.PERFORMANCE.LOW;
            }
            // We only want to lower the score, not increase it, as its unlikely a good browser will get a time < 1200.
            if(performanceScore !== meerkat.modules.performanceProfiling.PERFORMANCE.HIGH) {
                Results.setPerformanceMode(score);
            }
            performanceScore = score;
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
        $(document).ready(function utilitiesSortingInitDomready() {
            $sortElements = $('[data-sort-type]');

            //Just a test for the obvious
            if (typeof Results === 'undefined') {
                meerkat.logging.exception('[utilitiesSorting]', 'No Results Object Found!');
            }
        });
    }

    function resetToDefaultSort() {
        var $priceSortEl = $("[data-sort-type='totalDiscountValue']");
        var sortBy = Results.getSortBy(),
            price = 'totalDiscountValue';

        if (sortBy != price || ($priceSortEl.attr('data-sort-dir') == 'asc' && sortBy == price)) {
            $priceSortEl.parent('li').siblings().removeClass('active').end().addClass('active').end().attr('data-sort-dir', 'desc');
            Results.setSortBy('totalDiscountValue');
            Results.setSortDir('desc');
        }

    }

    /**
     * Handles the journey quirk where it hides a column depending on which option
     * you select e.g. if you are NOT moving in, show yearly savings. If you are moving in, hide it.
     * Contract Period becomes col-sm-5 col-lg-2
     * Total Discounts becomes col-sm-5 col-lg-3
     */
    function toggleColumns() {
        var discounts = $('.colTotalDiscounts'),
            savings = $('.colYearlySavings'),
            contractPeriod = $('.colContractPeriod');

        if (meerkat.modules.utilitiesResults.showYearlySavings()) {
            savings.removeClass('hidden');
            contractPeriod.removeClass('col-sm-5 col-lg-2').addClass('col-sm-3 col-lg-1');
            discounts.removeClass('col-sm-5 col-lg-3').addClass('col-sm-4 col-lg-2');
        } else {
            savings.addClass('hidden');
            contractPeriod.removeClass('col-sm-3 col-lg-1').addClass('col-sm-5 col-lg-2');
            discounts.removeClass('col-sm-4 col-lg-2').addClass('col-sm-5 col-lg-3');
        }
    }

    /**
     * -1 is before
     * 1 is after
     * 0 is equal
     * @param valueA
     * @param valueB
     * @returns {number}
     */
    function compare(valueA, valueB) {
        if (valueA < valueB) {
            return -1;
        }
        if (valueA > valueB) {
            return 1;
        }
        return 0;
    }

    /**
     * Sort by total discounts, and if same, sort by estimated savings.
     * @param resultA
     * @param resultB
     * @returns {*}
     */
    function sortDiscounts(resultA, resultB) {

        var returnValue,
            valueA = resultA.totalDiscountValue,
            valueB = resultB.totalDiscountValue;

        if (isNaN(valueA)) {
            return 1;
        }
        if (isNaN(valueB)) {
            return -1;
        }

        returnValue = compare(valueA, valueB);
        if (returnValue === 0) {
            var subValueA = resultA.yearlySavingsValue,
                subValueB = resultB.yearlySavingsValue;

            returnValue = compare(subValueA, subValueB);
        }
        if (Results.settings.sort.sortDir == 'desc') {
            returnValue *= -1;
        }
        return returnValue;
    }

    /**
     *
     * @param resultA
     * @param resultB
     * @returns {*}
     */
    function sortContracts(resultA, resultB) {

        var returnValue,
            valueA = resultA.contractPeriodValue,
            valueB = resultB.contractPeriodValue;

        if (isNaN(valueA)) {
            return 1;
        }
        if (isNaN(valueB)) {
            return -1;
        }

        returnValue = compare(valueA, valueB);
        if (returnValue === 0) {
            var subValueA = resultA.totalDiscountValue,
                subValueB = resultB.totalDiscountValue;

            returnValue = compare(subValueB, subValueA);
        }
        if (returnValue === 0) {
            var subSubValueA = resultA.yearlySavingsValue,
                subSubValueB = resultB.yearlySavingsValue;

            returnValue = compare(subSubValueB, subSubValueA);
        }
        if (Results.settings.sort.sortDir == 'desc') {
            returnValue *= -1;
        }
        return returnValue;
    }

    meerkat.modules.register('utilitiesSorting', {
        init: init,
        initSorting: initSorting,
        events: events,
        resetToDefaultSort: resetToDefaultSort,
        toggleColumns: toggleColumns,
        sortDiscounts: sortDiscounts,
        sortContracts: sortContracts
    });

})(jQuery);