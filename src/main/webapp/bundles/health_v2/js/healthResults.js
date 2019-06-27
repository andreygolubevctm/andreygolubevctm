;(function ($) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        selectedProduct = null,
        previousBreakpoint,
        best_price_count = 5,
        isLhcApplicable = 'N',
        selectedBenefitsList,
        premiumIncreaseContent = $('.healthPremiumIncreaseContent'),
        maxMilliSecondsForMessage = $("#maxMilliSecToWait").val(),
        resultsStepIndex = 3,
        $openingHours = null,

        templates = {
            premiumsPopOver: '{{ if(product.premium.hasOwnProperty(frequency)) { }}' +
            '<strong>Total Price including rebate and LHC: </strong><span class="highlighted">{{= product.premium[frequency].text }}</span><br/> ' +
            '<strong>Price including rebate but no LHC: </strong>{{=product.premium[frequency].lhcfreetext}}<br/> ' +
            '<strong>Price including LHC but no rebate: </strong>{{= product.premium[frequency].baseAndLHC }}<br/> ' +
            '<strong>Base price: </strong>{{= product.premium[frequency].base }}<br/> ' +
            '{{ } }}' +
            '<hr/> ' +
            '{{ if(product.premium.hasOwnProperty(\'fortnightly\')) { }}' +
            '<strong>Fortnightly (ex LHC): </strong>{{=product.premium.fortnightly.lhcfreetext}}<br/> ' +
            '{{ } }}' +
            '{{ if(product.premium.hasOwnProperty(\'monthly\')) { }}' +
            '<strong>Monthly (ex LHC): </strong>{{=product.premium.monthly.lhcfreetext}}<br/> ' +
            '{{ } }}' +
            '{{ if(product.premium.hasOwnProperty(\'annually\')) { }}' +
            '<strong>Annually (ex LHC): </strong>{{= product.premium.annually.lhcfreetext}}<br/> ' +
            '{{ } }}' +
            '<hr/> ' +
            '{{ if(product.hasOwnProperty(\'info\')) { }}' +
            '<strong>Name: </strong>{{=product.info.productTitle}}<br/> ' +
            '<strong>Product Code: </strong>{{=product.info.productCode}}<br/> ' +
            '<strong>Product ID: </strong>{{=product.productId}}<br/>' +
            '<strong>State: </strong>{{=product.info.State}}<br/> ' +
            '<strong>Membership Type: </strong>{{=product.info.Category}}' +
            '{{ } }}'
        },
        moduleEvents = {
            healthResults: {
                SELECTED_PRODUCT_CHANGED: 'SELECTED_PRODUCT_CHANGED',
                SELECTED_PRODUCT_RESET: 'SELECTED_PRODUCT_RESET',
                PREMIUM_UPDATED: 'PREMIUM_UPDATED'
            },
            WEBAPP_LOCK: 'WEBAPP_LOCK',
            WEBAPP_UNLOCK: 'WEBAPP_UNLOCK',
            RESULTS_ERROR: 'RESULTS_ERROR'
        },
        paymentFrequencyDictionary = [
            {
                key: "annually",
                label: "per year"
            }, {
                key: "halfyearly",
                label: "per half year"
            }, {
                key: "quarterly",
                label: "per quarter"
            }, {
                key: "monthly",
                label: "per month"
            }, {
                key: "fortnightly",
                label: "per <span class='hidden-xs'>fortnight</span><span class='hidden-sm hidden-md hidden-lg'>f/night</span>"
            }, {
                key: "weekly",
                label: "per week"
            }
        ];


    function initPage() {

        initResults();

        meerkat.modules.compare.initCompare();

        Features.init();

        eventSubscriptions();

        breakpointTracking();

    }

    function onReturnToPage() {
        breakpointTracking();
        if (previousBreakpoint !== meerkat.modules.deviceMediaState.get()) {
            Results.view.calculateResultsContainerWidth();
            Features.clearSetHeights();
            Features.balanceVisibleRowsHeight();
        }
        Results.pagination.refresh();
    }

    function initResults() {

        var frequencyValue = $('#health_filter_frequency').val();
        frequencyValue = meerkat.modules.healthResults.getFrequencyInWords(frequencyValue) || 'monthly';


        try {

            var healthQuoteResultsUrl = "ajax/json/health_quote_results.jsp";
            if (meerkat.modules.splitTest.isActive(40) || meerkat.site.isDefaultToHealthQuote) {
                healthQuoteResultsUrl = "ajax/json/health_quote_results_ws.jsp";
            }

            // Init the main Results object
            Results.init({
                url: healthQuoteResultsUrl,
                runShowResultsPage: false, // Don't let Results.view do it's normal thing.
                paths: {
                    results: {
                        list: "results.price",
                        info: "results.info"
                    },
                    brand: "info.Name",
                    productBrandCode: "info.providerName", // for tracking
                    productId: "productId",
                    productTitle: "info.productTitle",
                    productName: "info.productTitle", // for tracking
                    price: { // result object path to the price property
                        annually: "premium.annually.lhcfreevalue",
                        monthly: "premium.monthly.lhcfreevalue",
                        fortnightly: "premium.fortnightly.lhcfreevalue"
                    },
                    availability: { // result object path to the price availability property (see corresponding availability.price)
                        product: "available",
                        price: {
                            annually: "premium.annual.lhcfreevalue",
                            monthly: "premium.monthly.lhcfreevalue",
                            fortnightly: "premium.fortnightly.lhcfreevalue"
                        }
                    },
                    benefitsSort: 'info.rank'
                },
                show: {
                    // Apply Results availability filter (rule below)
                    nonAvailablePrices: false
                },
                availability: {
                    // This means the price has to be != 0 to display e.g. premium.annual.lhcfreevalue != 0
                    price: ["notEquals", 0]
                },
                render: {
                    templateEngine: '_',
                    features: {
                        mode: 'populate',
                        headers: false,
                        numberOfXSColumns: 2
                    },
                    dockCompareBar: false
                },
                displayMode: "features",
                pagination: {
                    margin: 15,
                    mode: 'page',
                    touchEnabled: false,
                    useSubPixelWidths: true
                },
                sort: {
                    sortBy: "benefitsSort"
                },
                frequency: frequencyValue,
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
                        active: false,
                        options: {
                            easing: "swing" // animation easing type
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
                elements: {
                    features: {
                        values: ".content",
                        extras: ".children",
                        renderTemplatesBasedOnFeatureIndex: true
                    }
                },
                dictionary: {
                    valueMap: [
                        {
                            key: 'Y',
                            value: ""
                        },
                        {
                            key: 'N',
                            value: ""
                        },
                        {
                            key: 'R',
                            value: ""
                        },
                        {
                            key: '-',
                            value: ""
                        },
                        {
                            key: 'None',
                            value: 'No'
                        },
                        {
                            key: 'No Waiting Period',
                            value: 'No'
                        }
                    ]
                },
                rankings: {
                    triggers: ['RESULTS_DATA_READY'],
                    callback: meerkat.modules.healthResults.rankingCallback,
                    forceIdNumeric: true
                },
                incrementTransactionId: false
            });

        } catch (e) {
            Results.onError('Sorry, an error occurred initialising page', 'results.tag', 'meerkat.modules.healthResults.initResults(); ' + e.message, e);
        }
    }


    function eventSubscriptions() {

        var tStart = 0;

        $(Results.settings.elements.resultsContainer).on("featuresDisplayMode", function () {
            _resetSelectionsStructureObject();
            _setupSelectedBenefits('Extras Selections', 'Extras Cover');
            _setupSelectedBenefits('Hospital Selections', 'Hospital Cover');
            Features.buildHtml();
            _.defer(meerkat.modules.healthResultsTemplate.postRenderFeatures);
        });

        $(document).on("generalReturned", function () {
            var generalInfo = Results.getReturnedGeneral();
            if (generalInfo.pricesHaveChanged) {
                meerkat.modules.dialogs.show({
                    title: "Just a quick note",
                    htmlContent: $('#quick-note').html(),
                    buttons: [{
                        label: "Show latest results",
                        className: "btn btn-next",
                        closeWindow: true
                    }]
                });
                $("input[name='health_retrieve_savedResults']").val("N");
            }
        });

        $(document).on("resultsLoaded", onResultsLoaded);

        $(document).on("resultsReturned", function () {
            meerkat.modules.utils.scrollPageTo($("header"));
            // Reset the feature header to match the new column content.
            $(".featuresHeaders .expandable.expanded").removeClass("expanded").addClass("collapsed");

            if (premiumIncreaseContent.length > 0) {
                _.defer(function () {
                    premiumIncreaseContent.click();
                });
            }
        });

        $(document).on("resultsDataReady", function () {
            if (meerkat.site.isCallCentreUser) {
                createPremiumsPopOver();
            }
        });

        $(document).on("resultsFetchStart", function onResultsFetchStart() {
            tStart = new Date().getTime();
            var waitMessageVal = $("#waitMessage").val();
            meerkat.modules.journeyEngine.loadingShow(waitMessageVal);

            // Hide pagination
            $('.results-pagination').add('header a[data-results-pagination-control]').addClass('hidden');
            meerkat.modules.coupon.triggerPopup();
        });

        // If error occurs, go back in the journey
        meerkat.messaging.subscribe(moduleEvents.RESULTS_ERROR, function resultsError() {
            // Delayed to allow journey engine to unlock
            _.delay(function () {
                meerkat.modules.journeyEngine.gotoPath('previous');
            }, 1000);
        });

        $(document).on("resultsFetchFinish", function onResultsFetchFinish() {
            _.defer(function () {
                // Show pagination header for mobile
                $('header a[data-results-pagination-control]').removeClass('hidden');
                // Setup pagination for non-mobile journey
                meerkat.modules.healthResultsTemplate.toggleRemoveResultPagination();
                // Setup scroll
                Results.pagination.setupNativeScroll();
                // render snapshot
                meerkat.modules.healthSnapshot.renderPreResultsRowSnapshot();
                // turn off increment tranId
                Results.settings.incrementTransactionId = false;
            });
            var tEnd = new Date().getTime();
            var tFetchFinish = (tEnd - tStart);
            var tVariance = maxMilliSecondsForMessage - tFetchFinish;
            if (tVariance < 0 || meerkat.site.isCallCentreUser) {
                tVariance = 0;
            }
            _.delay(function () {
                meerkat.modules.journeyEngine.loadingHide();
            }, tVariance);


            if (!meerkat.site.isNewQuote && !Results.getSelectedProduct() && meerkat.site.isCallCentreUser) {
                Results.setSelectedProduct($('.health_application_details_productId').val());
                var product = Results.getSelectedProduct();
                if (product) {
                    meerkat.modules.healthResults.setSelectedProduct(product);
                }
            }

            // if online user load quote from brochures edm (with attached productId), compare it with returend result set, if it is in there, select it, and go to apply stage.
            if (($('input[name="health_directApplication"]').val() === 'Y')) {
                Results.setSelectedProduct(meerkat.site.loadProductId);
                var productMatched = Results.getSelectedProduct();
                if (productMatched) {
                    meerkat.modules.healthResults.setSelectedProduct(productMatched);
                    meerkat.modules.journeyEngine.gotoPath("next");
                } else {
                    var productUpdated = Results.getResult("productTitle", meerkat.site.loadProductTitle);
                    var htmlContent = "";

                    if (productUpdated) {
                        meerkat.modules.healthResults.setSelectedProduct(productUpdated);
                        htmlContent = "Thanks for visiting " + meerkat.site.content.brandDisplayName + ". Please note that for this particular product, " +
                            "the price and/or features have changed since the last time you were comparing. If you need further assistance, " +
                            "you can chat to one of our Health Insurance Specialists on <span class=\"callCentreHelpNumber\">" + meerkat.site.content.callCentreHelpNumber + "</span>, and they will be able to help you with your options.";
                    } else {
                        $('#health_application_productId').val(''); // reset selected productId to prevent it getting saved into transaction details.
                        $('#health_application_productTitle').val(''); // reset selected productTitle to prevent it getting saved into transaction details.
                        htmlContent = "Thanks for visiting " + meerkat.site.content.brandDisplayName + ". Unfortunately the product you're looking for is no longer available. " +
                            "Please head to your results page to compare available policies or alternatively, " +
                            "chat to one of our Health Insurance Specialists on <span class=\"callCentreHelpNumber\">" + meerkat.site.content.callCentreHelpNumber + "</span>, and they will be able to help you with your options.";
                    }

                    meerkat.modules.dialogs.show({
                        title: "Just a quick note",
                        htmlContent: htmlContent,
                        buttons: [{
                            label: "Show latest results",
                            className: "btn btn-next",
                            closeWindow: true
                        }]
                    });
                }

                // reset
                meerkat.site.loadProductId = '';
                meerkat.site.loadProductTitle = '';
                $('input[name="health_directApplication"]').val('');
            }

            // Results are hidden in the CSS so we don't see the scaffolding after #benefits
            $(Results.settings.elements.page).show();

            createDiscountPopOver();
        });

        $(document).on("populateFeaturesStart", function onPopulateFeaturesStart() {
            meerkat.modules.performanceProfiling.startTest('results');

        });

        $(Results.settings.elements.resultsContainer).on("populateFeaturesEnd", function onPopulateFeaturesEnd() {

            var time = meerkat.modules.performanceProfiling.endTest('results');

            var score;
            if (time < 800) {
                score = meerkat.modules.performanceProfiling.PERFORMANCE.HIGH;
            } else if (time < 8000 && meerkat.modules.performanceProfiling.isIE8() === false) {
                score = meerkat.modules.performanceProfiling.PERFORMANCE.MEDIUM;
            } else {
                score = meerkat.modules.performanceProfiling.PERFORMANCE.LOW;
            }

            Results.setPerformanceMode(score);

        });


        $(document).on("resultPageChange", function (event) {

            var pageData = event.pageData;
            if (_.isNull(pageData.measurements)) {
                return false;
            }

            meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
                additionalData: {},
                onAfterEventMode: 'Pagination'
            });

        });

        $(document).on("FeaturesRendered", function () {

            $(Features.target + " .expandable > " + Results.settings.elements.features.values).on("mouseenter", function () {
                var featureId = $(this).attr("data-featureId");
                var $hoverRow = $(Features.target + ' [data-featureId="' + featureId + '"]');

                $hoverRow.addClass(Results.settings.elements.features.expandableHover.replace(/[#\.]/g, ''));
            })
                .on("mouseleave", function () {
                    var featureId = $(this).attr("data-featureId");
                    var $hoverRow = $(Features.target + ' [data-featureId="' + featureId + '"]');

                    $hoverRow.removeClass(Results.settings.elements.features.expandableHover.replace(/[#\.]/g, ''));
                });

            var coverType = meerkat.modules.health.getCoverType();

            if (coverType === 'E') {
                $('.featuresList .hospitalCover, .featuresList .selection_Hospital').addClass('hidden');
            }
            if (coverType === 'H') {
                $('.featuresList .extrasCover, .featuresList .selection_extra').addClass('hidden');
            }

        });
    }

    /**
     * Utility function to find an object by object value.
     * @param array
     * @param toFind
     * @param index
     * @returns {*}
     * @private
     */
    function _findByKey(array, toFind, index) {
        for (var i = 0, len = array.length; i < len; i++) {
            if (toFind == array[i][index]) {
                return array[i];
            }
        }
        return null;
    }


    /**
     * Reset the object to remove "do not render" flag
     * i.e. if the user changes selected benefits.
     * @private
     */
    function _resetSelectionsStructureObject() {
        var structure = Features.getPageStructure();
        for (var i = 0; i < structure.length; i++) {
            if (typeof structure[i].children !== 'undefined' && structure[i].children.length) {
                for (var m = 0; m < structure[i].children.length; m++) {
                    delete structure[i].children[m].doNotRender;
                }
            }
        }
    }

    /**
     * This function copies the benefits from the parent's pageStructure object, and injects it into the "selections" object.
     * We cannot splice from the original object, as if someone changes their filter, a benefit that used to be selected will not appear anymore.
     * We shouldn't store the object in memory twice, as its 100kb.
     * We can't set a property onto the object, without first removing the property after every rebuild.
     * @param injectIntoParent
     * @param injectFromParent
     * @private
     */
    function _setupSelectedBenefits(injectIntoParent, injectFromParent) {

        // Fetch the relevant objects so we can update the features structure
        var structure = Features.getPageStructure();

        // This is the object we are going to inject the selected benefits into.
        var selectedBenefitsStructureObject = _findByKey(structure, injectIntoParent, 'name');

        // reset it on each build, as benefits could change
        selectedBenefitsStructureObject.children = [];
        // this is where we are going to pull the children benefits from.
        var featuresStructureCover = _findByKey(structure, injectFromParent, 'name');

        // For each of the selected benefits
        for (var i = 0; i < selectedBenefitsList.length; i++) {
            var putInShortList = _findByKey(featuresStructureCover.children, selectedBenefitsList[i], 'id');
            if (putInShortList) {
                selectedBenefitsStructureObject.children.push($.extend({}, putInShortList));
                putInShortList.doNotRender = true;
            }
        }
    }

    function breakpointTracking() {

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function resultsXsBreakpointEnter() {
            if (meerkat.modules.journeyEngine.getCurrentStep().navigationId === "results") {
                startColumnWidthTracking();
            }
        });

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function resultsXsBreakpointLeave() {
            stopColumnWidthTracking();
        });

    }

    function startColumnWidthTracking() {
        if (meerkat.modules.deviceMediaState.get() === 'xs' && Results.getDisplayMode() === 'features') {
            Results.view.startColumnWidthTracking($(window), Results.settings.render.features.numberOfXSColumns, false);
            Results.pagination.setCurrentPageNumber(1);
            Results.pagination.resync();
        }
    }

    function stopColumnWidthTracking() {
        Results.view.stopColumnWidthTracking();
    }

    function recordPreviousBreakpoint() {
        previousBreakpoint = meerkat.modules.deviceMediaState.get();
    }

    // Wrapper around results component, load results data
    function get() {
        // Load rates before loading the results data (hidden fields are populated when rates are loaded).
        meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, {source: 'healthLoadRates'});
        meerkat.modules.health.loadRates(function afterFetchRates() {
            meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, {source: 'healthLoadRates'});
            meerkat.modules.resultsFeatures.fetchStructure('health2016').done(function () {
                Results.updateAggregatorEnvironment();
                Results.updateStaticBranch();
                Results.get();
            });
        });
    }

    // Wrapper around results component, load results data beofore result page
    function getBeforeResultsPage() {
        // Load rates before loading the results data (hidden fields are populated when rates are loaded).
        meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, {source: 'healthLoadRates'});
        meerkat.modules.health.loadRatesBeforeResultsPage(false, function afterFetchRates() {
            meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, {source: 'healthLoadRates'});
            meerkat.modules.resultsFeatures.fetchStructure('health2016').done(function () {
                Results.updateAggregatorEnvironment();
                Results.updateStaticBranch();
                Results.get();
            });
        });
    }

    // Get the selected product - a clone of the product object from the results component.
    function getSelectedProduct() {
        return selectedProduct;
    }

    function getSelectedProductPremium(frequency) {
        var selectedProduct = getSelectedProduct();
        return selectedProduct.premium[frequency];
    }

    function getFrequencyInLetters(frequency) {
        switch (frequency) {
            case 'weekly':
                return 'W';
            case 'fortnightly':
                return 'F';
            case 'monthly':
                return 'M';
            case 'quarterly':
                return 'Q';
            case 'halfyearly':
                return 'H';
            case 'annually':
                return 'A';
            default:
                return false;
        }
    }

    function getFrequencyInWords(frequency) {
        switch (frequency) {
            case 'W':
                return 'weekly';
            case 'F':
                return 'fortnightly';
            case 'M':
                return 'monthly';
            case 'Q':
                return 'quarterly';
            case 'H':
                return 'halfyearly';
            case 'A':
                return 'annually';
            default:
                return false;
        }
    }

    function getNumberOfPeriodsForFrequency(frequency) {
        switch (frequency) {
            case 'weekly':
                return 52;
            case 'fortnightly':
                return 26;
            case 'quarterly':
                return 4;
            case 'halfyearly':
                return 2;
            case 'annually':
                return 1;
            default:
                return 12;
        }
    }

    function getPaymentFrequencies() {
        return paymentFrequencyDictionary;
    }

    function setSelectedProduct(product, premiumChangeEvent, showIncPrice) {

        selectedProduct = product;

        // if updating premium, no need to write quote and update the dom as the product info isn't changing
        if (premiumChangeEvent === true) {
            meerkat.messaging.publish(moduleEvents.healthResults.PREMIUM_UPDATED, selectedProduct, showIncPrice);
        } else {
            // Set hidden fields with selected product info.
            var $_main = $('#mainform');
            if (product === null) {
	            _.each(['provider','productId','productNumber','productTitle','providerName','excessPerAdmission','excessPerPerson','excessPerPolicy','tier'], function(suffix) {
		            $_main.find('.health_application_details_' + suffix).val("");
	            });
            } else {
                $_main.find('.health_application_details_provider').val(selectedProduct.info.provider);
                $_main.find('.health_application_details_productId').val(selectedProduct.productId);
                $_main.find('.health_application_details_productNumber').val(selectedProduct.info.productCode);
                $_main.find('.health_application_details_productTitle').val(selectedProduct.info.productTitle);
                $_main.find('.health_application_details_providerName').val(selectedProduct.info.providerName);

	            var excessesAndCoPayment = meerkat.modules.healthUtils.getExcessesAndCoPayment(selectedProduct);
	            $_main.find('.health_application_details_excessPerAdmission').val(excessesAndCoPayment.excessPerAdmission);
	            $_main.find('.health_application_details_excessPerPerson').val(excessesAndCoPayment.excessPerPerson);
	            $_main.find('.health_application_details_excessPerPolicy').val(excessesAndCoPayment.excessPerPolicy);
	            $_main.find('.health_application_details_tier').val(selectedProduct.custom.reform.tier);

                meerkat.messaging.publish(moduleEvents.healthResults.SELECTED_PRODUCT_CHANGED, selectedProduct);
                if(!meerkat.site.skipResultsPopulation) {
                    $(Results.settings.elements.rows).removeClass("active");

                    var $targetProduct = $(Results.settings.elements.rows + "[data-productid='" + selectedProduct.productId + "']");
                    var targetPosition = $targetProduct.data('position') + 1;
                    $targetProduct.addClass("active");
                    Results.pagination.gotoPosition(targetPosition, true, false);
                }

                // update transaction details otherwise we will have to wait until people get to payment page
                meerkat.modules.writeQuote.write({
                    health_application_provider: selectedProduct.info.provider,
                    health_application_productId: selectedProduct.productId,
                    health_application_productName: selectedProduct.info.productCode,
                    health_application_productTitle: selectedProduct.info.productTitle
                }, false);
            }
        }

    }

    function resetSelectedProduct() {
        // Need to reset the health fund setting.
        meerkat.modules.healthFunds.unload();

        // Reset selected product.
        setSelectedProduct(null);

        meerkat.messaging.publish(moduleEvents.healthResults.SELECTED_PRODUCT_RESET);
    }

    // Load an individual product from the results service call. (used to refresh premium info on the payment step)
    function getProductData(callback) {
        meerkat.modules.health.loadRates(function afterFetchRates(data) {
            if (data === null) {

                // This has failed.
                callback(null);

            } else {

                var postData = meerkat.modules.journeyEngine.getFormData();

                // Override some form data to only return a single product.
                _.findWhere(postData, {name: "health_showAll"}).value = "N";
                _.findWhere(postData, {name: "health_onResultsPage"}).value = "N";
                _.findWhere(postData, {name: "health_incrementTransactionId"}).value = "N";

                // Dynamically add these fields because they are disabled when this method is called.
                postData.push({name: "health_payment_details_start", value: $("#health_payment_details_start").val()});
                postData.push({
                    name: "health_payment_details_type",
                    value: meerkat.modules.healthPaymentStep.getSelectedPaymentMethod()
                });
                postData.push({
                    name: "health_payment_details_frequency",
                    value: meerkat.modules.healthPaymentStep.getSelectedFrequency()
                });

                var healthQuoteResultsUrl = "ajax/json/health_quote_results.jsp";
                if (meerkat.modules.splitTest.isActive(40) || meerkat.site.isDefaultToHealthQuote) {
                    healthQuoteResultsUrl = "ajax/json/health_quote_results_ws.jsp";
                }

                meerkat.modules.comms.post({
                    url: healthQuoteResultsUrl,
                    data: postData,
                    cache: false,
                    errorLevel: "warning",
                    onSuccess: function onGetProductSuccess(data) {
                        Results.model.updateTransactionIdFromResult(data);

                        if (!data.results || !data.results.price || data.results.price.available === 'N') {
                            callback(null);
                        } else {
                            callback(data.results.price);
                        }

                    },
                    onError: function onGetProductError(data) {
                        callback(null);
                    }
                });
            }

        });
    }


    // Change the results templates to promote features to the 'selected' features row.

    function onBenefitsSelectionChange(selectedBenefits, callback) {

        selectedBenefitsList = selectedBenefits;

        // when hospital is set to off in [Customise Cover] hide the excess section
        var $excessSection = $component.find('.cell.excessSection');
        _.contains(selectedBenefits, 'Hospital') ? $excessSection.show() : $excessSection.hide();

        // If on the results step, reload the results data. Can this be more generic?
        if (typeof callback === 'undefined') {
            if (meerkat.modules.journeyEngine.getCurrentStepIndex() === 3) {
                get();
            }
        } else {
            callback();
        }

    }


    function onResultsLoaded() {

        if (meerkat.modules.deviceMediaState.get() == "xs") {
            startColumnWidthTracking();
        }
        if (meerkat.site.isCallCentreUser) {
            createPremiumsPopOver();
        }
    }

    function createDiscountPopOver(){
        $('#resultsPage .price').each(function () {

            var $this = $(this);
            var productId = $this.parents(Results.settings.elements.rows).attr("data-productId");
            var product = Results.getResultByProductId(productId);

            if (product.hasOwnProperty('promo') && product.promo.hasOwnProperty('discountText') && !_.isEmpty(product.promo.discountText)) {

                var position = meerkat.modules.deviceMediaState.get() === 'xs' ? 'top' : 'bottom';
                var text = product.promo.discountText;
                var $el = $this.parents(Results.settings.elements.rows).find('.discountPanel');
                meerkat.modules.popovers.create({
                    element: $el,
                    contentValue: text,
                    contentType: 'content',
                    showEvent: 'click',
                    position: {
                        my: position +' left',
                        at: 'top left'
                    },
                    style: {
                        classes: 'priceTooltips discount'
                    }
                });
            }
        });
    }

    /*
     * recreate the Simples tooltips over prices for Simples users
     * when the results get loaded/reloaded
     */
    function createPremiumsPopOver() {
        $('#resultsPage .price').each(function () {

            var $this = $(this);
            var productId = $this.parents(Results.settings.elements.rows).attr("data-productId");
            var product = Results.getResultByProductId(productId);

            if (product.hasOwnProperty('premium')) {
                var htmlTemplate = _.template(templates.premiumsPopOver);

                var text = htmlTemplate({
                    product: product,
                    frequency: Results.getFrequency()
                });

                meerkat.modules.popovers.create({
                    element: $this,
                    contentValue: text,
                    contentType: 'content',
                    showEvent: 'mouseenter',
                    position: {
                        my: 'top center',
                        at: 'bottom center'
                    },
                    style: {
                        classes: 'priceTooltips'
                    }
                });
            } else {
                meerkat.modules.errorHandling.error({
                    message: 'product does not have property premium',
                    page: 'healthResults.js',
                    description: 'createPremiumsPopOver()',
                    errorLevel: 'silent',
                    data: product
                });
            }
        });
    }

    function rankingCallback(product, position) {

        var data = {};
        var frequency = Results.getFrequency(); // eg monthly.yearly etc..
        var prodId = product.productId.replace('PHIO-HEALTH-', '');
        data["rank_productId" + position] = prodId;
        data["rank_price_actual" + position] = product.premium[frequency].value.toFixed(2);
        data["rank_price_shown" + position] = product.premium[frequency].lhcfreevalue.toFixed(2);
        data["rank_frequency" + position] = frequency;
        data["rank_lhc" + position] = product.premium[frequency].lhc;
        data["rank_rebate" + position] = product.premium[frequency].rebate;
        data["rank_discounted" + position] = product.premium[frequency].discounted;
        data["rank_premiumDiscountPercentage" + position] = product.premium[frequency].discountPercentage;

        var specialOffer = meerkat.modules.healthUtils.getSpecialOffer(product);
        data["rank_specialOffer" + position] = specialOffer.specialOffer;
        data["rank_specialOfferTerms" + position] = specialOffer.specialOfferTerms;

        if (_.isNumber(best_price_count) && position < best_price_count) {
            data["rank_provider" + position] = product.info.provider;
            data["rank_providerName" + position] = product.info.providerName;
            data["rank_productName" + position] = product.info.productTitle;
            data["rank_productCode" + position] = product.info.productCode;
            data["rank_premium" + position] = product.premium[Results.settings.frequency].lhcfreetext;
            data["rank_premiumText" + position] = product.premium[Results.settings.frequency].lhcfreepricing;
            data["rank_altPremium" + position] = product.altPremium[Results.settings.frequency].lhcfreetext;
            data["rank_altPremiumText" + position] = product.altPremium[Results.settings.frequency].lhcfreepricing;


        }

        // Do this only for the best price product
        if (position === 0) {

            var benefitCodes= $.map(meerkat.modules.healthUtils.getSelectedBenefits(product.info.ProductType),
                function(b) {
                    return b.code;
                });
            var situation = meerkat.modules.healthUtils.getSelectedHealthSituation().name;
            var currentPHI = meerkat.modules.healthUtils.getPrimaryCurrentPHI();
            var excessesAndCoPayment = meerkat.modules.healthUtils.getExcessesAndCoPayment(product);

            var healthMembership = $.trim($('#health_situation_healthCvr option:selected').text());

            data["rank_healthMembership" +  position] = healthMembership;
            data["rank_healthSituation" + position] = situation;
            data["rank_benefitCodes" + position] = benefitCodes.join(',');
            data["rank_coverType" + position] = product.info.ProductType;
            data["rank_primaryCurrentPHI" + position] = currentPHI;
            if (product.promo.hospitalPDF != 'health_brochure.jsp?pdf=') {
                data["rank_hospitalPdsUrl" +  position] = product.promo.hospitalPDF;
            }
            if (product.promo.extrasPDF != 'health_brochure.jsp?pdf=') {
                data["rank_extrasPdsUrl" +  position] = product.promo.extrasPDF;
            }
            data["rank_excessPerAdmission" + position] = excessesAndCoPayment.excessPerAdmission;
            data["rank_excessPerPerson" + position] = excessesAndCoPayment.excessPerPerson;
            data["rank_excessPerPolicy" + position] = excessesAndCoPayment.excessPerPolicy;
            data["rank_coPayment" + position] = excessesAndCoPayment.coPayment;
        }

        return data;
    }

    /**
     * This function has been refactored into calling a core resultsTracking module.
     * It has remained here so verticals can run their own unique calls.
     */
    function publishExtraSuperTagEvents() {

        meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
            additionalData: {
                preferredExcess: getPreferredExcess(),
                paymentPlan: Results.getFrequency(),
                sortBy: (Results.getSortBy() === "benefitsSort" ? "Benefits" : "Lowest Price"),
                simplesUser: meerkat.site.isCallCentreUser,
                isLhcApplicable: isLhcApplicable
            },
            onAfterEventMode: 'Load'
        });
    }

    function getPreferredExcess() {
        var excess = null;
        switch ($("#health_excess").val()) {
            case '1':
                excess = "0";
                break;
            case '2':
                excess = "1-250";
                break;
            case '3':
                excess = "251-500";
                break;
            default:
                excess = "ALL";
                break;
        }
        return excess;
    }

    function setLhcApplicable(lhcLoading) {
        isLhcApplicable = lhcLoading > 0 ? 'Y' : 'N';
    }

    function init() {
        meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);
    }


    function setSelectedBenefitsList(selectedBenefits) {
        selectedBenefitsList = selectedBenefits;
    }

    function hideNavigationLink() {
        $('.floated-next-arrow').addClass('hidden');
        $('.floated-previous-arrow').addClass('hidden');
    }

    function setCallCentreText() {
        $openingHours = _.isNull($openingHours) ? $('[data-step="results"] [data-livechat="target"] .today-hours') : $openingHours;
        // add talk to experts blurb just for results page
        if ($openingHours.text().length > 0) {
            $openingHours.text(meerkat.site.ccOpeningHoursText + $openingHours.text());
        }
    }

    function resetCallCentreText() {
        if (!_.isNull($openingHours)) {
            $openingHours.text($openingHours.text().replace(meerkat.site.ccOpeningHoursText, ''));
        }
    }

    meerkat.modules.register('healthResults', {
        init: init,
        events: moduleEvents,
        initPage: initPage,
        onReturnToPage: onReturnToPage,
        get: get,
        getBeforeResultsPage: getBeforeResultsPage,
        getSelectedProduct: getSelectedProduct,
        setSelectedProduct: setSelectedProduct,
        resetSelectedProduct: resetSelectedProduct,
        getProductData: getProductData,
        getSelectedProductPremium: getSelectedProductPremium,
        getNumberOfPeriodsForFrequency: getNumberOfPeriodsForFrequency,
        getFrequencyInLetters: getFrequencyInLetters,
        getFrequencyInWords: getFrequencyInWords,
        getPaymentFrequencies: getPaymentFrequencies,
        stopColumnWidthTracking: stopColumnWidthTracking,
        recordPreviousBreakpoint: recordPreviousBreakpoint,
        rankingCallback: rankingCallback,
        publishExtraSuperTagEvents: publishExtraSuperTagEvents,
        setLhcApplicable: setLhcApplicable,
        resultsStepIndex: resultsStepIndex,
        setSelectedBenefitsList: setSelectedBenefitsList,
        hideNavigationLink: hideNavigationLink,
        setCallCentreText: setCallCentreText,
        resetCallCentreText: resetCallCentreText
    });

})(jQuery);
