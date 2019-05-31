/**
 * Comparison mode External documentation:
 */

;(function ($, undefined) {
  
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var events = {
            compare: {
                RENDER_BASKET: "RENDER_BASKET",
                BEFORE_ADD_COMPARE_PRODUCT: "BEFORE_ADD_COMPARE_PRODUCT",
                ADD_PRODUCT: "COMPARE_ADD_PRODUCT",
                ADD_PRODUCT_NEW: "ADD_PRODUCT_NEW",
                REMOVE_PRODUCT: "COMPARE_REMOVE_PRODUCT",
                ENTER_COMPARE: "ENTER_COMPARE",
                AFTER_ENTER_COMPARE_MODE: "AFTER_ENTER_COMPARE_MODE",
                EXIT_COMPARE: "EXIT_COMPARE_MODE",
                RENDER_FINISHED: "RENDER_FINISHED",
                TOGGLE_CHECKBOXES: "TOGGLE_CHECKBOXES",
                AFTER_SWITCH: "AFTER_SWITCH"
            }
        },
        moduleEvents = events.compare;


    var comparedProducts = [],
        comparisonOpen = false,
        resultsFiltered = false,
        previousMode,
        resultsContainer, // set in applyEventListeners
        productIdPath, // path is set in init
        defaults = {
            // The minimum number of products required before the compare shortlist button can be active
            minProducts: 2,
            // The maximum number of products you can compare/filter at once.
            maxProducts: 3,
            /**
             * If you do not want it to automatically "filter" to the compared results
             * when you hit the max, set this to false
             */
            autoCompareAtMax: true,
            elements: {
                // Location of where the "basket" will be rendered in featuers mode (usually the left)
                basketLocationFeatures: $('.resultInsert.controlContainer'),
                // Location of where the "basket" will be rendered in price mode (usually as a navbar_additional)
                basketLocationPrice: $('#navbar-compare > .compare-basket'),
                // The buttons to enter/clear comparison.
                enterCompareMode: $('.enter-compare-mode'),
                clearCompare: $('.clear-compare'),
                exitCompareButton: $('.back-to-price-mode'),
                compareBar: $('#navbar-compare'),
                priceModeToggle: $('.filter-pricemode'),
                featuresModeToggle: $('.filter-featuresmode')
            },
            templates: {
                // Don't forget to update the templates paths for product information.
                compareBasketFeatures: $('#compare-basket-features-template'),
                compareBasketPrice: $('#compare-basket-price-template')
            },
            callbacks: {
                switchMode: function (mode) {
                    switch (mode) {
                        case 'features':
                            settings.elements.featuresModeToggle.trigger('click');
                            break;
                        case 'price':
                            settings.elements.priceModeToggle.trigger('click');
                            // Collapse all features again.
                            $(".featuresHeaders .expandable.expanded, .featuresList .expandable.expanded").removeClass("expanded").addClass("collapsed");
                            break;
                        default:
                            log("[compare:switchMode] No mode specified");
                            break;
                    }
                }
            }
        },
        settings = {};

    /**
     * Initialise
     */
    function initCompare(options) {
        options = typeof options === 'object' && options !== null ? options : {};
        settings = $.extend({}, defaults, options);
        productIdPath = Results.settings.paths.productId;

        jQuery(document).ready(function ($) {

            applyEventListeners();

            eventSubscriptions();
        });
    }

    /**
     * Apply the event listeners for the module.
     */
    function applyEventListeners() {

        /**
         * Cache the resultsContainer object.
         */
        resultsContainer = $(Results.settings.elements.resultsContainer);

        /**
         * Bind to the change event of the checkbox to toggle a product on or off
         */
        resultsContainer.on('change', '.compare-tick', toggleProductEvent);
        /**
         * When clicking the "x" in the price mode basket.
         */
        settings.elements.basketLocationPrice.on('click', '.remove-compare', toggleProductEvent);

        /**
         * Clear the comparison queue and return to previous results.
         */
        resultsContainer.on("click", '.clear-compare', resetComparison);
        /**
         * Click to swap to features mode and start filtering, or just filter, if in features mode.
         */
        $(document).on("click", '.enter-compare-mode', enterCompareMode);

        /**
         * Changing results should reset the comparison
         */
        resultsContainer.on("resultsReset resultsFetchStart", resetComparison);

        /**
         * Reset comparison by clicking a back button that replaces the price/features mode buttons.
         */
        settings.elements.exitCompareButton.on("click", resetComparison);

    }

    /**
     * The events compare subscribes to.
     */
    function eventSubscriptions() {

        meerkat.messaging.subscribe(moduleEvents.ADD_PRODUCT, addProductToCompare);
        meerkat.messaging.subscribe(moduleEvents.ADD_PRODUCT_NEW, addProductToCompareV2);
        meerkat.messaging.subscribe(moduleEvents.REMOVE_PRODUCT, removeProduct);
        meerkat.messaging.subscribe(moduleEvents.RENDER_BASKET, renderBasket);
        meerkat.messaging.subscribe(moduleEvents.ENTER_COMPARE, enterCompareMode);
        meerkat.messaging.subscribe(moduleEvents.TOGGLE_CHECKBOXES, toggleCheckboxes);
        meerkat.messaging.subscribe(moduleEvents.AFTER_SWITCH, afterSwitchMode);

        // External events:
        // This mode is causing it to render 3 times for no reason when in compare mode... maybe hooked up in Results.js in the wrong place?
        meerkat.messaging.subscribe(ResultsView.moduleEvents.RESULTS_TOGGLE_MODE, toggleViewMode);

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, resetComparison);
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, resetComparison);
    }
    
    
    function toggleCheckboxes() {
      var check = $('.compare-tick:checkbox:not(:checked)').is(':disabled');
      $('.compare-tick:checkbox:not(:checked)').prop('disabled', !check);
    }

    function afterSwitchMode(mode) {
      if (mode === 'features' && isAtMaxQueue()) {
        enterCompareModeAfterSwitch();
        meerkat.messaging.publish(moduleEvents.TOGGLE_CHECKBOXES);
      }
    }

    /**
     * Event
     * Toggle a product in and out of the comparison basket,
     * binding either on a label or a "x" that removes the product.
     * I.E. as the "x" (price mode) would never be :checked, it will always trigger a remove.
     * Publish the event with the productId data attribute, as well as the result.
     *
     */
    function toggleProductEvent(event) {

        var $element = $(this),
            eventType,
            productId = $element.attr('data-productId');

        // In case it lags, to prevent it from running twice.
        if($element.prop('disabled')) {
            return;
        }

        $element.prop('disabled',true);

        if ($element.prop('checked')) {
            eventType = moduleEvents.ADD_PRODUCT;
            $element.addClass('checked');
            if (meerkat.site.vertical === 'car' || meerkat.site.vertical === 'home') {
              eventType = moduleEvents.ADD_PRODUCT_NEW;
            }
        } else {
            eventType = moduleEvents.REMOVE_PRODUCT;
            $element.removeClass('checked');
        }

        meerkat.messaging.publish(eventType, {
            element: $element,
            productId: productId,
            product: Results.getResult("productId", productId)
        });

        // 300ms timeout should cater to double clickers, who would otherwise click, then unclick.
        setTimeout(function() {
            $element.prop('disabled',false);
        }, 300);
    }

    /**
     * Event
     * The callback for the ADD_PRODUCT event.
     * It will publish a BEFORE_COMPARE_PRODUCT event, which can be customised per vertical if required.
     * If an item was successfully pushed to the comparedProducts array, we will manipulate the view
     * to keep it in sync.
     * Steps to maintain the view:
     * 1) render the basket
     * 2) ensure all checkboxes for that productId are in sync
     * 3) Perform post-view, potentially vertical specific changes.
     *
     * If we reach the maximum number in the queue, it will automatically start to compare.
     */
    function addProductToCompare(eventObject) {

        meerkat.messaging.publish(moduleEvents.BEFORE_ADD_COMPARE_PRODUCT);

        var productId = eventObject.productId;
        var success = addComparedProduct(productId, eventObject.product);
        if (success) {
            toggleSelectedState(productId, true);
            if (isAtMaxQueue() && settings.autoCompareAtMax === true) {
                meerkat.messaging.publish(moduleEvents.ENTER_COMPARE);
            } else {
                meerkat.messaging.publish(moduleEvents.RENDER_BASKET);
            }
        } else {
            log("[compare] Failed to add product");
        }
    }
    
    function addProductToCompareV2(eventObject) {
      meerkat.messaging.publish(moduleEvents.BEFORE_ADD_COMPARE_PRODUCT);
      
      var productId = eventObject.productId;
      var success = addComparedProduct(productId, eventObject.product);
      if (success) {
        toggleSelectedState(productId, true);
        if (isAtMaxQueue() && settings.autoCompareAtMax === true && Results.getDisplayMode() === 'features') {
              meerkat.messaging.publish(moduleEvents.ENTER_COMPARE);
          } else if(isAtMaxQueue()) {
              meerkat.messaging.publish(moduleEvents.TOGGLE_CHECKBOXES);
              meerkat.messaging.publish(moduleEvents.RENDER_BASKET);
          } else {
              meerkat.messaging.publish(moduleEvents.RENDER_BASKET);
          }
        } else {
          log("[compare] Failed to add product");
        }
    }

    /**
     * The callback for the REMOVE_PRODUCT event
     * If successfully removed a product from the array, manage the view state appropriately
     * If the comparison mode is "open", filter the results immediately to remove the product.
     */
    function removeProduct(eventObject) {
        var productId = eventObject.productId;

        if (typeof productId === 'undefined') {
            return;
        }

        var success = removeComparedProductId(productId);

        if (success) {
            // If comparison is open, filter the results immediately
            if (getComparedProducts().length === 2) {
                meerkat.messaging.publish(moduleEvents.TOGGLE_CHECKBOXES);
            }
            
            if (isCompareOpen()) {
                filterResults();
            }
            meerkat.messaging.publish(moduleEvents.RENDER_BASKET);
            toggleSelectedState(productId, false);

        } else {
            log("[compare] Failed to remove product");
        }

    }

    /**
     * Event
     */
    function resetComparison() {
        if (Results.getFilteredResults() === false)
            return;

        comparedProducts = [];

        // Reset the basket
        meerkat.messaging.publish(moduleEvents.RENDER_BASKET);

        // Reset views for compare rows and checkboxes
        toggleSelectedState(false, false);

        if (isCompareOpen()) {
            comparisonOpen = false;
            if (previousMode == "price") {
                if (typeof settings.callbacks.switchMode === 'function') {
                    settings.callbacks.switchMode(previousMode);
                }
            }

            settings.elements.exitCompareButton.addClass('hidden');

            // Collapse hospital and extra sections
            if (Results.settings.render.features.expandRowsOnComparison) {
                // Collapse selected items details.
                $(".featuresHeaders .featuresList > .selectionHolder > .children > .category.expandable.expanded > .content").trigger('click');

                // Collapse hospital and extra sections
                $(".featuresHeaders .featuresList > .section.expandable.expanded > .content").trigger('click');

            }

            // defer the animations to prevent some jarring
            _.defer(function () {
                unfilterResults();
            });

            meerkat.messaging.publish(moduleEvents.EXIT_COMPARE);
        }

    }

    /**
     * Event
     */
     function enterCompareModeAfterSwitch() {
       comparisonOpen = true;
       settings.elements.enterCompareMode.addClass('disabled');
       settings.elements.exitCompareButton.removeClass('hidden');
       filterResults();
       
       if (previousMode == null) {
         previousMode = Results.getDisplayMode();
       }

       // Expand hospital and extra sections
       if (Results.settings.render.features.expandRowsOnComparison) {
           $(".featuresHeaders .featuresList > .section.expandable.collapsed > .content").trigger('click');

           // Expand selected items details.
           $(".featuresHeaders .featuresList > .selectionHolder > .children > .category.expandable.collapsed > .content").trigger('click');
       }

       //meerkat.modules.address.appendToHash('compare');
       meerkat.messaging.publish(moduleEvents.AFTER_ENTER_COMPARE_MODE);
       if (previousMode !== 'price') {
          trackComparison();
       }
       setTimeout(function () {
           settings.elements.enterCompareMode.removeClass('disabled');
       }, 250);
     }
     
    function enterCompareMode() {
        comparisonOpen = true;

        settings.elements.enterCompareMode.addClass('disabled');
        settings.elements.exitCompareButton.removeClass('hidden');
        previousMode = Results.getDisplayMode();
        if (previousMode == "price") {
            if (typeof settings.callbacks.switchMode === 'function') {
                settings.callbacks.switchMode("features");
            }
        }
        filterResults();

        // Expand hospital and extra sections
        if (Results.settings.render.features.expandRowsOnComparison) {
            $(".featuresHeaders .featuresList > .section.expandable.collapsed > .content").trigger('click');

            // Expand selected items details.
            $(".featuresHeaders .featuresList > .selectionHolder > .children > .category.expandable.collapsed > .content").trigger('click');
        }

        //meerkat.modules.address.appendToHash('compare');

        meerkat.messaging.publish(moduleEvents.AFTER_ENTER_COMPARE_MODE);

        trackComparison();

        setTimeout(function () {
            settings.elements.enterCompareMode.removeClass('disabled');
        }, 250);

    }

    /**
     * View
     * Render function to maintain the state of the basket.
     * @param {POJO} eventObject
     * @optional eventObject
     */
    function renderBasket(eventObject) {
        switch (Results.getDisplayMode()) {
            case 'features':
                $template = settings.templates.compareBasketFeatures;
                $location = settings.elements.basketLocationFeatures;
                $(settings.elements.basketLocationPrice).empty();
                break;
            case 'price':
                $template = settings.templates.compareBasketPrice;
                $location = settings.elements.basketLocationPrice;
                $(settings.elements.basketLocationFeatures).empty();
                break;
        }

        if (typeof $template === 'undefined' || $template.length === 0) {
            return;
        }

        var templateCallback = _.template($template.html()),
            templateObj = {
                maxAllowable: getMaxToCompare(),
                resultsCount: Results.getFilteredResults().length,
                comparedResultsCount: getComparedProducts().length,
                products: getComparedProducts(),
                isCompareOpen: isCompareOpen()
            };

        $location.html(templateCallback(templateObj));
        if (Results.getDisplayMode() == 'price') {
            if (getComparedProducts().length) {
                $location.closest('nav').removeClass('hidden');
            } else {
                $location.closest('nav').addClass('hidden');
            }
        }
        meerkat.messaging.publish(moduleEvents.RENDER_FINISHED);
    }

    /**
     * Ensure the state of the checkboxes and row highlights stays in sync. The checked class is for IE8
     * @param {String} productId The productId of the provider
     * @status {Boolean} Whether we are toggling the checkbox on or off.
     * @return
     */
    function toggleSelectedState(productId, status) {
        var $collectionCheckboxes,
            $collectionRows;

        if (productId === false) {
            $collectionCheckboxes = $('.compare-tick[data-productId]');
            $collectionRows = $('.result-row.compared', resultsContainer);
        } else {
            $collectionCheckboxes = $('.compare-tick[data-productId="' + productId + '"]');
            $collectionRows = $('.result-row[data-productId="' + productId + '"]', resultsContainer);
        }

        $collectionCheckboxes.each(function () {
            var $el = $(this);
            $el.prop('checked', status).toggleClass('checked', status);
        });

        $collectionRows.each(function () {
            $(this).toggleClass('compared', status);
        });

    }

    /**
     * View
     */
    function toggleViewMode() {
        meerkat.messaging.publish(moduleEvents.RENDER_BASKET);

        switch (Results.getDisplayMode()) {
            case 'features':
                settings.elements.compareBar.addClass('hidden');
                break;
        }

    }

    /**
     * Handles the logic for filtering the Results object.
     * You can only filter if there are 2 or more products.
     * When it tries to filter on 1 or 0 products (i.e. when removing items), it will reset.
     */
    function filterResults() {

        // Force filter out unavailable combined mode
        var comparedIds = getComparedProductIds();
        if (comparedIds.length > 1) {
            resultsFiltered = true;
            Results.filterBy("productId", "value", {inArray: comparedIds}, true);
            if (Results.settings.show.unavailableCombined === true) {
                _.defer(function () {
                    Results.view.fadeResultOut($('.result_unavailable_combined'), Results.settings.animation.filter.active);
                });
            }
        } else {
            resetComparison();
        }
    }

    /**
     * Unfilter the results so they appear again.
     */
    function unfilterResults() {

        Results.unfilterBy("productId", "value", resultsFiltered);
        if (Results.settings.show.unavailableCombined === true) {
            // The unavailable combined row is not in the model, so cannot be filtered out properly...
            // fadeIn at the end position
            _.defer(function () {
                Results.view.fadeResultIn($('.result_unavailable_combined'), Results.getFilteredResults().length + 1, Results.settings.animation.filter.active);
            });
        }
        resultsFiltered = false;
    }

    /**
     * Utility
     * Return the array containing the product objects.
     */
    function getComparedProducts() {
        return typeof comparedProducts === 'object' && comparedProducts !== null ? comparedProducts : [];
    }

    /**
     * Retrieve the maximum number of products that you can compare at once
     */
    function getMaxToCompare() {
        return settings.maxProducts;
    }

    /**
     * Get the product Ids of the products in the comparison queue.
     * @param {Boolean} asObj - If TRUE, it will return {productID: p[i][productIdPath]}
     */
    function getComparedProductIds(asObj) {
        var productIds = [],
            products = getComparedProducts();

        for (var i = 0; i < products.length; i++) {
            if (typeof products[i][productIdPath] === 'undefined') {
                log("[getComparedProductIds] No Product Id in Object: ", products[i]);
                continue;
            }
            if (asObj) {
                var data = {
                    productID: String(products[i][productIdPath])
                };

                // If it exists, add it in:
                if (typeof products[i].brandCode !== 'undefined') {
                    data.productBrandCode = products[i].brandCode;
                }

                productIds.push(data);
            } else {
                productIds.push(String(products[i][productIdPath]));
            }
        }
        return productIds;
    }

    /**
     * Model/Utility
     * Check if it exists, and if it does, add it to the object.
     * @return {Boolean}
     */
    function addComparedProduct(productId, obj) {
        if (typeof comparedProducts === 'object' && comparedProducts !== null) {
            var item = findById(getComparedProducts(), productId);
            if (item === null) {
                comparedProducts.push(obj);
                return true;
            }
        }
        return false;
    }

    /**
     * Model/Utility
     */
    function removeComparedProductId(productId) {
        var list = getComparedProducts();

        // Only remove something that's already in the object:
        var removeIndex = findById(list, productId, true, productIdPath);
        if (typeof list[removeIndex] !== 'undefined') {
            list.splice(removeIndex, 1);
            return true;
        }

        return false;
    }

    /**
     * Utility
     * Finds the array referenced by a particular productId
     * @example findById(comparedProducts, id).price
     * @example order.findById(comparedProducts, 1) // returns full array for 8ft tramp
     * @example order.findById(comparedProducts, 1, true) // returns key of the array
     * @example order.findById(comparedProducts, 1, true, 'productId') // returns key of the array where 'productId' is found
     * @param {array} array
     * @param {integer} id
     * @param {bool} returnKey
     * @param {String} index
     * @return {POJO|null}
     */
    function findById(array, id, returnKey, index) {
        index = !index ? productIdPath : index;

        for (var i = 0, len = array.length; i < len; i++) {
            if (id == array[i][index]) {
                if (returnKey) {
                    return i;
                } else {
                    return array[i];
                }
            }
        }

        return null;
    }

    function isCompareOpen() {
        return comparisonOpen;
    }

    function isAtMaxQueue() {
        return getMaxToCompare() == getComparedProducts().length;
    }


    /**
     * Standard tracking functions for Comparison.
     */
    function trackComparison() {


        meerkat.messaging.publish(meerkatEvents.tracking.TOUCH, {
            touchType: 'H',
            touchComment: 'ResCompare'
        });

        // Required for HNC
        var verticalCode = meerkat.site.vertical === 'home' ? 'Home_Contents' : meerkat.site.vertical;

        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: 'trackQuoteComparison',
            object: {
                products: getComparedProductIds(true),
                vertical: verticalCode
            }
        });

    }

    meerkat.modules.register("compare", {
        initCompare: initCompare,
        events: events,
        isCompareOpen: isCompareOpen,
        afterSwitchMode: afterSwitchMode
    });

})(jQuery);