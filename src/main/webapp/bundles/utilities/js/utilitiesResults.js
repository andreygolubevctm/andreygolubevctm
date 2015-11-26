;(function($){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var events = {
        // Defined here because it's published in Results.js
        RESULTS_ERROR: 'RESULTS_ERROR'
    };
    var $component, //Stores the jQuery object for the component group
        thoughtWorldCustomerRef = '',
        initialised = false;

    function initPage(){
        if(!initialised) {
            initialised = true;
            $component = $("#resultsPage");
            meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);
            initResults();
            eventSubscriptions();
        }
    }

    function initResults(){

        try {

            // Init the main Results object
            Results.init({
                url: "ajax/json/utilities_quote_results.jsp",
                runShowResultsPage: false, // Don't let Results.view do it's normal thing.
                paths: {
                    results: {
                        list: "results.plans",
                        general: "results.uniqueCustomerId"
                    },
                    productId: "productId",
                    productName: "planName",
                    productBrandCode: "retailerName",
                    contractPeriodValue: "contractPeriodValue",
                    totalDiscountValue: "totalDiscountValue",
                    yearlySavingsValue: "yearlySavingsValue",
                    estimatedCostValue: "estimatedCostValue",
                    availability: {
                        product: "productAvailable"
                    }
                },
                show: {
                    nonAvailableProducts: false, // This will apply the availability.product rule
                    unavailableCombined: true    // Whether or not to render a 'fake' product which is a placeholder for all unavailable products.
                },
                availability: {
                    product: ["equals", "Y"]
                },
                render: {
                    templateEngine: '_',
                    dockCompareBar: false
                },
                displayMode: 'price', // features, price
                pagination: {
                    touchEnabled: false
                },
                sort: {
                    sortBy: 'totalDiscountValue',
                    sortByMethod: meerkat.modules.utilitiesSorting.sortDiscounts,
                    sortDir: 'desc'
                },
                //frequency: "premium",
                animation: {
                    results: {
                        individual: {
                            active: false
                        },
                        delay: 500,
                        options: {
                            easing: "swing", // animation easing type
                            duration: 1000
                        }
                    },
                    shuffle: {
                        active: true,
                        options: {
                            easing: "swing", // animation easing type
                            duration: 1000
                        }
                    },
                    filter: {
                        reposition: {
                            options: {
                                easing: "swing" // animation easing type
                            }
                        }
                    }
                },
                rankings: {
                    triggers : ['RESULTS_DATA_READY'],
                    callback : rankingCallback,
                    forceIdNumeric : false,
                    filterUnavailableProducts : true
                }
            });
        }
        catch(e) {
            Results.onError('Sorry, an error occurred initialising page', 'results.tag', 'meerkat.modules.utilitiesResults.initResults(); '+e.message, e);
        }
    }


    /**
     * Pre-filter the results object to add another parameter. This will be unnecessary when the field comes back from Java.
     */
    function massageResultsObject(products) {

        if (_.isArray(products) && products.length > 0 && _.isArray(products[0])) {
            products = [{
                productAvailable: 'N'
            }];
            return products;
        }
        var whatToCompare = $(".what-to-compare").find("input[type='radio']:checked").val() || null;
        _.each(products, function massageJson(result, index) {

            // Add properties
            result.productAvailable = 'Y';
            result.brandCode = result.retailerName;
            result.productId = result.planId;

            // Set to object so can be rendered separately.
            if(whatToCompare == "EG") {
                result.discountElectricity = 0;
                result.discountGas = 0;
                result.discountOther = 0;
                result.totalDiscountValue = getTotalDiscount(result, result.payontimeDiscounts) + getTotalDiscount(result, result.ebillingDiscounts) + getTotalDiscount(result, result.guaranteedDiscounts) + getTotalDiscount(result, result.otherDiscounts);
            } else {
                result.totalDiscountValue = Number(result.payontimeDiscounts) + Number(result.ebillingDiscounts) + Number(result.guaranteedDiscounts) + Number(result.otherDiscounts);
            }
            result.contractPeriodValue = result.contractPeriod.indexOf('Year') != -1 ? parseInt(result.contractPeriod.replace(/[^\d]/g, ''), 10) : 0;
            result.yearlyElectricitySavingsValue = typeof result.yearlyElectricitySavings === 'undefined' || result.yearlyElectricitySavings === null ? 0 : result.yearlyElectricitySavings;
            result.yearlyElectricitySavingsValue = Number(result.yearlyElectricitySavingsValue.toFixed(2));

            result.yearlyGasSavingsValue = typeof result.yearlyGasSavings === 'undefined' || result.yearlyGasSavings === null ? 0 : result.yearlyGasSavings;
            result.yearlyGasSavingsValue = Number(result.yearlyGasSavingsValue.toFixed(2));

            result.estimatedCostValue = typeof result.estimatedCost === 'undefined' || result.estimatedCost === null ? 0 : result.estimatedCost;
            result.estimatedCostValue = Number(result.estimatedCostValue.toFixed(2));
        });
        return products;
    }

    /**
     * Handle when the API returns "Electricity - 35% and Gas - 20%.
     * Summed so can be sorted on.
     * @param result The result object so we can set new parameters back onto it.
     * @param value
     * @returns Number the raw number or a total of the two separate numbers.
     */
    function getTotalDiscount(result, value) {

        // Return the number as-is.
        var discountAsNumber = Number(value);
        if(!isNaN(discountAsNumber)) {
            result.discountOther += discountAsNumber;
            return discountAsNumber;
        }

        var matches = value.match(/(Electricity)\s\-\s([0-9]{1,2})\%\sand\s(Gas)\s\-\s([0-9]{1,2})\%/);
        if (matches.length === 5) {
            result.discountElectricity += Number(matches[2]);
            result.discountGas += Number(matches[4]);
            var sum = result.discountElectricity + result.discountGas;
            return isNaN(sum) ? 0 : sum;
        }
        return 0;
    }

    function rankingCallback(product, position) {
        var data = {};

        // If the is the first time sorting, send the prm as well
        //data["rank_premium" + position] = product.price;
        data["rank_productId" + position] = product.productId;

        return data;
    }

    function eventSubscriptions() {

        // Model updated, make changes before rendering
        meerkat.messaging.subscribe(Results.model.moduleEvents.RESULTS_MODEL_UPDATE_BEFORE_FILTERSHOW, function modelUpdated() {
            Results.model.returnedProducts = massageResultsObject(Results.model.returnedProducts);

            // Populating sorted products is a trick for HML due to setting sortBy:false
            Results.model.sortedProducts = Results.model.returnedProducts;
        });

        // When the navar docks/undocks
        meerkat.messaging.subscribe(meerkatEvents.affix.AFFIXED, function navbarFixed() {
            $component.css('margin-top', '8px');
        });
        meerkat.messaging.subscribe(meerkatEvents.affix.UNAFFIXED, function navbarUnfixed() {
            $component.css('margin-top', '0');
        });

        // Run the show method even when there are no available products
        // This will render the unavailable combined template
        $(Results.settings.elements.resultsContainer).on("noFilteredResults", function() {
            Results.view.show();
        });

        // If error occurs, go back in the journey
        meerkat.messaging.subscribe(events.RESULTS_ERROR, function resultsError() {
            // Delayed to allow journey engine to unlock
            _.delay(function() {
                meerkat.modules.journeyEngine.gotoPath('previous');
            }, 1000);
        });

        // Scroll to the top when results come back
        $(document).on("resultsReturned", function(){
            meerkat.modules.utils.scrollPageTo($("header"));

        });

        // Start fetching results
        $(document).on("resultsFetchStart", function onResultsFetchStart() {
            meerkat.modules.journeyEngine.loadingShow('...getting your quotes...');
            $component.removeClass('hidden');

            // Hide pagination
            Results.pagination.hide();
        });

        // Fetching done
        $(document).on("resultsFetchFinish", function onResultsFetchFinish() {

            // Results are hidden in the CSS so we don't see the scaffolding after #benefits
            $(Results.settings.elements.page).show();

            meerkat.modules.journeyEngine.loadingHide();

            $(document.body).addClass('priceMode');

        });

        $(Results.settings.elements.resultsContainer).on("noResults", function onResultsNone() {
            showNoResults();
        });

        $(document).on("generalReturned", function onGeneralReturned() {
            thoughtWorldCustomerRef = Results.getReturnedGeneral();
            $('.thoughtWorldRefNoContainer').html("Reference no. "+ thoughtWorldCustomerRef);
            $('#utilities_partner_uniqueCustomerId').val(thoughtWorldCustomerRef);
        });

        // Handle result row click
        $(Results.settings.elements.resultsContainer).on('click', '.result-row', resultRowClick);

        $(document.body).on('click', '.btn-apply', enquireNowClick);
        $(document.body).on('click', '.btn-change-type', changeTypeClick);
        $(document.body).on('click', '.btn-add-bill', addBillClick);

    }

    function enquireNowClick(event) {

        event.preventDefault();

        var $resultrow = $(event.target);
        if ($resultrow.hasClass('result-row') === false) {
            $resultrow = $resultrow.parents('.result-row');
        }
        // Row must be available to click it.
        if (typeof $resultrow.attr('data-available') === 'undefined' || $resultrow.attr('data-available') !== 'Y') return;

        if($resultrow.attr("data-productId")) {
            Results.setSelectedProduct($resultrow.attr("data-productId"));
        }

        meerkat.modules.utilities.trackHandover();
        meerkat.modules.moreInfo.setProduct(Results.getResult('productId', $resultrow.attr('data-productId')));
        meerkat.modules.utilitiesMoreInfo.retrieveExternalCopy(Results.getSelectedProduct()).done(function() {
            meerkat.modules.journeyEngine.gotoPath('next', $resultrow.find('.btn-apply'));
        });

    }

    function changeTypeClick(event) {

        event.preventDefault();

        var $e = $('#change-type-template');
        if ($e.length > 0) {
            templateCallback = _.template($e.html());
        }

        var htmlContent = templateCallback();
        var modalOptions = {
            htmlContent: htmlContent,
            hashId: '',
            className: 'change-type-modal',
            closeOnHashChange: true,
            openOnHashChange: false,
            onOpen: function (modalId) {

                $('.change-type-modal').show();

            },
            onClose: function(modalId) {

            }
        };

        changeTypeId = meerkat.modules.dialogs.show(modalOptions);
        $(".what-to-compare-reset").on('change',_toggleChangeType);

    }

    function addBillClick(event) {

        event.preventDefault();
        $('#utilities_householdDetails_recentElectricityBill_Y').parent().click();
        $('#utilities_householdDetails_recentGasBill_Y').parent().click();

        meerkat.modules.journeyEngine.gotoPath('start');

    }

    function _toggleChangeType() {
        var type = $(".what-to-compare-reset").find("input[type='radio']:checked").val();

        $('#utilities_householdDetails_whatToCompare').find('label').removeClass('active');

        $('#utilities_householdDetails_whatToCompare_' + type).parent().click();
        $('#utilities_householdDetails_whatToCompare_' + type).prop('checked',true);
        $('#utilities_householdDetails_whatToCompare_' + type).parent().addClass('active');

        meerkat.modules.journeyEngine.gotoPath('start');
    }

    function resultRowClick(event) {
        // Ensure only in XS price mode
        if ($(Results.settings.elements.resultsContainer).hasClass('priceMode') === false) return;
        if (meerkat.modules.deviceMediaState.get() !== 'xs') return;

        var $resultrow = $(event.target);
        if ($resultrow.hasClass('result-row') === false) {
            $resultrow = $resultrow.parents('.result-row');
        }

        // Row must be available to click it.
        if (typeof $resultrow.attr('data-available') === 'undefined' || $resultrow.attr('data-available') !== 'Y') return;

        // Set product and launch bridging
        meerkat.modules.moreInfo.setProduct(Results.getResult('productId', $resultrow.attr('data-productId')));
        meerkat.modules.utilitiesMoreInfo.runDisplayMethod();
    }

    // Wrapper around results component, load results data
    function get() {
        Results.get();
    }

    function showNoResults() {
        meerkat.modules.dialogs.show({
            htmlContent: $('#no-results-content')[0].outerHTML
        });
    }

    /**
     * This function has been refactored into calling a core resultsTracking module.
     * It has remained here so verticals can run their own unique calls.
     */
    function publishExtraSuperTagEvents(additionalData) {
        additionalData = typeof additionalData === 'undefined' ? {} : additionalData;
        meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
            additionalData: $.extend({
                sortBy: Results.getSortBy() +'-'+ Results.getSortDir()
            }, additionalData),
            onAfterEventMode: 'Refresh'
        });
    }

    /**
     * Yearly savings are only shown if you already live in the home.
     * @returns {*}
     */
    function showYearlySavings() {
        return $('#utilities_householdDetails_movingIn_N').prop('checked');
    }

    function showEstimatedUsage() {
        var hasElecBill = $('#utilities_householdDetails_recentElectricityBill_N').prop('checked'),
        hasGasBill = $('#utilities_householdDetails_recentGasBill_N').prop('checked');

        return (hasElecBill && hasGasBill);
    }

    function showEstimatedCost() {
        var movingIn = $('#utilities_householdDetails_movingIn_N').prop('checked'),
        hasElecBill = $('#utilities_householdDetails_recentElectricityBill_Y').prop('checked'),
        hasGasBill = $('#utilities_householdDetails_recentGasBill_Y').prop('checked');

        return movingIn && (hasElecBill || hasGasBill);
    }

    function getThoughtWorldReferenceNumber() {
        return thoughtWorldCustomerRef;
    }

    meerkat.modules.register('utilitiesResults', {
        initPage: initPage,
        get: get,
        showNoResults: showNoResults,
        publishExtraSuperTagEvents: publishExtraSuperTagEvents,
        showYearlySavings: showYearlySavings,
        showEstimatedCost: showEstimatedCost,
        showEstimatedUsage: showEstimatedUsage,
        getThoughtWorldReferenceNumber: getThoughtWorldReferenceNumber
    });

})(jQuery);
