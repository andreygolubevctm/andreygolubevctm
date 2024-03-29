;(function ($) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        selectedProduct = null,
        previousBreakpoint,
        best_price_count = 5,
        isLhcApplicable = 'N',
        selectedBenefitsList,
        selectedClinicalBenefitsList,
	    ambulanceAccidentCoverList,
        premiumIncreaseContent = $('.healthPremiumIncreaseContent'),
        maxMilliSecondsForMessage = $("#maxMilliSecToWait").val(),
        resultsStepIndex = 3,
        extendedFamilyResultsRulesAjax = null,
        providersReturned = [],
        extendedFamilyResultsRulesData = {},
        extendedFamilyResultsRules = '',
        exception = meerkat.logging.exception,
        toggleCell = {
            "id": 0,
            "name": "Toggle",
            "type": "category",
            "resultPath": "hospital.benefits.TOGGLE",
            "vertical": "health_cc",
            "shortlistKey": "TOGGLE",
            "children": [],
            "safeName": "Toggle",
            "shortlistable": true,
            "classStringForInlineLabel": "category collapsed ",
            "contentClassString": "",
            "classString": "category collapsed view-clinical-categories-toggle ",
            "classStringForInlineLabelCover": "",
            "toggle": true,
            "benefitsQuantityClass": "clinical-category-quantity"
        };

        templates = {
            premiumsPopOver:
            '{{ if(extraPopOverData.length > 0) { }}'+
                '{{ for(var i in extraPopOverData) { }}'+
                '<span class="providerSpecificContent">{{= extraPopOverData[i].providerBlurb}}</span>' +
                '<hr/>'+
                '{{ } }}' +
            '{{ } }}'+
            '{{ if(product.premium.hasOwnProperty(frequency)) { }}' +
                '<h6>Customer Pays:</h6>'+
                '<ul class="price-list">'+
                    '<li><strong>Base Premium{{= (product.info.provider == "MYO" ? " (excl Vitality)" : "") }}: </strong>'+'<span>{{= product.premium[frequency].base }}</span></li>'+
                    '<li><strong>Fortnightly Premium: </strong>'+'<span>{{= product.premium.fortnightly.text }}</span></li>'+
                    '<li><strong>Monthly Premium: </strong>'+'<span>{{= product.premium.monthly.text }}</span></li>'+
                    '<li><strong>Annual Premium: </strong>'+'<span>{{= product.premium.annually.text }}</span></li>'+
                    '<li><strong>Price including Rebate, excluding LHC: </strong>'+'<span>{{= product.premium[frequency].lhcfreetext }}</span></li>'+
                '</ul>'+
                '{{ if(usefulLinks.length > 0) { }}'+
                    '<hr/>'+
                    '<h6>Useful Links:</h6>'+
                    '<ul class="link-list">'+
                        '{{ for(var i in usefulLinks) { }}'+
                            "<li><a target='_blank' href='{{= usefulLinks[i].url}}'>{{= usefulLinks[i].name}}</a></li>"+
                        '{{ } }}' +
                    '</ul>'+
                '{{ } }}'+
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
                url: healthQuoteResultsUrl + (!_.isEmpty(meerkat.site.urlStyleCodeId) && (_.indexOf(["wfdd", "bddd"], meerkat.site.urlStyleCodeId) >= 0) ? "?brandCode=" + meerkat.site.urlStyleCodeId : ""),
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
                            key: 'No Waiting Period',
                            value: 'No'
                        }
                    ]
                },
                rankings: {
                    triggers: ['RESULTS_DATA_READY'],
                    callback: meerkat.modules.healthResults.rankingCallback,
                    filterUnavailableProducts: false,
                    forceIdNumeric: true
                },
                incrementTransactionId: false,
                setContainerWidthCB: getElementWidth
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

                providersReturned = [];
                extendedFamilyResultsRulesData = {};
                extendedFamilyResultsRules = "";
                extendedFamilyResultsRulesAjax = null;
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

            // if online user load quote from brochures edm (with attached productId), compare it with returned result set, if it is in there, select it, and go to apply stage.
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

            $(".view-clinical-categories-toggle").on("click", function() {
                $('.clinical-benefits-text').addClass('clinical-toggle-link-not-underlined');
                if($('.clinical-categories-result-card').hasClass('hidden')) {
                    $('.clinical-categories-result-card').removeClass('hidden');
                    $('.clinical-benefits-text').text('Hide details');
                    $('.contentInner .clinical-benefits-icon').removeClass('icon-angle-down').addClass('icon-angle-up');
                } else {
                    $('.clinical-categories-result-card').addClass('hidden');
                    $('.clinical-benefits-text').text('View details');
                    $('.contentInner .clinical-benefits-icon').removeClass('icon-angle-up').addClass('icon-angle-down');
                }
            });

            $('.clinical-benefits-text').on('mouseenter', function () {
                $(this).removeClass('clinical-toggle-link-not-underlined').addClass('clinical-toggle-link-underlined');
            }).on('mouseleave', function () {
                $(this).removeClass('clinical-toggle-link-underlined').addClass('clinical-toggle-link-not-underlined');
            });

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

        meerkat.messaging.subscribe(meerkatEvents.device.RESIZE_DEBOUNCED, function resultsWindowResized() {
            if (meerkat.modules.journeyEngine.getCurrentStep().navigationId === "results") {
                Results.view.calculateResultsContainerWidth();
            }
        });
    }


    function getProvidersReturned() {
        return providersReturned;
    }


    function setExtendedFamilyResultsRules(){

        extendedFamilyResultsRulesAjax = meerkat.modules.comms.get({
            url: 'spring/content/getsupplementary.json',
            data: {
                vertical: 'HEALTH',
                key: 'ExtendedFamilyRulesResultsPageInfo'
            },
            cache: true,
            dataType: 'json',
            useDefaultErrorHandling: false,
            errorLevel: 'silent',
            timeout: 5000,
            onSuccess: function onSubmitSuccess(data) {

                //get each extended family rule returned from the content_supplementary table
                data.supplementary.forEach(function(item) {
                    extendedFamilyResultsRulesData[item.supplementaryKey] = item.supplementaryValue;
                });

                //build extended family rules HTML for the providers returned on the results page
                providersReturned.forEach(function(provider){
                    if (extendedFamilyResultsRulesData[provider]) {
                        extendedFamilyResultsRules += extendedFamilyResultsRulesData[provider];
                    }
                });

                //insert returned rules into Dialog box
                $('.extFamilyFundSpecificRules').html(extendedFamilyResultsRules);
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
        var selectedBenefits = [],
            isFirstClinical = true,
            isHospital = injectIntoParent === 'Hospital Selections';

        selectedBenefitsList.forEach(function(benefit) {
            var isClinical = selectedClinicalBenefitsList.includes(benefit);
            if(isClinical && isFirstClinical) {
                isFirstClinical = false;
                selectedBenefits.push('TOGGLE');
            }
            selectedBenefits.push(benefit);
        });

        // Fetch the relevant objects so we can update the features structure
        var structure = Features.getPageStructure();

        // This is the object we are going to inject the selected benefits into.
        var selectedBenefitsStructureObject = _findByKey(structure, injectIntoParent, 'name');

        // reset it on each build, as benefits could change
        selectedBenefitsStructureObject.children = [];
        // this is where we are going to pull the children benefits from.
        var featuresStructureCover = _findByKey(structure, injectFromParent, 'name');

        if (isHospital) {
            if(featuresStructureCover && featuresStructureCover.children && featuresStructureCover.children.length !== 0) {
                var indexOfToggle;
                featuresStructureCover.children.forEach(function(c) {
                    c.isHospital = undefined;
                    indexOfToggle = c.id === toggleCell.id;
                });
                if(!indexOfToggle || indexOfToggle === -1) {
                    featuresStructureCover.children.push(toggleCell);
                }
            }
        }

        // For each of the selected benefits
        for (var i = 0; i < selectedBenefits.length; i++) {
            var putInShortList = _findByKey(featuresStructureCover.children, selectedBenefits[i], 'shortlistKey');
            if (putInShortList) {
                putInShortList.isHospital = isHospital;
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
            meerkat.modules.resultsFeatures.fetchStructure(meerkat.modules.health.getSimplesCategoryVersion()).then(function () {
                Results.updateAggregatorEnvironment();
                Results.updateStaticBranch();
                Results.get();
            })
            .catch(function onError(obj, txt, errorThrown) {
                exception(txt + ': ' + errorThrown);
            });
        });
    }

    // Wrapper around results component, load results data beofore result page
    function getBeforeResultsPage() {
        // Load rates before loading the results data (hidden fields are populated when rates are loaded).
        meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, {source: 'healthLoadRates'});
        meerkat.modules.health.loadRatesBeforeResultsPage(false, function afterFetchRates() {
            meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, {source: 'healthLoadRates'});
            meerkat.modules.resultsFeatures.fetchStructure(meerkat.modules.health.getSimplesCategoryVersion()).then(function () {
                Results.updateAggregatorEnvironment();
                Results.updateStaticBranch();
                Results.get();
            })
            .catch(function onError(obj, txt, errorThrown) {
                exception(txt + ': ' + errorThrown);
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
	            _.each(['provider', 'providerId', 'productId','productNumber','productTitle','providerName','excessPerAdmission','excessPerPerson','excessPerPolicy','tier'], function(suffix) {
		            $_main.find('.health_application_details_' + suffix).val("");
	            });
            } else {
                $_main.find('.health_application_details_provider').val(selectedProduct.info.provider);
                $_main.find('.health_application_details_providerId').val(selectedProduct.info.providerId);
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
                    health_application_providerId: selectedProduct.info.providerId,
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
                var selectedProduct = Results.getSelectedProduct();
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

                if(selectedProduct.productUpi) {
                    postData.push({
                        name: 'health_application_productUpi',
                        value: selectedProduct.productUpi
                    });
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

    function getProviderSpecificPopoverData(fundCode){
        var extraPopOverData = [];
        switch(fundCode){
            case 'AHM':
                extraPopOverData.push(
                    {"providerBlurb" : "AHM are affiliated with Medibank health insurance who are one of Australia&apos;s biggest brands. You will get a fresh approach to health insurance, mixed with the big brand agreements of Medibank and for what you need they are giving really great value."}
                );
                break;
            case 'AUF':
                extraPopOverData.push(
                    {"providerBlurb" : "Australian Unity are Australia&apos;s oldest health fund, starting in 1870, so you will be looked after by a fund with more experience than any other, and for what you need they are giving really great value."}
                );
                break;
            case 'BUD':
                extraPopOverData.push(
                    {"providerBlurb" : "<ul><li>We are backed by GHMBA who have over 80 years&apos; experience and cover more than 230,000 Australians nationally.</li><li>We offer Hospital In The Home and Rehabilitation In The Home programs, meaning you could receive treatment at home rather than in hospital.</li><li>Our Gap Cover scheme covers you for up to 20% above the MBS fee.</li></ul>"}
                );
                break;
            case 'BUP':
                extraPopOverData.push(
                    {"providerBlurb" : "Bupa are Australia&apos;s largest health fund in terms of members. They will give you some really great member benefits and the security of being with an industry leader, and for what you need they are giving really great value."}
                );
                break;
            case 'CBH':
                extraPopOverData.push(
                    {"providerBlurb" : "Being aligned with such a big financial institution means CBHS can give great returns and for what you need they are giving really great value."}
                );
                break;
            case 'CUA':
                extraPopOverData.push(
                    {"providerBlurb" : "CUA Health are part of Credit Union Australia – Australia&apos;s largest member owned financial institution, so you know you&apos;re in good hands, and for what you need they are giving really great value."}
                );
                break;
            case 'FRA':
                extraPopOverData.push(
                    {"providerBlurb" : "Frank are a non for profit health fund, backed by a major player, GMHBA who have been around for over 80 years. Frank like to keep health insurance as simple as possible and for what you need they are giving really great value."}
                );
                break;
            case 'GMH':
                extraPopOverData.push(
                    {"providerBlurb" : "GMHBA are a not for profit health fund with over 80 year&apos;s industry experience and for what you need they are giving really great value."}
                );
                break;
            case 'HBF':
                extraPopOverData.push(
                    {"providerBlurb" : "HBF are a non for profit health fund, with over a million members mostly based in Western Australia they are spreading rapidly across Australia and for what you need they are giving really great value."}
                );
                break;
            case 'HCF':
                extraPopOverData.push(
                    {"providerBlurb" : "HCF are Australia&apos;s third largest fund and the largest non for profit health fund in Australia. So you&apos;ll be covered by a fund that puts its members first and for what you need they are giving really great value."}
                );
                break;
            case 'HIF':
                extraPopOverData.push(
                    {"providerBlurb" : "HIF are a not for profit health fund who have award winning hospital cover, and for what you&apos;re after they are giving you really great value."}
                );
                break;
            case 'MYO':
                extraPopOverData.push(
                    {"providerBlurb" : "AIA Australia is a leading life insurer with over 45 years of local experience. When it comes to their health insurance, they believe it should benefit you every day – not just when things go wrong. That’s why they include AIA Vitality, the health and wellbeing program that rewards you for learning more about your health and taking steps to improve it. <p>Before getting into the hospital cover, let me explain how to get the best value out of the program. This is done by reaching AIA Vitality Silver Status which anyone can achieve. Getting there is as simple as spending 30 minutes in total doing online activities focused on your health and visiting a pharmacy or doctor for a health check to unlock additional benefits and discounts, which I will get to in a moment.</p>"}
                );
                break;
            case 'NHB':
                extraPopOverData.push(
                    {"providerBlurb" : "Navy Health design their policies to give back as much as they can to the family members of former defence force members and for what you need they are giving really great value."}
                );
                break;
            case 'NIB':
                extraPopOverData.push(
                    {"providerBlurb" :"NIB are one of Australia&apos;s largest health funds, providing health insurance to over 1 million Australian and New Zealand residents. Their hospital and extras benefits are really easy to understand and for what you need they are giving really great value."}
                );
                break;
            case 'QTS':
                extraPopOverData.push(
                    {"providerBlurb" :"<p>Looking for more rewarding health insurance?</p><p>Qantas Health Insurance offers a range of covers, so if you&rsquo;re young and single, newly married, busy raising a family or enjoying a well-earned retirement, we have you covered.</p><p>Plus as the only health insurance that comes with Qantas Points you could be turning your health premiums into your next holiday.</p>"}
                );
                break;
            case 'UHF':
                extraPopOverData.push(
                    {"providerBlurb" :"Union Health is a not for profit health fund that is 100% member owned. Their profits go straight back into providing affordable, cost effective options to suit members needs and for what you need they are giving you really great value."}
                );
                break;
            case 'QCH':
                extraPopOverData.push(
                    {"providerBlurb" :"Queensland Country Health are a non for profit fund based here in Queensland, giving you the peace of mind you are dealing with a local fund, and for what you need they are giving really great value."}
                );
                break;
            case 'QTU':
                extraPopOverData.push(
                    {"providerBlurb" : "TUH was started by a group of teachers over 40 years ago to ensure that their members were getting the best returns available from their health insurance and for what you need they are giving really great value."}
                );
                break;
            case 'WFD':
                extraPopOverData.push(
                    {"providerBlurb" : "Westfund are a not for profit health fund who are really highly rated in terms of customer satisfaction, and for what you need they are giving really great value."}
                );
                break;
            case 'HEA':
                extraPopOverData.push(
                    {"providerBlurb" : "Health.com.au is a very simple fund to understand. They have one thing in mind, and that’s to do what’s right for their customers. They take the complexity out of health insurance with simple and easy-to-understand products, and for what you need, they are giving really great value."}
                );
                break;
            default:
                break;
        }
        return extraPopOverData;
    }

    function getUsefulLinks(fundCode){
        var usefulLinks = [];
        switch(fundCode){
            case 'AHM':
                usefulLinks.push(
                    {"name" : "Fund Page", "url": "https://ctm.livepro.com.au/goto/ahm1"},
                    {"name" : "Hospital Network", "url": "https://ctm.livepro.com.au/goto/ahm-agreement-hospitals-amp-gap-scheme"},
                    {"name" : "Gap Scheme Doctors", "url": "https://ctm.livepro.com.au/goto/ahm-agreement-hospitals-amp-gap-scheme"},
                    {"name" : "Dental Agreements", "url": "https://ctm.livepro.com.au/goto/ahm-no-gap-dental"}

                );
                break;
            case 'AUF':
                usefulLinks.push(
                    {"name" : "Fund Page", "url": "https://ctm.livepro.com.au/goto/australian-unity1"},
                    {"name" : "Hospital Network", "url": "https://ctm.livepro.com.au/goto/australian-unity-agreement-hospitals-amp-gap-scheme"},
                    {"name" : "Gap Scheme Doctors", "url": "https://ctm.livepro.com.au/goto/australian-unity-agreement-hospitals-amp-gap-scheme"},
                    {"name" : "Dental agreements", "url": "https://ctm.livepro.com.au/goto/australian-unity-dental-agreements"},
                    {"name" : "Optical Benefits", "url": "https://ctm.livepro.com.au/goto/australian-unity-optical-benefits"}
                );
                break;
            case 'BUD':
                usefulLinks.push(
                    {"name" : "Privatehealth.gov.au", "url": "http://www.privatehealth.gov.au/dynamic/InsurerDetails.aspx?code=GMH"},
                    {"name" : "Hospital Network", "url": "https://www.budgetdirect.com.au/content/dam/budgetdirect/website-assets/participating-private-hospitals.pdf"},
                    {"name" : "Travel Vaccines", "url": "https://www.budgetdirect.com.au/content/dam/budgetdirect/website-assets/approved-travel-vaccinations.pdf"}
                );
                break;
            case 'BUP':
                usefulLinks.push(
                    {"name" : "Privatehealth.gov.au", "url": "http://www.privatehealth.gov.au/dynamic/InsurerDetails.aspx?code=BUP"},
                    {"name" : "Hospital Network", "url": "http://www.bupa.com.au/find-a-provider"},
                    {"name" : "Dental Agreement", "url": "http://www.bupa.com.au/find-a-provider"},
                    {"name" : "Extra Benefit - Specsavers Optical", "url": "https://www.specsavers.com.au/health-funds/bupa"},
                    {"name" : "Extra Benefit - Home Doctor", "url": "https://homedoctor.com.au/"}
                );
                break;
            case 'CBH':
                usefulLinks.push(
                    {"name" : "Privatehealth.gov.au", "url": "http://www.privatehealth.gov.au/dynamic/InsurerDetails.aspx?code=CBH"},
                    {"name" : "Hospital Network", "url": "https://www.cbhs.com.au/members/claims-information/hospital-search"},
                    {"name" : "Dental Agreement", "url": "https://www.cbhs.com.au/members/member-information/choice-network-providers/find-your-provider"},
                    {"name" : "Optical Agreement", "url": "https://www.cbhs.com.au/members/member-information/choice-network-providers/find-your-provider"},
                    {"name" : "Eligibility", "url": "https://www.cbhs.com.au/join-cbhs/joining-cbhs/who-can-join-"}
                );
                break;
            case 'CUA':
                usefulLinks.push(
                    {"name" : "Fund Page", "url": "https://ctm.livepro.com.au/goto/cua"},
                    {"name" : "Hospital Network", "url": "https://ctm.livepro.com.au/goto/cua-agreement-hospitals-amp-gap-scheme"},
                    {"name" : "Gap Scheme Doctors", "url": "https://ctm.livepro.com.au/goto/cua-agreement-hospitals-amp-gap-scheme"}
                );
                break;
            case 'FRA':
                usefulLinks.push(
                    {"name" : "Fund Page", "url": "https://ctm.livepro.com.au/goto/frank"},
                    {"name" : "Hospital Network", "url": "https://ctm.livepro.com.au/goto/frank-agreement-hospitals-amp-gap-scheme"},
                    {"name" : "Gap Scheme", "url": "https://ctm.livepro.com.au/goto/frank-agreement-hospitals-amp-gap-scheme"},
                    {"name" : "Dental Agreements", "url": "https://ctm.livepro.com.au/goto/frank-dental-agreements"}
                );
                break;
            case 'GMH':
                usefulLinks.push(
                    {"name":  "Fund Page", "url": "https://ctm.livepro.com.au/goto/gmhba1"},
                    {"name":  "Hospital Network", "url": "https://ctm.livepro.com.au/goto/gmhba-agreement-hospitals-amp-gap-scheme"},
                    {"name":  "Gap Scheme Doctors", "url": "https://ctm.livepro.com.au/goto/gmhba-agreement-hospitals-amp-gap-scheme"},
                    {"name":  "Dental Agreements", "url": "https://ctm.livepro.com.au/goto/gmhba-dental-agreements"}
                );
                break;
            case 'HBF':
                usefulLinks.push(
                    {"name" : "Privatehealth.gov.au", "url": "http://www.privatehealth.gov.au/dynamic/InsurerDetails.aspx?code=HBF"},
                    {"name" : "Hospital Network", "url": "http://confluence:8090/display/CTMKB/Agreement+Hospitals"}
                );
                break;
            case 'HCF':
                usefulLinks.push(
                    {"name" : "Privatehealth.gov.au", "url": "http://www.privatehealth.gov.au/dynamic/InsurerDetails.aspx?code=HCF"},
                    {"name" : "Hospital Network", "url": "https://www.hcf.com.au/locations/participating-hospitals"},
                    {"name" : "Dental Agreement", "url": ""}
                );
                break;
            case 'HIF':
                usefulLinks.push(
                    {"name": "Fund Page", "url": "https://ctm.livepro.com.au/goto/hif1"},
                    {"name": "Hospital Network", "url": "https://ctm.livepro.com.au/goto/hif-agreement-hospitals-amp-gap-scheme"},
                    {"name": "Gap Scheme Doctors", "url": "https://ctm.livepro.com.au/goto/hif-agreement-hospitals-amp-gap-scheme"},
                    {"name": "Dental Benefits", "url": "https://ctm.livepro.com.au/goto/hif-dental-benefits"},
                    {"name": "Optical Benefits", "url": "https://ctm.livepro.com.au/goto/hif-optical-benefits"}
                );
                break;
            case 'MYO':
                usefulLinks.push(
                    {"name": "Fund Page", "url": "https://ctm.livepro.com.au/goto/aia-health-insurance"},
                    {"name": "Hospital Network", "url": "https://ctm.livepro.com.au/goto/agreement-hospitals-amp-gap-scheme-aia-health-insurance"},
                    {"name": "Gap Scheme Doctors", "url": "https://ctm.livepro.com.au/goto/agreement-hospitals-amp-gap-scheme-aia-health-insurance"},
                    {"name": "Dental Agreements", "url": "https://ctm.livepro.com.au/goto/aia-health-insurance-dental-agreements"}
                );
                break;
            case 'NHB':
                usefulLinks.push(
                    {"name" : "Privatehealth.gov.au", "url": "http://www.privatehealth.gov.au/dynamic/InsurerDetails.aspx?code=NHB"},
                    {"name" : "Hospital Network", "url": "https://navyhealth.com.au/member-services/providers/hospital-search/"},
                    {"name" : "Eligibility", "url": "http://canijoin.com.au/"}
                );
                break;
            case 'NIB':
                usefulLinks.push(
                    {"name": "Fund Page", "url": "https://ctm.livepro.com.au/goto/nib"},
                    {"name": "Hospital Network", "url": "https://ctm.livepro.com.au/goto/nib-agreement-hospitals-amp-gap-scheme"},
                    {"name": "Gap Scheme Doctors", "url": "https://ctm.livepro.com.au/goto/nib-agreement-hospitals-amp-gap-scheme"},
                    {"name": "Dental Agreements", "url": "https://ctm.livepro.com.au/goto/nib-dental-agreements"},
                    {"name": "Optical Benefits", "url": "https://ctm.livepro.com.au/goto/nib-optical-benefits"}
                );
                break;
            case 'QTS':
                usefulLinks.push(
                    {"name": "Fund Page", "url": "https://ctm.livepro.com.au/goto/nib"},
                    {"name": "Hospital Network", "url": "https://ctm.livepro.com.au/goto/nib-agreement-hospitals-amp-gap-scheme"},
                    {"name": "Gap Scheme Doctors", "url": "https://ctm.livepro.com.au/goto/nib-agreement-hospitals-amp-gap-scheme"},
                    {"name": "Dental Agreements", "url": "https://ctm.livepro.com.au/goto/nib-dental-agreements"},
                    {"name": "Optical Benefits", "url": "https://ctm.livepro.com.au/goto/nib-optical-benefits"}
                );
                break;
            case 'UHF':
                usefulLinks.push(
                    {"name": "Fund Page", "url": "https://ctm.livepro.com.au/goto/union-health"},
                    {"name": "Hospital Network", "url": "https://ctm.livepro.com.au/goto/union-health-agreement-hospitals-amp-gap-scheme"},
                    {"name": "Gap Scheme Doctors", "url": "https://ctm.livepro.com.au/goto/union-health-agreement-hospitals-amp-gap-scheme"},
                    {"name": "Dental Agreements", "url": "https://ctm.livepro.com.au/goto/union-health-dental-agreements"},
                    {"name": "Optical Benefits", "url": "https://ctm.livepro.com.au/goto/union-health-optical-benefits"}
                );
                break;
            case 'QCH':
                usefulLinks.push(
                    {"name" : "Privatehealth.gov.au", "url": "http://www.privatehealth.gov.au/dynamic/InsurerDetails.aspx?code=QCH"},
                    {"name" : "Hospital Network", "url": "https://www.qldcountryhealth.com.au/members/hospital-network/find-a-hospital"}
                );
                break;
            case 'QTU':
                usefulLinks.push(
                    {"name": "Fund Page", "url": "https://ctm.livepro.com.au/goto/tuh"},
                    {"name": "Hospital Network", "url": "https://ctm.livepro.com.au/goto/tuh-agreement-hospitals-amp-gap-scheme"},
                    {"name": "Gap Scheme Doctors", "url": "https://ctm.livepro.com.au/goto/tuh-agreement-hospitals-amp-gap-scheme"},
                    {"name": "Dental Agreements", "url": "https://ctm.livepro.com.au/goto/tuh-dental-agreements"},
                    {"name": "Optical Benefits", "url": "https://ctm.livepro.com.au/goto/tuh-optical-benefits"}
                );
                break;
            case 'WFD':
                usefulLinks.push(
                    {"name": "Fund Page", "url": "https://ctm.livepro.com.au/goto/westfund1"},
                    {"name": "Hospital Network", "url": "https://ctm.livepro.com.au/goto/westfund-agreement-hospitals-amp-gap-scheme"},
                    {"name": "Gap Scheme Doctors", "url": "https://ctm.livepro.com.au/goto/westfund-agreement-hospitals-amp-gap-scheme"},
                    {"name": "Dental Agreements", "url": "https://ctm.livepro.com.au/goto/westfund-dental-agreements"},
                    {"name": "Optical Benefits", "url": "https://ctm.livepro.com.au/goto/westfund-optical-benefits"}
                );
                break;
            default:
                break;
        }
        return usefulLinks;
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
                    extraPopOverData: getProviderSpecificPopoverData(product.info.provider),
                    product: product,
                    usefulLinks: getUsefulLinks(product.info.provider),
                    frequency: Results.getFrequency()
                });

                meerkat.modules.popovers.create({
                    element: $this,
                    contentValue: text,
                    contentType: 'content',
                    showSolo: true,
                    showEvent: 'click',
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
        data["rank_premiumDiscountPercentage" + position] = product.premium[frequency].discountPercentage;
        var specialOffer = meerkat.modules.healthUtils.getSpecialOffer(product);
        data["rank_specialOffer" + position] = specialOffer.specialOffer;
        data["rank_specialOfferTerms" + position] = specialOffer.specialOfferTerms;
        data["rank_altPremiumDate" + position] = meerkat.modules.dateUtils.dateValueShortFormat(product.dualPricingDate);

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

    function setSelectedClinicalBenefitsList(selectedBenefits) {
        selectedClinicalBenefitsList = selectedBenefits;
    }

    function setAmbulanceAccidentCoverList(ambulanceAccidentCover) {
		ambulanceAccidentCoverList = ambulanceAccidentCover;
	}

    function hideNavigationLink() {
        $('.floated-next-arrow').addClass('hidden');
        $('.floated-previous-arrow').addClass('hidden');
    }

    function getElementWidth($element) {
        if ($element.length === 0) return 0;

        var boundingClientRectWidth = $element[0].getBoundingClientRect().width,
            marginLeft = parseInt($element.css('margin-left')),
            marginRight = parseInt($element.css('margin-right'));

        return boundingClientRectWidth + marginLeft + marginRight;
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
        setSelectedClinicalBenefitsList: setSelectedClinicalBenefitsList,
	    setAmbulanceAccidentCoverList: setAmbulanceAccidentCoverList,
        hideNavigationLink: hideNavigationLink,
        getProvidersReturned : getProvidersReturned,
        getProviderSpecificPopoverData: getProviderSpecificPopoverData,
        findByKey: _findByKey
    });

})(jQuery);
